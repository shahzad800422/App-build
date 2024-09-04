import 'dart:io';
import 'package:cpod_server/cpod_server.dart';
import 'package:path_provider/path_provider.dart';
import 'package:cpodpractice/services/vocaServer.dart';

class LessonService {
  // get from local first if available
  final CpodServer server;

  static const VOCAFILEVERSION = "VOCA1";
  static const PDFVERSION = 'PDF1';

  LessonService(this.server);

  Future getVOCAB(String lessonID) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file =
          File('${directory.path}/${VOCAFILEVERSION}_${lessonID}.json');

      if (!file.existsSync()) {
        print('not exist ' + file.path);
        var s = VocaServer();

        // var lesson = await s.getVoca(lessonID);
        var lesson = await server.geLessonVoca(lessonID);

        print('lessons error');
        print(lesson[0]);
        print(lesson[0].runtimeType);
        print(lesson[0] == 200);
        print(lesson);

        if (lesson[0] == 200) {
          var hks = s.cpodvoca2Hks(lesson[1]);

          print('id s_____');

          print(lessonID);
          print('xxxxxxxxxxxxxxxx');
          print(hks);

          return Future.value(hks);
        } else {
          print('something is wrong');
          //   return Future.value("Error " + lesson[0]);
          if (lesson[0] == 401)
            throw 'Sorry, VOCAB is available to member only.';
          else
            throw 'HTTP ERROR : ${lesson[0]}';
        }
      } else {
        print('exist ' + file.path);
        String text = await file.readAsString();
        return Future.value(text);
      }
    } catch (e) {
      print("we got an error in getVOCA");
      print(e);
      throw e;
    }
  }

  Future saveVOCAB(String lessonID, String hks) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file =
          File('${directory.path}/${VOCAFILEVERSION}_${lessonID}.json');
      print(directory);
      if (!file.existsSync()) {
        print('not exist ' + file.path);
        await file.writeAsString(hks);
      }

      return Future.value('saved');
    } catch (e) {
      print("Couldn't read file");
    }
  }

  Future getPDF(Map<String, dynamic> lesson) async {
    try {
      print('lesson');
      var pdf =
          'https://s3contents.chinesepod.com/${lesson['id']}/${lesson['hash_code']}/${lesson['pdf1']}';

      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/${PDFVERSION}_${lesson['id']}.pdf');

      if (!file.existsSync()) {
        print('not exist ' + file.path);

        var s = VocaServer();

        var pdfResp = await s.getPDF(pdf);

        if (pdfResp[0] == 200) {
          print(pdfResp[0]);
          return Future.value(pdfResp[1]);
        } else {
          print('something is wrong');

          throw 'HTTP ERROR : ${pdfResp[0]}';
        }
      } else {
        print('exist ' + file.path);
        //  String text = await file.readAsString();
        return Future.value(null);
      }
    } catch (e) {
      print("we got an error in getPDF");
      print(e);
      throw e;
    }
  }

  Future savePDF(String lessonID, var pdfData) async {
    try {
      print('save pdf');
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/${PDFVERSION}_${lessonID}.pdf');

      print('in savePDF');
      print(pdfData.runtimeType);

      print(directory);
      if (!file.existsSync()) {
        print('not exist ' + file.path);
        file.writeAsBytesSync(pdfData);
      } else {
        print('exist already ' + file.path);
      }
      return Future.value(file.path);
    } catch (e) {
      print("Couldn't read file");
    }
  }
}
