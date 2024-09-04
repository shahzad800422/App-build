import 'dart:async';

import 'package:cpod_server/cpod_server.dart';
import 'package:cpodpractice/authService.dart';
import 'package:cpodpractice/contentService.dart';
import 'package:cpodpractice/main0Content.dart';
import 'package:cpodpractice/mainLessons.dart';
import 'package:cpodpractice/practiceList.dart';
import 'package:cpodpractice/practiceListService.dart';
import 'package:cpodpractice/setLessonService.dart';
import 'package:cpodpractice/settings.dart';
import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import 'package:package_info/package_info.dart';
import './main0padAnimator.dart';
import './profile.dart';
import './cpodSelection.dart';
import 'package:flutter/cupertino.dart';
import './oem.dart';
import 'main.dart';

/*
void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ChinesePod Writing App',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: Home(),
    );
  }
}
*/

// This is the main page of the app after login or landing pages

class TabCtrl {
  TabController ctrl;
}

class MainTab extends StatefulWidget {
  final initialTab;

  const MainTab({Key key, this.initialTab = 0}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return HomeState();
  }
}

class HomeState extends State<MainTab> {
  int _currentIndex = 0;

  Future beforeMainTabProc;

  final List<Widget> _children = [
    PracticePage(),
    CpodSelection(),
    Own(),
    ProfilePage()
  ];

  void initState() {
    super.initState();

    beforeMainTabProc = beforeMain(context);
  }

  @override
  void dispose() {
    print('disposing main tab');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: FutureBuilder(
          future: beforeMainTabProc,
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.error != null) {
                print("error");
                return Text(snapshot.error.toString());
              } else
                return buildMainTabScaffold();
              /*
              if (snapshot.hasData) {
                // print(Navigator.of(context));
                // Navigator.of(context).popUntil((route) => route.isFirst);
                //   Provider.of<CpodServer>(context, listen: false).apiKey =
                //     snapshot.data['apiKey'];
                //   return PadMain(context);
                print('inside snashopt');
                return buildMainTabScaffold();
                // return PadMain(title: 'Chinese Character Practice');
              }*/
            } else {
              return LoadingCircle();
            }
          }),
    );
  }

  Future<bool> _onBackPressed() async {
    print('wanna quit?');
    await signoutGuest(context);
    return Future.value(false);
  }

/* july 22, 2020
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: beforeMainTabProc,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.error != null) {
              print("error");
              return Text(snapshot.error.toString());
            } else
              return buildMainTabScaffold();
            /*
            if (snapshot.hasData) {
              // print(Navigator.of(context));
              // Navigator.of(context).popUntil((route) => route.isFirst);
              //   Provider.of<CpodServer>(context, listen: false).apiKey =
              //     snapshot.data['apiKey'];
              //   return PadMain(context);
              print('inside snashopt');
              return buildMainTabScaffold();
              // return PadMain(title: 'Chinese Character Practice');
            }*/
          } else {
            return LoadingCircle();
          }
        });
  }*/

  // this got called right after login/guest login

  Future beforeMain(copntext) {
    Completer c = Completer();

    print('beforemain');

    var auth = Provider.of<AuthService>(context, listen: false);
    auth.getUser().then((usr) {
      print('before veryt main, see user below');
      print(usr);
      print('first time?');

      if (usr.firstTime) {
        usr.firstTime = false;
        if (usr.userType != 'CPOD') {
          print('creating practiceset');
          var lessonId = getLessonIDFromType(usr.userType);
          print(lessonId);
          var cService = Provider.of<ContentService>(context, listen: false);
          Provider.of<SetLessonService>(context, listen: false)
              .createPracticeSet(lessonId)
              .then((pset) async {
            await cService.saveList(name: 'current', words: pset['words']);
            await cService.saveSelection(
                selectionName: 'current', jobject: pset['selection']);
            c.complete();
            // return null;
          });
        } else {
          _currentIndex = 1; // show list of lessons for first time cpod user

          c.complete();
        }
      } else {
        print('user not first time');

        c.complete();
      }
    });

    return c.future;
  }

  Scaffold buildMainTabScaffold() {
    var bottomBar;

    if (OEM.APP_WITH_CPOD == 'YES')
      bottomBar = buildBottomNavigationBar4CpodUser();
    else
      bottomBar = buildBottomNavigationBar4SetLessons();

    return Scaffold(
      body: getBody(_currentIndex),
      bottomNavigationBar: bottomBar,
    );
  }

  BottomNavigationBar buildBottomNavigationBar4CpodUser() {
    return BottomNavigationBar(
      showSelectedLabels: true,
      showUnselectedLabels: true,
      // backgroundColor: Colors.red,
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.black,
      onTap: onTabTapped,
      currentIndex: _currentIndex,
      items: [
        BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.pencil),
            title: new Text(
              'Practice',
            )),
        BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.book),
            title: new Text(
              'Lessons',
            )),
        BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.tags),
            title: new Text(
              'Net Lessons',
            )),
        BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.profile_circled), title: Text('Profile')),

