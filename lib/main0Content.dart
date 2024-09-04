import 'dart:async';
import 'dart:convert';

import 'package:cpodpractice/hanji_buttons.dart';
import 'package:cpodpractice/practiceListService.dart';
import 'package:cpodpractice/userPreference.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'contentService.dart';
import './types.dart';
import './lessonBanners.dart';
import './videoPlayer.dart';

typedef ShowCallback = void Function(
    bool actionConfirm); // for snackbarAction call back

class MainContent extends StatefulWidget {
  final TabController tabController;

  const MainContent({Key key, this.tabController}) : super(key: key);
  @override
  _MainContentState createState() => _MainContentState();
}

class _MainContentState extends State<MainContent> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(),
      resizeToAvoidBottomPadding: false,
      body: mainPage(context),
    );
  }

  Future getSomething(BuildContext context) async {
    Completer c = Completer();
    print('get something');

    PracticeListService pListService =
        Provider.of<PracticeListService>(context, listen: false);

    await pListService
        .retrieve(); // make sure it is loaded in case user add new words from this page

    ContentService cService =
        Provider.of<ContentService>(context, listen: false);

    // return current selection, or default selection if no current
    cService.getSelection(selectionName: 'current').then((sel) {
      print('sel');
      print(sel.runtimeType);
      if (sel != null) {
        c.complete(sel);
      } else {
        c.complete(null);
      }
    });

    print('about to c.return');

    return c.future;
  }

  Widget mainPage(BuildContext context) {
    return FutureBuilder(
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // log error to console
            if (snapshot.error != null) {
              print("error");
              return Text(snapshot.error.toString());
            } else
              return buildBody(snapshot.data);
          } else {
            return Center(child: Container(child: CircularProgressIndicator()));
          }
        },
        future: getSomething(context));
  }

  Widget buildBody(String vocab) {
    print(vocab);

    print('vocab from buildBody');

    if (vocab == null)
      return emptyContent();
    else {
      return PageViewContent(
        vocab: vocab,
        tabController: widget.tabController,
      );
    }
  }

  Widget emptyContent() {
    return Center(
      child: Image.asset(
        'assets/images/emptybox.jpg',
        width: 200.0,
      ),
    );
  }
}

class PageViewContent extends StatefulWidget {
  final String vocab;
  final TabController tabController;

  const PageViewContent({Key key, this.vocab, this.tabController})
      : super(key: key);

  @override
  _PageViewContentState createState() => _PageViewContentState();
}

