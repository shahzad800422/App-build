// some service for set lessons (HKS, 66WORDS, etc)


import 'package:cpodpractice/services/vocaServer.dart';
import 'package:cpodpractice/sqlite3.dart';
import 'package:cpodpractice/types.dart';
import 'package:cpodpractice/utils.dart';

class SetLessonService {
  Sqlite3 sq;

  SetLessonService() {
    print('creating setLesson');
  }

  hello() {
    print('hello');
  }

  createPracticeSet(String lessonId) async {
    VocaServer s = VocaServer();
    var lesson = await sq.getLesson(lessonId: lessonId);
    var vocab = await sq.getVocab(lessonId: lessonId);
    var hks = s.cpodvoca2Hks(vocab); // convert cpod vocab to Hks format
    var selInHks = s.lesson2HKS(lesson, hks); // add lesson title to hks

    List<Kanji> wordlst = selection2Kanjis(selInHks);
    print('haha wordlst');
    print(wordlst);
   
    return {'selection': selInHks, 'words': wordlst};
  }
}
