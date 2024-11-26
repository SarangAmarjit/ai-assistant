import 'dart:convert';
import 'dart:developer';

import 'package:ai_assistant/controller/chat_controller.dart';
import 'package:ai_assistant/controller/speechservices.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_to_text.dart' as speechToText;

import '../apis/apis.dart';
import '../helper/my_dialog.dart';
import 'image_controller.dart';

class TranslateController extends GetxController {

    FlutterTts? flutterTtschat;

  TranslateController({this.flutterTtschat});
  final textC = TextEditingController();
  final resultC = TextEditingController();

  final from = ''.obs, to = 'English'.obs;
  final status = Status.none.obs;

  final SpeechService speechService = Get.find();

     // Method to update the FlutterTts instance
  void updateFlutterTts(FlutterTts flutterTtsInstance) {
    flutterTtschat = flutterTtsInstance;
  }


  void reset(){
    from.value='';
    to.value='English';
textC.clear();
resultC.clear();
status.value = Status.none;
  }


  void trasnlisten({required FlutterTts flutterTts}) async {
    log('translator controlller listen');
    if (!speechService.isListening.value) {
      log('translator....');
      var isvail = await speechService.traninitialize(
        (status) {
          log("translator speech status :$status");
          if (status == 'done') {
       
            speechService.stopListening();
        Get.put(ChatController(flutterTts: flutterTtschat)).ischatscreen.value?  Get.put(ChatController(flutterTts: flutterTtschat)).askQuestion():  translate(flutterTts: flutterTts);
          }
        },
        (text) {
          log(text.toString());
          return;
        },
      );
      if (isvail) {
log("trans isavail");
        speechService.startListening((recognizedText) {
          textC.text = recognizedText;
        });
      }
    }
  }

  Future<void> translate({required FlutterTts flutterTts}) async {
    if (textC.text.trim().isNotEmpty && to.isNotEmpty) {
      status.value = Status.loading;

      String prompt = '';

      if (from.isNotEmpty) {
        prompt =
            'Can you translate given text from ${from.value} to ${to.value}:\n${textC.text}';
      } else {
        prompt = 'Can you translate given text to ${to.value}:\n${textC.text}';
      }

      log(prompt);

      final res = await APIs.getAnswer(prompt);

      // Regular expression to match Devanagari characters
      RegExp hindiRegex = RegExp(r'[\u0900-\u097F]+');
      // Regular expression to match text within two asterisks
      RegExp asteriskRegex = RegExp(r'\*\*(.*?)\*\*');

      // Find the first match
      Match? engmatch = asteriskRegex.firstMatch(res);
      String? engtext = engmatch?.group(1);
      Iterable<Match> matches = hindiRegex.allMatches(engtext ?? res);
      // Extract the matched text

      // Extract all Hindi words

      // Combine matches into a single string or list
      String hindiText = matches.map((match) => match.group(0)!).join(' ');
      resultC.text = to.value == 'Hindi' ? hindiText : engtext ?? res;
      List voices = await flutterTts.getVoices;

      if (voices.isNotEmpty) {
        final Map<String, String> stringVoice =
            voices.last.map<String, String>((key, value) {
          return MapEntry(key.toString(), value.toString());
        });
        final Map<String, String> stringVoicehindi = voices
            .firstWhere(
          (voice) => voice['name'] == 'hi-in-x-hia-local',
          orElse: () => voices.first, // Fallback to the first voice
        )
            .map<String, String>((key, value) {
          return MapEntry(key.toString(), value.toString());
        });
      status.value = Status.complete;
        await flutterTts
            .setVoice(to.value == 'Hindi' ? stringVoicehindi : stringVoice);

        await flutterTts.speak(to.value == 'Hindi' ? hindiText : resultC.text);
      }

    } else {
      status.value = Status.none;
      if (to.isEmpty) MyDialog.info('Select To Language!');
      if (textC.text.isEmpty) MyDialog.info('Type Something to Translate!');
    }
  }

  void swapLanguages() {
    if (to.isNotEmpty && from.isNotEmpty) {
      final t = to.value;
      to.value = from.value;
      from.value = t;
    }
  }

  Future<void> googleTranslate() async {
    if (textC.text.trim().isNotEmpty && to.isNotEmpty) {
      status.value = Status.loading;

      resultC.text = await APIs.googleTranslate(
          from: jsonLang[from.value] ?? 'auto',
          to: jsonLang[to.value] ?? 'en',
          text: textC.text);

      status.value = Status.complete;
    } else {
      status.value = Status.none;
      if (to.isEmpty) MyDialog.info('Select To Language!');
      if (textC.text.isEmpty) {
        MyDialog.info('Type Something to Translate!');
      }
    }
  }

