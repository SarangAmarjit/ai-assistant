import 'dart:developer';

import 'package:ai_assistant/controller/speechservices.dart';
import 'package:ai_assistant/controller/translate_controller.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/chat_controller.dart';
import '../../helper/global.dart';
import '../../widget/message_card.dart';

class ChatBotFeature extends StatefulWidget {
  const ChatBotFeature({super.key});

  @override
  State<ChatBotFeature> createState() => _ChatBotFeatureState();
}

class _ChatBotFeatureState extends State<ChatBotFeature> {
  late FlutterTts flutterTts;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    flutterTts = FlutterTts();
    log('init state');
 // Ensure controllers are registered and update their FlutterTts instances
    final chatController = Get.put(ChatController());
    chatController.updateFlutterTts(flutterTts);

    final translateController = Get.put(TranslateController());
    translateController.updateFlutterTts(flutterTts);



  }

  @override
  Widget build(BuildContext context) {
    final SpeechService speechService = Get.find();
    ChatController chatcontroller = Get.find<ChatController>();
    return Scaffold(
      //app bar
      appBar: AppBar(
        title:  Text('Chat with AI Assistant',style: TextStyle(fontFamily: 'NotoSansMeeteiMayek'),),
      ),

      //send message field & btn
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(children: [
          //text input field
          Expanded(
              child: TextFormField(
            controller: chatcontroller.textC,
            textAlign: TextAlign.center,
            onTapOutside: (e) => FocusScope.of(context).unfocus(),
            decoration: InputDecoration(
                fillColor: Theme.of(context).scaffoldBackgroundColor,
                filled: true,
                isDense: true,
                hintText: 'Ask me anything you want...',
                hintStyle: const TextStyle(
                    fontSize: 14, color: Color.fromARGB(255, 192, 191, 191)),
                border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(50)))),
          )),

          //for adding some space
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () {
              chatcontroller.listen(flutterTts: flutterTts);
            },
            // onLongPressStart: (details) {

            // },
            // onLongPressEnd: (details) => chatcontroller.listen(),
            child: Obx(
              () => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: speechService.isListening.value
                    ? const Icon(
                        Icons.stop,
                        color: Colors.red,
                        size: 25.0,
                      )
                    : const Icon(
                        Icons.mic,
                        color: Colors.blue,
                        size: 25.0,
                      ),
              ),
            ),
          ),

          //send button
          CircleAvatar(
            radius: 24,
            backgroundColor: Theme.of(context).buttonColor,
            child: IconButton(
              onPressed: () {
                chatcontroller.askQuestion();
              },
              icon: const Icon(Icons.rocket_launch_rounded,
                  color: Colors.white, size: 28),
            ),
          )
        ]),
      ),

      //body
      body: Obx(
        () => ListView(
          physics: const BouncingScrollPhysics(),
          controller: chatcontroller.scrollC,
          padding: EdgeInsets.only(
            top: mq.height * .02,
            bottom: mq.height * .1,
          ),
          children: chatcontroller.list.asMap().entries.map((entry) {
            int index = entry.key;
            var message = entry.value;
            return MessageCard(
              message: message,
              index: index, // Pass index to the MessageCard
            );
          }).toList(),
        ),
      ),
    );
  }
}
