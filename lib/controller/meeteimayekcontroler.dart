import 'dart:developer';

import 'package:ai_assistant/constant/const.dart';
import 'package:ai_assistant/model/meeteimayek/mapper.dart';
import 'package:ai_assistant/model/meeteimayek/phonememodel.dart';
import 'package:ai_assistant/model/meeteimayek/phonemeoutput.dart';
import 'package:get/get.dart';

class MeeteiMayekController extends GetxController {
  String transliterate(String? text) {
    log("Input Text : $text");
    Phoneme prev = PHI; // PHI is a `Phoneme` instance.
    List<Phoneme> phonemes = [];
    text = (text ?? '').toLowerCase();

for (int i = 0; i < text.length; i++) {
  String next = text[i];
  log("Processing character: $next");
  log("Current phonemes: ${phonemes.map((p) => p.phoneme).toList()}");

  if (!((next.codeUnitAt(0).isBetween('a'.codeUnitAt(0), 'z'.codeUnitAt(0))) ||
      (next.codeUnitAt(0).isBetween('0'.codeUnitAt(0), '9'.codeUnitAt(0))) ||
      next == '.')) {
    log('Non-alphanumeric, adding as-is.');
    var nextPhoneme = Phoneme(next, asConsonant: next);
    phonemes.add(nextPhoneme);
    prev = nextPhoneme;
    continue;
  }

  var digraphPhoneme = MAPPER.mapToPhonemeOrNull(prev.phoneme, next);
  if (digraphPhoneme == null) {
    log("No digraph match, processing single phoneme for: $next");
    var nextPhoneme = MAPPER.mapToPhonemeOrNull(next) ??
        Phoneme(next, asConsonant: next);
    phonemes.add(nextPhoneme);
    prev = nextPhoneme;
  } else {
    log("Digraph match found for: ${prev.phoneme + next}");
    if (phonemes.isNotEmpty) {
      phonemes.removeLast();
    }
    phonemes.add(digraphPhoneme);
    prev = digraphPhoneme;
  }
}


    return _convertToMMCVC(phonemes);
  }

  String _convertToMMCVC(List<Phoneme> phonemes) {
    List<PhonemeOutput> output = [];
    CVCState state = CVCState.NONE;
    PhonemeOutput prev = PhonemeOutput(PHI, OutputMode.CONSONANT);

    for (var curr in phonemes) {
      if (curr.isUnknown) {
        // Unknown phonemes are output as-is.
        output.add(PhonemeOutput(curr, OutputMode.CONSONANT));
        state = CVCState.NONE;
        continue;
      }

      if (state == CVCState.NONE) {
        // Start syllable as consonant.
        var nextOutput = PhonemeOutput(curr, OutputMode.CONSONANT);
        output.add(nextOutput);
        state = curr.isNumeric
            ? CVCState.NONE
            : (curr.isVowel ? CVCState.VOWEL : CVCState.CONSONANT);
        prev = nextOutput;
      } else if (state == CVCState.CONSONANT) {
        if (curr.isVowel) {
          // CV case: Consonant followed by vowel.
          var next = PhonemeOutput(curr, OutputMode.VOWEL);
          output.add(next);
          state = CVCState.VOWEL;

          if (prev.outputMode == OutputMode.LONSUM) {
            prev.outputMode = OutputMode
                .CONSONANT; // Flip previous lonsum if followed by a vowel.
          }
          prev = next;
        } else {
          // CC case: Two consecutive consonants.
          if (curr.phoneme == "ng") {
            // Special handling for "ng".
            var next = PhonemeOutput(curr, OutputMode.VOWEL);
            output.add(next);
            state = CVCState.VOWEL;
            prev = next;
          } else {
            // Add Apun Mayek if needed.
            if (MAPPER.isApunMayekPhonemesCombo(prev.phoneme, curr)) {
              output.add(
                  PhonemeOutput(APUN_MAYEK_AS_PHONEME, OutputMode.CONSONANT));
            }

            // Use as lonsum greedily if possible.
            var next = PhonemeOutput(
              curr,
              curr.canBeLonsum && prev.outputMode != OutputMode.LONSUM
                  ? OutputMode.LONSUM
                  : OutputMode.CONSONANT,
            );
            output.add(next);
            state = CVCState.CONSONANT;
            prev = next;
          }
        }
      } else {
        // Previous was a vowel.
        if (curr.isVowel) {
          // VV case: Two consecutive vowels.
          var next =
              PhonemeOutput(curr, OutputMode.CONSONANT); // Flip to consonant.
          output.add(next);
          state = CVCState.CONSONANT;
          prev = next;
        } else {
          // VC case: Vowel followed by consonant.
          var next = PhonemeOutput(
            curr,
            curr.canBeLonsum ? OutputMode.LONSUM : OutputMode.CONSONANT,
          );
          output.add(next);
          state = CVCState.CONSONANT;
          prev = next;
        }
      }
    }

    // Generate final text from the output.
    return output.map((e) => e.getOutput()).join('');
  }
}
