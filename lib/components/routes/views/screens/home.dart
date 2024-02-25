// ignore_for_file: avoid_print, use_build_context_synchronously, library_private_types_in_public_api

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curfind/components/routes/views/screens/guard/nombre_curfind.dart';
import 'package:curfind/shared/prefe_users.dart';
import 'package:curfind/style/global_colors.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isUpdating = false;
  bool? _isSwitched;

  Future<void> _updateText() async {
    var prefs = PreferencesUser();

    if (!_isUpdating) {
      _isUpdating = true;
      try {
        DocumentSnapshot<Map<String, dynamic>> snapshot = await _firestore
            .collection('ColorEstado')
            .doc(prefs.ultimateUid)
            .get();

        if (snapshot.exists) {
          bool newValue = !snapshot.data()!['Estado'];
          await _firestore
              .collection('ColorEstado')
              .doc(prefs.ultimateUid)
              .update({
            'Estado': newValue,
          });
        }
      } catch (e) {
        String errorMessage = e.toString();
        _openAnimatedDialog(context, errorMessage);
      } finally {
        _isUpdating = false;
      }
    }
  }

  void _openAnimatedDialog(BuildContext context, String errorMessage) {
    showGeneralDialog(
      context: context,
      pageBuilder: (context, animation1, animation2) {
        return Container();
      },
      transitionBuilder: (context, a1, a2, widget) {
        return AlertDialog(
          title: const Text('ERRROR!!'),
          content: Text('Error al actualizar el texto: $errorMessage'),
          shape: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var prefs = PreferencesUser();

    Color backColor = _isSwitched == true
        ? WallpaperColor.purpleLight().color
        : WallpaperColor.greenLight().color;

    Color iconColor = _isSwitched == true
        ? IconColor.purpleSuperLight().color
        : IconColor.greenSuperLight().color;

    Color circleColor =
        _isSwitched == true ? const Color(0xFFEFCEEF) : const Color(0xFFB5DDF5);

    Color mapColor = _isSwitched == true
        ? WallpaperColor.purpleDark().color
        : WallpaperColor.greenDark().color;

    return GestureDetector(
        onPanUpdate: (DragUpdateDetails details) {
          if (details.delta.dx > 5000000000000000000 && !_isUpdating) {
            Future.delayed(const Duration(milliseconds: 100), () {
              _updateText();
            });
          }
          if (details.delta.dx < 5000000000000000000 && !_isUpdating) {
            Future.delayed(const Duration(milliseconds: 100), () {
              _updateText();
            });
          }
        },
        child: StreamBuilder<DocumentSnapshot>(
            stream: _firestore
                .collection('ColorEstado')
                .doc(prefs.ultimateUid)
                .snapshots(),
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot> snapshot) {
              _isSwitched = snapshot.data?['Estado'];
              backColor = _isSwitched == true
                  ? WallpaperColor.purpleLight().color
                  : WallpaperColor.greenLight().color;
              iconColor = _isSwitched == true
                  ? IconColor.purpleSuperLight().color
                  : IconColor.greenSuperLight().color;
              circleColor = _isSwitched == true
                  ? const Color(0xFFEFCEEF)
                  : const Color(0xFFB5DDF5);
              mapColor = _isSwitched == true
                  ? WallpaperColor.purpleDark().color
                  : WallpaperColor.greenDark().color;

              return Scaffold(
                backgroundColor: backColor,
                appBar: AppBar(
                  backgroundColor: Colors.transparent,
                  excludeHeaderSemantics: false,
                  automaticallyImplyLeading: false,
                  title: Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: Stack(
                            children: [
                              const Icon(
                                Icons.notifications,
                                size: 60,
                              ),
                              Positioned(
                                top: 1,
                                right: -3,
                                child: Container(
                                  margin: const EdgeInsets.all(3),
                                  decoration: BoxDecoration(
                                    color: circleColor,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: backColor,
                                      width: 3,
                                    ),
                                  ),
                                  constraints: const BoxConstraints(
                                    minWidth: 23,
                                    minHeight: 23,
                                  ),
                                  child: const Text(
                                    '1',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontFamily: 'Poppins'),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          color: iconColor,
                          onPressed: () {
                            // Acción al presionar el icono de notificaciones
                          },
                        ),
                        const Expanded(
                          child: Center(
                            child: NombreCurfind(),
                          ),
                        ),
                        IconButton(
                          icon: Stack(
                            children: [
                              const Icon(
                                Icons.notifications,
                                size: 60,
                              ),
                              Positioned(
                                top: 1,
                                right: -3,
                                child: Container(
                                  margin: const EdgeInsets.all(3),
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.transparent,
                                      width: 3,
                                    ),
                                  ),
                                  constraints: const BoxConstraints(
                                    minWidth: 23,
                                    minHeight: 23,
                                  ),
                                  child: const Text(
                                    '1',
                                    style: TextStyle(
                                        color: Colors.transparent,
                                        fontSize: 15,
                                        fontFamily: 'Poppins'),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          color: Colors.transparent,
                          onPressed: () {
                            // Acción al presionar el icono de notificaciones
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                body: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Stack(
                    children: [
                      Expanded(
                        child: Container(
                          width: double.maxFinite,
                          decoration: const BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage('assets/maps.png'))),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: mapColor,
                              width: 6,
                            ),
                          ),
                          width: double.maxFinite,
                        ),
                      ),
                      const Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                            SizedBox(
                              width: 1.5,
                            ),
                                FotoBPerfil(),
                              ],
                            ),
                            SizedBox(
                              height: 80.9,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }));
  }
}

class FotoBPerfil extends StatefulWidget {
  const FotoBPerfil({
    super.key,
  });

  @override
  _FotoBPerfilState createState() => _FotoBPerfilState();
}

class _FotoBPerfilState extends State<FotoBPerfil> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String fotoUrl = '';
  var prefs = PreferencesUser();

  @override
  void initState() {
    super.initState();
    _getFotoUrl();
  }

  Future<void> _getFotoUrl() async {
    final DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection('Users')
        .doc(prefs.ultimateUid)
        .collection('ImagenesPerfil')
        .doc(prefs.ultimateUid)
        .get();
    setState(() {
      fotoUrl = documentSnapshot['FotoPerfil'];
    });
  }

  @override
  Widget build(BuildContext context) {
    var prefs = PreferencesUser();
    return StreamBuilder<DocumentSnapshot>(
        stream: _firestore
            .collection('ColorEstado')
            .doc(prefs.ultimateUid)
            .snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.network(
              fotoUrl,
              width: 39.8,
              height: 39.8,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(
                  Icons.account_circle,
                  size: 32.6,
                  color: Color(0xFFB3B3B3),
                );
              },
            ),
          );
        });
  }
}
