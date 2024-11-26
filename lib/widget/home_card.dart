import 'package:ai_assistant/helper/global.dart';
import 'package:ai_assistant/model/home_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class HomeCard extends StatelessWidget {
  final HomeType homeType;
  final RxBool isDarkMode; // Accept RxBool

  const HomeCard({
    super.key,
    required this.homeType,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    Animate.restartOnHotReload = true;

    return Obx(
      () => Card(
        elevation: 10,
        color: isDarkMode.value
            ? const Color.fromARGB(255, 1, 4, 52)
            : Colors.white,
        margin: EdgeInsets.only(bottom: mq.height * .02),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20))),
        child: InkWell(
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          onTap: homeType.onTap,
          child: homeType.leftAlign
              ? Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  child: Row(
                    children: [
                      // Lottie Animation
                      Container(
                        width: mq.width * .35,
                        padding: homeType.padding,
                        child: Lottie.asset(
                            height: 140, 'assets/lottie/${homeType.lottie}'),
                      ),
                      const Spacer(),
                      // Title
                      Text(
                        homeType.title,
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1),
                      ),
                      const Spacer(flex: 2),
                    ],
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            homeType.lottie.contains('.gif')
                                ? const SizedBox()
                                : const Spacer(flex: 2),
                            // Title
                            homeType.lottie.contains('.gif')
                                ? Expanded(
                                    child: Text(
                                      textAlign: TextAlign.center,
                                      homeType.title,
                                      overflow: TextOverflow.visible,
                                      softWrap: true,
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 1),
                                    ),
                                  )
                                : Text(
                                    homeType.title,
                                    overflow: TextOverflow.visible,
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1),
                                  ),
                            homeType.lottie.contains('.gif')
                                ? const SizedBox()
                                : const Spacer(),
                          ],
                        ),
                      ),
                      // Lottie Animation
                      Expanded(
                        child: Container(
                          width: mq.width * .35,
                          padding: homeType.padding,
                          child: homeType.lottie.contains('.gif')
                              ? Image.asset(
                                  'assets/lottie/${homeType.lottie}',
                                  height: 100,
                                )
                              : Lottie.asset(
                                  height: 100,
                                  'assets/lottie/${homeType.lottie}'),
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
