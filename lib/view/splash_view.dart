import 'dart:async';

import 'package:curfind/style/global_colors.dart';
import 'package:curfind/view/Log/splash_login.dart';
import 'package:curfind/view/home/home.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  bool inLoggedIn = false;
  @override
  void initState() {
    super.initState();
    Timer(Duration(milliseconds: (336 * 20).round()), () {
      if(inLoggedIn){
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const Home()),
        );
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const SplashLogin()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WallpaperColor.purple,
      body: Center(
        child: SizedBox(
          width: 120,
          height: 213.5,
          child: Lottie.asset('assets/splash_curfind.json'),
        ),
      ),
    );
  }
}

/*mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
                width: 84,
                height: 132.8,
                child: Image.asset("assets/logo_curfind.png")),
            SizedBox(
                width: 152.4,
                height: 56.6,
                child: Image.asset("assets/nombre_curfind.png"))
          ],*/
