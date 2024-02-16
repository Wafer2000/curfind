import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:curfind/firebase/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesUser {
  static late SharedPreferences _prefs;

  static Future init() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    _prefs = await SharedPreferences.getInstance();

    // Inicializa el valor de ultimateUid desde el archivo local
    String? uid = await PreferencesUser.readUltimateUid();
    if (uid != null) {
      _prefs.setString('ultimateUid', uid);
    }
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/ultimateUid.txt');
  }

  static Future<String> readUltimateUid() async {
    try {
      final file = await PreferencesUser()._localFile;
      String contents = await file.readAsString();
      return contents;
    } catch (e) {
      return '';
    }
  }

  static Future<void> writeUltimateUid(String uid) async {
    final file = await PreferencesUser()._localFile;
    await file.writeAsString(uid);

    // Actualiza el valor de ultimateUid en SharedPreferences
    _prefs.setString('ultimateUid', uid);
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
    writeUltimateUid(value);
  }
}