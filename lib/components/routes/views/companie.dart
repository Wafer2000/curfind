import 'package:flutter/material.dart';

class Companie extends StatefulWidget {
  const Companie({super.key});

  @override
  State<Companie> createState() => _CompanieState();
}

class _CompanieState extends State<Companie> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Comapanie'),),
    );
  }
}