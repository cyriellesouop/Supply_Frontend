// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../constants.dart';
import 'deliver_model.dart';

class CommandPage extends StatefulWidget {
  const CommandPage({Key? key}) : super(key: key);

  @override
  _CommandPageState createState() => _CommandPageState();
}

class _CommandPageState extends State<CommandPage> {
  List<Deliver> delivers = [
    Deliver(1, "romeo", "voiture", 10, "assets/images/avatarlist.svg"),
    Deliver(2, "Luc", "Moto", 1, "assets/images/avatarlist.svg"),
    Deliver(3, "leo", "voiture", 8, "assets/images/avatarlist.svg"),
    Deliver(4, "Luc", "Moto", 1, "assets/images/avatarlist.svg"),
    Deliver(5, "leo", "voiture", 8, "assets/images/avatarlist.svg"),
    Deliver(6, "Luc", "Moto", 1, "assets/images/avatarlist.svg"),
    Deliver(7, "leo", "voiture", 8, "assets/images/avatarlist.svg"),
    Deliver(8, "Luc", "Moto", 1, "assets/images/avatarlist.svg"),
    Deliver(9, "leo", "voiture", 8, "assets/images/avatarlist.svg"),
    Deliver(10, "Luc", "Moto", 1, "assets/images/avatarlist.svg"),
    Deliver(11, "leo", "voiture", 8, "assets/images/avatarlist.svg"),
    Deliver(12, "Luc", "Moto", 1, "assets/images/avatarlist.svg"),
    Deliver(13, "leo", "voiture", 8, "assets/images/avatarlist.svg"),
    Deliver(14, "Luc", "Moto", 1, "assets/images/avatarlist.svg"),
    Deliver(15, "leo", "voiture", 8, "assets/images/avatarlist.svg")
  ];
  @override
  Widget build(BuildContext context) {
    String dropdownValue = 'Fragile';
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 70,
        // titleSpacing: 0,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.arrow_back,
                size: 24,
              ),
              CircleAvatar(
                radius: 20,
                child: SvgPicture.asset(
                  "assets/images/avatarlist.svg",
                  height: 36,
                  width: 36,
                ),
              )
            ],
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "Luc",
              style: TextStyle(fontSize: 18.5, fontWeight: FontWeight.bold),
            ),
            Text(
              " situe a une distance de 10 km de vous",
              style: TextStyle(fontSize: 11),
            )
          ],
        ),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(
            vertical: kDefaultPadding, horizontal: kDefaultPadding),
        width: size.width - 20,
        child: Column(
          children: [
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                // mainAxisAlignment: MainAxisAlignment.start
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
                    style:
                        TextStyle(fontSize: 18.5, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Voiture",
                    style: TextStyle(fontSize: 13),
                  ),
                  Text(
                    "distance",
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              decoration: InputDecoration(
                  labelText: 'nom de la commande',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  filled: true,
                  hintStyle: TextStyle(color: Colors.grey[800]),
                  // prefixIcon: const Icon(Icons.write),
                  //     hintText: "",
                  fillColor: Colors.white70),
            ),
            SizedBox(
              height: 20,
            ),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Etat du colis',
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
              items: <String>['Fragile', 'non-fragile', 'autres']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            // ignore: prefer_const_constructors
            SizedBox(
              height: 20,
            ),
            FlatButton(
              onPressed: () {},
              color: kPrimaryColor,
              textColor: Colors.white,
              child: const Text(
                'Publier',
                style: TextStyle(fontSize: 15),
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
            ),
            SizedBox(
              height: 20,
            ),
            FlatButton(
              onPressed: () {
                Navigator.pop(context);
              },
              color: kPrimaryColor,
              textColor: Colors.white,
              child: const Text(
                'Annuler',
                style: TextStyle(fontSize: 15),
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
            )
          ],
        ),
      ),
    );
  }
}
