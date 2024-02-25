// ignore_for_file: use_build_context_synchronously, await_only_futures, unnecessary_null_comparison

import 'package:curfind/components/routes/Log/splash_login.dart';
import 'package:curfind/components/routes/views/screens.dart';
import 'package:curfind/shared/prefe_users.dart';
import 'package:curfind/style/global_colors.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoadingPage extends StatefulWidget {
  static const String routname = 'LoadingPage';
  const LoadingPage({super.key});

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  @override
  void initState() {
    super.initState();
    PreferencesUser prefs = PreferencesUser();
    Future.delayed(Duration(milliseconds: (6720).round()), () async {
      final uid = await prefs.ultimateUid;
      if (uid != null && uid != '') {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) {return const Screens() ;}),
        );
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) {return const SplashLogin() ;}),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WallpaperColor.purpleLight().color,
      body: Center(
        child: Transform.scale(
          scale: 3,
          child: SizedBox(
            child: Lottie.asset(
              'assets/loading.json',
            ),
          ),
        ),
      ),
    );
  }
}