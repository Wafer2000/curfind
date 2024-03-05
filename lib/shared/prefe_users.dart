import 'package:curfind/firebase/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesUser {
  static late SharedPreferences _prefs;

  static Future init() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    _prefs = await SharedPreferences.getInstance();
  }

  String get ultimateUid {
    return _prefs.getString('ultimateUid') ?? '';
  }

  set ultimateUid(String value) {
    _prefs.setString('ultimateUid', value);
  }

  String get photoPerfil {
    return _prefs.getString('photoPerfil') ?? '';
  }

  set photoPerfil(String value) {
    _prefs.setString('photoPerfil', value);
  }

  String get photoEncabezado {
    return _prefs.getString('photoEncabezado') ?? '';
  }

  set photoEncabezado(String value) {
    _prefs.setString('photoEncabezado', value);
  }

  String get photoLeft {
    return _prefs.getString('photoLeft') ?? '';
  }

  set photoLeft(String value) {
    _prefs.setString('photoLeft', value);
  }

  String get photoCenter {
    return _prefs.getString('photoCenter') ?? '';
  }

  set photoCenter(String value) {
    _prefs.setString('photoCenter', value);
  }

  String get photoRight {
    return _prefs.getString('photoRight') ?? '';
  }

  set photoRight(String value) {
    _prefs.setString('photoRight', value);
  }

  String get description {
    return _prefs.getString('description') ?? '';
  }

  set description(String value) {
    _prefs.setString('description', value);
  }
}
