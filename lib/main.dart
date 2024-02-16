import 'package:curfind/components/routes/Log/splash_login.dart';
import 'package:curfind/components/routes/views/screens.dart';
import 'package:curfind/firebase/firebase_options.dart';
import 'package:curfind/shared/prefe_users.dart';
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
      initialRoute: prefs.ultimateUid != null || prefs.ultimateUid != ''
          ? SplashLogin.routname
          : Screens.routname,
      routes: {
        SplashLogin.routname: (context) => const SplashLogin(),
        Screens.routname: (context) => const Screens(),
      },
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case SplashLogin.routname:
            if (prefs.ultimateUid != null || prefs.ultimateUid != '') {
              return MaterialPageRoute(builder: (context) {
                return const Screens();
              });
            } else {
              return MaterialPageRoute(builder: (context) {
                return const SplashLogin();
              });
            }
          // Add other routes here
          default:
            return MaterialPageRoute(builder: (context) {
              return const Scaffold(
                body: Center(
                  child: Text('Page not found'),
                ),
              );
            });
        }
      },
    );
  }
}
