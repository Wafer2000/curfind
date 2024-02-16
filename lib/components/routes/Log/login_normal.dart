// ignore_for_file: unused_field, use_build_context_synchronously

import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curfind/components/routes/Log/registro_normal.dart';
import 'package:curfind/components/routes/config/snackbar.dart';
import 'package:curfind/components/routes/views/screens.dart';
import 'package:curfind/firebase/firebase_auth.dart';
import 'package:curfind/shared/prefe_users.dart';
import 'package:curfind/style/global_colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginNormal extends StatefulWidget {
  const LoginNormal({super.key});

  @override
  State<LoginNormal> createState() => _LoginNormalState();
}

class _LoginNormalState extends State<LoginNormal> {
  @override
  Widget build(BuildContext context) {
    return const Stack(children: [
      Wave(),
      Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            OptionsLogin(),
          ],
        ),
      ),
    ]);
  }
}

class SplashLogo extends StatelessWidget {
  const SplashLogo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      FadeInUp(
        child: Align(
            alignment: Alignment.topCenter,
            child: SizedBox(
                width: 120, child: Image.asset('assets/slpash_logo.png'))),
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
    return Container(
      color: WallpaperColor.purple().color,
      width: size.width,
      height: size.height,
      child: Stack(
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
      ),
    );
  }
}

class OptionsLogin extends StatelessWidget {
  const OptionsLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FadeInUpBig(
        child: const Padding(
          padding: EdgeInsets.fromLTRB(10, 0, 15, 8),
          child: SingleChildScrollView(
            reverse: false,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  height: 60,
                ),
                SplashLogo(),
                SizedBox(
                  height: 130,
                ),
                Inputs(),
                SizedBox(
                  height: 19,
                ),
                ChangePassword(),
                SizedBox(
                  height: 22,
                ),
                Bottoms(),
                SizedBox(
                  height: 29,
                ),
                Register(),
                SizedBox(
                  height: 110,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Inputs extends StatefulWidget {
  const Inputs({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _InputsState createState() => _InputsState();
}

class _InputsState extends State<Inputs> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _emailIsValid = false;
  bool _passwordIsValid = false;

  void updateEmailValidity(bool isValid) {
    setState(() {
      _emailIsValid = isValid;
    });
  }

  void updatePasswordValidity(bool isValid) {
    setState(() {
      _passwordIsValid = isValid;
    });
  }

  void _signInWithEmailAndPassword(
      BuildContext context,
      TextEditingController emailController,
      TextEditingController passwordController) async {
    final email = emailController.text;
    final password = passwordController.text;

    var pref = PreferencesUser();
    final now = DateTime.now();
    final hingreso = DateFormat('HH:mm:ss').format(now);
    final fingreso = DateFormat('yyyy-MM-dd').format(now);

    var uid = await AuthService().signInWithEmailAndPassword(email, password);
    //final SharedPreferences sharedPreferences = 
    if (uid == 1) {
      showSnackBar(context, 'Error: El usuario no existe');
    } else if (uid == 2) {
      showSnackBar(context, 'Error: Contraseña Incorrecta');
    } else if (uid != null) {
      pref.ultimateUid = uid;

      FirebaseFirestore.instance.collection('Users').doc(uid).update({
        'hingreso': hingreso,
        'fingreso': fingreso,
      });
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Screens()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 40),
        CustomInputs(
          emailController: _emailController,
          passwordController: _passwordController,
        ),
        const SizedBox(
          height: 40,
        ),
        ButtomLogin(
          emailController: _emailController,
          passwordController: _passwordController,
          onTap: _emailIsValid && _passwordIsValid
              ? () {
                  _signInWithEmailAndPassword(
                      context, _emailController, _passwordController);
                }
              : null,
        ),
      ],
    );
  }
}

class CustomInputs extends StatelessWidget {
  const CustomInputs({
    super.key,
    required TextEditingController emailController,
    required TextEditingController passwordController,
  })  : _emailController = emailController,
        _passwordController = passwordController;

  final TextEditingController _emailController;
  final TextEditingController _passwordController;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 300,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InputEmail(emailController: _emailController),
            const SizedBox(height: 10),
            InputPassword(passwordController: _passwordController)
          ],
        ),
      ),
    );
  }
}

class InputEmail extends StatefulWidget {
  const InputEmail({
    required TextEditingController emailController,
    super.key,
  }) : _emailController = emailController;

  final TextEditingController _emailController;

  @override
  State<InputEmail> createState() => _InputEmailState();
}

class _InputEmailState extends State<InputEmail> {
  final focusNode = FocusNode();
  String? _emailErrorText;

