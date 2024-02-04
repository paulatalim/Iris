import 'stt.dart';
import 'tts.dart';

class Speech {
  final _key = "53cada5a127d4d3c88f518d736af77f2";
  String _language = "en-US";
  final _region = "brazilsouth";

  late Tts _textToSpeech;
  late Stt _speechToText;

  bool? _microphoneOn;
  bool _isTalking = false;
  
  Speech() {
    _textToSpeech = Tts(_key, _language);
    _speechToText = Stt(_key, _region, _language);

    _microphoneOn = _speechToText.isRecording;
  }

  void setLanguage(String languageCode) {
    switch (languageCode) {
      case 'pt':
        _language = "pt-br";
      case 'en':
      default:
        _language = "en-US";
    }

    // Atualiza idioma
    _speechToText.language = _language;
    _textToSpeech.language = _language;
  }

  void speak(String text) async {
    _isTalking = true;
    _textToSpeech.speak(text);

    // TODO desativar microfone

    // Espera terminar a fala
    do {
      await Future.delayed(Duration(seconds: 1));
    } while(_textToSpeech.isTalking);

    _isTalking = false;
  }

  Future<String> listen() async {
    _speechToText.speech();

    print('oiiiii');

    // bool microfoneAtivado = false;

    while (!_speechToText.isRecording) {
      await Future.delayed(Duration(seconds: 1));
    }
    
    do {
      await Future.delayed(Duration(seconds: 2));
      _microphoneOn = true;
    } while (_speechToText.isRecording);

    _microphoneOn = false;

    print("ahhhhhhhhhhhhhhhhhh");
    print(_speechToText.resposta);

    return Future.value(_speechToText.resposta.toLowerCase().replaceAll(".", '').trim());
  }

  /// Verifica se o microfone stá ligado ou nao
  get microphoneOn => _microphoneOn ?? false;

  get isTalking => _isTalking;
}

Speech speech = Speech();