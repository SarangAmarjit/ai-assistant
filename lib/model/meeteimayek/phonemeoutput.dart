import 'package:ai_assistant/constant/const.dart';
import 'package:ai_assistant/model/meeteimayek/phonememodel.dart';

class PhonemeOutput {
  final Phoneme phoneme;
  OutputMode outputMode;

  PhonemeOutput(this.phoneme, this.outputMode);

  String getOutput() {
    switch (outputMode) {
      case OutputMode.VOWEL:
        return phoneme.asVowel;
      case OutputMode.CONSONANT:
        return phoneme.asConsonant;
      case OutputMode.LONSUM:
        return phoneme.asLonsum;
      default:
        return phoneme.asConsonant;
    }
  }
}
