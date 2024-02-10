/*import 'dart:math';

import 'package:flutter/material.dart';

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _verificationResult = '';

  Future<void> _verifyDNI(String dniNumber, String dniType) async {
    // Implement DNI verification logic here
    // For demonstration purposes, we'll use a simple simulation

    // Perform the verification
    await Future.delayed(const Duration(seconds: 2));

    // Generate a random result
    final random = Random();
    final resultCode = random.nextInt(2);

    // Set the verification result
    setState(() {
      if (resultCode == 0) {
        _verificationResult = 'DNI verification succeeded';
      } else {
        _verificationResult = 'DNI verification failed';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          children: [
            TextButton(
              child: const Text('Verify DNI'),
              onPressed: () async {
                // Simulate user input for DNI number and type
                final dniNumber = '12345678Z';
                final dniType = 'TIPO_DNI';

                // Call the verification function
                await _verifyDNI(dniNumber, dniType);
              },
            ),
            Text(_verificationResult),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(const MyApp());
}*/