  late final lang = jsonLang.keys.toList();

  final jsonLang = const {
    // 'Automatic': 'auto',
    'Afrikaans': 'af',
    'Albanian': 'sq',
    'Amharic': 'am',
    'Arabic': 'ar',
    'Armenian': 'hy',
    'Assamese': 'as',
    'Aymara': 'ay',
    'Azerbaijani': 'az',
    'Bambara': 'bm',
    'Basque': 'eu',
    'Belarusian': 'be',
    'Bengali': 'bn',
    'Bhojpuri': 'bho',
    'Bosnian': 'bs',
    'Bulgarian': 'bg',
    'Catalan': 'ca',
    'Cebuano': 'ceb',
    'Chinese (Simplified)': 'zh-cn',
    'Chinese (Traditional)': 'zh-tw',
    'Corsican': 'co',
    'Croatian': 'hr',
    'Czech': 'cs',
    'Danish': 'da',
    'Dhivehi': 'dv',
    'Dogri': 'doi',
    'Dutch': 'nl',
    'English': 'en',
    'Esperanto': 'eo',
    'Estonian': 'et',
    'Ewe': 'ee',
    'Filipino (Tagalog)': 'tl',
    'Finnish': 'fi',
    'French': 'fr',
    'Frisian': 'fy',
    'Galician': 'gl',
    'Georgian': 'ka',
    'German': 'de',
    'Greek': 'el',
    'Guarani': 'gn',
    'Gujarati': 'gu',
    'Haitian Creole': 'ht',
    'Hausa': 'ha',
    'Hawaiian': 'haw',
    'Hebrew': 'iw',
    'Hindi': 'hi',
    'Hmong': 'hmn',
    'Hungarian': 'hu',
    'Icelandic': 'is',
    'Igbo': 'ig',
    'Ilocano': 'ilo',
    'Indonesian': 'id',
    'Irish': 'ga',
    'Italian': 'it',
    'Japanese': 'ja',
    'Javanese': 'jw',
    'Kannada': 'kn',
    'Kazakh': 'kk',
    'Khmer': 'km',
    'Kinyarwanda': 'rw',
    'Konkani': 'gom',
    'Korean': 'ko',
    'Krio': 'kri',
    'Kurdish (Kurmanji)': 'ku',
    'Kurdish (Sorani)': 'ckb',
    'Kyrgyz': 'ky',
    'Lao': 'lo',
    'Latin': 'la',
    'Latvian': 'lv',
    'Lithuanian': 'lt',
    'Luganda': 'lg',
    'Luxembourgish': 'lb',
    'Macedonian': 'mk',
    'Malagasy': 'mg',
    'Maithili': 'mai',
    'Malay': 'ms',
    'Malayalam': 'ml',
    'Maltese': 'mt',
    'Maori': 'mi',
    'Marathi': 'mr',
    'Meiteilon (Manipuri)': 'mni-mtei',
    'Mizo': 'lus',
    'Mongolian': 'mn',
    'Myanmar (Burmese)': 'my',
    'Nepali': 'ne',
    'Norwegian': 'no',
    'Nyanja (Chichewa)': 'ny',
    'Odia (Oriya)': 'or',
    'Oromo': 'om',
    'Pashto': 'ps',
    'Persian': 'fa',
    'Polish': 'pl',
    'Portuguese': 'pt',
    'Punjabi': 'pa',
    'Quechua': 'qu',
    'Romanian': 'ro',
    'Russian': 'ru',
    'Samoan': 'sm',
    'Sanskrit': 'sa',
    'Scots Gaelic': 'gd',
    'Sepedi': 'nso',
    'Serbian': 'sr',
    'Sesotho': 'st',
    'Shona': 'sn',
    'Sindhi': 'sd',
    'Sinhala': 'si',
    'Slovak': 'sk',
    'Slovenian': 'sl',
    'Somali': 'so',
    'Spanish': 'es',
    'Sundanese': 'su',
    'Swahili': 'sw',
    'Swedish': 'sv',
    'Tajik': 'tg',
    'Tamil': 'ta',
    'Tatar': 'tt',
    'Telugu': 'te',
    'Thai': 'th',
    'Tigrinya': 'ti',
    'Tsonga': 'ts',
    'Turkish': 'tr',
    'Turkmen': 'tk',
    'Twi (Akan)': 'ak',
    'Ukrainian': 'uk',
    'Urdu': 'ur',
    'Uyghur': 'ug',
    'Uzbek': 'uz',
    'Vietnamese': 'vi',
    'Welsh': 'cy',
    'Xhosa': 'xh',
    'Yiddish': 'yi',
    'Yoruba': 'yo',
    'Zulu': 'zu'
  };
}
