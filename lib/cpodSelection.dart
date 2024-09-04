import 'package:cpod_server/cpod_server.dart';
import 'package:cpodpractice/authService.dart';
import 'package:cpodpractice/services/vocaServer.dart';
import 'package:cpodpractice/sqlite3.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'dart:convert';

import 'contentService.dart';
import 'lessonService.dart';

// show a list of cpod lessons

class CpodSelection extends StatefulWidget {
  @override
  _CpodSelectionState createState() => _CpodSelectionState();
}

class _CpodSelectionState extends State<CpodSelection> {
  Future getLessonsProc;
  String usrType; // this will be set in future once

  void initState() {
    super.initState();
    getLessonsProc = getLessons(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Lessons'),
        ),
        body: lessonsList(context));
  }

  Widget lessonsList(BuildContext context) {
    return FutureBuilder(
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // log error to console
            if (snapshot.error != null) {
              print("error");
              return Container(
                  padding: EdgeInsets.all(20.0),
                  child: Text(snapshot.error.toString()));
            } else {
              return buildLessons(context, snapshot.data);
            }
          } else {
            return Center(child: Container(child: CircularProgressIndicator()));
          }
        },
        future: getLessonsProc);
  }

  ListView buildLessons(BuildContext context, data) {
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, pos) {
        var lesson = data[pos];
        return Padding(
            padding: EdgeInsets.only(bottom: 16.0),
            child: Card(
              // color: Colors.white,
              child: ListTile(
                title: Text(lesson['title']),
                subtitle: Text(lesson['id']),
                leading: InkWell(
                  child: Image.network(makeImageURL(lesson)),
                ),
                onTap: () async {
                  var vocab = await _loadCpodVocab(context, lesson['id']);
                  if (vocab != null) {
                    VocaServer vs = VocaServer();

                    vocab = vs.lesson2HKS(json.encode(lesson),
                        vocab); // put a title object as first

                    var contentService =
                        Provider.of<ContentService>(context, listen: false);
                    await contentService.saveSelection(
                        selectionName: 'current',
                        jobject: vocab); // save the vocab as current selection
                    Navigator.pushReplacementNamed(context, '/home2');
                  }
                },
              ),
            ));
      },
    );
  }

  _loadCpodVocab(context, String lessonID) async {
    print(lessonID);
    var id = lessonID;

    // let's try sqlite first before cpod remote

    Sqlite3 sq = Provider.of<Sqlite3>(context, listen: false);

    var lsn = await sq.getVocab(lessonId: id);
    if (lsn != null) {
      VocaServer vs = VocaServer();

      print('got the vocab');
      print(lsn);
      var hks = vs.cpodvoca2Hks(lsn);
      print(hks);
      return Future.value(hks);
    } else {
      try {
        var server = Provider.of<CpodServer>(context, listen: false);
        var lservice = LessonService(server);

        print(lessonID);

        var hks = await lservice.getVOCAB(id); // get from file if exists

        print(hks);

        await lservice.saveVOCAB(id, hks); // it will not saved if already exist

        return Future.value(hks); // fw should we decode this in isolate?
      } catch (e) {
        print('error');
        print(e);
        // return Future.value(_words);
        //  throw (e);
        print(e.runtimeType);
        _errorDialog(context, e.toString());
      }
    }
  }

  Future getLessons(BuildContext context) async {
    var cService = Provider.of<ContentService>(context, listen: false);
    var auth = Provider.of<AuthService>(context, listen: false);

    var usr = await auth.getUser();
    usrType = usr.userType; // set the state in this page

    print('getting lessons...');

    if (usr.userType != 'CPOD') {
      return getSetLessons(context, usr.userType);
    } else {
      try {
        var studiedLessons = await cService.getStudiedLessons();
        if (studiedLessons == null) {
          return Future.value([]);
        } else {
          var temp = json.decode(studiedLessons[1]);
          print(temp['lessons']);
          return Future.value(temp['lessons']);
        }
      } catch (err) {
        print('Caught error: $err');
        throw (err);
      }
    }
  }
}

Future getSetLessons(context, String setType) async {
  print('get set lessons $setType');
  var setT;
  if (setType.startsWith('HSK'))
    setT = 'HSK';
  else
    setT = '66WORDS';
  Sqlite3 sq = Provider.of<Sqlite3>(context, listen: false);
  var s = await sq.getLessonSet(setT);
  return Future.value(json.decode(s));
}

String makeImageURL(Map<String, dynamic> lesson) {
  var url;
  
  if (lesson['image'].startsWith('http')) {
    return lesson['image'];
  }
  if (lesson['type'] == 'extra') {
    url =
        'https://s3contents.chinesepod.com/extra/${lesson['id']}/${lesson['hash_code']}/${lesson['image']}';
  } else
    url =
        'https://s3contents.chinesepod.com/${lesson['id']}/${lesson['hash_code']}/${lesson['image']}';

  return url;
}

Future _errorDialog(BuildContext context, _message) {
  return showDialog(
    builder: (context) {
      return AlertDialog(
        title: Text('Error Message'),
        content: Text(_message),
        actions: <Widget>[
          FlatButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              })
        ],
      );
    },
    context: context,
  );
}
