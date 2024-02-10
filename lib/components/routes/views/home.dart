import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: Text('Hola Mundo'),
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
          const BottomNavigationBarItem(
              icon: Icon(Icons.abc),
              label: ''
              ),
          BottomNavigationBarItem(
              icon: Image.asset(
              'assets/logo_curfind.png',
              width: 28.2,
              height: 44.6,
            ),
              label: ''
              ),
          const BottomNavigationBarItem(
              icon: Icon(Icons.ac_unit),
              label: ''
              )
        ],
      ),
    );
  }
}
