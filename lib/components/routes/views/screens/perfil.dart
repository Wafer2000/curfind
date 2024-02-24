// ignore_for_file: use_build_context_synchronously, avoid_print, unused_import, no_leading_underscores_for_local_identifiers, unused_local_variable, unused_field, must_be_immutable

import 'dart:ui';

import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curfind/components/routes/Log/login_normal.dart';
import 'package:curfind/components/routes/views/screens/guard/crear_perfil.dart';
import 'package:curfind/shared/prefe_users.dart';
import 'package:curfind/style/global_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'guard/nombre_curfind.dart';

class Perfil extends StatefulWidget {
  const Perfil({super.key});

  @override
  State<Perfil> createState() => _PerfilState();
}

class _PerfilState extends State<Perfil> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool? _isSwitched;

  @override
  Widget build(BuildContext context) {
    var prefs = PreferencesUser();

    Color backColor = _isSwitched == false
        ? WallpaperColor.purple().color
        : WallpaperColor.green().color;
    return StreamBuilder<DocumentSnapshot>(
        stream: _firestore
            .collection('ColorEstado')
            .doc(prefs.ultimateUid)
            .snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          _isSwitched = snapshot.data?['Estado'];
          backColor = _isSwitched == true
              ? WallpaperColor.purple().color
              : WallpaperColor.green().color;

          return Stack(
            children: [
              const Encabezado(),
              Scaffold(
                backgroundColor: Colors.transparent,
                appBar: AppBar(
                  backgroundColor: Colors.transparent,
                  title: const Center(child: NombreCurfind()),
                ),
                body: const Stack(
                  alignment: AlignmentDirectional.center,
                  children: [
                    DatosPerfil(),
                    Align(alignment: Alignment.topCenter, child: FotoDePerfil())
                  ],
                ),
              ),
            ],
          );
        });
  }
}

class DatosPerfil extends StatefulWidget {
  const DatosPerfil({
    super.key,
  });

  @override
  State<DatosPerfil> createState() => _DatosPerfilState();
}

class _DatosPerfilState extends State<DatosPerfil> {
  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        SizedBox(
          height: 60.9,
        ),
        DatosPersonales(),
      ],
    );
  }
}

class DatosPersonales extends StatefulWidget {
  const DatosPersonales({
    super.key,
  });

  @override
  State<DatosPersonales> createState() => _DatosPersonalesState();
}

