import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cpod_server/cpod_server.dart';
import 'package:cpodpractice/types.dart';
import 'package:path_provider/path_provider.dart';

class ContentService {
  static const String LIST_TAG = 'LIST3';
  static const String CURRENT_LIST_NAME = 'current'; // practice list
  static const String SELECTION_TAG = 'SELECTION1'; // current selection
  static const String CURRENT_SELECTION_NAME = 'current'; // current selection
/*
  List<Kanji> _defaultList = [
    Kanji('我', 'wǒ', 'I'),
    Kanji('你', 'nǐ', 'you'),
    Kanji('他', 'tā', 'he')
  ];*/

  List<Kanji> _defaultList = [];

  CpodServer _cpodServer;
  // ContentService(this._cpodServer);

  String get msg => 'Hello Content';
  void doSomthing() {
    //print(_myModel.msg);
    print(_cpodServer);
  }

  // return saved words, from server for now, later should check cached area
  Future getWords() {
    Completer<List> c = Completer();
    _cpodServer.getWords().then((value) {
      print(value);
      c.complete(value);
    });
    return c.future;
  }

  updateDependencies(CpodServer cServer) {
    _cpodServer = cServer;
  }

  Future getStudiedLessons() {
    Completer<List> c = Completer();
    if (_cpodServer.apiKey != null) {
      _cpodServer.geStudiedLessons().then((value) {
        print(value);
        c.complete(value);
      }).catchError((e) {
        print('we got an error');
        print(e);
        c.completeError(e);
      });
    } else
      c.complete(null);

    return c.future;
  }

  Future geLessonVoca(String lessonID) {
    Completer<List> c = Completer();
    if (_cpodServer.apiKey != null) {
      _cpodServer.geLessonVoca(lessonID).then((value) {
        print('voca?');
        print(value);
        c.complete(value);
      });
    } else
      c.complete(null);

    return c.future;
  }

  Future<List> getCurrentList() async {
    Completer<List> c = Completer();
    var lst = await getList(name: CURRENT_LIST_NAME);
    print(lst);
    if (lst == null) {
      c.complete(_defaultList);
    } else {
      List<Kanji> ret = [];

      for (var i = 0; i < lst.length; i++) {
        var j = lst[i];
        // print(lst[i]);

        ret.add(Kanji(j['chinese'], j['pinyin'], j['english'], j['chinese_t'],
            j['source'], j['sourceT']));
      }
      c.complete(ret);
    }
    return c.future;
  }

  // return a current saved list, if none, return defalt
  Future<List> getList({String name}) {
    Completer<List> c = Completer();

    print(name);

    getApplicationDocumentsDirectory().then((directory) {
      final file = File('${directory.path}/${LIST_TAG}_${name}.json');
      print(file.path);
      file.exists().then((found) {
        if (found) {
          file.readAsString().then((content) {
            print(content);
            var temp = json.decode(content);

            c.complete(temp);
          });
        } else
          c.complete(null);
      });
    });
    return c.future;
  }

  Future saveList({String name, List<Kanji> words}) {
    Completer<List> c = Completer();
    var s2 = json.encode(words);

    print('saving list');
    print(words);

    getApplicationDocumentsDirectory().then((directory) {
      final file = File('${directory.path}/${LIST_TAG}_${name}.json');
      file.writeAsString(s2).then((value) => c.complete());
    });

    return c.future;
  }

  Future saveSelection({String selectionName, String jobject}) {
    Completer c = Completer();
    getApplicationDocumentsDirectory().then((directory) {
      final file =
          File('${directory.path}/${SELECTION_TAG}_${selectionName}.json');
      file.writeAsString(jobject).then((value) => c.complete(value));
    });
    return c.future;
  }

  Future getSelection({String selectionName}) {
    Completer c = Completer();
    getApplicationDocumentsDirectory().then((directory) {
      final file =
          File('${directory.path}/${SELECTION_TAG}_${selectionName}.json');
      if (file.existsSync())
        file.readAsString().then((value) => c.complete(value));
      else
        c.complete(null);
    });
    return c.future;
  }

  // Erase the practice set (practice list and current selection)

  Future erasePracticeSet() {
    Completer c = Completer();
    getApplicationDocumentsDirectory().then((directory) {
      final file =
          File('${directory.path}/${LIST_TAG}_$CURRENT_LIST_NAME.json');
      print('erasing ' + file.path);
      if (file.existsSync()) {
        file.deleteSync();
      }
      final selection = File(
          '${directory.path}/${SELECTION_TAG}_$CURRENT_SELECTION_NAME.json');
      if (selection.existsSync()) selection.deleteSync();
      print('erasing ' + selection.path);
      c.complete();
    });
    return c.future;
  }
}
