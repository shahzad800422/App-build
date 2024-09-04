import 'dart:async';
import 'package:cpod_server/cpod_server.dart';
import 'package:flutter/material.dart';
import './PrefsStore.dart';
import './types.dart';

class AuthService with ChangeNotifier {
  Usr currentUser;
  /*
  var regCode = ''; //
  var regViews = 0; //
  var lastList;
*/
  CpodServer server;
  PrefsStore prefsStore;

  AuthService() {
    print('new AuthService');
  }

  Future<Usr> getUser() async {
    if (this.currentUser == null) {
      print('let try local data first');

      var user = await prefsStore.getUser();
      print('user below');
      print(user);
      if (user['email'] != null) {
        print('got one email');
        _setCurrentUser(user['email'], user['apiKey'], user['userType']);
        server.apiKey = user['apiKey'];
      } else {}
      print('user above');
    }
    return Future.value(currentUser);
  }

  logout() async {
    await prefsStore.delUser();
    this.currentUser = null;
    print('logging out');
    print(this.currentUser);
    //  notifyListeners();
  }

  Future createGuestUser(String userType) {
    _setCurrentUser('guest', null, userType);
    notifyListeners();
    return Future.value(this.currentUser);
  }

  // new approach login

  Future<Usr> login(
      {String email,
      String password,
      VoidCallback onPracticeSetOwnerDiff}) async {
    Completer<Usr> c = Completer();
    server.login(email: email, password: password).then((apiKey) async {
      if (apiKey[0] == 200) {
        _setCurrentUser(email, apiKey[1], 'CPOD');
        var practiceSetOwner = await prefsStore.getPracticeSetOwner();
        print('practiceSetOwner is $practiceSetOwner');
        if (onPracticeSetOwnerDiff != null) onPracticeSetOwnerDiff();
        await prefsStore.saveUser(email, apiKey[1], 'CPOD');
        notifyListeners();
        c.complete(this.currentUser);
      } else {
        this.currentUser = null;
        c.complete(null);
      }
    });

    return c.future;
  }

  void _setCurrentUser(String email, String apiKey, String userType) {
    this.currentUser = new Usr(email, apiKey, userType);
  }
}
