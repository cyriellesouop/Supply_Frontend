// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:supply_app/constants.dart';

class InscriptionName extends StatefulWidget {
  const InscriptionName({Key? key}) : super(key: key);

  @override
  _InscriptionNameState createState() => _InscriptionNameState();
}

class _InscriptionNameState extends State<InscriptionName> {
  String dropdownValue = 'voiture';
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      margin: const EdgeInsets.symmetric(
          vertical: kDefaultPadding * 2, horizontal: kDefaultPadding * 2),
      child: Column(
        children: [
          Container(
            height: size.height * 0.3,
            width: size.width * 0.4,
            padding: const EdgeInsets.symmetric(
                horizontal: kDefaultPadding, vertical: kDefaultPadding),
            decoration: const BoxDecoration(
                image: DecorationImage(
                    alignment: Alignment.center,
                    fit: BoxFit.fill,
                    image: AssetImage("assets/images/avatar.png"))),
          ),
          SizedBox(
            height: size.height * 0.1,
          ),
          TextFormField(
            decoration: InputDecoration(
                labelText: 'nom d\'utilisateur',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                filled: true,
                hintStyle: TextStyle(color: Colors.grey[800]),
                // prefixIcon: const Icon(Icons.write),
                //     hintText: "",
                fillColor: Colors.white70),
          ),
          // ignore: prefer_const_constructors
          SizedBox(
            height: 20,
          ),
          DropdownButtonFormField<String>(
            decoration: InputDecoration(
              labelText: 'Quel est votre outil de livraison',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            value: dropdownValue,
            onChanged: (String? newValue) {
              setState(() {
                dropdownValue = newValue!;
              });
            },
            items: <String>['voiture', 'moto', 'tricyle', 'camionnette']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          // ignore: prefer_const_constructors
          SizedBox(
            height: 50,
          ),
          FlatButton(
            minWidth: size.width,
            textColor: kBackgroundColor,
            color: kPrimaryColor,
            onPressed: () {},
            child: const Text(
              "Suivant",
              style: TextStyle(
                fontSize: 22,
              ),
            ),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ],
      ),
    );
  }
}

AppBar buildAppBar() {
  return AppBar(
    title: const Text('Mon application',
        style: TextStyle(
            fontFamily: 'DayRoman', fontWeight: FontWeight.bold, fontSize: 24)),
    centerTitle: true,
  );
}
