import 'dart:async';
import 'package:curfind/main.dart';
import 'package:curfind/style/global_colors.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(milliseconds: (336 * 20).round()), () {
      runApp(App());
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: WallpaperColor.purple,
        body: Center(
          child: SizedBox(
            width: 120,
            height: 213.5,
            child: Lottie.asset('assets/splash_curfind.json'),
          ),
        ),
      ),
    );
  }
}
