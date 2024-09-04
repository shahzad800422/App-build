import 'dart:convert';

// this is the type used in practice list(汉字)

class Kanji {
  String simplified; // this is always simplified
  String pinyin;
  String english;
  String traditional;
  String source; // source of the ji come from
  String sourceT;

  Kanji(this.simplified, this.pinyin, this.english, this.traditional,
      this.source, this.sourceT);

  @override
  String toString() {
    return '[$simplified - $pinyin - $english - $traditional - $source - $sourceT]';
  }

  Map<String, dynamic> toJson() => {
        'chinese': simplified,
        'pinyin': pinyin,
        'english': english,
        'chinese_t': traditional,
        'source': source,
        'sourceT': sourceT
      };
}

class Usr {
  final String email;
  final String apiKey;
  final String userType; // HSK, 66WORDS, CPOD
  bool firstTime;

  Usr(this.email, this.apiKey, this.userType) {
    print('creating usr');
    firstTime = true;
  }

  @override
  String toString() {
    return '$email - $apiKey - $userType - $firstTime';
  }
}

Hsk hskFromJson(String str) => Hsk.fromJson(json.decode(str));

String hskToJson(Hsk data) => json.encode(data.toJson());

// this is the type that used in the selection list
// another one called HKS in vocaServer, should be depreciated

class Hsk {
  Hsk({
    this.word,
    this.pinyin,
    this.eng,
    this.wordT,
  });

  String word;
  String pinyin;
  String eng;
  String wordT;

  factory Hsk.fromJson(Map<String, dynamic> json) => Hsk(
        word: json["word"],
        pinyin: json["pinyin"],
        eng: json["eng"],
        wordT: json["word_t"],
      );

  Map<String, dynamic> toJson() => {
        "word": word,
        "pinyin": pinyin,
        "eng": eng,
        "word_t": wordT,
      };
}
