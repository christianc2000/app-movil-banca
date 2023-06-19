import 'package:flutter/material.dart';

class CobroScreen extends StatefulWidget {
  const CobroScreen({ Key? key }) : super(key: key);

  @override
  _CobroScreenState createState() => _CobroScreenState();
}

class _CobroScreenState extends State<CobroScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cobrar'),
      ),
      body: Center(
        child: const Text('Vista de Cobrar'),
      ),
    );
  }
}