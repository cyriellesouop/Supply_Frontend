// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:supply_app/components/screen/accueil/body.dart';
import 'package:supply_app/constants.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return (Scaffold(
      backgroundColor: kBackgroundColor,
      body: Body(),
    ));
  }
}
