import 'package:animate_do/animate_do.dart';
import 'package:curfind/style/global_colors.dart';
import 'package:flutter/material.dart';

class LoginNormal extends StatefulWidget {
  const LoginNormal({super.key});

  @override
  State<LoginNormal> createState() => _LoginNormalState();
}

class _LoginNormalState extends State<LoginNormal> {
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
    return Stack(children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(0, 100, 0, 0),
        child: FadeInUp(
          child: Align(
              alignment: Alignment.topCenter,
              child: SizedBox(
                  width: 120, child: Image.asset('assets/slpash_logo.png'))),
        ),
      ),
    ]);
  }
}

class Wave extends StatelessWidget {
  const Wave({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Stack(
      children: [
        FadeInUpBig(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              width: size.width,
              child: Image.asset(
                'assets/green_super_wave.png',
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class OptionsLogin extends StatelessWidget {
  const OptionsLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FadeInUpBig(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 10, 15, 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Inputs(),
              const SizedBox(
                height: 40,
              ),
              const BottomLogin(),
              const SizedBox(
                height: 19,
              ),
              const ChangePassword(),
              const SizedBox(
                height: 22,
              ),
              const Bottoms(),
              const SizedBox(
                height: 29,
              ),
              const Register(),
              const SizedBox(
                height: 110,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Inputs extends StatelessWidget {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Inputs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 40),
        CustomInput(),
      ],
    );
  }
}

class CustomInput extends StatelessWidget {
  const CustomInput({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextField(
            style: TextStyle(
                color: TextColor.purpleWhite,
                fontSize: 18,
                fontFamily: 'Poppins'),
            decoration: InputDecoration(
              labelText: 'Cuenta',
              filled: false,
              labelStyle: TextStyle(
                  color: TextColor.purpleWhite,
                  fontSize: 15,
                  fontFamily: 'Poppins'),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: TextColor.purpleWhite, width: 2),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: TextColor.purpleWhite, width: 2),
              ),
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            style: TextStyle(
                color: TextColor.purpleWhite,
                fontSize: 18,
                fontFamily: 'Poppins'),
            decoration: InputDecoration(
              labelText: 'Contraseña',
              labelStyle: TextStyle(
                  color: TextColor.purpleWhite,
                  fontSize: 15,
                  fontFamily: 'Poppins'),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: TextColor.purpleWhite, width: 2),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: TextColor.purpleWhite, width: 2),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class BottomLogin extends StatelessWidget {
  const BottomLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 270,
      height: 45,
      child: ElevatedButton(
        onPressed: () {
          /*Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => OtherPage()),
          );*/
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: WallpaperColor.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 4,
        ),
        child: Text('Ingresar',
            style: TextStyle(
              color: TextColor.purpleWhite,
              fontSize: 21,
              decoration: TextDecoration.underline,
              decorationColor: TextColor.purpleWhite,
              fontFamily: 'Poppins',
            )),
      ),
    );
  }
}

class ChangePassword extends StatelessWidget {
  const ChangePassword({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      /*onTap: () {
        // Navigate to the desired page
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const LoginNormal()),
        );
      },*/
      child: const Text('Cambiar contraseña',
          style: TextStyle(
            color: Color(0xFFF8F4FF),
            fontSize: 14,
            fontFamily: 'Poppins',
          )),
    );
  }
}

class Bottoms extends StatelessWidget {
  const Bottoms({super.key});

  @override
  Widget build(BuildContext context) {
    return const Align(
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [BottomGoogle(), BottomApple()],
      ),
    );
  }
}

class BottomGoogle extends StatelessWidget {
  const BottomGoogle({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ElevatedButton(
        onPressed: () {
          /*Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => OtherPage()),
          );*/
        },
        style: ElevatedButton.styleFrom(
          shape: const CircleBorder(),
          backgroundColor: WallpaperColor.white,
          elevation: 4,
        ),
        child: Image.asset('assets/google_grey_icon.png', width: 33),
      ),
    );
  }
}

class BottomApple extends StatelessWidget {
  const BottomApple({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ElevatedButton(
        onPressed: () {
          /*Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => OtherPage()),
          );*/
        },
        style: ElevatedButton.styleFrom(
          shape: const CircleBorder(),
          backgroundColor: WallpaperColor.white,
          elevation: 4,
        ),
        child: Image.asset('assets/apple_grey_icon.png', width: 33),
      ),
    );
  }
}

class Register extends StatelessWidget {
  const Register({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      /*onTap: () {
        // Navigate to the desired page
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const LoginNormal()),
        );
      },*/
      child: const Text('¿No tienes una cuenta?',
          style: TextStyle(
            color: Color(0xFFF8F4FF),
            fontSize: 14,
            fontFamily: 'Poppins',
          )),
    );
  }
}
