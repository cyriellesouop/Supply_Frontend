// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:supply_app/components/screen/accueil/body.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return (Scaffold(
      appBar: buildAppBar(),
      body: Body(),
    ));
  }
}

AppBar buildAppBar() {
  return AppBar(
    title: Text('Mon application',
        style: TextStyle(
            fontFamily: 'DayRoman', fontWeight: FontWeight.bold, fontSize: 24)),
    centerTitle: true,
  );
}
