import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _updateText() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await _firestore
          .collection('ColorEstado')
          .doc('7HQdmSTNdcE8hYmFYYmf')
          .get();

      if (snapshot.exists) {
        // Toggle the value of the 'Estado' field to its opposite boolean value
        bool newValue = !snapshot.data()!['Estado'];

        // Call the 'update' method to save the updated value to Firebase Firestore
        await _firestore
            .collection('ColorEstado')
            .doc('7HQdmSTNdcE8hYmFYYmf')
            .update({
          'Estado': newValue,
        });
      }
    } catch (e) {
      print('Error al actualizar el texto: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onPanUpdate: (DragUpdateDetails details) {
          if (details.delta.dx > 5) {
            _updateText();
          }
          if (details.delta.dx < 5) {
            _updateText();
          }
        },
        child: const Scaffold(
          body: Center(child: Text('Actualizar texto')),
        ));
  }
}
