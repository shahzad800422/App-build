import 'dart:convert';

import 'package:cpodpractice/types.dart';

// selection is a json in string format
// see sample_selection*

List<Kanji> selection2Kanjis(String selection) {
  var words = json.decode(selection);
  print(words);

  List<String> keys = [];
  List<Kanji> kanjis = [];

  for (int i = 1; i < words.length; i++) {
    // skip 1st row as it is a header
    Hsk hsk = Hsk.fromJson(words[i]);

    print(hsk.toJson());
    String word = hsk.word; //fw, to be wordT too
    String wordT = hsk.wordT;

    List<String> sounds = hsk.pinyin.split(' ');

    for (int k = 0; k < word.length; k++) {
      String zi = word[k]; // 字
      String ziT = wordT[k];

      if (_isKanji(zi) && keys.indexOf(zi) == -1) {
        Kanji kj =
            Kanji(zi, sounds[k], hsk.eng, ziT, hsk.word, hsk.wordT);

        kanjis.add(kj);
        keys.add(zi);
      }
    }
  }
  return kanjis;
}

bool _isKanji(String zi) {
  int v = zi.codeUnitAt(0);
  return (v >= 0x4E00) && (v <= 0x9FA5);
}
