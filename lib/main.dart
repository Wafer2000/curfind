import 'package:curfind/components/routes/Log/splash_login.dart';
import 'package:curfind/firebase/firebase_options.dart';
import 'package:curfind/shared/prefe_users.dart';
import 'package:curfind/components/routes/screens.dart';
import 'package:curfind/components/splash_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PreferencesUser.init();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then((_) {
    runApp(const SplashView());
  });
}

class App extends StatelessWidget {
  App({super.key});
  final prefs = PreferencesUser();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: prefs.ultimatePage,
      routes: {
        SplashLogin.routname: (contest) => const SplashLogin(),
      },
      //home: Screens(),
    );
  }
}