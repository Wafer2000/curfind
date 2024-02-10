import 'package:curfind/components/routes/views/companie.dart';
import 'package:curfind/components/routes/views/history.dart';
import 'package:curfind/components/routes/views/home.dart';
import 'package:curfind/components/routes/views/menssages.dart';
import 'package:curfind/components/routes/views/perfil.dart';
import 'package:curfind/style/global_colors.dart';
import 'package:flutter/material.dart';

class Screens extends StatefulWidget {
  const Screens({super.key});

  @override
  State<Screens> createState() => _ScreensState();
}

class _ScreensState extends State<Screens> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final screens = [
      const Messages(),
      const History(),
      const Home(),
      const Companie(),
      const Perfil()
    ];

    return Scaffold(
      body: IndexedStack(
        index: selectedIndex,
        children: screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.shifting,
        currentIndex: selectedIndex,
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
                color: IconColor.green,
              ),
              label: ''),
          BottomNavigationBarItem(
              icon: Image.asset(
                'assets/history.png',
                width: 29.6,
                height: 26.3,
                color: IconColor.green,
              ),
              label: ''),
          BottomNavigationBarItem(
              icon: Image.asset(
                'assets/logo_curfind.png',
                width: 28.2,
                height: 44.6,
              ),
              label: ''),
          BottomNavigationBarItem(
              icon: Image.asset(
                'assets/companie.png',
                width: 29.6,
                height: 29.6,
                color: IconColor.green,
              ),
              label: ''),
          const BottomNavigationBarItem(
              icon: CircleAvatar(
                backgroundImage: AssetImage(
                  'assets/photo_perfil.png',
                ),
              ),
              label: '')
        ],
      ),
    );
  }
}
