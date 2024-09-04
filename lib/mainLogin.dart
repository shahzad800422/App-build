import 'package:cpodpractice/contentService.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cpodpractice/authService.dart';
import 'package:url_launcher/url_launcher.dart';
import './login.dart';
import './oem.dart';
import './mainLessons.dart';

class MainLoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // centerTitle: true,
        title: Text(OEM.APP_NAME),
      ),
      body: buildContainer(context),
      bottomNavigationBar: _bottomBar(context),
    );
  }

  Widget _bottomBar(BuildContext context) {
    if (OEM.APP_WITH_CPOD == 'YES')
      return Card(
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => LoginPage(),
                  maintainState: false),
            );
          },
          child: Image.asset(
            'assets/images/connect_cpod.png',
          ),
        ),
      );
    else
      return null;    
  }

  Container buildBottomBar(BuildContext context) {
    return Container(
      color: Colors.redAccent,
      height: 50,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => LoginPage(),
                        maintainState: false),
                  );
                },
                child: Text(
                  'CONNECT TO YOUR ACCOUNT',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              InkWell(
                onTap: () {
                  launch('https://www.chinesepod.com/signup');
                },
                child: Text(
                  'Sign up via browser',
                  style: TextStyle(
                    color: Colors.white,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildContainer(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemCount: getLessonList(OEM.APP_SHORT_NAME).length,
      itemBuilder: (BuildContext context, int index) {
        return Card(
          child: _getTitle(context, index),
        );
      },
    );
  }

  Widget _getTitle(context, index) {
    // return Text(Lessons[index].name);

    return InkWell(
      onTap: () async {
        if (index > 0) {
          print('need to erase first');
          await Provider.of<ContentService>(context, listen: false)
              .erasePracticeSet();

          await Provider.of<AuthService>(context, listen: false)
              .createGuestUser(getLessonList(OEM.APP_SHORT_NAME)[index].type);
        }
      },
      child: Image.asset(
          // 'assets/images/66w7.jpg'
          // Lessons[index].imgUrl,

          getLessonList(OEM.APP_SHORT_NAME)[index].imgUrl),
    );
  }
}