  @override
  Widget build(BuildContext context) {
    final inputsState = context.findAncestorStateOfType<_InputsState>()!;

    return TextField(
      focusNode: focusNode,
      onTapOutside: (event) {
        focusNode.unfocus();
      },
      controller: widget._emailController,
      style: TextStyle(
          color: TextColor.purple().color, fontSize: 18, fontFamily: 'Poppins'),
      decoration: InputDecoration(
        labelText: 'Correo',
        labelStyle: TextStyle(
            color: TextColor.purple().color,
            fontSize: 15,
            fontFamily: 'Poppins'),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: TextColor.purple().color, width: 2),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: TextColor.purple().color, width: 2),
        ),
        errorText: _emailErrorText, // Agregar errorText
      ),
      onChanged: (value) {
        setState(() {
          _emailErrorText = InputValidator.validateEmail(value);
          inputsState.updateEmailValidity(_emailErrorText == null);
        });
      },
    );
  }
}

class InputPassword extends StatefulWidget {
  const InputPassword({
    super.key,
    required TextEditingController passwordController,
  }) : _passwordController = passwordController;

  final TextEditingController _passwordController;

  @override
  State<InputPassword> createState() => _InputPasswordState();
}

class _InputPasswordState extends State<InputPassword> {
  final focusNode = FocusNode();
  String? _passwordErrorText;
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    final inputsState = context.findAncestorStateOfType<_InputsState>()!;

    return Stack(
      children: [
        TextField(
          focusNode: focusNode,
          onTapOutside: (event) {
            focusNode.unfocus();
          },
          obscureText: !_isPasswordVisible,
          controller: widget._passwordController,
          style: TextStyle(
              color: TextColor.purple().color,
              fontSize: 18,
              fontFamily: 'Poppins'),
          decoration: InputDecoration(
            labelText: 'Contraseña',
            labelStyle: TextStyle(
                color: TextColor.purple().color,
                fontSize: 15,
                fontFamily: 'Poppins'),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: TextColor.purple().color, width: 2),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: TextColor.purple().color, width: 2),
            ),
            errorText: _passwordErrorText, // Agregar errorText
          ),
          onChanged: (value) {
            setState(() {
              _passwordErrorText = InputValidator.validatePassword(value);
            });
            inputsState.updatePasswordValidity(_passwordErrorText == null);
          },
        ),
        Positioned(
          right: 0,
          child: IconButton(
            icon: Icon(
              _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
              color: TextColor.purple().color,
            ),
            onPressed: () {
              setState(() {
                _isPasswordVisible = !_isPasswordVisible;
              });
            },
          ),
        ),
      ],
    );
  }
}

class InputValidator {
  static String? validateEmail(String value) {
    if (value.isEmpty) {
      return 'El correo electrónico es requerido';
    }
    if (!RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(value)) {
      return 'El correo electrónico debe tener un formato válido';
    }
    return null;
  }

  static String? validatePassword(String value) {
    if (value.length < 8) {
      return 'La contraseña debe tener al menos 8 caracteres';
    }
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'La contraseña debe contener al menos una letra mayúscula';
    }
    if (!value.contains(RegExp(r'[a-z]'))) {
      return 'La contraseña debe contener al menos una letra minúscula';
    }
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'La contraseña debe contener al menos un dígito';
    }
    if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return 'La contraseña debe contener al menos un símbolo';
    }
    return null;
  }
}

class ButtomLogin extends StatelessWidget {
  const ButtomLogin({
    super.key,
    required TextEditingController emailController,
    required TextEditingController passwordController,
    this.onTap,
  })  : _emailController = emailController,
        _passwordController = passwordController;

  final TextEditingController _emailController;
  final TextEditingController _passwordController;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 270,
        height: 45,
        child: ElevatedButton(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: WallpaperColor.white().color,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            elevation: 4,
          ),
          child: Text('Ingresar',
              style: TextStyle(
                color: TextColor.purple().color,
                fontSize: 21,
                decoration: TextDecoration.underline,
                decorationColor: TextColor.purple().color,
                fontFamily: 'Poppins',
              )),
        ),
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
      child: const Text('¿Olvidaste tu contraseña?',
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
          backgroundColor: WallpaperColor.white().color,
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
          backgroundColor: WallpaperColor.white().color,
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
      onTap: () {
        // Navigate to the desired page
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const RegistroNormal()),
        );
      },
      child: const Text('¿No tienes una cuenta?',
          style: TextStyle(
            color: Color(0xFFF8F4FF),
            fontSize: 14,
            fontFamily: 'Poppins',
          )),
    );
  }
}