/*
        BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.bookmark), title: Text('Selections')),*/
      ],
    );
  }

  Widget getBody(int index) {
    /*  if (index == 0)
    
      return PracticePage(
        initialIndex: widget.initialTab,
      );
    else*/
    return _children[index];
  }

  Future<void> onTabTapped(int index) async {
    setState(() {
      _currentIndex = index;
    });
  }

  BottomNavigationBar buildBottomNavigationBar4SetLessons() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.shifting,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      // backgroundColor: Colors.red,
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.black,
      onTap: onTabSetLessons,
      currentIndex: _currentIndex,
      items: [
        BottomNavigationBarItem(
          backgroundColor: Colors.red,
          icon: Opacity(
              opacity: 1.0,
              child: Icon(
                Icons.list,
                color: Colors.white,
              )),
          title: Text(
            'List',
            style: TextStyle(color: Colors.white),
          ),
        ),
        BottomNavigationBarItem(
            icon: Icon(
              CupertinoIcons.bookmark,
              color: Colors.white,
            ),
            title: Text(
              'Select',
              style: TextStyle(color: Colors.white),
            )),
      ],
    );
  }

  Future<void> onTabSetLessons(int index) async {
    if (index == 1) {
      // user press 'select'
      await signoutGuest(context);
    } else {
      // fw can we set it to practice pad?
      await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PracticeList(),
          ));
    }
  }

  signoutGuest(context) async {
    print('signing guest out');
    Provider.of<CpodServer>(context, listen: false).apiKey = null;
    Provider.of<PracticeListService>(context, listen: false).eraseAll();
    await Provider.of<AuthService>(context, listen: false).logout();
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => mainPage(context)));
  }
}

// this the 0 page of the MainTab, it contains two tabs: PRACTICE and CONTENT

class PracticePage extends StatefulWidget {
  final int initialIndex;

  const PracticePage({Key key, this.initialIndex = 0}) : super(key: key);
  @override
  PracticePageState createState() => PracticePageState();
}

class PracticePageState extends State<PracticePage>
    with SingleTickerProviderStateMixin {
  List tabs = ["PRACTICE", "CONTENT"];
  TabController tabController;
  @override
  void initState() {
    super.initState();
    tabController = TabController(
        initialIndex: widget.initialIndex, length: tabs.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: widget.key,
      appBar:
          //Will show when SE(
          AppBar(
        title: const Text(OEM.APP_NAME),
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (value) async {
              print(value);
              if (value == 0) {
                // Navigator.pushNamed(context, '/about');
                PackageInfo packageInfo = await PackageInfo.fromPlatform();
                showAboutDialog(
                    context: context,
                    applicationName: OEM.APP_NAME,
                    applicationVersion:
                        '${packageInfo.version} (build: ${packageInfo.buildNumber})',
                        
                    applicationIcon: null,/*Image.asset(
                      'assets/cpod.jpg',
                      width: 30.0,
                    ),*/
                    applicationLegalese: 'to be provided when released');
              } else {
                await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Settings(),
                    ));
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 0,
                child: Text("About"),
              ),
              PopupMenuItem(
                value: 1,
                child: Text("Settings"),
              ),
            ],
          ),
        ],
      ),
      body: practiceBody(),
    );
  }

  Widget practiceBody() {
    return Column(
      children: <Widget>[
        Material(
          color: Colors.red,
          child: TabBar(
            onTap: (int n) async {
              print(n);
              if (n == 1) {
                await Provider.of<PracticeListService>(context, listen: false)
                    .save();
              }
            },
            labelColor: Colors.redAccent,
            unselectedLabelColor: Colors.white,
            indicatorSize: TabBarIndicatorSize.label,
            indicator: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(5), topRight: Radius.circular(5)),
                color: Colors.white),
            tabs: [
              Tab(
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      "CONTENT",
                    ),
                  ),
                ),
              ),
              Tab(
                child: Align(
                  alignment: Alignment.center,
                  child: Text("PRACTICE"),
                ),
              ),
            ], //tabs.map((text) => Tab(text: text)).toList(),
            controller: tabController,
            // labelColor: Colors.black,
            indicatorColor: Colors.red,
          ),
        ),
        Expanded(
          child: Provider<TabCtrl>(
            create: (BuildContext context) {
              return TabCtrl()..ctrl = tabController;
            },
            child: TabBarView(
                physics: NeverScrollableScrollPhysics(),
                controller: tabController,
                children: [
                  // ShowPadFB(context),
                  MainContent(tabController: tabController),
                  ShowPad(tabController: tabController),
                ]),
          ),
        ),
      ],
    );
  }
}

class Own extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Net Lessons')),
        body: Center(
            child: Container(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  children: <Widget>[
                    Text('Net Lessons'),
                    SizedBox(
                      height: 20,
                    ),
                    Image.asset(
                      'assets/cpod.jpg',
                      width: 100.0,
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 20),
                      width: 200,
                      child: Text(
                        "We are evaluating user contributed contents right now, please come back later.",
                        overflow: TextOverflow.ellipsis,
                        maxLines: 5,
                      ),
                    ),
                  ],
                ))));
  }
}

class LoadingCircle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: CircularProgressIndicator(),
        alignment: Alignment(0.0, 0.0),
      ),
    );
  }
}
