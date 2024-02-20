// ignore_for_file: unnecessary_null_comparison

import 'package:curfind/components/routes/Log/splash_login.dart';
import 'package:curfind/components/routes/views/screens.dart';
import 'package:curfind/components/splash_view.dart';
import 'package:curfind/shared/prefe_users.dart';
import 'package:flutter/material.dart';

class Routes extends StatefulWidget {
  const Routes({super.key});

  @override
  State<Routes> createState() => _RoutesState();
}

class _RoutesState extends State<Routes> {
  final prefs = PreferencesUser();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: SplashView.routname,
      routes: {
        SplashView.routname: (context) => const SplashView(),
        SplashLogin.routname: (context) => const SplashLogin(),
        Screens.routname: (context) => const Screens(),
      },
    );
  }
}
