import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

typedef MyCallback(int offset, String selected);

class HanjiButton extends StatelessWidget {
  final String hanji;
  final MyCallback onTap;
  final MyCallback onDoubleTap;
  final MyCallback onLongPress;
  final TextStyle textStyle1;
  final TextStyle textStyle2;

  const HanjiButton(this.hanji,
      {Key key,
      this.onTap,
      @required this.textStyle1,
      @required this.textStyle2,
      this.onDoubleTap,
      this.onLongPress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List lst = hanji.split('');

    List<Widget> btns = [];
    bool single = lst.length == 1;
    for (var i = 0; i < lst.length; i++) {
      print(lst[i].runtimeType);
      btns.add(InkWell(
          onTap: () {
            if (onTap != null) onTap(i, lst[i]);
          },
          onDoubleTap: () {
            print('dobule press');
            if (onDoubleTap != null) onDoubleTap(i, lst[i]);
          },
          onLongPress: () {
            print('long press');
            if (onLongPress != null) onLongPress(i, lst[i]);
          },
          child: Text(
            lst[i],
            style: single ? textStyle1 : textStyle2,
          )));
      // var b =InkWell(child: lst[i]);
      // btns.add(b);
    }

    if (single) {
      return btns[0];
    } else {
      return Wrap(
        children: btns,
      );
    }
  }
  /*
  Widget build(BuildContext context) {
    List lst = hanji.split('');
    if (lst.length == 1) {
      return InkWell(
        onTap: () {
          if (onTap != null) onTap(0, hanji);
        },
        onLongPress: () {
          print('long press');
        },
        onDoubleTap: () {
          print('double tap');
        },
        child: Text(
          hanji,
          style: textStyle1,
        ),
      );
    } else {
      List<Widget> btns = [];
      for (var i = 0; i < lst.length; i++) {
        print(lst[i].runtimeType);
        btns.add(InkWell(
            onTap: () {
              if (onTap != null) onTap(i, lst[i]);
            },
            child: Text(
              lst[i],
              style: textStyle2,
            )));
        // var b =InkWell(child: lst[i]);
        // btns.add(b);
      }

      print(btns);

      return Wrap(
        children: btns,
      );
    }
  }
  */
}
