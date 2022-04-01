// ignore_for_file: deprecated_member_use, prefer_const_constructors
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:supply_app/components/screen/accueil/introduction_screen1.dart';
import 'package:supply_app/constants.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
          child: Column(
            children: <Widget>[
              Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: kDefaultPadding * 2,
                      vertical: kDefaultPadding * 2),
                  height: size.height * 0.6,
                  width: size.width * 0.6,
                  child: Image.asset("assets/images/liv.png")),
              Container(
                  height: size.height / 6,
                  width: size.width * 0.8,
                  child: Text(
                    "Bienvenue sur mon application",
                    style: GoogleFonts.philosopher(
                        fontSize: 30, fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  )),
              Text(
                "Merci d\'avoir installe l\'application, passons maintenant a la configuration",
                style: GoogleFonts.poppins(color: Colors.grey, fontSize: 13),
                textAlign: TextAlign.center,
              ),
              Container(
                  padding: const EdgeInsets.only(
                      top: kDefaultPadding * 2, bottom: kDefaultPadding * 2),
                  child: FlatButton(
                    padding: EdgeInsets.all(15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    color: kPrimaryColor,
                    textColor: kBackgroundColor,
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => IntroductionScreen()));
                    },
                    child: Text(
                      "S\'INSCRIRE",
                      style: GoogleFonts.poppins(fontSize: 15),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
