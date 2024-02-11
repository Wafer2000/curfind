import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curfind/components/routes/views/companie.dart';
import 'package:curfind/components/routes/views/history.dart';
import 'package:curfind/components/routes/views/home.dart';
import 'package:curfind/components/routes/views/menssages.dart';
import 'package:curfind/components/routes/views/perfil.dart';
import 'package:flutter/material.dart';

class Screens extends StatefulWidget {
  const Screens({super.key});

  @override
  State<Screens> createState() => _ScreensState();
}

class _ScreensState extends State<Screens> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool? _isSwitched;
  int selectedIndex = 0;
  Color iconColor = Colors.purple;

  @override
  void initState() {
    super.initState();
    _getData();
  }

  Future<void> _getData() async {
    try {
      final snapshot = await _firestore
          .collection('ColorEstado')
          .doc('7HQdmSTNdcE8hYmFYYmf')
          .snapshots()
          .first;

      if (snapshot.exists) {
        setState(() {
          _isSwitched = snapshot.data()!['Estado'];
          _isSwitched == false
              ? iconColor = Colors.green
              : iconColor = Colors.purple;
        });
      }
    } catch (e) {
      print('Error al obtener el dato: $e');
    }
  }

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
              icon: Image.asset('assets/message.png',
                  width: 29.9, height: 29.9, color: iconColor),
              label: ''),
          BottomNavigationBarItem(
              icon: Image.asset(
                'assets/history.png',
                width: 29.6,
                height: 26.3,
                color: iconColor,
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
                color: iconColor,
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
