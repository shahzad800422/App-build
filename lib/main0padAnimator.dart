import 'dart:async';

import 'package:cpodpractice/contentService.dart';
import 'package:cpodpractice/maintab.dart';
import 'package:cpodpractice/padHelpers.dart';
import 'package:cpodpractice/practiceList.dart';
import 'package:cpodpractice/practiceListService.dart';
import 'package:cpodpractice/sqlite3.dart';
import 'package:cpodpractice/types.dart';
import 'package:cpodpractice/userPreference.dart';
import 'package:cpodpractice/utils.dart';
import 'package:flutter/material.dart';
import 'package:hanziServices/hanziServices.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import 'package:stroke_order_animator/strokeOrderAnimationController.dart';
import 'package:stroke_order_animator/strokeOrderAnimator.dart';

import './oem.dart';
import 'grid.dart';

typedef _ShowCallback = void Function(bool actionConfirm);

class ShowPad extends StatefulWidget {
  final TabController tabController;

  const ShowPad({Key key, this.tabController}) : super(key: key);
  @override
  _ShowPadState createState() => _ShowPadState();
}

class _ShowPadState extends State<ShowPad>
/*with AutomaticKeepAliveClientMixin<ShowPad> */ {
  StrokeOrderAnimationController _stkController;
  HanziData _strokeData;
  Sqlite3 _sq;
  int myKey = 0;
/*
  var s =
      '{"strokes": ["M 524 533 Q 537 536 755 560 Q 768 557 779 573 Q 780 586 754 600 Q 709 627 634 603 Q 526 582 524 580 L 479 572 Q 404 563 234 546 Q 200 542 226 521 Q 265 491 291 494 Q 309 503 446 521 L 524 533 Z", "M 524 580 Q 524 682 544 758 Q 559 783 532 802 Q 516 814 485 833 Q 460 851 439 834 Q 433 828 440 813 Q 474 762 476 711 Q 477 647 479 572 L 477 458 Q 474 208 466 155 Q 442 46 456 5 Q 460 -7 466 -21 Q 473 -40 481 -43 Q 488 -50 495 -41 Q 504 -37 514 -15 Q 524 10 523 44 Q 522 90 523 480 L 524 580 Z", "M 446 521 Q 368 337 127 132 Q 114 119 124 117 Q 134 113 146 119 Q 276 176 403 344 Q 472 450 477 458 C 528 538 464 563 446 521 Z", "M 523 480 Q 607 338 716 186 Q 737 159 774 157 Q 901 147 942 150 Q 954 151 957 157 Q 957 164 941 173 Q 773 251 721 302 Q 628 398 523 532 Q 523 533 524 533 L 524 533 C 506 558 508 506 523 480 Z"], "medians": [[[228, 534], [280, 522], [695, 584], [728, 584], [766, 574]], [[453, 825], [506, 771], [498, 218], [486, -29]], [[474, 519], [459, 504], [447, 460], [404, 389], [332, 297], [244, 206], [179, 154], [130, 124]], [[528, 513], [549, 470], [641, 344], [749, 220], [789, 200], [951, 159]]]}';
*/
  Future retrieveProc;

  void initState() {
    super.initState();

    getApplicationDocumentsDirectory().then((result) {
      _strokeData = HanziData(result.path);
    });
    retrieveProc = Provider.of<PracticeListService>(context, listen: false)
        .retrieve(); // retrieve2 called only once
    _sq = Provider.of<Sqlite3>(context, listen: false);
  }

  @override
  void dispose() {
    print('going out, disposing');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // super.build(context);
    return FutureBuilder(
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.error != null) {
              return Text(snapshot.error.toString());
            } else
              return buildBody(context);
          } else {
            return Center(child: Container(child: CircularProgressIndicator()));
          }
        },
        future: this.retrieveProc);
  }

  Widget buildBody(BuildContext context) {
    return ChangeNotifierProxyProvider<PracticeListService, KanjisProvider>(
      lazy: false,
      update: (BuildContext context, PracticeListService value,
          KanjisProvider previous) {
        return previous..updateDep(value);
      },
      create: (_) {
        return KanjisProvider();
      },
      child: Scaffold(
        body: Consumer<KanjisProvider>(
          builder: (BuildContext context, KanjisProvider value, Widget child) {
            print('we are changing');

            if (value.store.count() < 1) {
              return NoWords2Practice();
            } else {
              Kanji curC = value.store.currentChar();
              return FutureBuilder(
                  builder:
                      (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                    if (snapshot.hasData) {
                      var strokeStyle =
                          Provider.of<UserPreference>(context, listen: false)
                              .strokeSyle;
                      print('stroke style');
                      print(strokeStyle);
                      var showOutline = Provider.of<UserPreference>(context, listen: false).isOutline;

                      return Center(
                        child: Column(
                          children: <Widget>[
                            Container(
                              child: Column(
                                children: <Widget>[
                                  Text('Pinyin : ' + curC.pinyin),
                                  Text(
                                    _getHintLine(context, curC),
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              // decoration: myBoxDecoration(),
                              width: MediaQuery.of(context).size.width - 50,
                              margin: EdgeInsets.only(top: 20),
                            ),
                            Row(
                              children: <Widget>[
                                /*
                                Container(
                                  margin: EdgeInsets.all(0.0),
                                  width: 30,
                                  child: FlatButton(
                                    child: Icon(Icons.navigate_before),
                                    onPressed: () {
                                      print('prev');
                                        value.gotoPrevWord(() { });
                                    },
                                  ),
                                ),*/

                                Container(
                                    child: InkWell(
                                      child:
                                          Icon(Icons.navigate_before, size: 35),
                                      onTap: () {
                                        value.gotoPrevWord(() {});
                                      },
                                    ),
                                    padding: EdgeInsets.only(left: 5)),
                                Flexible(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 20.0),
                                    child: AspectRatio(
                                      aspectRatio: 2 / 2,
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width -
                                                40,
                                        margin: const EdgeInsets.all(3.0),
                                        // decoration: myBoxDecoration(),
                                        child: KanjiAnimator(
                                          key: ValueKey(myKey++),
                                          strokes: snapshot.data,
                                          strokeStyle: strokeStyle,
                                          showOutline: showOutline,
                                          onStrokeCreated:
                                              (StrokeOrderAnimationController
                                                  controller) {
                                            print('stroke re-creatred');
                                            _stkController = controller;
                                            _stkController.startQuiz();
                                          },
                                          onQuizCompleteCallback:
                                              (QuizSummary summary) {
                                            print('completed');
                                            print(summary.mistakes);
                                            print(summary.mistakes.runtimeType);

                                            int nmistake = 0;

                                            summary.mistakes.forEach((element) {
                                              print(element);
                                              if (element != 0)
                                                nmistake = nmistake + 1;
                                            });

                                            String stks = summary.nStrokes == 1
                                                ? 'stroke'
                                                : 'strokes';
                                            var msg = summary.nTotalMistakes ==
                                                    0
                                                ? "Perfect, you finished the whole ${summary.nStrokes} $stks"
                                                : "You missed ${nmistake} out of ${summary.nStrokes} $stks";

                                            showMessage(msg, (confirmedAction) {
                                              if (confirmedAction) {
                                                _stkController.reset();
                                                _stkController.startQuiz();
                                              } else {
                                                //   value.gotoNextWord(() {});
                                              }
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  child: InkWell(
                                    child: Icon(Icons.navigate_next, size: 35),
                                    onTap: () {
                                      value.gotoNextWord(() {});
                                    },
                                  ),
                                  padding: EdgeInsets.only(right: 5),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    } else {
                      return CircularProgressIndicator();
                    }
                  },
                  future: getStrokes(value.store.currentChar()));
            }
          },
        ),
        floatingActionButton: getFAB(context),
      ),
    );
  }

  Widget getFAB(BuildContext context) {
    if (OEM.APP_WITH_CPOD == 'YES') {
      return Padding(
        padding: const EdgeInsets.only(bottom: 50.0),
        child: FloatingActionButton(
          onPressed: () async {
            //    var kp = Provider.of<KanjisProvider>(context, listen: false);
            /*
            if (this._stkController != null && this._stkController.isQuizzing) {
              this._stkController.stopQuiz();
            }*/
            await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PracticeList(),
                ));
            print('back 123');
            //      kp.saveList();
          },
          tooltip: 'List of words',
          child: Icon(Icons.list),
        ),
      );
    } else
      return null;
  }

  getStrokes(Kanji kanji) async {
    var ch =
        Provider.of<UserPreference>(context, listen: false).chineseStandard;

    String cWord = ch == 'T' ? kanji.traditional : kanji.simplified;

    var stks = await _sq.getStrokes(word: cWord);
    if (stks == null) {
      stks = await _strokeData.getHanzi(cWord);
    } else {
      print('use q version of stroke');
    }

    return stks;
  }

  Future showMessage(String msg, _ShowCallback cb) {
    var action1 = SnackBarAction(
      label: 'Again?',
      textColor: Colors.white,
      onPressed: () {
        print('again');
      },
    );Provider.of<UserPreference>(context, listen: false).isOutline == 'YES';
    return Scaffold.of(context)
        .showSnackBar(
          SnackBar(
            content: Text(msg),
            backgroundColor: Colors.redAccent,
            duration: const Duration(milliseconds: 2000),
            action: action1,
          ),
        )
        .closed
        .then((value) {
      print(value);
      if (value == SnackBarClosedReason.timeout) {
        cb(false);
        //     kp.gotoNextWord(() {});
      } else {
        cb(true);

        //    strokeCtrl.reset();
        //    strokeCtrl.startQuiz();
      }
    });
  }
}

class NoWords2Practice extends StatelessWidget {
  const NoWords2Practice({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureProvider<Object>(
      initialData: 'loading...',
      create: (BuildContext context) {
        // var cService = Provider.of<ContentService>(context, listen: false);
        return Provider.of<ContentService>(context, listen: false)
            .getSelection(selectionName: 'current');
        // return Future.delayed(Duration(seconds: 4), () => 'sample');
      },
      child: Container(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Consumer<Object>(
            builder: (BuildContext context, value, Widget child) {
              print('object is');
              print(value.runtimeType);
              print(value);
              if (value != null) {
                return Column(
                  children: <Widget>[
                    SizedBox(
                      height: 20,
                    ),
                    Text('You have not yet selected any character to practice'),
                    SizedBox(
                      height: 10,
                    ),
                    RaisedButton(
                      child: Text('Select all characters in the lesson'),
                      onPressed: () {
                        print('check selection');
                        print(value);
                        if (value != null) {
                          List<Kanji> wordlst = selection2Kanjis(value);
                          print(wordlst);
                          KanjisProvider ps = Provider.of<KanjisProvider>(
                              context,
                              listen: false);
                          ps.store.addChars(wordlst);
                          ps.plist.dirty = true;
                          ps.plist.save();
                          ps.refresh();
                        }
                      },
                    ),
                    RaisedButton(
                      child: Text('Select characters individually'),
                      onPressed: () {
                        TabCtrl tctrl =
                            Provider.of<TabCtrl>(context, listen: false);
                        tctrl.ctrl.index = 0;
                        print('haha');
                      },
                    ),
                  ],
                );
              } else {
                return Column(
                  children: <Widget>[
                    SizedBox(
                      height: 20,
                    ),
                    Text('You have not yet selected any lessson to practice'),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                );
              }
            },
          ),
        ),
      )),
    );
  }
}

String _getHintLine(context, Kanji w) {
  if (w.source.length == 1)
    return w.english;
  else {
    var ch =
        Provider.of<UserPreference>(context, listen: false).chineseStandard;

    String source = ch == 'T' ? w.sourceT : w.source;

    return '(' + source + ') ' + w.english;
  }
}

class KanjisProvider with ChangeNotifier {
  PracticeListService plist;

  PadStore get store => plist.store;

  updateDep(PracticeListService pService) {
    this.plist = pService;
  }

  gotoNextWord(VoidCallback cb) {
    this.store.incCharIndex(false);
    if (cb != null) {
      cb();
    }
    notifyListeners();
  }

  gotoPrevWord(VoidCallback cb) {
    this.store.incCharIndex(true);
    if (cb != null) {
      cb();
      //
    }
    notifyListeners();
  }

  refresh() {
    notifyListeners();
  }

  saveList() {
    plist.save();
  }
}

// KanjiAnimator.dart

typedef void StrokeCreatedCallback(StrokeOrderAnimationController controller);

class KanjiAnimator extends StatefulWidget {
  final String strokes;
  final String strokeStyle;
  final String showOutline;
  final StrokeCreatedCallback onStrokeCreated;
  final Function onQuizCompleteCallback;

  const KanjiAnimator({
    Key key,
    this.strokes,
    this.strokeStyle,
    this.showOutline,
    this.onStrokeCreated,
    this.onQuizCompleteCallback,
  }) : super(key: key);

  @override
  _KanjiAnimatorState createState() => _KanjiAnimatorState();
}

class _KanjiAnimatorState extends State<KanjiAnimator>
    with TickerProviderStateMixin {
  StrokeOrderAnimationController myController;
  void initState() {
    super.initState();

    myController = StrokeOrderAnimationController(widget.strokes, this,
        /*
      (int strokes, int mistakes) {
        print('done, stroke count is');
        print(strokes);
        /*
        if (widget.onDone != null) {
          widget.onDone(strokes, mistakes);
        }*/
      },*/
        showOutline: widget.showOutline == 'YES',
        showStroke: widget.strokeStyle != 'RAW', // either SNAP or BOTH
        showUserStroke: widget.strokeStyle == 'RAW' || widget.strokeStyle == 'BOTH',
        brushColor: widget.strokeStyle == 'RAW' ? Colors.black : Colors.red,
        strokeColor: widget.strokeStyle == 'RAW' ? Colors.grey : Colors.black,
        hintColor: Colors.redAccent,
        brushWidth: 35.0,
        hintAfterStrokes: 1, onQuizCompleteCallback: (QuizSummary summary) {
      print(summary.runtimeType);
      print(summary.nTotalMistakes);
      print(summary.nStrokes);
      widget.onQuizCompleteCallback(summary);
    });

    if (widget.onStrokeCreated != null) {
      widget.onStrokeCreated(myController);
    }
  }

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    return ChangeNotifierProvider<StrokeOrderAnimationController>.value(
      value: myController,
      child: Consumer<StrokeOrderAnimationController>(
        builder: (BuildContext context,
            StrokeOrderAnimationController controller, Widget child) {
          print('building the kj');
          return Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 1024,
                height: 1024,
                child: CustomPaint(
                  size: Size(w, w),
                  painter: Background(),
                ),
              ),
              FittedBox(
                fit: BoxFit.fill,
                child: StrokeOrderAnimator(
                  controller,
                  key: UniqueKey(),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build2(BuildContext context) {
    return ChangeNotifierProvider<StrokeOrderAnimationController>.value(
      value: myController,
      child: Consumer<StrokeOrderAnimationController>(
        builder: (BuildContext context,
            StrokeOrderAnimationController controller, Widget child) {
          print('building the kj');
          return FittedBox(
            fit: BoxFit.fill,
            child: StrokeOrderAnimator(
              controller,
              key: UniqueKey(),
            ),
          );
        },
      ),
    );
  }
}

// helpers

BoxDecoration myBoxDecoration() {
  return BoxDecoration(
    border: Border.all(
      color: Colors.red, //                   <--- border color
      width: 1.0,
    ),
  );
}
