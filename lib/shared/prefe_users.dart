import 'package:shared_preferences/shared_preferences.dart';

class PreferencesUser {
  static late SharedPreferences _prefs;

  static Future init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  String get ultimatePage {
    return _prefs.getString('ultimatePage') ?? 'SplashLogin';
  }

  set ultimatePage(String value) {
    _prefs.setString('ultimatePage', value);
  }

  String get ultimateUid {
    return _prefs.getString('ultimateUid') ?? '';
  }

  set ultimateUid(String value) {
    _prefs.setString('ultimateUid', value);
  }
}
