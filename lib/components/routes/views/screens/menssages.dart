import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curfind/components/routes/views/screens/guard/nombre_curfind.dart';
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
            backgroundColor: backColor,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              excludeHeaderSemantics: false,
              automaticallyImplyLeading: false,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.search,
                      size: 30,
                    ),
                    color: TextColor.black().color,
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
                    icon: const Icon(
                      Icons.search,
                      size: 30,
                    ),
                    color: Colors.transparent,
                    onPressed: () {
                      // Acción al presionar el icono de notificaciones
                    },
                  ),
                ],
              ),
            ),
            body: const Center(
              child: Column(children: []),
            ),
          );
        });
  }
}
