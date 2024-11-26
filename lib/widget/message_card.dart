import 'dart:developer';

import 'package:ai_assistant/controller/chat_controller.dart';
import 'package:get/get.dart';

import '../main.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

import '../helper/global.dart';
import '../model/message.dart';

class MessageCard extends StatelessWidget {
  final Message message;
  final int index;

  const MessageCard({super.key, required this.message, required this.index});

  @override
  Widget build(BuildContext context) {
    log('Index coming : '+index.toString());
    
    const r = Radius.circular(15);
    ChatController chatcon = Get.find<ChatController>();
    return message.msgType == MessageType.bot

        //bot
        ? Row(children: [
            const SizedBox(width: 6),

            CircleAvatar(
              radius: 18,
              backgroundColor: Colors.white,
              child: Image.asset('assets/images/logo.png', width: 24),
            ),

            //
            Container(
              constraints: BoxConstraints(maxWidth: mq.width * .6),
              margin: EdgeInsets.only(
                  bottom: mq.height * .02, left: mq.width * .02),
              padding: EdgeInsets.symmetric(
                  vertical: mq.height * .01, horizontal: mq.width * .02),
              decoration: BoxDecoration(
                  border: Border.all(color: Theme.of(context).lightTextColor),
                  borderRadius: const BorderRadius.only(
                      topLeft: r, topRight: r, bottomRight: r)),
              child: message.msg.isEmpty
                  ? AnimatedTextKit(animatedTexts: [
                      TypewriterAnimatedText(
                        ' Please wait... ',
                        speed: const Duration(milliseconds: 100),
                      ),
                    ], repeatForever: true)
                  : Text(
                      message.msg,
                      textAlign: TextAlign.center,
                    ),
            ),
           Obx(() =>   index == chatcon.list.length-1
                ?
           
           chatcon.isstartedspeaking.value
                    ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset(
                          'assets/images/chatspeaking.gif',
                          height: 75,
                        ),
                    )
                    : const SizedBox()     : const SizedBox())
           
          ])

        //user
        : Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            //
            Container(
                constraints: BoxConstraints(maxWidth: mq.width * .6),
                margin: EdgeInsets.only(
                    bottom: mq.height * .02, right: mq.width * .02),
                padding: EdgeInsets.symmetric(
                    vertical: mq.height * .01, horizontal: mq.width * .02),
                decoration: BoxDecoration(
                    border: Border.all(color: Theme.of(context).lightTextColor),
                    borderRadius: const BorderRadius.only(
                        topLeft: r, topRight: r, bottomLeft: r)),
                child: Text(
                  message.msg,
                  textAlign: TextAlign.center,
                )),

            const CircleAvatar(
              radius: 18,
              backgroundColor: Colors.white,
              child: Icon(Icons.person, color: Colors.blue),
            ),

            const SizedBox(width: 6),
          ]);
  }
}
