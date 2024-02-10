import 'package:animate_do/animate_do.dart';
import 'package:curfind/components/routes/screens.dart';
import 'package:curfind/firebase/firebase_auth.dart';
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
      color: WallpaperColor.purple,
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
  const Inputs({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _InputsState createState() => _InputsState();
}

class _InputsState extends State<Inputs> {
  final _accountController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _accountIsValid = false;
  bool _passwordIsValid = false;

  void updateAccountValidity(bool isValid) {
    setState(() {
      _accountIsValid = isValid;
    });
  }

  void updatePasswordValidity(bool isValid) {
    setState(() {
      _passwordIsValid = isValid;
    });
  }

  void _signInWithEmailAndPassword(BuildContext context, TextEditingController accountController, TextEditingController passwordController) async {
    final account = accountController.text;
    final password = passwordController.text;

    // Aquí puedes enviar los datos a otro widget o función
    //print('Cuenta: $account, Contraseña: $password');

    try {
      // Llama al método signInWithEmailAndPassword de tu objeto Auth
      await Auth()
          .signInWithEmailAndPassword(email: account, password: password);

      // Si el inicio de sesión es exitoso, puedes navegar a otra pantalla
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Screens()),
      );
    } catch (e) {
      // Si hubo un error, muestra un mensaje al usuario
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error de inicio de sesión: $e')),
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
          accountController: _accountController,
          passwordController: _passwordController,
        ),
        const SizedBox(
          height: 40,
        ),
        ButtomLogin(
          accountController: _accountController,
          passwordController: _passwordController,
          onTap: _accountIsValid && _passwordIsValid
              ? () {
                  _signInWithEmailAndPassword(
                      context, _accountController, _passwordController);
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
    required TextEditingController accountController,
    required TextEditingController passwordController,
  })  : _accountController = accountController,
        _passwordController = passwordController;

  final TextEditingController _accountController;
  final TextEditingController _passwordController;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 300,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InputAccount(accountController: _accountController),
            const SizedBox(height: 10),
            InputPassword(passwordController: _passwordController)
          ],
        ),
      ),
    );
  }
}

class InputAccount extends StatefulWidget {
  const InputAccount({
    required TextEditingController accountController,
    super.key,
  }) : _accountController = accountController;

  final TextEditingController _accountController;

  @override
  State<InputAccount> createState() => _InputAccountState();
}

class _InputAccountState extends State<InputAccount> {
  String? _accountErrorText;

  @override
  Widget build(BuildContext context) {
    final inputsState = context.findAncestorStateOfType<_InputsState>()!;

    return TextField(
      controller: widget._accountController,
      style: TextStyle(
          color: TextColor.purpleWhite, fontSize: 18, fontFamily: 'Poppins'),
      decoration: InputDecoration(
        labelText: 'Correo',
        labelStyle: TextStyle(
            color: TextColor.purpleWhite, fontSize: 15, fontFamily: 'Poppins'),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: TextColor.purpleWhite, width: 2),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: TextColor.purpleWhite, width: 2),
        ),
        errorText: _accountErrorText, // Agregar errorText
      ),
      onChanged: (value) {
        setState(() {
          _accountErrorText = InputValidator.validateEmail(value);
          inputsState.updateAccountValidity(_accountErrorText == null);
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
  String? _passwordErrorText;

  @override
  Widget build(BuildContext context) {
    final inputsState = context.findAncestorStateOfType<_InputsState>()!;

    return TextField(
      obscureText: true,
      controller: widget._passwordController,
      style: TextStyle(
          color: TextColor.purpleWhite, fontSize: 18, fontFamily: 'Poppins'),
      decoration: InputDecoration(
        labelText: 'Contraseña',
        labelStyle: TextStyle(
            color: TextColor.purpleWhite, fontSize: 15, fontFamily: 'Poppins'),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: TextColor.purpleWhite, width: 2),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: TextColor.purpleWhite, width: 2),
        ),
        errorText: _passwordErrorText, // Agregar errorText
      ),
      onChanged: (value) {
        setState(() {
          _passwordErrorText = InputValidator.validatePassword(value);
        });
        inputsState.updatePasswordValidity(_passwordErrorText == null);
      },
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
    required TextEditingController accountController,
    required TextEditingController passwordController,
    this.onTap,
  })  : _accountController = accountController,
        _passwordController = passwordController;

  final TextEditingController _accountController;
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
