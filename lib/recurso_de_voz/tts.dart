import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:audioplayers/audioplayers.dart';

class Tts {
  late String _key;
  String _language = "en-US";
  bool isTalking = false;
  double _volume = 1;
  final player = AudioPlayer();

  Tts(String key, String language) {
    _key = key;
    _language = _language;
  }

  String _getNameLanguage() {
    switch (_language) {
      case 'pt-br':
        return 'en-US-AvaNeural';

      case 'en-US':
      default:
        return 'en-US-AvaNeural';
    }
  }

  Future<void> speak(String text) async {
    isTalking = true;

    final responseToken = await http.post(
      Uri.parse(
          'https://brazilsouth.api.cognitive.microsoft.com/sts/v1.0/issueToken'),
      headers: {
        "Ocp-Apim-Subscription-Key": _key,
        "Content-type": "application/x-www-form-urlencoded"
      },
    );

    var xmlData = '''
      <speak version='1.0' xml:lang='$_language'>
        <voice xml:lang='$_language' xml:gender='Female' name='${_getNameLanguage()}'>
          $text
        </voice>
      </speak>
    ''';

    final responseAudio = await http.post(
      Uri.parse(
          'https://brazilsouth.tts.speech.microsoft.com/cognitiveservices/v1'),
      headers: {
        "Authorization": "Bearer ${responseToken.body}",
        "Ocp-Apim-Subscription-_Key": _key,
        "Content-type": "application/ssml+xml",
        "X-Microsoft-OutputFormat": "audio-48khz-96kbitrate-mono-mp3"
      },
      body: xmlData,
    );

    // Mensagem recebida da API
    var bytes = responseAudio.bodyBytes;

    var tempDir;
    
    // Cria um diretorio temporario
    do {
      tempDir = await getTemporaryDirectory();
    } while (!await tempDir.exists());

    // Salva a mensagem recebida da API em um arquivo mp3
    File file = await File('${tempDir.path}/audio.mp3').create();
    file.writeAsBytesSync(bytes);
    
    // Toca o arquivo mp3
    await player.play(UrlSource(file.path));

    // Espera o audio terminar
    while (player.state.toString().compareTo("PlayerState.completed") != 0) {
      await Future.delayed(const Duration(seconds: 1));
    }

    // Atualizacao de variavel
    isTalking = false;
  }

  void stopPlayer () {
    player.stop();
  }

  set language(String language) => _language = language;
  set volume(double value) {
    _volume = value;
    player.setVolume(_volume);
  }
}