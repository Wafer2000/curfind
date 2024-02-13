import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curfind/components/routes/views/screens/companie.dart';
import 'package:curfind/components/routes/views/screens/history.dart';
import 'package:curfind/components/routes/views/screens/home.dart';
import 'package:curfind/components/routes/views/screens/menssages.dart';
import 'package:curfind/components/routes/views/screens/guard/perfil.dart';
import 'package:curfind/shared/prefe_users.dart';
import 'package:curfind/style/global_colors.dart';
import 'package:flutter/material.dart';

class Screens extends StatefulWidget {
  const Screens({super.key});

  @override
  State<Screens> createState() => _ScreensState();
}

class _ScreensState extends State<Screens> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool? _isSwitched;
  var prefs = PreferencesUser();
  int selectedIndex = 2;

  @override
  Widget build(BuildContext context) {
    Color iconColor = _isSwitched == true
        ? IconColor.purple().color
        : IconColor.green().color;
    Color backColor = _isSwitched == true
        ? WallpaperColor.purple().color
        : WallpaperColor.green().color;

    final screens = [
      const Messages(),
      const History(),
      const Home(),
      const Companie(),
      const Perfil()
    ];

    return StreamBuilder<DocumentSnapshot>(
        stream: _firestore
            .collection('ColorEstado')
            .doc(prefs.ultimateUid)
            .snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          _isSwitched = snapshot.data?['Estado'];
          iconColor = _isSwitched == true
              ? IconColor.purple().color
              : IconColor.green().color;
          backColor = _isSwitched == true
              ? WallpaperColor.purple().color
              : WallpaperColor.green().color;

          return Scaffold(
            body: IndexedStack(
              index: selectedIndex,
              children: screens,
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: selectedIndex,
              showSelectedLabels: true,
              type: BottomNavigationBarType.fixed,
              backgroundColor: backColor,
              onTap: (value) {
                setState(() {
                  selectedIndex = value;
                });
              },
              elevation: 0,
              items: [
                BottomNavigationBarItem(
                  icon: Image.asset(
                    'assets/message.png',
                    width: 29.9,
                    height: 29.9,
                    color: iconColor,
                  ),
                  label: '',
                  backgroundColor: backColor,
                ),
                BottomNavigationBarItem(
                    icon: Image.asset(
                      'assets/history.png',
                      width: 29.6,
                      height: 26.3,
                      color: iconColor,
                    ),
                    label: '',
                    backgroundColor: backColor),
                BottomNavigationBarItem(
                    icon: Image.asset(
                      'assets/logo_curfind.png',
                      width: 28.2,
                      height: 44.6,
                    ),
                    label: '',
                    backgroundColor: backColor),
                BottomNavigationBarItem(
                    icon: Image.asset(
                      'assets/companie.png',
                      width: 29.6,
                      height: 29.6,
                      color: iconColor,
                    ),
                    label: '',
                    backgroundColor: backColor),
                BottomNavigationBarItem(
                    icon: const CircleAvatar(
                      backgroundImage: AssetImage(
                        'assets/photo_perfil.png',
                      ),
                    ),
                    label: '',
                    backgroundColor: backColor)
              ],
            ),
          );
        });

    /**/
  }
}
