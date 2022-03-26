import 'package:flutter/material.dart';
import 'package:supply_app/components/home_screen.dart';
import 'package:supply_app/components/screen/accueil/body.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // ignore: prefer_const_constructors
    return MaterialApp(
        title: 'Mon application',
        debugShowCheckedModeBanner: false,
        home: HomeScreen());
  }
}
