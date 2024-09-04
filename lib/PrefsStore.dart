import 'package:shared_preferences/shared_preferences.dart';

class PrefsStore {
  static const EMAIL = 'v2UserEmail';
  static const APIKEY = 'v2UserApiKey';
  static const USERTYPE = 'v2UserType';
  static const PRACTICESETOWNER = 'v2PracticeSetOwner';

  dynamic getUser() async {
    final prefs = await SharedPreferences.getInstance();

    String email = prefs.getString(EMAIL);
    final String apiKey = prefs.getString(APIKEY);
    final String userType = prefs.getString(USERTYPE);
    final String practiceSetOwner = prefs.getString(PRACTICESETOWNER);

    print('email beflow');
    print(email);
    print(apiKey);

    print('read: $email');
    return {
      'email': email,
      'apiKey': apiKey,
      'userType': userType,
      'practiceSetOwner': practiceSetOwner
    };
  }

  getPracticeSetOwner() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(PRACTICESETOWNER);
  }

  saveUser(String email, String apiKey, String userType) async {
    print('saving user');
    final prefs = await SharedPreferences.getInstance();
    print('saving user 2');
    prefs.setString(EMAIL, email);
    prefs.setString(APIKEY, apiKey);
    prefs.setString(USERTYPE, userType);
    prefs.setString(PRACTICESETOWNER, email);
    print('save $email');
  }

  delUser() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(EMAIL);
    prefs.remove(APIKEY);
    prefs.remove(USERTYPE);
    // we do not remove practicesetOwner, he might login next time so we can compare
  }
}
