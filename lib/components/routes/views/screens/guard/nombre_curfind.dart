// ignore_for_file: use_build_context_synchronously, unused_local_variable, unused_field, unused_element, no_leading_underscores_for_local_identifiers, avoid_print, unnecessary_null_comparison

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curfind/shared/prefe_users.dart';
import 'package:curfind/style/global_colors.dart';
import 'package:flutter/material.dart';

class NombreCurfind extends StatefulWidget {
  const NombreCurfind({
    super.key,
  });

  @override
  State<NombreCurfind> createState() => _NombreCurfindState();
}

class _NombreCurfindState extends State<NombreCurfind> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool? _isSwitched;

  @override
  Widget build(BuildContext context) {
    var prefs = PreferencesUser();

    Color _textColor = _isSwitched == true
        ? TextColor.purple().color
        : TextColor.green().color;

    return StreamBuilder<DocumentSnapshot>(
        stream: _firestore
            .collection('ColorEstado')
            .doc(prefs.ultimateUid)
            .snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> _snapshot) {
          _isSwitched = _snapshot.data?['Estado'];

          _textColor = _isSwitched == true
              ? TextColor.purple().color
              : TextColor.green().color;

          return SizedBox(
              width: 127.7,
              child: Image.asset(
                'assets/nombre_curfind.png',
                color: _textColor,
                errorBuilder: (context, url, error) => SizedBox(
                  width: 127.7,
                  child: Image.asset(
                    'assets/nombre_curfind.png',
                    color: TextColor.purple().color,
                  ),
                ),
              ));
        });
  }
}
