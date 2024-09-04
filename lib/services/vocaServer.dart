import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:lpinyin/lpinyin.dart';

const String DOMAIN2 = 'http://localhost:8080';
const String DOMAIN = 'http://cpod.ipadzip.com:8080';
const String VOCA_PATH = 'api/get_voca';
const String LESSON_PATH = 'api/get_lesson';

// curl -i http://cpod.ipadzip.com:8080/api/get_voca?lesson_id=4671

class HKS {
  final String word;
  final String pinyin;
  final String eng;
  final String word_t;

  HKS(this.word, this.pinyin, this.eng, [this.word_t]);

  Map<String, dynamic> toJson() =>
      {'word': word, 'pinyin': pinyin, 'eng': eng, 'word_t': word_t};
}

class VocaServer {
  // return [200, string] caller should convert it into json
/*
  Future getVoca000(String lessonID) async {
    var myurl = '$DOMAIN/$VOCA_PATH?lesson_id=$lessonID';
    print('getVoca $myurl');

    try {
      // Await the http get response, then decode the json-formatted response.
      var response = await http.get(myurl);

      //  print('Response status: ${response.statusCode}');
      //  print('Response body: ${response.body}');

      int statusCode = response.statusCode;
      print(response);

      String data;

      if (statusCode == 200) {
        data = response.body;
      }
      return Future.value([statusCode, data]);
    } catch (e) {
      throw e;
    } finally {
      print('finally');
    }
  }

  Future getLesson00(String lessonID) async {
    // Await the http get response, then decode the json-formatted response.
    var myurl = '$DOMAIN/$LESSON_PATH?lesson_id=$lessonID';

    var response = await http.get(myurl);

    // print('Response status: ${response.statusCode}');
    // print('Response body: ${response.body}');

    int statusCode = response.statusCode;
    String data;

    if (statusCode == 200) {
      data = response.body;
    }
    return Future.value([statusCode, data]);
  }
*/
  Future getPDF(String pdfURL) async {
    // fw : move this to content service
    try {
      final response = await http.get(pdfURL);
      final responseJson = response.bodyBytes;

      print('bac');
      int statusCode = response.statusCode;
      print(statusCode);
      print(responseJson.runtimeType);
      return Future.value([statusCode, responseJson]);
    } catch (e) {
      throw e;
    } finally {
      print('finally');
    }
  }

/*
 {
        "word": "安静",
        "pinyin": "an1 jing4",
        "eng": "quiet; peaceful; calm"
    },
*/

  String cpodvoca2Hks(String voca) {
    var r = [];
    List j = json.decode(voca);
    for (var i = 0; i < j.length; i++) {
      var word = j[i];

      var p = PinyinHelper.getPinyin(word['s'],
          separator: " ", format: PinyinFormat.WITH_TONE_MARK);

      var h = HKS(word['s'], p, word['en'], word['t']);
      r.add(h);
    }
    return json.encode(r);
  }

  String lesson2HKS(String lesson, String vocab) {
    var jlesson = json.decode(lesson);

    Map<String, dynamic> titleMap = {
      'title': jlesson['title'],
      'lesson_id': jlesson['id'],
      'image': _makeImageURL(jlesson),
      'introduction': jlesson['introduction'],
    };

    print('titlemap');
    print(json.encode(titleMap));

    print(vocab);

    var ret = _insertObject(vocab, json.encode(titleMap));
    print('vocab-ret');
    print(json.decode(ret));
    print('vocab1-ret');

    return ret;
  }

  _insertObject(String jobject, String newObj, {bool beginning = true}) {
    var source = json.decode(jobject);
    var newJobj = json.decode(newObj);
    source.insert(0, newJobj);
    return json.encode(source);
  }

  String _makeImageURL(Map<String, dynamic> lesson) {
    print('lesson');

    print(lesson.runtimeType);
    print(lesson['type']);
    var url;
    if (lesson['type'] == 'extra') {
      url =
          'https://s3contents.chinesepod.com/extra/${lesson['id']}/${lesson['hash_code']}/${lesson['image']}';
    } else
      url =
          'https://s3contents.chinesepod.com/${lesson['id']}/${lesson['hash_code']}/${lesson['image']}';

    return url;
  }
}
