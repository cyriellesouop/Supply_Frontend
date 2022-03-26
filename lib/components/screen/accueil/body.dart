// ignore_for_file: deprecated_member_use, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:supply_app/components/screen/manager/components/inscription.dart';
import 'package:supply_app/constants.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
        child: Column(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: kDefaultPadding * 2,
                  vertical: kDefaultPadding / 4),
              height: size.height * 0.4,
              width: size.width * 0.6,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      alignment: Alignment.center,
                      fit: BoxFit.cover,
                      image: AssetImage("assets/images/fleur.png"))),
            ),
            Container(
                height: size.height / 6,
                width: size.width * 0.8,
                child: const Text(
                  "Bienvenue sur mon application",
                  style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'DayRoman'),
                  textAlign: TextAlign.center,
                )),
            const Text(
              "Merci d\'avoir installe l\'application, passons maintenant a la configuration",
              maxLines: 2,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
                fontFamily: 'DayRoman',
              ),
              textAlign: TextAlign.center,
            ),
            //Spacer(),
            Container(
                padding: const EdgeInsets.only(
                    top: kDefaultPadding * 4, bottom: kDefaultPadding * 3),
                child: FlatButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  color: kPrimaryColor,
                  textColor: Colors.white,
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Inscription()));
                  },
                  child: const Text(
                    "S\'inscrire",
                    style: TextStyle(fontSize: 22),
                  ),
                )),

            /* Text(
              "En appuyant sur s\'inscrire, vous accepter notre politique de confidentialite et notre condition d\'utilisation.",
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 9,
                fontFamily: 'DayRoman',
              ),
              textAlign: TextAlign.center,
            ),*/
          ],
        ),
      ),
    );
  }
}
