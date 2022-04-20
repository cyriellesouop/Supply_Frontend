// ignore_for_file: dead_code, sized_box_for_whitespace, prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supply_app/components/screen/manager/components/inscription/inscription_validate.dart';
import 'package:supply_app/constants.dart';

class InscriptionName extends StatefulWidget {
  const InscriptionName({Key? key}) : super(key: key);

  @override
  _InscriptionNameState createState() => _InscriptionNameState();
}

class _InscriptionNameState extends State<InscriptionName> {
 // String dropdownValueOutil = 'voiture';

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: buildAppBar(),
      body: Container(
          padding: const EdgeInsets.symmetric(
              vertical: kDefaultPadding, horizontal: kDefaultPadding),
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: ListView(
              children: <Widget>[
                Center(
                  child: Stack(children: [
                    Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                          border: Border.all(width: 4, color: Colors.white70),
                          boxShadow: [
                            BoxShadow(
                                spreadRadius: 2,
                                blurRadius: 10,
                                color: Colors.black.withOpacity(0.1))
                          ],
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: AssetImage("assets/images/profil.png"))),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(width: 4, color: Colors.white),
                            color: kPrimaryColor),
                        child: IconButton(
                          icon: Icon(Icons.edit, color: Colors.white),
                          onPressed: () {},
                        ),
                      ),
                    )
                  ]),
                ),
                const SizedBox(
                  height: 25.0,
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 30),
                  child: TextFormField(
                    style: GoogleFonts.poppins(fontSize: 15),
                    decoration: InputDecoration(
                        //  labelText: 'Veuillez saisir le nom de l\'entreprise',

                        filled: true,
                        hintStyle: TextStyle(color: Colors.grey[800]),
                        hintText: "Nom de l\'entreprise",
                        //  prefixIcon: const Icon(Icons.home_mini_rounded),
                        fillColor: Colors.white70),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 30),
                  child: TextFormField(
                    style: GoogleFonts.poppins(fontSize: 15),
                    decoration: InputDecoration(
                        //  labelText: 'Veuillez saisir le nom de l\'entreprise',

                        filled: true,
                        hintStyle: TextStyle(color: Colors.grey[800]),
                        hintText: "Adresse de l'entreprise",
                        //  prefixIcon: const Icon(Icons.home_mini_rounded),
                        fillColor: Colors.white70),
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                FlatButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const PhoneAuth()));
                  },
                  padding: EdgeInsets.all(15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  color: kPrimaryColor,
                  textColor: kBackgroundColor,
                  child: Text(
                    'SUIVANT',
                    style: GoogleFonts.poppins(fontSize: 15),
                  ),
                )
              ],
            ),
          )),
    );
  }
}

AppBar buildAppBar() {
  return AppBar(
    backgroundColor: kPrimaryColor,
    title: Text(
      'Mon application',
      style: GoogleFonts.philosopher(fontSize: 20),
    ),
    centerTitle: true,
  );
}