class _DatosPersonalesState extends State<DatosPersonales> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool? _isSwitched;
  String _nombres = '';
  String _apellidos = '';
  String _descripcion = '';
  String _fNacimiento = '';
  String _fotoi = '';
  String _fotoc = '';
  String _fotod = '';
  final _pref = PreferencesUser();
  int _edadf = 0;

  @override
  void initState() {
    super.initState();
    _getDocuments();
  }

  Future _getDocuments() async {
    final DocumentSnapshot _documentSnapshot = await FirebaseFirestore.instance
        .collection('Users')
        .doc(_pref.ultimateUid)
        .get();
    final DocumentSnapshot _fotosdocumentSnapshot = await FirebaseFirestore
        .instance
        .collection('Users')
        .doc(_pref.ultimateUid)
        .collection('ImagenesPerfil')
        .doc(_pref.ultimateUid)
        .get();

    final DateFormat formatter = DateFormat('dd/MM/yyyy');
    final DateTime fechaNacimiento =
        formatter.parse(_documentSnapshot['fnacimiento']);
    final DateTime now = DateTime.now();
    final int years = now.year - fechaNacimiento.year;
    int _edad;
    if (now.month < fechaNacimiento.month ||
        (now.month == fechaNacimiento.month && now.day < fechaNacimiento.day)) {
      _edad = years - 1;
    } else {
      _edad = years;
    }

    setState(() {
      _nombres = _documentSnapshot['nombres'];
      _apellidos = _documentSnapshot['apellidos'];
      _descripcion = _documentSnapshot['descripcion'];
      _fNacimiento = _documentSnapshot['fnacimiento'];
      _fotoi = _fotosdocumentSnapshot['FotoIzquierda'];
      _fotoc = _fotosdocumentSnapshot['FotoCentro'];
      _fotod = _fotosdocumentSnapshot['FotoDerecha'];
      _edadf = _edad;
    });
  }

  Future<void> _signOut() async {
    var pref = PreferencesUser();
    final now = DateTime.now();
    final hsalida = DateFormat('HH:mm:ss').format(now);
    final fsalida = DateFormat('yyyy-MM-dd').format(now);

    try {
      FirebaseFirestore.instance
          .collection('Users')
          .doc(pref.ultimateUid)
          .update({
        'hsalida': hsalida,
        'fsalida': fsalida,
      });
      await FirebaseAuth.instance.signOut();
      pref.ultimateUid = '';
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginNormal()),
      );
    } catch (e) {
      print(e);
    }
  }

  void _openAnimatedDialog(
      BuildContext context, Color iconColor, Color backColor) {
    showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierLabel: '',
        transitionDuration: const Duration(milliseconds: 100),
        pageBuilder: (context, animation1, animation2) {
          return Container();
        },
        transitionBuilder: (context, a1, a2, widget) {
          return ScaleTransition(
            scale: Tween<double>(begin: 0.5, end: 1.0).animate(a1),
            child: FadeTransition(
              opacity: Tween<double>(begin: 0.5, end: 1.0).animate(a1),
              child: AlertDialog(
                backgroundColor: backColor,
                titleTextStyle: const TextStyle(
                    fontFamily: 'Poppins', color: Colors.black, fontSize: 30),
                title: Center(
                    child: Text(
                  'Configuraciones',
                  style: TextStyle(color: iconColor),
                )),
                content: Container(
                  alignment: Alignment.centerLeft,
                  color: Colors.transparent,
                  height: 200,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 16),
                            decoration: BoxDecoration(
                              color: iconColor,
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Modo Oscuro/Claro',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    color: Colors.white,
                                    fontSize: 15,
                                  ),
                                ),
                                Icon(
                                  Icons.keyboard_arrow_right,
                                  size: 20,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 16),
                            decoration: BoxDecoration(
                              color: iconColor,
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Contraseña y Seguridad',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    color: Colors.white,
                                    fontSize: 15,
                                  ),
                                ),
                                Icon(
                                  Icons.keyboard_arrow_right,
                                  size: 20,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 16),
                            decoration: BoxDecoration(
                              color: iconColor,
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Datos Personales',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    color: Colors.white,
                                    fontSize: 15,
                                  ),
                                ),
                                Icon(
                                  Icons.keyboard_arrow_right,
                                  size: 20,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 16),
                            decoration: BoxDecoration(
                              color: iconColor,
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Verificacion de Cuentas',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    color: Colors.white,
                                    fontSize: 15,
                                  ),
                                ),
                                Icon(
                                  Icons.keyboard_arrow_right,
                                  size: 20,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        GestureDetector(
                          onTap: () {
                            _signOut();
                            Navigator.pop(context);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 16),
                            decoration: BoxDecoration(
                              color: iconColor,
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Cerrar Sesion',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    color: Colors.white,
                                    fontSize: 15,
                                  ),
                                ),
                                Icon(
                                  Icons.keyboard_arrow_right,
                                  size: 20,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                shape: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.0),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    Color iconColor = _isSwitched == true
        ? IconColor.purpleLight().color
        : IconColor.greenLight().color;
    Color backColor = _isSwitched == true
        ? WallpaperColor.purple().color
        : WallpaperColor.green().color;

    var _prefs = PreferencesUser();

    final fotos = [_fotoi, _fotoc, _fotod];

    return StreamBuilder<DocumentSnapshot>(
        stream: _firestore
            .collection('ColorEstado')
            .doc(_prefs.ultimateUid)
            .snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          _isSwitched = snapshot.data?['Estado'];
          iconColor = _isSwitched == true
              ? IconColor.purpleLight().color
              : IconColor.greenLight().color;
          backColor = _isSwitched == true
              ? WallpaperColor.purple().color
              : WallpaperColor.green().color;

          return Container(
            decoration: BoxDecoration(
                color: WallpaperColor.white().color,
                borderRadius: BorderRadius.circular(30.0)),
            width: 321.8,
            height: 433.2,
            child: Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                automaticallyImplyLeading: true,
                flexibleSpace: SafeArea(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Image.asset(
                          'assets/setting.png',
                          width: 26.9,
                          height: 26.9,
                          color: iconColor,
                        ),
                        onPressed: () {
                          _openAnimatedDialog(context, iconColor, backColor);
                        },
                      ),
                      IconButton(
                        icon: Image.asset(
                          'assets/edit.png',
                          width: 26.5,
                          height: 26.9,
                          color: iconColor,
                        ),
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const CrearPerfil()),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              body: Container(
                alignment: Alignment.topCenter,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      '${_nombres.split(' ')[0]} ${_apellidos.split(' ')[0]}',
                      style: TextStyle(
                        color: TextColor.black().color,
                        fontSize: 30.5,
                        fontFamily: 'Poppins',
                        //fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Container(
                      color: TextColor.black().color,
                      height: 2,
                      width: 30.6,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    SizedBox(
                      width: 243.6,
                      height: 40,
                      child: _descripcion == ''
                          ? const Text(
                              'Agrega una descripción, por favor',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 15.3,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.bold),
                            )
                          : Text(
                              _descripcion,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: TextColor.black().color,
                                fontSize: 15.3,
                                fontFamily: 'Poppins',
                              ),
                            ),
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    SizedBox(
                      width: 243.6,
                      height: 20,
                      child: _edadf == 0
                          ? const Text(
                              'No es posible ver tu edad',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 22.3,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.bold),
                            )
                          : Text(
                              '${_edadf.toString()} Años',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: TextColor.black().color,
                                  fontSize: 22.3,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w500),
                            ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    CarouselImages(
                      fotos: fotos,
                      color: iconColor,
                    ),
                    /*Stack(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: SizedBox(
                                width: 137,
                                height: 205.6,
                                child: Image.network(
                                  _fotoi,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(
                                      Icons.person,
                                      color: Colors.grey,
                                      size: 100,
                                    );
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: SizedBox(
                                width: 137,
                                height: 205.6,
                                child: Image.network(
                                  _fotod,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(
                                      Icons.person,
                                      color: Colors.grey,
                                      size: 100,
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                        Center(
                          child: Column(
                            children: [
                              const SizedBox(height: 14,),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: SizedBox(
                                  width: 137,
                                  height: 205.6,
                                  child: Image.network(
                                    _fotoc,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Icon(
                                        Icons.person,
                                        color: Colors.grey,
                                        size: 100,
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )*/
                  ],
                ),
              ),
            ),
          );
        });
  }
}

