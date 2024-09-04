import 'package:flutter/material.dart';
import 'package:transformer_page_view/transformer_page_view.dart';

import './main.dart';

class SplashPage extends StatefulWidget {
  final String title;
  SplashPage({this.title});
  @override
  SplashPageState createState() {
    return new SplashPageState();
  }
}

class SplashPageState extends State<SplashPage> {
  int _slideIndex = 0;
  final GlobalKey<ScaffoldState> _key = new GlobalKey<ScaffoldState>();
  final List<String> images = [
    "assets/images/slide1.png",
    "assets/images/slide2.png",
    "assets/images/slide3.jpg",
  ];

  List<Color> colors = [Colors.orange];
  final List<String> text0 = [
    "Welcome",
    "Learn it easy.",
    "Practice cpod lessons"
  ];

  final List<String> text1 = [
    "An App for Chinesepod users.",
    "Write Directly On Screen.",
    "Get lessons in the app.",
  ];

  final IndexController controller = IndexController();

  @override
  Widget build(BuildContext context) {
    TransformerPageView transformerPageView = TransformerPageView(
        pageSnapping: true,
        onPageChanged: (index) {
          setState(() {
            this._slideIndex = index;
          });
        },
        loop: false,
        controller: controller,
        transformer: new PageTransformerBuilder(
            builder: (Widget child, TransformInfo info) {
          return new Material(
            color: Colors.white,
            elevation: 8.0,
            textStyle: new TextStyle(color: Colors.white),
            borderRadius: new BorderRadius.circular(12.0),
            child: new Container(
              alignment: Alignment.center,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                  
                    new ParallaxContainer(
                      child: new Text(
                        text0[info.index],
                        style: new TextStyle(
                            color: Colors.red,
                            fontSize: 30.0,
                            fontFamily: 'Quicksand',
                            fontWeight: FontWeight.bold),
                      ),
                      position: info.position,
                      opacityFactor: .8,
                      translationFactor: 400.0,
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    new ParallaxContainer(
                      child: new Image.asset(
                        images[info.index],
                        fit: BoxFit.contain,
                        height: 350,
                      ),
                      position: info.position,
                      translationFactor: 400.0,
                    ),
                    SizedBox(
                      height: 35.0,
                    ),
                    new ParallaxContainer(
                      child: new Text(
                        text1[info.index],
                        textAlign: TextAlign.center,
                        style: new TextStyle(
                            color: Colors.red,
                            fontSize: 20.0,
                            fontFamily: 'Quicksand',
                            fontWeight: FontWeight.bold),
                      ),
                      position: info.position,
                      translationFactor: 300.0,
                    ),
                    SizedBox(
                      height: 25.0,
                    ),
                    new ParallaxContainer(
                      position: info.position,
                      translationFactor: 500.0,
                      child: Dots(
                        controller: controller,
                        slideIndex: _slideIndex,
                        numberOfDots: images.length,
                      ),
                    ),
                    Container(
                        child: RaisedButton(
                            child: const Text('Get started!'),
                            color: Colors.red,
                            textColor: Colors.white,
                            disabledTextColor: Colors.white,
                            disabledColor: Colors.redAccent,
                            onPressed: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          mainPage(context)));
                            }),
                        // Text('some', style: TextStyle(color: Colors.red)),
                        padding: EdgeInsets.all(10.0))
                  ],
                ),
              ),
            ),
          );
        }),
        itemCount: 3);

    return Scaffold(
      backgroundColor: Colors.white,
      body: transformerPageView,
    );
  }
}

class Dots extends StatelessWidget {
  final IndexController controller;
  final int slideIndex;
  final int numberOfDots;
  Dots({this.controller, this.slideIndex, this.numberOfDots});

  List<Widget> _generateDots() {
    List<Widget> dots = [];
    for (int i = 0; i < numberOfDots; i++) {
      dots.add(i == slideIndex ? _activeSlide(i) : _inactiveSlide(i));
    }
    return dots;
  }

  Widget _activeSlide(int index) {
    return GestureDetector(
      onTap: () {
        print('Tapped');
      },
      child: new Container(
        child: Padding(
          padding: EdgeInsets.only(left: 8.0, right: 8.0),
          child: Container(
            width: 20.0,
            height: 20.0,
            decoration: BoxDecoration(
              color: Colors.orangeAccent.withOpacity(.3),
              borderRadius: BorderRadius.circular(50.0),
            ),
          ),
        ),
      ),
    );
  }

  Widget _inactiveSlide(int index) {
    return GestureDetector(
      onTap: () {
        controller.move(index);
      },
      child: new Container(
        child: Padding(
          padding: EdgeInsets.only(left: 5.0, right: 5.0),
          child: Container(
            width: 14.0,
            height: 14.0,
            decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.7),
                borderRadius: BorderRadius.circular(50.0)),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: _generateDots(),
    ));
  }
}
