import 'dart:developer';
import 'package:ai_assistant/controller/speechservices.dart';
import 'package:ai_assistant/controller/translate_controller.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../apis/apis.dart';
import '../helper/my_dialog.dart';
import '../model/message.dart';

enum TtsState { playing, stopped, paused, continued }

class ChatController extends GetxController {
  FlutterTts? flutterTts;

  ChatController({this.flutterTts});

  // Method to update the FlutterTts instance
  void updateFlutterTts(FlutterTts flutterTtsInstance) {
    flutterTts = flutterTtsInstance;
    getlanguage();
  }

  void getlanguage() async {
    // Retrieve the list of supported languages
    List<dynamic> languages = await flutterTts!.getLanguages;

    // Print the list of languages to the console
    log("Supported languages: $languages");
  }

  final textC = TextEditingController();
  final RxBool ischatscreen = false.obs;
  RxBool isstartedspeaking = false.obs;
  final scrollC = ScrollController();

  var ttsState = TtsState.stopped.obs; // Reactive variable for TTS state
  var errorMessage = ''.obs; // Reactive variable for error messages
  final list = <Message>[
    Message(msg: 'Hello, How can I help you?', msgType: MessageType.bot)
  ].obs;
  final SpeechService speechService = Get.find();
  void setchatscreenbool({required bool ischatscreenss}) {
    ischatscreen.value = ischatscreenss;
  }

  void listen({required FlutterTts flutterTts}) async {
    log('chat controlller listen');
    if (!speechService.isListening.value) {
      log('chatiing....');
      var isvail = await speechService.initialize(
        (status) {
          log("chat speech status :$status");
          if (status == 'done') {
            speechService.stopListening();
            ischatscreen.value
                ? askQuestion()
                : Get.put(TranslateController())
                    .translate(flutterTts: flutterTts);
          }
        },
        (text) {
          return;
        },
      );
      if (isvail) {
        log("chat isavail");
        speechService.startListening((recognizedText) {
          print("Final text: $recognizedText");
          textC.text = recognizedText;
        });
      }
    }
  }

  Future<void> askQuestion() async {
    log('ask question function');
    if (textC.text.trim().isNotEmpty) {
      // User message
      list.add(Message(msg: textC.text, msgType: MessageType.user));
      list.add(Message(msg: '', msgType: MessageType.bot));
      _scrollDown();

      final responseanswer = await APIs.getAnswer(textC.text);

      // AI bot response
      list.removeLast();
      list.add(Message(msg: responseanswer, msgType: MessageType.bot));
      _scrollDown();
      log("List length : $list");
      textC.text = '';
      // Fetch available voices
      List voices = await flutterTts!.getVoices;

      if (voices.isNotEmpty) {
        // Print the available voices (Optional: for debugging)
        // for (var voice in voices) {
        //   print(voice);
        // }

        final Map<String, String> stringVoice =
            voices.last.map<String, String>((key, value) {
          return MapEntry(key.toString(), value.toString());
        });

        // Listener for when an utterance completes

        await flutterTts!.setVoice(stringVoice);

        await flutterTts!.awaitSpeakCompletion(true);
        flutterTts!.setStartHandler(() {
          isstartedspeaking.value = true;
          log('speaking started');
        });
        flutterTts!.setCompletionHandler(() {
          isstartedspeaking.value = false;
          log('speaking completed');
        });
        await flutterTts!.speak(responseanswer).whenComplete(() {});
      }
      // Use text-to-speech for the bot's response
    } else {
      MyDialog.info(
        'Ask Something!',
      );
    }
  }

  //for moving to end message
  void _scrollDown() {
    scrollC.animateTo(scrollC.position.maxScrollExtent,
        duration: const Duration(milliseconds: 500), curve: Curves.ease);
  }
}