class CarouselImages extends StatefulWidget {
  const CarouselImages({
    super.key,
    required this.fotos,
    required this.color,
  });
  final Color color;
  final List<String> fotos;

  @override
  State<CarouselImages> createState() => _CarouselImagesState();
}

class _CarouselImagesState extends State<CarouselImages> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: Center(
          child: CarouselSlider.builder(
            options: CarouselOptions(
                height: 224,
                initialPage: 1,
                viewportFraction: 0.5,
                enlargeCenterPage: true,),
            itemCount: widget.fotos.length,
            itemBuilder: (context, index, realIndex) {
              final _urlImage = widget.fotos[index];

              return BuildImage(
                urlImage: _urlImage,
                index: index, color: widget.color,
              );
            },
          ),
        ),
      ),
    );
  }
}

class BuildImage extends StatelessWidget {
  String urlImage;
  int index;
  Color color;
  BuildImage({
    super.key,
    required this.urlImage,
    required this.index,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: color,
                image: DecorationImage(
                    image: NetworkImage(urlImage),
                    fit: BoxFit.cover,
                    onError: (Object exception, StackTrace? stackTrace) {
                      print('Error al cargar la imagen: $exception');
                    })),
          ),
        ),
      ],
    );
  }
}

class Encabezado extends StatefulWidget {
  const Encabezado({
    super.key,
  });

