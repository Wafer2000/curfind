// ignore_for_file: avoid_print
import 'package:curfind/shared/prefe_users.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  writeSecureData(String value) async {
    final pref = PreferencesUser();
    pref.ultimateUid = value;
    await storage.write(key: 'uid', value: value);
  }

  readSecureData() async {
    String value = await storage.read(key: 'uid') ?? "No data found";
    print("Data read from secure storage: $value");
  }

  deleteSecureData() async {
    await storage.delete(key: 'uid');
  }
}
