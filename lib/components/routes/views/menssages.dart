import 'package:flutter/material.dart';

class Messages extends StatefulWidget {
  const Messages({super.key});

  @override
  State<Messages> createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Padding(
          padding: EdgeInsets.fromLTRB(14, 0, 0, 0),
          child: Icon(
            Icons.search,
            size: 30,
            ),
        ),
        title: Image.asset(
          'assets/nombre_curfind.png',
          width: 127.7,
          height: 53.4,
        ),
        centerTitle: true,
      ),
      body: const Center(
        child: Column(children: []),
      ),
    );
  }
}
