import 'package:animate_do/animate_do.dart';
import 'package:curfind/style/global_colors.dart';
import 'package:curfind/view/Log/login_normal.dart';
import 'package:flutter/material.dart';

class SplashLogin extends StatefulWidget {
  const SplashLogin({super.key});

  @override
  State<SplashLogin> createState() => _SplashLoginState();
}

class _SplashLoginState extends State<SplashLogin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WallpaperColor.purple,
      body: const Stack(
        children: [
          SplashLogo(),
          Wave(),
          OptionsLogin(),
        ],
      ),
    );
  }
}

class SplashLogo extends StatelessWidget {
  const SplashLogo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FadeIn(
      child: Align(
          alignment: Alignment.center,
          child: Image.asset(
            'assets/slpash_logo.png',
            width: 120,
            height: 213.5,
          ),
        ),
    );
  }
}

class Wave extends StatelessWidget {
  const Wave({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: FadeInUpBig(
        child: Image.asset(
            'assets/green_wave.png',
            height: 310,
          ),
      ),
    );
  }
}

class OptionsLogin extends StatelessWidget {
  const OptionsLogin({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FadeInUpBig(
        child: const Padding(
          padding: EdgeInsets.fromLTRB(10, 10, 15, 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              BottomGoogle(),
              SizedBox(
                height: 15,
              ),
              BottomApple(),
              SizedBox(
                height: 12,
              ),
              BottomAlternate(),
              SizedBox(
                height: 19,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BottomGoogle extends StatelessWidget {
  const BottomGoogle({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: 43,
      child: ElevatedButton.icon(
        onPressed: () {
          /*Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => OtherPage()),
          );*/
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: WallpaperColor.purple,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        icon: Image.asset('assets/google_icon.png', width: 30),
        label: Text('Continuar con Google',
            style: TextStyle(
              color: TextColor.purpleWhite,
              fontSize: 18,
              decoration: TextDecoration.underline,
              decorationColor: TextColor.purpleWhite,
              fontFamily: 'Poppins',
            )),
      ),
    );
  }
}

class BottomApple extends StatelessWidget {
  const BottomApple({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: 43,
      child: ElevatedButton.icon(
        onPressed: () {
          /*Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => OtherPage()),
          );*/
        },
        icon: Image.asset('assets/apple_icon.png', width: 38),
        label: Text('Continuar con Apple ID',
            style: TextStyle(
              color: TextColor.purpleWhite,
              fontSize: 18,
              decoration: TextDecoration.underline,
              decorationColor: TextColor.purpleWhite,
              fontFamily: 'Poppins',
            )),
        style: ElevatedButton.styleFrom(
          backgroundColor: WallpaperColor.purple,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
    );
  }
}

class BottomAlternate extends StatelessWidget {
  const BottomAlternate({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to the desired page
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const LoginNormal()),
        );
      },
      child: const Text('Continuar de otra forma',
          style: TextStyle(
            color: Color(0xFFF8F4FF),
            fontSize: 16,
            decoration: TextDecoration.underline,
            decorationColor: Color(0xFFF8F4FF),
            fontFamily: 'Poppins',
          )),
    );
  }
}
