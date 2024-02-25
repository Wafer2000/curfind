import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curfind/shared/prefe_users.dart';
import 'package:curfind/style/global_colors.dart';
import 'package:flutter/material.dart';

class Companie extends StatefulWidget {
  const Companie({super.key});

  @override
  State<Companie> createState() => _CompanieState();
}

class _CompanieState extends State<Companie> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool? _isSwitched;
  
  @override
  Widget build(BuildContext context) {
  var prefs = PreferencesUser();
    Color backColor = _isSwitched == true
        ? WallpaperColor.purpleLight().color
        : WallpaperColor.greenLight().color;
    return StreamBuilder<DocumentSnapshot>(
        stream: _firestore
            .collection('ColorEstado')
            .doc(prefs.ultimateUid)
            .snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          _isSwitched = snapshot.data?['Estado'];
          backColor = _isSwitched == true
              ? WallpaperColor.purpleLight().color
              : WallpaperColor.greenLight().color;

          return Scaffold(
            body: const Center(
              child: Text('Companie'),
            ),
            backgroundColor: backColor,
          );
        });
  }
}