  @override
  State<Encabezado> createState() => _EncabezadoState();
}

class _EncabezadoState extends State<Encabezado> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool? _isSwitched;
  String _imageUrl = '';
  final _pref = PreferencesUser();

  @override
  void initState() {
    super.initState();
    _getImageUrl();
  }

  Future _getImageUrl() async {
    final DocumentSnapshot _documentSnapshot = await FirebaseFirestore.instance
        .collection('Users')
        .doc(_pref.ultimateUid)
        .collection('ImagenesPerfil')
        .doc(_pref.ultimateUid)
        .get();

    setState(() {
      _imageUrl = _documentSnapshot['Encabezado'];
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var prefs = PreferencesUser();
    Color _backColor = _isSwitched == true
        ? WallpaperColor.purple().color
        : WallpaperColor.green().color;

    return StreamBuilder<DocumentSnapshot>(
        stream: _firestore
            .collection('ColorEstado')
            .doc(prefs.ultimateUid)
            .snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> _snapshot) {
          _isSwitched = _snapshot.data?['Estado'];
          Color _backColor = _isSwitched == true
              ? WallpaperColor.purple().color
              : WallpaperColor.green().color;

          return Stack(
            children: [
              Container(
                alignment: Alignment.topCenter,
                color: _backColor,
                child: Image.network(
                  _imageUrl,
                  fit: BoxFit.cover,
                  width: size.width * size.width,
                  height: 188.6,
                  errorBuilder: (context, error, stackTrace) {
                    return CircularProgressIndicator(
                      value: null,
                      strokeWidth: 5.0,
                      backgroundColor: Colors.grey[200],
                      valueColor: AlwaysStoppedAnimation<Color>(_backColor),
                    );
                  },
                ),
              ),
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 3, sigmaY: 0.5),
                child: Container(
                  alignment: Alignment.topCenter,
                  color: Colors.transparent,
                ),
              ),
            ],
          );
        });
  }
}

class FotoDePerfil extends StatefulWidget {
  const FotoDePerfil({
    super.key,
  });

  @override
  State<FotoDePerfil> createState() => _FotoDePerfilState();
}

class _FotoDePerfilState extends State<FotoDePerfil> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String _imageUrl = '';
  final _pref = PreferencesUser();

  @override
  void initState() {
    super.initState();
    _getImageUrl();
  }

  Future _getImageUrl() async {
    final DocumentSnapshot _documentSnapshot = await FirebaseFirestore.instance
        .collection('Users')
        .doc(_pref.ultimateUid)
        .collection('ImagenesPerfil')
        .doc(_pref.ultimateUid)
        .get();

    setState(() {
      _imageUrl = _documentSnapshot['FotoPerfil'];
    });
  }

  @override
  Widget build(BuildContext context) {
    var prefs = PreferencesUser();

    return ClipRRect(
      borderRadius: BorderRadius.circular(100),
      child: Image.network(
        _imageUrl,
        width: 121.8,
        height: 121.8,
        errorBuilder: (context, error, stackTrace) {
          return IconButton(
            highlightColor: Colors.transparent,
            onPressed: () {},
            icon: Image.asset(
              'assets/user.png',
              width: 121.8,
              height: 121.8,
            ),
          );
        },
      ),
    );
  }
}
