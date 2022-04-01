// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';
import 'package:supply_app/components/screen/manager/components/deliver_list.dart';
import 'package:supply_app/constants.dart';

class Inscription extends StatefulWidget {
  @override
  _InscriptionState createState() => _InscriptionState();
}

class _InscriptionState extends State<Inscription> {
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
                              image: AssetImage("assets/images/avar.svg"))),
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
                  // width: size.width - 40,
                  child: TextFormField(
                    style: GoogleFonts.poppins(fontSize: 15),
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        // labelText: 'votre numero de telephone',

                        fillColor: Colors.white70,
                        filled: true,
                        hintText: "telephone",
                        hintStyle: TextStyle(color: Colors.grey[800]),
                        prefixIcon: CountryCodePicker(
                          initialSelection: 'CM',
                          favorite: ['+237', 'CM'],
                          hideMainText: true,
                        )
                        //  prefixIcon: const Icon(Icons.contact_phone_rounded),
                        ),
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                Center(
                  child: Text("Veuillez saisir le code recu",
                      style: GoogleFonts.poppins(
                          fontSize: 15, color: Colors.redAccent)),
                ),
                const SizedBox(
                  height: 30,
                ),
                OTPTextField(
                  keyboardType: TextInputType.number,
                  length: 5,
                  width: MediaQuery.of(context).size.width - 34,
                  fieldWidth: 30,
                  otpFieldStyle: OtpFieldStyle(borderColor: Colors.black),
                  style: const TextStyle(fontSize: 17, color: Colors.black),
                  textFieldAlignment: MainAxisAlignment.spaceAround,
                  fieldStyle: FieldStyle.underline,
                  /* onCompleted: (pin) {
                  print("Completed: " + pin);
                },*/
                ),
                const SizedBox(
                  height: 30.0,
                ),
                FlatButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const DeliverList()));
                  },
                  padding: EdgeInsets.all(15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  color: kPrimaryColor,
                  textColor: kBackgroundColor,
                  child: Text(
                    'CREER VOTRE COMPTE',
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
