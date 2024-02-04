import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:audioplayers/audioplayers.dart';

class Tts {
  String key = '53cada5a127d4d3c88f518d736af77f2';
  String language = "en-US";

  String getNameLanguage() {
    switch (language) {
      case 'pt-br':
        return 'en-US-AvaNeural';

      case 'en-US':
      default:
        return 'en-US-AvaNeural';
    }
  }

  void speak(String text) async {
    final responseToken = await http.post(
      Uri.parse(
          'https://brazilsouth.api.cognitive.microsoft.com/sts/v1.0/issueToken'),
      headers: {
        "Ocp-Apim-Subscription-Key": key,
        "Content-type": "application/x-www-form-urlencoded"
      },
    );

    var xmlData = '''
      <speak version='1.0' xml:lang='$language'>
        <voice xml:lang='$language' xml:gender='Female' name='${getNameLanguage()}'>
          $text
        </voice>
      </speak>
    ''';

    final responseAudio = await http.post(
      Uri.parse(
          'https://brazilsouth.tts.speech.microsoft.com/cognitiveservices/v1'),
      headers: {
        "Authorization": "Bearer ${responseToken.body}",
        "Ocp-Apim-Subscription-Key": key,
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
    final player = AudioPlayer();
    await player.play(UrlSource(file.path));
  }
}