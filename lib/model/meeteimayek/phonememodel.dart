class Phoneme {
  final String phoneme;
  final bool isVowel;
  final String asVowel;
  final String asConsonant;
  final bool canBeLonsum;
  final String asLonsum;
  final bool isNumeric;
  final bool isUnknown;

  Phoneme(
    this.phoneme, {
    this.isVowel = false,
    this.asVowel = '',
    this.asConsonant = '',
    this.canBeLonsum = false,
    this.asLonsum = '',
    this.isNumeric = false,
  }) : isUnknown = phoneme.isEmpty
            ? true
            : !(phoneme
                    .codeUnitAt(0)
                    .isBetween('a'.codeUnitAt(0), 'z'.codeUnitAt(0)) ||
                phoneme
                    .codeUnitAt(0)
                    .isBetween('0'.codeUnitAt(0), '9'.codeUnitAt(0)));
}

extension CodeUnitRange on int {
  bool isBetween(int lower, int upper) => this >= lower && this <= upper;
}
