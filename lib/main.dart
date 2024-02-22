// ignore_for_file: unnecessary_null_comparison
import 'package:curfind/components/routes.dart';
import 'package:curfind/firebase/firebase_options.dart';
import 'package:curfind/models/loading_page.dart';
import 'package:curfind/shared/prefe_users.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await PreferencesUser.init();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then((_) async {
    runApp(App());
  });
}

class App extends StatelessWidget {
  App({super.key});
  final prefs = PreferencesUser();

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Routes(),
      //home: LoadingPage(),
    );
  }
}
