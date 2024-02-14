// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curfind/components/routes/Log/login_normal.dart';
import 'package:curfind/components/routes/views/screens/guard/crear_perfil.dart';
import 'package:curfind/shared/prefe_users.dart';
import 'package:curfind/style/global_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
    print(prefs.ultimateUid);

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

          return Scaffold(
            appBar: AppBar(
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CrearPerfil()),
                    );
                  },
                ),
              ],
            ),
            body: const Center(
              child: Text('Perfil'),
            ),
            backgroundColor: backColor,
          );
        });
  }
}
