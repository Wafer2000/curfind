import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curfind/shared/prefe_users.dart';
import 'package:curfind/style/global_colors.dart';
import 'package:flutter/material.dart';

class Messages extends StatefulWidget {
  const Messages({super.key});

  @override
  State<Messages> createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool? _isSwitched;

  @override
  Widget build(BuildContext context) {
  var prefs = PreferencesUser();
    Color backColor = _isSwitched == true
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
            backgroundColor: backColor,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              leading: const Padding(
                padding: EdgeInsets.fromLTRB(14, 0, 0, 0),
                child: Icon(
                  Icons.search,
                  size: 30,
                ),
              ),
              title: Image.asset(
                'assets/nombre_curfind.png',
                width: 127.7,
                height: 53.4,
              ),
              centerTitle: true,
            ),
            body: const Center(
              child: Column(children: []),
            ),
          );
        });
  }
}
