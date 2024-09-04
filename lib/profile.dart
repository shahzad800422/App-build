import 'package:cpod_server/cpod_server.dart';
import 'package:cpodpractice/practiceListService.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cpodpractice/authService.dart';

import 'main.dart';
/*
class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Profile'),
        ),
        body: buildContainer(context));
  }

  Widget buildContainer(context) {
    AuthService auth = Provider.of<AuthService>(context, listen: false);
    return Container(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: <Widget>[
              Image.asset(
                'assets/cpod.jpg',
                width: 100.0,
              ),
              SizedBox(
                height: 30,
              ),
               Text(au.currentUser.email),
               Text(value.currentUser.userType),
              Spacer(),
              RaisedButton(
                child: Text('logout'),
                onPressed: () async {
                  // print(value.currentUser);

                  Provider.of<CpodServer>(context, listen: false).apiKey = null;
                  Provider.of<PracticeListService>(context, listen: false)
                      .eraseAll();

                  await auth.logout();
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) =>
                              mainPage(context)));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
*/

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body:  Consumer<AuthService>(
        builder: (BuildContext context, AuthService value, Widget child) {
          return Container(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: <Widget>[
                    Image.asset(
                      'assets/cpod.jpg',
                      width: 100.0,
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Text(value.currentUser.email),
                    Text(value.currentUser.userType),
                    Spacer(),
                    RaisedButton(
                      child: Text('logout'),
                      onPressed: () async {
                        print(value.currentUser);

                        Provider.of<CpodServer>(context, listen: false).apiKey =
                            null;
                        Provider.of<PracticeListService>(context, listen: false)
                            .eraseAll();

                        await value.logout();
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    mainPage(context)));
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}


class ProfilePage2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Consumer<AuthService>(
        builder: (BuildContext context, AuthService value, Widget child) {
          return Container(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: <Widget>[
                    Image.asset(
                      'assets/cpod.jpg',
                      width: 100.0,
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Text(value.currentUser.email),
                    Text(value.currentUser.userType),
                    Spacer(),
                    RaisedButton(
                      child: Text('logout'),
                      onPressed: () async {
                        print(value.currentUser);

                        Provider.of<CpodServer>(context, listen: false).apiKey =
                            null;
                        Provider.of<PracticeListService>(context, listen: false)
                            .eraseAll();

                        await value.logout();
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    mainPage(context)));
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
