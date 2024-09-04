import 'package:flutter/material.dart';

import 'link_text.dart';

class About extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title: Text('About')),
      body: Center(
          child: Container(
        child: Column(
          children: <Widget>[
             SizedBox(height: 20,),
            LinkText('Terms', url: 'https://www.chinesepod.com/terms'),
            SizedBox(height: 20,),
            LinkText('Privacy', url: 'https://www.chinesepod.com/privacy'),
             SizedBox(height: 20,),
            LinkText('Credits', url: 'https://www.chinesepod.com/privacy'),
          ],
        ),
      )),
    );
  }
}
