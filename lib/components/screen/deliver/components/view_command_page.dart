// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../constants.dart';

class ViewCommandPage extends StatefulWidget {
  const ViewCommandPage({Key? key}) : super(key: key);

  @override
  _ViewCommandPageState createState() => _ViewCommandPageState();
}

class _ViewCommandPageState extends State<ViewCommandPage> {
  @override
  Widget build(BuildContext context) {
    String dropdownValue = 'Fragile';
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Commande',
            style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.bold,
                fontSize: 24)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.symmetric(
              vertical: kDefaultPadding, horizontal: kDefaultPadding),
          width: size.width - 20,
          child: Column(
            children: [
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 40,
                      child: SvgPicture.asset(
                        "assets/images/avatarlist.svg",
                        height: 70,
                        width: 70,
                      ),
                    ),
                    Text(
                      "Luv",
                      style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 18.5,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Voiture",
                      style: TextStyle(fontFamily: 'Roboto', fontSize: 13),
                    ),
                    Text(
                      "distance",
                      style: TextStyle(
                          fontSize: 13,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                child: Text(
                  "Description de la commande ici",
                  style: TextStyle(fontFamily: 'Roboto'),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              FlatButton(
                onPressed: () {},
                color: kPrimaryColor,
                textColor: Colors.white,
                child: const Text(
                  'Valider',
                  style: TextStyle(fontFamily: 'Roboto', fontSize: 15),
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
