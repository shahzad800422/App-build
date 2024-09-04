import 'dart:collection';

import 'package:http/http.dart' as http;
import 'dart:convert';
import '../config.dart';

final String url = 'https://staging.chinesepod.com/api/v1/entrance/login';

class Login {
  Future login({String email, String password}) async {
    print('log me in');

    print(email);
    print(password);

    var response = await http.post(url, body: {
      'emailAddress': email,
      'password': password,
      'rememberMe': 'false'
    });

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    String apiKey;
    int statusCode = response.statusCode;

    if (statusCode == 200) {
      var rsp = json.decode(response.body);
      apiKey = rsp['token'];
      /*
      var setCookie = response.headers['set-cookie'];
      var cookie = setCookie.split(';');
      var CPODSESSID = cookie[0];
      if (CPODSESSID.startsWith('CPODSESSID=')) {
        int p = CPODSESSID.indexOf('=');
        if (p != -1) {
          apiKey = CPODSESSID.substring(p + 1);
        }
      }*/
    }

    print(response);

    return Future.value([statusCode, apiKey]);

    // print(await http.read('https://example.com/foobar.txt'));
  }

  // code base functions

  Future getCode() async {
    var response = await http.post(Config.GET_CODE_URL, body: {
      'client_id': 'chinesepodrecap',
    });

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    String regCode;
    int statusCode = response.statusCode;

    if (statusCode == 200) {
      var words = json.decode(response.body);
      int success = words['success'];

      if (success == 1) {
        regCode = words['data']['code'];
      }
    }

    return Future.value([statusCode, regCode]);
  }

  Future checkCode(String code) async {
    var response = await http.post(Config.CHECK_CODE_URL,
        body: {'client_id': 'chinesepodrecap', 'code': code});

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    int statusCode = response.statusCode;
    String sessionid;
    String err;

    if (statusCode == 200) {
      var words = json.decode(response.body);
      int success = words['success'];
      if (success == 1) {
        sessionid = words['data']['sessionid'];
      } else {
        err = words['error'];
      }
    }
    return Future.value([statusCode, sessionid, err]);
  }

  Future checkSessionID(String sessionID) async {
    var url = Config.CHECK_SESSION_ID + '?sessionid=$sessionID';

    print(url);

    // Await the http get response, then decode the json-formatted response.
    var response = await http.get(url);

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    int statusCode = response.statusCode;
    int data;
    int success;

    if (statusCode == 200) {
      var words = json.decode(response.body);
      print(words);
      success = words['success'];
      print(success.runtimeType);
      if (success == 1) {
        data = words['data'];
      }
    }
    return Future.value([statusCode, success, data]);
  }
}
