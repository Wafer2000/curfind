import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curfind/style/global_colors.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isUpdating = false;
  bool? _isSwitched;

  Future<void> _updateText() async {
    if (!_isUpdating) {
      _isUpdating = true;
      try {
        DocumentSnapshot<Map<String, dynamic>> snapshot = await _firestore
            .collection('ColorEstado')
            .doc('7HQdmSTNdcE8hYmFYYmf')
            .get();

        if (snapshot.exists) {
          bool newValue = !snapshot.data()!['Estado'];
          await _firestore
              .collection('ColorEstado')
              .doc('7HQdmSTNdcE8hYmFYYmf')
              .update({
            'Estado': newValue,
          });
        }
      } catch (e) {
        String errorMessage = e.toString();
        _openAnimatedDialog(context, errorMessage);
      } finally {
        _isUpdating = false;
      }
    }
  }

  void _openAnimatedDialog(BuildContext context, String errorMessage) {
    showGeneralDialog(
      context: context,
      pageBuilder: (context, animation1, animation2) {
        return Container();
      },
      transitionBuilder: (context, a1, a2, widget) {
        return AlertDialog(
          title: const Text('ERRROR!!'),
          content: Text('Error al actualizar el texto: $errorMessage'),
          shape: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Color backColor = _isSwitched == true
        ? WallpaperColor.purple().color
        : WallpaperColor.green().color;

    return GestureDetector(
        onPanUpdate: (DragUpdateDetails details) {
          if (details.delta.dx > 5000000000000000000 && !_isUpdating) {
            Future.delayed(const Duration(milliseconds: 100), () {
              _updateText();
            });
          }
          if (details.delta.dx < 5000000000000000000 && !_isUpdating) {
            Future.delayed(const Duration(milliseconds: 100), () {
              _updateText();
            });
          }
        },
        child: StreamBuilder<DocumentSnapshot>(
            stream: _firestore
                .collection('ColorEstado')
                .doc('7HQdmSTNdcE8hYmFYYmf')
                .snapshots(),
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot> snapshot) {
              _isSwitched = snapshot.data?['Estado'];
              backColor = _isSwitched == true
                  ? WallpaperColor.purple().color
                  : WallpaperColor.green().color;

              return Scaffold(
                body: const Center(
                  child: Text('Home'),
                ),
                backgroundColor: backColor,
              );
            }));
  }
}
