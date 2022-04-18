// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';
import 'package:supply_app/components/screen/manager/components/deliver_list.dart';
import 'package:supply_app/constants.dart';
//import '../components/manager_list.dart';

class PhoneAuth extends StatefulWidget {
  const PhoneAuth({Key? key}) : super(key: key);

  @override
  _PhoneAuthState createState() => _PhoneAuthState();
}

class _PhoneAuthState extends State<PhoneAuth> {
  int start = 30;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: buildAppBar(),
      body: Container(
          padding: const EdgeInsets.only(
              top: kDefaultPadding * 4,
              bottom: kDefaultPadding,
              left: kDefaultPadding,
              right: kDefaultPadding),
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: ListView(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: 30),
                  child: TextFormField(
                    
                    decoration: InputDecoration(
                      fillColor: Colors.white70,
                      filled: true,
                      hintText: "Votre Contact",
                      hintStyle: TextStyle(color: Colors.grey[800]),
                      prefixIcon: CountryCodePicker(
                        initialSelection: 'CM',
                        favorite: ['+237', 'CM'],
                        hideMainText: true,
                      ),
                      /*  suffixIcon: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 14, horizontal: 15),
                          child: IconButton(
                              icon:
                                  SvgPicture.asset("assets/icons/envoyer.svg"),
                              onPressed: () {
                                startTimer();
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>  DeliverList()));
                              }),
                        )*/
                    ),
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                Center(
                  child: Row(
                    children: [
                      Text("Renvoie d'un nouveau code dans",
                          style: GoogleFonts.poppins(
                              fontSize: 15, fontWeight: FontWeight.bold)),
                      Expanded(
                        child: Text("00:$start",
                            style: GoogleFonts.poppins(
                                fontSize: 15,
                                color: Color.fromARGB(255, 225, 28, 10))),
                      ),
                      Expanded(
                        child: Text(" sec",
                            style: GoogleFonts.poppins(
                                fontSize: 15, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
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
                  height: 40.0,
                ),
                FlatButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const  DeliverList()));
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

  void startTimer() {
    const onsec = Duration(seconds: 1);
    Timer timer = Timer.periodic(onsec, (timer) {
      if (start == 0) {
        setState(() {
          timer.cancel();
        });
      } else {
        setState(() {
          start--;
        });
      }
    });
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
