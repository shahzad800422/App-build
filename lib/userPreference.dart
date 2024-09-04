import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

//const std = 'CHINESE_STANDARD';
const STD = 'CHINESE_STANDARD';    // traditional or simplified
const STROKE = 'STROKE_STYLE';
const OUTLINE = 'STROKE_OUTLINE';

class UserPreference with ChangeNotifier {
  String chineseStandard; // 'S' or 'T'
  String strokeSyle; // 'SNAP' or 'RAW'
  String isOutline; // YES or NO

  UserPreference();

/*
  static Future<String> get() async {
    var ref = await SharedPreferences.getInstance();
    String value = ref.getString(std);
    return value;
  }
*/
  static Future<String> get(String key) async {
    var ref = await SharedPreferences.getInstance();
    String value = ref.getString(key);
    return value;
  }

  init() async {
    print('init userPreference');
    var std = await UserPreference.get(STD);
    this.chineseStandard = std;
    this.strokeSyle = await UserPreference.get(STROKE);
    this.isOutline = await UserPreference.get(OUTLINE);

    print('stroke style');
    if (this.strokeSyle == null)
      this.strokeSyle = 'SNAP';

    print(this.strokeSyle);

    if (this.isOutline == null)
      this.isOutline = 'YES';

    notifyListeners();
  }

  // String get chineseID => 'word';

  save() {
    SharedPreferences.getInstance().then((value) async {
      await value.setString(STD, this.chineseStandard);
      await value.setString(STROKE, this.strokeSyle);
      await value.setString(OUTLINE, this.isOutline);
    });
  }
}
