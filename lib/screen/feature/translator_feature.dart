import 'package:ai_assistant/controller/speechservices.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';

import '../../controller/image_controller.dart';
import '../../controller/translate_controller.dart';
import '../../helper/global.dart';
import '../../widget/custom_btn.dart';
import '../../widget/custom_loading.dart';
import '../../widget/language_sheet.dart';

class TranslatorFeature extends StatefulWidget {
  const TranslatorFeature({super.key});

  @override
  State<TranslatorFeature> createState() => _TranslatorFeatureState();
}

class _TranslatorFeatureState extends State<TranslatorFeature> {
    late FlutterTts flutterTts;
 @override
  void initState() {
    // TODO: implement initState
    super.initState();
    flutterTts = FlutterTts();

  }




  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }
  Widget build(BuildContext context) {
    final SpeechService speechService = Get.find();
    TranslateController translatecontroller = Get.put(TranslateController());
    return Scaffold(
      //app bar
      appBar: AppBar(
        title: const Text('Multi Language Translator'),
      ),

      //body
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.only(top: mq.height * .02, bottom: mq.height * .1),
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            //from language
            InkWell(
              onTap: () => Get.bottomSheet(LanguageSheet(
                  c: translatecontroller, s: translatecontroller.from)),
              borderRadius: const BorderRadius.all(Radius.circular(15)),
              child: Container(
                height: 50,
                width: mq.width * .4,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.blue),
                    borderRadius: const BorderRadius.all(Radius.circular(15))),
                child: Obx(() => Text(translatecontroller.from.isEmpty
                    ? 'Auto'
                    : translatecontroller.from.value)),
              ),
            ),

            //swipe language btn
            IconButton(
                onPressed: translatecontroller.swapLanguages,
                icon: Obx(
                  () => Icon(
                    CupertinoIcons.repeat,
                    color: translatecontroller.to.isNotEmpty &&
                            translatecontroller.from.isNotEmpty
                        ? Colors.blue
                        : Colors.grey,
                  ),
                )),

            //to language
            InkWell(
              onTap: () => Get.bottomSheet(LanguageSheet(
                  c: translatecontroller, s: translatecontroller.to)),
              borderRadius: const BorderRadius.all(Radius.circular(15)),
              child: Container(
                height: 50,
                width: mq.width * .4,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.blue),
                    borderRadius: const BorderRadius.all(Radius.circular(15))),
                child: Obx(() => Text(translatecontroller.to.isEmpty
                    ? 'To'
                    : translatecontroller.to.value)),
              ),
            ),
          ]),

          //text field
          Padding(
            padding: EdgeInsets.only(
                left: mq.width * .04,
                right: mq.width * .04,
                top: mq.height * .035),
            // EdgeInsets.symmetric(
            //     horizontal: mq.width * .04, vertical: mq.height * .035),
            child: TextFormField(
              controller: translatecontroller.textC,
              minLines: 5,
              maxLines: null,
              onTapOutside: (e) => FocusScope.of(context).unfocus(),
              decoration: const InputDecoration(
                  hintText: 'Translate anything you want...',
                  hintStyle: TextStyle(fontSize: 13.5),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)))),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: mq.width * .04, vertical: mq.height * .035),
                child: GestureDetector(
                  onTap: () {
              translatecontroller.reset();
                  },
                  // onLongPressStart: (details) {

                  // },
                  // onLongPressEnd: (details) => chatcontroller.listen(),
                  child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              color: const Color.fromARGB(255, 164, 164, 164))),
                      child: const Padding(
                        padding: EdgeInsets.all(8),
                        child: Icon(
                          Icons.refresh,
                          color: Colors.blue,
                          size: 25.0,
                        ),
                      ),
                    ),
                 
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: mq.width * .04, vertical: mq.height * .035),
                child: GestureDetector(
                  onTap: () {
                    translatecontroller.trasnlisten(flutterTts: flutterTts);
                  },
                  // onLongPressStart: (details) {

                  // },
                  // onLongPressEnd: (details) => chatcontroller.listen(),
                  child: Obx(
                    () => Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              color: const Color.fromARGB(255, 164, 164, 164))),
                      child: Padding(
                        padding: const EdgeInsets.all(8),
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
                ),
              ),
            ],
          ),
          //result field
          Obx(() => _translateResult(translatecontroller)),

          //for adding some space
          SizedBox(height: mq.height * .04),

          //translate btn
          CustomBtn(
            onTap: translatecontroller.googleTranslate,
            // onTap: _c.translate,
            text: 'Translate',
          )
        ],
      ),
    );
  }

  Widget _translateResult(TranslateController c) => switch (c.status.value) {
        Status.none => const SizedBox(),
        Status.complete => Padding(
            padding: EdgeInsets.symmetric(horizontal: mq.width * .04),
            child: TextFormField(
              controller: c.resultC,
              maxLines: null,
              onTapOutside: (e) => FocusScope.of(context).unfocus(),
              decoration: const InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)))),
            ),
          ),
        Status.loading => const Align(child: CustomLoading())
      };
}
