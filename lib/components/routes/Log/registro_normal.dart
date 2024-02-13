// ignore_for_file: use_build_context_synchronously, unused_local_variable, unused_field
import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curfind/components/routes/Log/login_normal.dart';
import 'package:curfind/components/routes/config/snackbar.dart';
import 'package:curfind/components/routes/views/screens/guard/crear_perfil.dart';
import 'package:curfind/firebase/firebase_auth.dart';
import 'package:curfind/shared/prefe_users.dart';
import 'package:curfind/style/global_colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RegistroNormal extends StatefulWidget {
  const RegistroNormal({super.key});

  @override
  State<RegistroNormal> createState() => _RegistroNormalState();
}

class _RegistroNormalState extends State<RegistroNormal> {

  @override
  Widget build(BuildContext context) {
    return const Stack(children: [
      Wave(),
      Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            OptionsRegister(),
          ],
        ),
      ),
    ]);
  }
}

class NombreCurfind extends StatelessWidget {
  const NombreCurfind({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      FadeInUp(
        child: Align(
            alignment: Alignment.topCenter,
            child: SizedBox(
                width: 200, child: Image.asset('assets/nombre_curfind.png'))),
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

class OptionsRegister extends StatelessWidget {
  const OptionsRegister({super.key});

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
                  height: 20,
                ),
                NombreCurfind(),
                SizedBox(
                  height: 80,
                ),
                Inputs(),
                SizedBox(
                  height: 19,
                ),
                Bottoms(),
                SizedBox(
                  height: 29,
                ),
                Login(),
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
  final _nombresController = TextEditingController();
  final _apellidosController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _fnacimientoController = TextEditingController();
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

  void _createAccount(
    BuildContext context,
    TextEditingController nombresController,
    TextEditingController apellidosController,
    TextEditingController emailController,
    TextEditingController passwordController,
    TextEditingController fnacimientoController,
  ) async {
    final nombres = nombresController.text;
    final apellidos = apellidosController.text;
    final email = emailController.text;
    final password = passwordController.text;
    final fnacimiento = passwordController.text;

    var pref = PreferencesUser();
    final now = DateTime.now();
    final hcreacion = DateFormat('HH:mm:ss').format(now);
    final fcreacion = DateFormat('yyyy-MM-dd').format(now);

    var uid = await AuthService().createAcount(email, password);
    if (uid == 1) {
      showSnackBar(context, 'Error: La contraseña es muy corta');
    } else if (uid == 2) {
      showSnackBar(context, 'Error: La cuenta ya existe');
    } else if (uid != null) {
      pref.ultimateUid = uid;

      FirebaseFirestore.instance.collection('Users').doc(uid).set({
        'uid': uid,
        'nombres': nombres,
        'apellidos': apellidos,
        'email': email,
        'password': password,
        'fnacimiento': fnacimiento,
        'hcreacion': hcreacion,
        'fcreacion': fcreacion,
      });

      FirebaseFirestore.instance.collection('ColorEstado').doc(uid).set({
        'Estado': true,
      });

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const CrearPerfil()),
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
          nombresController: _nombresController,
          apellidosController: _apellidosController,
          emailController: _emailController,
          passwordController: _passwordController,
          fnacimientoController: _fnacimientoController,
        ),
        const SizedBox(
          height: 40,
        ),
        ButtomLogin(
          nombresController: _nombresController,
          apellidosController: _apellidosController,
          emailController: _emailController,
          passwordController: _passwordController,
          fnacimientoController: _fnacimientoController,
          onTap: _emailIsValid && _passwordIsValid
              ? () {
                  _createAccount(
                      context,
                      _nombresController,
                      _apellidosController,
                      _emailController,
                      _passwordController,
                      _fnacimientoController);
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
    required TextEditingController nombresController,
    required TextEditingController apellidosController,
    required TextEditingController emailController,
    required TextEditingController passwordController,
    required TextEditingController fnacimientoController,
  })  : _nombresController = nombresController,
        _apellidosController = apellidosController,
        _emailController = emailController,
        _passwordController = passwordController,
        _fnacimientoController = fnacimientoController;

  final TextEditingController _nombresController;
  final TextEditingController _apellidosController;
  final TextEditingController _emailController;
  final TextEditingController _passwordController;
  final TextEditingController _fnacimientoController;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 300,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InputNombres(nombresController: _nombresController),
            const SizedBox(height: 10),
            InputApellidos(apellidosController: _apellidosController),
            const SizedBox(height: 10),
            InputEmail(emailController: _emailController),
            const SizedBox(height: 10),
            InputPassword(passwordController: _passwordController),
            const SizedBox(height: 10),
            InputFNacimiento(fnacimientoController: _fnacimientoController)
          ],
        ),
      ),
    );
  }
}

class InputNombres extends StatefulWidget {
  const InputNombres({
    required TextEditingController nombresController,
    super.key,
  }) : _nombresController = nombresController;

  final TextEditingController _nombresController;

  @override
  State<InputNombres> createState() => _InputNombresState();
}

class _InputNombresState extends State<InputNombres> {
  final focusNode = FocusNode();
  String? _nombresErrorText;

