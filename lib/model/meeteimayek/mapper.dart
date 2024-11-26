import 'package:ai_assistant/constant/const.dart';
import 'package:ai_assistant/model/meeteimayek/phonememodel.dart';

class Mapper {
  final Map<String, Phoneme> phonemes = {};
  final Set<String> apunMayekPhonemes = {};

  Mapper() {
    for (Phoneme phoneme in meiteiMayekPhonemes) {
      phonemes[phoneme.phoneme] = Phoneme(
        phoneme.phoneme,
        isVowel: phoneme.isVowel,
        asVowel: phoneme.asVowel,
        asConsonant: phoneme.asConsonant,
        canBeLonsum: phoneme.canBeLonsum,
        asLonsum: phoneme.asLonsum,
      );
    }

    MEITEI_MAYEK_NUMBERS.forEach((key, value) {
      phonemes[value] = Phoneme(value, isNumeric: true, asConsonant: key);
    });

    for (var rule in MEITEI_MAYEK_APUN_MAYEK_RULES) {
      apunMayekPhonemes.add('${rule[0]}-${rule[1]}');
    }
  }

  Phoneme? mapToPhonemeOrNull(String curr, [String next = '']) {
    return phonemes[curr + next];
  }

  bool isApunMayekPhonemesCombo(Phoneme one, Phoneme two) {
    return apunMayekPhonemes.contains('${one.phoneme}-${two.phoneme}');
  }
}
