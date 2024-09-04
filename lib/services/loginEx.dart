import 'package:cpodpractice/services/login.dart';

// import 'dart:async';

void main() async {
  Login lg = Login();

  print('loginEx');
/*
  var apiKey = await lg.login(email: 'cpod@catalina.ph', password: 'cpod123*');
  print(apiKey);
  lg.logout();
  */

//  var code = await lg.getCode();

  //print(code);

  //var rslt = await lg.checkCode('7ADU');

  var rslt = await lg.checkSessionID('ed962c8c723ebd38ba24ad101140a60c');


  print('rslt');

  print(rslt);


 // lg.logout();

  // Await the http get response, then decode the json-formatted response.
}
/*
Response body: {
 "success": 1,
 "data": {
  "sessionid": "ed962c8c723ebd38ba24ad101140a60c",
  "updated_at": "2020-02-27 07:57:32"
 }
}

*/