class _PageViewContentState extends State<PageViewContent> {
  PageController _controller = PageController(
    initialPage: 0,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      pageSnapping: true,
      controller: _controller,
      children: [
        _vocabList(
            'abc'), /*
        Page1(
          vocab: widget.vocab,
          tabController: widget.tabController,
        ),*/
        //    Page2(vocab: widget.vocab),
      ],
    );
  }

  _vocabList(String title) {
    var jvocab = json.decode(widget.vocab);

    return showVocabs(context, jvocab);
  }

  Widget showVocabs(context, vocabs) {
    return ListView.builder(
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemCount: vocabs.length,
      itemBuilder: (BuildContext context, int index) {
        if (index == 0) {
          return _getBanner(context, vocabs[index]);
        } else {
          var w = vocabs[index];
          return _getTitle(context, w);
        }
      },
    );
  }

  Widget _getBanner(BuildContext context, var info) {
    String lessonID = info['lesson_id'];
    LessonBanner lb = getLessonBanner2(lessonID);
    if (lb.videoUrl != null)
      return Card(
        child: Column(
          children: <Widget>[
            getImage(info),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: <Widget>[
                  Text(
                    info['title'],
                    style: TextStyle(
                        color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  IconButton(
                    onPressed: () async {
                      await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => VideoPlayerScreen(
                              lesson: info['title'],
                              videoUrl: lb.videoUrl,
                            ),
                          ));
                    },
                    icon: Icon(Icons.ondemand_video),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    else {
      return Card(
        child: Column(
          children: <Widget>[
            getImage(info),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                info['title'],
                style:
                    TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      );
    }
  }

  Widget getImage(info) {
    String lessonID = info['lesson_id'];

    String s = getLessonBanner(lessonID);

    if (s == null) s = info['image'];

    if (s.startsWith('http')) {
      return Image.network(
        info['image'],
        fit: BoxFit.cover,
      );
    } else {
      return Image.asset(
        s,
      );
    }
  }

  Widget _getTitle(BuildContext context, var w) {
    //String w = _words[index]['word'];
    String e = _Help.makeEngShort(_Help.removeCL(w['eng']));
    var ch = Provider.of<UserPreference>(context, listen: true).chineseStandard;
    var wordID = ch == 'T' ? 'word_t' : 'word';
    var zi = w[wordID];
    return Card(
      child: ListTile(
        title: HanjiButtons(
          zi,
          simplified: w['word'], // onTap's chinese will refer to this
          onTap: (int offset, String chinese, String simplified) {
            if (_add2Selection(simplified, w)) {
              showMessage(chinese + ' added', (actionConfirm) {
                print(actionConfirm);
                if (actionConfirm) {
                  widget.tabController.index = 1;
                }
              });
            } else {
              setCharIndexAndPractice(chinese);
              widget.tabController.index = 1;
              /*
              showMessage(chinese + ' already exists', (actionConfirm) {
                print(actionConfirm);
                if (actionConfirm) {
                  setCharIndexAndPractice(chinese);

                  widget.tabController.index = 1;
                }
              });*/
            }
          },
        ),
        trailing: Text(w['pinyin']),
        subtitle: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(e),
        ),
        onTap: () {
          var zi = w['word'];
          for (int k = 0; k < zi.length; k++) {
            var simplified = zi[k];
            _add2Selection(simplified, w);
            setCharIndexAndPractice(simplified);
          }

          widget.tabController.index = 1;
          // _addToSelection(context, index, 0);
          //   _controller.nextPage(
          //     duration: Duration(seconds: 1), curve: Curves.easeIn);
        },
      ),
    );
  }

  Future showMessage(String msg, ShowCallback cb) {
    var action1 = SnackBarAction(
      label: 'Practice now?',
      textColor: Colors.white,
      onPressed: () {
        print('again');
      },
    );
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
      } else {
        cb(true);
      }
    });
  }

  bool _add2Selection(String simplified, Map<String, dynamic> word) {
    String pinyin = _Help.makePinyin(simplified, word);
    String hint = word['eng']; //_Help.makeHint(chinese, word);
    String simplifiedWord = word['word'];
    String traditionalWord = word['word_t'];

    int offset = simplifiedWord.indexOf(simplified);
    String traditional = traditionalWord[offset];

    assert(offset != -1);

    return _addChar(new Kanji(simplified, pinyin, hint, traditional,
        simplifiedWord, traditionalWord));
  }

  bool _addChar(Kanji k) {
    if (!_Help.isKanji(k.simplified)) return false;
    var pListService = Provider.of<PracticeListService>(context, listen: false);
    print('before adding to store');
    print(pListService.store.getList());
    var rslt = pListService.store.addChar(k);
    if (rslt) {
      print('after adding to store');
      print(pListService.store.getList());
      pListService.store.gotoLast();
      print(pListService.store.charIndex());
      pListService.dirty = true;
      //   lst.broadcast();
    }
    return rslt;
  }

  void setCharIndexAndPractice(String zi) {
    print('index now is');

    var lst = Provider.of<PracticeListService>(context, listen: false);
    lst.store.setCharIndexByZi(zi);
  }
}

class _Help {
  static bool isKanji(String zi) {
    int v = zi.codeUnitAt(0);
    return (v >= 0x4E00) && (v <= 0x9FA5);
  }

  static String makePinyin(String char, knj) {
    String w = knj['word'];
    String p = knj['pinyin'];

    List<String> lst = p.split(' ');
    int charPos = w.indexOf(char);
    if (charPos == -1) {
      w = knj['word_t'];
      charPos = w.indexOf(char);
    }

    return lst[charPos];
  }

  static String makeHint(String char, knj) {
    String w = knj['word'];
    String e = knj['eng'];
    int n = e.indexOf('CL');
    if (n != -1) {
      e = e.substring(0, n);
    }

    e = makeEngShort(e);

    if (w.length > 1)
      return w.replaceFirst(char, '(' + char + ')') + ':' + e;
    else
      return e;
  }

  static String makeEngShort(String eng) {
    const maxLen = 80;
    if (eng.length > maxLen) {
      String temp = eng.substring(0, maxLen);
      int n = temp.lastIndexOf(';');
      if (n != -1) {
        return temp.substring(0, n) + '..';
      } else
        return temp;
    } else
      return eng;
  }

  static String removeCL(String e) {
    int n = e.indexOf('CL');
    if (n != -1) {
      e = e.substring(0, n);
    }
    return e;
  }
}

// to be removed:

/*
class Page1 extends StatefulWidget {
  final String vocab;
  final TabController tabController;

  const Page1({Key key, this.vocab, this.tabController}) : super(key: key);

  @override
  _Page1State createState() => _Page1State();
}

class _Page1State extends State<Page1>
    with AutomaticKeepAliveClientMixin<Page1> {
  TextStyle display1;
  TextStyle style4single;
  TextStyle style4multi;
//  List<dynamic> _words = [];
//  List<Kanji> _selected = [];
  double wordFontSize;

  Future<Null> getSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var sz = prefs.getDouble('wordFfontSize');

    setState(() {
      wordFontSize = sz == null ? 24.0 : sz;
    });
  }

  void initState() {
    super.initState();
    wordFontSize = 24.0;
    getSharedPrefs(); // if no await, future still completes only if error happens, become uncaught
    // https://stackoverflow.com/questions/37551843/invoking-async-function-without-await-in-dart-like-starting-a-thread
  }

  @override
  Widget build(Object context) {
    super.build(context);
    return Container(
        padding: const EdgeInsets.all(20.0),
        child: _buildWords(context, json.decode(widget.vocab)));
  }

  Widget _buildWords(BuildContext context, List words) {
    var lst = List<Widget>();

    // var wordID = Provider.of<UserPreference>(context, listen: false).chineseID;

    var wordID = 'word'; //fw traditional?

    if (wordID == 'word') {
      style4single =
          GoogleFonts.maShanZheng(color: Colors.black, fontSize: wordFontSize);
      style4multi = GoogleFonts.maShanZheng(
          decoration: TextDecoration.underline, fontSize: wordFontSize);
    } else {
      style4single =
          GoogleFonts.notoSans(color: Colors.black, fontSize: wordFontSize);
      style4multi = GoogleFonts.notoSans(
          decoration: TextDecoration.underline, fontSize: wordFontSize);
    }

    for (int i = 1; i < words.length; i++) {
      Map<String, dynamic> word =
          words[i]; // ex: {word: 八, pinyin: ba1, eng: eight; 8}

      if (word != null) {
        lst.add(new HanjiButton(
          word[wordID],
          textStyle1: style4single,
          textStyle2: style4multi,
          onTap: (int index, String chinese) {
            if (_add2Selection(chinese, word)) {
              showMessage(chinese + ' added', (actionConfirm) {
                print(actionConfirm);
                if (actionConfirm) {
                  widget.tabController.index = 1;
                }
              });
            } else {
              showMessage(chinese + ' already exists', (actionConfirm) {
                print(actionConfirm);
                if (actionConfirm) {
                  setCharIndexAndPractice(chinese);

                  widget.tabController.index = 1;
                }
              });
            }
          },
          onDoubleTap: (int index, String chinese) {
            setState(() {
              wordFontSize = wordFontSize + 10.0;
              if (wordFontSize > 64.0) wordFontSize = 24.0;
              SharedPreferences.getInstance().then((value) async {
                await value.setDouble('wordFfontSize', wordFontSize);
              });
            });
          },
          onLongPress: (int index, String chinese) {},
        ));
      }
    }

    return Column(
      children: <Widget>[
        Expanded(
          child: Container(
            padding: EdgeInsets.all(30),
            child: SingleChildScrollView(
              child: Wrap(
                direction: Axis.horizontal,
                crossAxisAlignment: WrapCrossAlignment.center,
                // direction: Axis.vertical,
                alignment: WrapAlignment.start,
                // verticalDirection: VerticalDirection.down,
                runSpacing: 8.0,
                //textDirection: TextDirection.rtl,
                spacing: 5.0,
                children: lst,
              ),
            ),
          ),
        ),
        Divider(),
        Container(
          child: Row(
            children: <Widget>[
              Container(
                width: 200,
                child: Text(
                  'Tap a word to select\ndouble tap for bigger fonts',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              Spacer(),
              InkWell(
                  onTap: () {
                    print('select all');
                    _addAllToSelection(context, words);
                  },
                  child:
                      Text('Select All', style: TextStyle(color: Colors.blue))),
            ],
          ),
        ),
      ],
    );
  }

  void setCharIndexAndPractice(String zi) {
    print('index now is');

    var lst = Provider.of<PracticeListService>(context, listen: false);
    lst.store.setCharIndexByZi(zi);
  }

  bool _add2Selection(String chinese, Map<String, dynamic> word) {
    String pinyin = _Help.makePinyin(chinese, word);
    var hint = word['eng']; //_Help.makeHint(chinese, word);
    var word_t = word['word_t'];

    print(word);
    print(word_t);
    return _addChar(
        new Kanji(chinese, pinyin, hint, word_t, word['word'], word['word_t']));
  }

  void _addAllToSelection(BuildContext context, List words) {
    int cnt = 0;
    print(words);
    for (int i = 1; i < words?.length; i++) {
      Map<String, dynamic> j = words[i];
      print('jj');
      print(j);
      print('jj-x');
      String word = j['word'].trim();
      for (int k = 0; k < word.length; k++) {
        String zi = word[k];
        _add2Selection(zi, j);
        cnt++;
      }
    }

    _showSnackbarMessage('$cnt characters added');
  }

  bool _addChar(Kanji k) {
    if (!_Help.isKanji(k.chinese)) return false;
    var pListService = Provider.of<PracticeListService>(context, listen: false);
    print('before adding to store');
    print(pListService.store.getList());
    var rslt = pListService.store.addChar(k);
    if (rslt) {
      print('after adding to store');
      print(pListService.store.getList());
      pListService.store.gotoLast();
      print(pListService.store.charIndex());
      pListService.dirty = true;
      //   lst.broadcast();
    }
    return rslt;
  }

  void _showSnackbarMessage(String msg) {
    Scaffold.of(context).showSnackBar(SnackBar(
        content: Text(msg),
        backgroundColor: Colors.redAccent,
        duration: const Duration(milliseconds: 500),
        action: null));
  }

  Future showMessage(String msg, ShowCallback cb) {
    var action1 = SnackBarAction(
      label: 'Practice now?',
      textColor: Colors.white,
      onPressed: () {
        print('again');
      },
    );
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
      } else {
        cb(true);
      }
    });
  }

  @override
  bool get wantKeepAlive {
    var plst = Provider.of<PracticeListService>(context, listen: false);
    print('plst?');
    print(plst.dirty);
    print(plst.store.count());
    print(plst.loaded);
    print('plst*');
    return true;
  }
} */
/*
class Page2 extends StatelessWidget {
  final String vocab;

  const Page2({Key key, this.vocab}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: Theme.of(context).textTheme.bodyText2,
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints viewportConstraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: viewportConstraints.maxHeight,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Container(
                    // A fixed-height child.
                    color: const Color(0xffeeee00), // Yellow
                    height: 120.0,
                    alignment: Alignment.center,
                    child: const Text('Fixed Height Content'),
                  ),
                  Container(
                    // Another fixed-height child.
                    color: const Color(0xff008000), // Green
                    height: 120.0,
                    alignment: Alignment.center,
                    child: const Text('Fixed Height Content'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
*/