  @override
  Widget build(BuildContext context) {
    final inputsState = context.findAncestorStateOfType<_InputsState>()!;

    return TextField(
      focusNode: focusNode,
      onTapOutside: (event) {
        focusNode.unfocus();
      },
      controller: widget._nombresController,
      style: TextStyle(
          color: TextColor.purple().color, fontSize: 18, fontFamily: 'Poppins'),
      decoration: InputDecoration(
        labelText: 'Nombres',
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
        errorText: _nombresErrorText, //
      ),
      onChanged: (value) {
        setState(() {
          _nombresErrorText = InputValidator.validateNombres(value);
        });
      },
    );
  }
}

class InputApellidos extends StatefulWidget {
  const InputApellidos({
    required TextEditingController apellidosController,
    super.key,
  }) : _apellidosController = apellidosController;

  final TextEditingController _apellidosController;

  @override
  State<InputApellidos> createState() => _InputApellidosState();
}

class _InputApellidosState extends State<InputApellidos> {
  final focusNode = FocusNode();
  String? _apellidosErrorText;

  @override
  Widget build(BuildContext context) {
    final inputsState = context.findAncestorStateOfType<_InputsState>()!;

    return TextField(
      focusNode: focusNode,
      onTapOutside: (event) {
        focusNode.unfocus();
      },
      controller: widget._apellidosController,
      style: TextStyle(
          color: TextColor.purple().color, fontSize: 18, fontFamily: 'Poppins'),
      decoration: InputDecoration(
        labelText: 'Apellidos',
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
        errorText: _apellidosErrorText, // Agregar errorText
      ),
      onChanged: (value) {
        setState(() {
          _apellidosErrorText = InputValidator.validateApellidos(value);
        });
      },
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

class InputFNacimiento extends StatefulWidget {
  const InputFNacimiento({
    required TextEditingController fnacimientoController,
    super.key,
  }) : _fnacimientoController = fnacimientoController;

  final TextEditingController _fnacimientoController;

  @override
  State<InputFNacimiento> createState() => _InputFNacimientoState();
}

class _InputFNacimientoState extends State<InputFNacimiento> {
  final focusNode = FocusNode();
  String? _fnacimientoErrorText;

  @override
  Widget build(BuildContext context) {
    final inputsState = context.findAncestorStateOfType<_InputsState>()!;

    return TextField(
      focusNode: focusNode,
      onTapOutside: (event) {
        focusNode.unfocus();
      },
      controller: widget._fnacimientoController,
      style: TextStyle(
          color: TextColor.purple().color, fontSize: 18, fontFamily: 'Poppins'),
      decoration: InputDecoration(
        labelText: 'Fecha de Nacimiento',
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
        errorText: _fnacimientoErrorText,
        hintText: 'dd/MM/aaaa',
        hintStyle: const TextStyle(
            color: Colors.grey, fontSize: 15, fontFamily: 'Poppins'),
      ),
      onChanged: (value) {
        setState(() {
          _fnacimientoErrorText = InputValidator.validateFNacimiento(value);
        });
      },
    );
  }
}

class InputValidator {
  static String? validateNombres(String value) {
    if (value.isEmpty) {
      return 'El o los nombres son requeridos';
    }
    return null;
  }

  static String? validateApellidos(String value) {
    if (value.isEmpty) {
      return 'El o los apellidos son requeridos';
    }
    return null;
  }

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

  static String? validateFNacimiento(String? value) {
    if (value == null || value.isEmpty) {
      return 'La fecha de nacimiento es requerida';
    }

    final dateFormat = DateFormat('dd/MM/yyyy');

    try {
      dateFormat.parseStrict(value);
    } catch (e) {
      return 'La fecha de nacimiento debe este formato: (dd/MM/yyyy)';
    }

    final parsedDate = dateFormat.parse(value);

    final now = DateTime.now();
    final birthDate =
        DateTime.utc(parsedDate.year, parsedDate.month, parsedDate.day);

    if (now.isAfter(birthDate)) {
      final age = now.year - birthDate.year;
      if (now.month < birthDate.month ||
          (now.month == birthDate.month && now.day < birthDate.day)) {
        // Si el mes y el día de nacimiento no han llegado todavía, restar un año a la edad
        return null;
      }
      return null;
    }

    return 'La fecha de nacimiento no puede ser una fecha futura';
  }
}

class ButtomLogin extends StatelessWidget {
  const ButtomLogin({
    super.key,
    required TextEditingController nombresController,
    required TextEditingController apellidosController,
    required TextEditingController emailController,
    required TextEditingController passwordController,
    required TextEditingController fnacimientoController,
    this.onTap,
  })  : _nombresController = nombresController,
        _apellidosController = apellidosController,
        _emailController = emailController,
        _passwordController = passwordController,
        _fnacimientoController = fnacimientoController;

  final TextEditingController _nombresController;
  final TextEditingController _apellidosController;
  final TextEditingController _emailController;
  final TextEditingController _passwordController;
  final TextEditingController _fnacimientoController;
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
          child: Text('Registrar',
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

class Login extends StatelessWidget {
  const Login({super.key});

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
      child: const Text('¿Ya tienes una cuenta?',
          style: TextStyle(
            color: Color(0xFFF8F4FF),
            fontSize: 14,
            fontFamily: 'Poppins',
          )),
    );
  }
}
