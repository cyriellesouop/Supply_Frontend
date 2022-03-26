// ignore_for_file: dead_code, sized_box_for_whitespace, prefer_const_constructors
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';
import 'package:supply_app/constants.dart';

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
    return Container(
      margin: const EdgeInsets.symmetric(
          vertical: kDefaultPadding, horizontal: kDefaultPadding),
      height: size.height,
      width: size.width,
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.only(
                  top: kDefaultPadding * 2, bottom: kDefaultPadding * 3),
              child: Text('Creation de compte',
                  style: (Theme.of(context).textTheme.headline5?.copyWith(
                      fontFamily: 'DayRoman', fontWeight: FontWeight.bold))),
            ),
            SizedBox(
              height: 40.0,
            ),
            Container(
              width: size.width - 40,
              child: TextFormField(
                decoration: InputDecoration(
                    labelText: 'votre numero de telephone',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    fillColor: Colors.white70,
                    filled: true,
                    hintStyle: TextStyle(color: Colors.grey[800]),
                    prefixIcon: const Icon(Icons.contact_phone_rounded),
                    suffixIcon: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 14, horizontal: 15),
                      child: IconButton(
                          icon: SvgPicture.asset("assets/icons/envoyer.svg"),
                          onPressed: () {
                            startTimer();
                          }),
                    )),
                //  hintText: "",
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              width: size.width - 30,
              child: Row(children: [
                Expanded(
                  child: Container(
                    height: 1,
                    color: Colors.grey,
                    margin: EdgeInsets.symmetric(horizontal: 12),
                  ),
                ),
                Text("Saisir le code recu"),
                Expanded(
                  child: Container(
                    height: 1,
                    color: Colors.grey,
                    margin: EdgeInsets.symmetric(horizontal: 12),
                  ),
                ),
              ]),
            ),
            SizedBox(
              height: 30,
            ),
            OTPTextField(
              length: 5,
              width: MediaQuery.of(context).size.width - 34,
              fieldWidth: 30,
              otpFieldStyle: OtpFieldStyle(borderColor: Colors.black),
              style: TextStyle(fontSize: 17, color: Colors.black),
              textFieldAlignment: MainAxisAlignment.spaceAround,
              fieldStyle: FieldStyle.underline,
              onCompleted: (pin) {
                print("Completed: " + pin);
              },
            ),
            SizedBox(
              height: 40,
            ),
            RichText(
                text: TextSpan(children: [
              TextSpan(
                  text: "Renvoie d'un nouveau code dans ",
                  style: TextStyle(fontSize: 16, color: Colors.pinkAccent)),
              TextSpan(
                  text: "00:$start",
                  style: TextStyle(
                      fontSize: 16, color: Color.fromARGB(255, 192, 223, 18))),
              TextSpan(
                  text: " sec",
                  style: TextStyle(fontSize: 16, color: Colors.pinkAccent)),
            ])),
          ],
        ),
      ),
    );
  }

//fonction pour gerer le delais de saisi du code qu'il a recu
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
    title: Text('Mon application',
        style: TextStyle(
            fontFamily: 'DayRoman', fontWeight: FontWeight.bold, fontSize: 24)),
    centerTitle: true,
  );
}
