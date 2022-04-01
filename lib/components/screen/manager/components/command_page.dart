// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../constants.dart';

class CommandPage extends StatefulWidget {
  const CommandPage({Key? key}) : super(key: key);

  @override
  _CommandPageState createState() => _CommandPageState();
}

class _CommandPageState extends State<CommandPage> {
  String bouton = "Annuler";
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
                          fontFamily: 'Roboto',
                          fontSize: 13,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 25,
              ),
              TextField(
                decoration: InputDecoration(
                    labelText: 'nom de la commande',
                    hintStyle: TextStyle(color: Colors.grey[800]),
                    fillColor: Colors.white70),
              ),
              SizedBox(
                height: 20,
              ),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Etat du colis',
                  hintStyle: TextStyle(color: Colors.grey[800]),
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
              SizedBox(
                height: 20,
              ),

              TextFormField(
                decoration: InputDecoration(
                    labelText: 'Donner une esstimation de poids',
                    hintStyle: TextStyle(color: Colors.grey[800]),
                    fillColor: Colors.white70),
              ),

              // ignore: prefer_const_constructors
              SizedBox(
                height: 20,
              ),
              TextFormField(
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.newline,
                minLines: 1,
                maxLines: 5,
                decoration: InputDecoration(
                    labelText: 'Decrire clairement la commande ici',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    filled: true,
                    hintStyle: TextStyle(color: Colors.grey[800]),
                    // prefixIcon: const Icon(Icons.write),
                    hintText: "Description de la commande ici",
                    fillColor: Colors.white70),
              ),
              SizedBox(
                height: 20,
              ),
              FlatButton(
                onPressed: () {},
                color: kPrimaryColor,
                textColor: Colors.white,
                child: Text(
                  "$EtatBouton",
                  style: TextStyle(fontSize: 15),
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
              ),
              SizedBox(
                height: 10,
              ),
              FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                color: kPrimaryColor,
                textColor: Colors.white,
                child: Text(
                  "$EtatBouton",
                  style: TextStyle(fontSize: 15),
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
              )
            ],
          ),
        ),
      ),
    );
  }

  String EtatBouton() {
    if (bouton == "publier") {
      setState(() {
        bouton = "Annuler";
      });
    } else {
      bouton = "publier";
    }
    return bouton;
  }
}

  /* AppBar(
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
      ), */
