import 'package:ai_assistant/controller/chat_controller.dart';
import 'package:ai_assistant/screen/feature/meeteimayek.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../screen/feature/chatbot_feature.dart';
import '../screen/feature/image_feature.dart';
import '../screen/feature/translator_feature.dart';

enum HomeType { aiChatBot, aiImage, aiTranslator, meeteimayek }

extension MyHomeType on HomeType {
  //title
  String get title => switch (this) {
        HomeType.aiChatBot => 'AI ChatBot',
        HomeType.aiImage => 'AI Image Creator',
        HomeType.aiTranslator => 'Language Translator',
        HomeType.meeteimayek => 'Meitei Mayek Transliteration Tool'
      };

  //lottie
  String get lottie => switch (this) {
        HomeType.aiChatBot => 'chatai.json',
        HomeType.aiImage => 'imagecreator.json',
        HomeType.aiTranslator => 'language.json',
        HomeType.meeteimayek => 'meeteimayek.gif'
      };

  //for alignment
  bool get leftAlign => switch (this) {
        HomeType.aiChatBot => true,
        HomeType.aiImage => false,
        HomeType.aiTranslator => true,
        HomeType.meeteimayek => false
      };

  //for padding
  EdgeInsets get padding => switch (this) {
        HomeType.aiChatBot => EdgeInsets.zero,
        HomeType.aiImage => const EdgeInsets.all(20),
        HomeType.aiTranslator => EdgeInsets.zero,
        HomeType.meeteimayek => const EdgeInsets.all(17),
      };

  //for navigation
  VoidCallback get onTap {
    ChatController chatController = Get.put(ChatController());
    return switch (this) {
      HomeType.aiChatBot => () {
          chatController.setchatscreenbool(ischatscreenss: true);
          Get.to(() => const ChatBotFeature());
        },
      HomeType.aiImage => () {
          Get.to(() => const ImageFeature());
        },
      HomeType.aiTranslator => () {
          chatController.setchatscreenbool(ischatscreenss: false);
          Get.to(() => const TranslatorFeature());
        },
      HomeType.meeteimayek => () {
          chatController.setchatscreenbool(ischatscreenss: false);
          Get.to(() => const MeiteiMayekConverter());
        },
    };
  }
}
