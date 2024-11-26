import 'dart:developer';

import 'package:get/get.dart';
import 'package:speech_to_text/speech_to_text.dart' as speechToText;

class SpeechService extends GetxService {
    speechToText.SpeechToText? speech;
  final RxBool isListening = false.obs;

  Future<bool> initialize(
      Function(String status) onStatus, Function(String text) onResult) async {
  speech = speechToText.SpeechToText();

    log('initializing again');
    return await speech!.initialize(
      onStatus: onStatus,
      onError: (error) {
        print("Speech Error: ${error.errorMsg}");
      },
    );
  }

    Future<bool> traninitialize(
      Function(String status) onStatus, Function(String text) onResult) async {
   speech = speechToText.SpeechToText();

    log('initializing again trans');
    return await speech!.initialize(
      onStatus: onStatus,
      onError: (error) {
        print("Speech Error: ${error.errorMsg}");
      },
    );
  }


  void startListening(Function(String) onRecognized) {
    isListening.value = true;
    speech!.listen(onResult: (result) {
      print("Recognized text: ${result.recognizedWords}");
      onRecognized(result.recognizedWords);
    });
  }

  void stopListening() {
    isListening.value = false;
    speech!.stop();
    speech=null;
  }
}
