import 'package:cpod_server/cpod_server.dart';
import 'package:cpodpractice/setLessonService.dart';
import 'package:cpodpractice/settings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './authService.dart';
import './splash.dart';
// import 'Licenses.dart';
import './about.dart';
import 'contentService.dart';
import 'mainLogin.dart';
import './maintab.dart';
import './userPreference.dart';
import './practiceListService.dart';
import './practiceList.dart';
import './PrefsStore.dart';
import './sqlite3.dart';

// void main() => runApp(MyApp());

/*
void main() => runApp(
      ChangeNotifierProvider<AuthService>(
        child: MyApp(),
        create: (BuildContext context) {
          return AuthService();
        },
        lazy: false,
      ),
    );
*/

void main() => runApp(MultiProvider(providers: [
      Provider<CpodServer>(
        create: (_) {
          return CpodServer();
        },
        lazy: false,
      ),
      ChangeNotifierProvider<UserPreference>(
        create: (BuildContext context) {
          return UserPreference()..init();
        },
        child: Text('child'),
      ),
      Provider<PrefsStore>(
        create: (_) {
          return PrefsStore();
        },
        lazy: false,
      ),
      Provider<Sqlite3>(
        create: (_) {
          return Sqlite3()..connect();
        },
        lazy: false,
      ),
      ProxyProvider<CpodServer, ContentService>(
        update:
            (BuildContext context, CpodServer value, ContentService previous) {
          return previous..updateDependencies(value);
        },
        create: (_) {
          return ContentService();
        },
      ),
      ProxyProvider<ContentService, PracticeListService>(
        update: (BuildContext context, ContentService value,
            PracticeListService previous) {
          return previous..contentService = value;
        },
        create: (_) {
          return PracticeListService();
        },
      ),
      ProxyProvider<Sqlite3, SetLessonService>(
        create: (_) {
          return SetLessonService(); // called only once
        },
        update:
            (BuildContext context, Sqlite3 value, SetLessonService previous) {
          print('setLessonService');
          return previous..sq = value;
        },
      ),
      ChangeNotifierProxyProvider2<CpodServer, PrefsStore, AuthService>(
          lazy: false,
          update: (BuildContext context, CpodServer cServer, PrefsStore pStore,
              AuthService authService) {
            authService.server = cServer;
            return authService..prefsStore = pStore;
          },
          create: (context) => AuthService()),
    ], child: MyApp()));

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chinese Characters',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      routes: <String, WidgetBuilder>{
        '/about': (BuildContext context) {
          return About();
        },
        '/licenses': (_) {
          return Text('Licenses');
        },
        '/home': (_) {
          return MainTab(
            initialTab: 0,
          );
        },
        '/home2': (_) {
          return MainTab(
            initialTab: 1,
          );
        },
        '/home3': (_) {
          return MainTab(
            initialTab: 0,
          );
        },
        '/practiceList': (_) {
          return PracticeList();
        },
        '/settings': (_) {
          return Settings();
        }
      },

      home: mainPage(context),
      // home: mainPage(context),

      //PadPage(title: 'Chinese Character Practice'),
    );
  }
}

Widget landing(BuildContext context) {
  return FutureBuilder(
    future: Provider.of<AuthService>(context).getUser(),
    builder: (context, AsyncSnapshot snapshot) {
      print('hahaha in landing');
      print(snapshot.connectionState);
      if (snapshot.connectionState == ConnectionState.done) {
        // log error to console
        if (snapshot.error != null) {
          print("error");
          return Text(snapshot.error.toString());
        }
        print('--');
        print(snapshot.data);
        print(snapshot.hasData);
        print('==');
        if (snapshot.hasData) {
          // print(Navigator.of(context));
          // Navigator.of(context).popUntil((route) => route.isFirst);
          return mainPage(context);
        } else {
          return SplashPage(title: 'cpod');
        }
      } else {
        return Center(child: Container(child: LoadingCircle()));
      }
    },
  );
}

FutureBuilder mainPage(BuildContext context) {
  return FutureBuilder(
    future: Provider.of<AuthService>(context).getUser(),
    builder: (context, AsyncSnapshot snapshot) {
      print('hahaha');
      print(snapshot.connectionState);
      if (snapshot.connectionState == ConnectionState.done) {
        // log error to console
        if (snapshot.error != null) {
          print("error");
          return Text(snapshot.error.toString());
        }
        print('--');
        print(snapshot.data);
        print(snapshot.hasData);
        print('==');

        if (snapshot.hasData) {
          print('inside snashopt');
          return MainTab();
          // return PadMain(title: 'Chinese Character Practice');
        } else {
          return MainLoginPage();
        }
      } else {
        return Center(child: Container(child: LoadingCircle()));
      }
    },
  );
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
