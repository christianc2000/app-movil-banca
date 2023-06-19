import 'package:appmovilbanca/src/screen/login_screen.dart';
import 'package:flutter/material.dart';
//import 'package:appmovilbanca/src/app.dart';
void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'App Login',
      theme: ThemeData(useMaterial3: true,),
       home: LoginScreen(),
    );
  }
}