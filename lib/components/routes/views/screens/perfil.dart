// ignore_for_file: use_build_context_synchronously, avoid_print, unused_import, no_leading_underscores_for_local_identifiers, unused_local_variable, unused_field

import 'dart:ui';

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
              Stack(
                children: [
                  Column(
                    children: [
                      const SizedBox(
                        height: 150,
                      ),
                      Center(
                        child: Container(
                          decoration: BoxDecoration(
                              color: WallpaperColor.white().color,
                              borderRadius: BorderRadius.circular(10.0)),
                          width: 321.8,
                          height: 433.2,
                          child: Scaffold(
                            backgroundColor: Colors.transparent,
                            appBar: AppBar(
                              backgroundColor: Colors.transparent,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  Scaffold(
                    appBar: /*AppBar(
                      backgroundColor: Colors.transparent,
                      title: const Center(child: NombreCurfind()),
                    ),*/
                    AppBar(
                  title: const Text('Perfil'),
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.logout),
                      onPressed: () {
                        _signOut();
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const CrearPerfil()),
                        );
                      },
                    ),
                  ],),
                    body: const Stack(
                      children: [
                        Align(
                            alignment: Alignment.topCenter,
                            child: FotoDePerfil())
                      ],
                    ),
                    backgroundColor: Colors.transparent,
                  ),
                ],
              ),
            ],
          );
        });
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
          return const Icon(
            Icons.account_circle,
            size: 80,
          );
        },
      ),
    );
  }
}

/*AppBar(
                  title: const Text('Perfil'),
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.logout),
                      onPressed: () {
                        _signOut();
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const CrearPerfil()),
                        );
                      },
                    ),
                  ],
                )*/
