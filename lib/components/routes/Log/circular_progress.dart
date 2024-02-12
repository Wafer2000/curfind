import 'package:curfind/components/routes/views/screens/guard/crear_perfil.dart';
import 'package:flutter/material.dart';

class CircularProgress extends StatefulWidget {
  const CircularProgress({
    super.key,
  });

  @override
  State<CircularProgress> createState() => _CircularProgressState();
}

class _CircularProgressState extends State<CircularProgress> {
  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const CrearPerfil()),
      );
    });

    return const Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Cargando...'),
        ],
      ),
    );
  }
}