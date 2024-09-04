import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

typedef MyCallback(int offset, String selected, String simplified);

class HanjiButtons extends StatelessWidget {
  final String hanji;
  final String simplified;
  final MyCallback onTap;
  final MyCallback onDoubleTap;
  final MyCallback onLongPress;

  const HanjiButtons(this.hanji,
      {Key key,
      this.onTap,
      this.onDoubleTap,
      this.onLongPress,
      @required this.simplified})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> lst = hanji.split(''); // 简或繁
    List<String> simplifiedLst = simplified.split(''); // 简或繁

    List<Widget> wlst = [];
    List<bool> slst = [];
    for (var i = 0; i < lst.length; i++) {
      wlst.add(Text(lst[i]));
      slst.add(false);
    }
    return ToggleButtons(
      borderRadius: BorderRadius.all(new Radius.circular(5.0)),
      borderWidth: 0.5,
      borderColor: Colors.red,
      // selectedColor: Colors.red,
      selectedBorderColor: Colors.red,
      constraints: BoxConstraints(minHeight: 30, minWidth: 40),
      isSelected: slst,
      children: wlst,
      onPressed: (i) {
        print(i);
        if (onTap != null) onTap(i, lst[i], simplifiedLst[i]);
      },
    );
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

BoxDecoration myBoxDecoration() {
  return BoxDecoration(
    border: Border.all(
      color: Colors.red, //                   <--- border color
      width: 1.0,
    ),
  );
}
