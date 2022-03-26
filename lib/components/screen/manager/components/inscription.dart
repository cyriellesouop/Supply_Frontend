// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';
import 'package:supply_app/components/screen/manager/components/deliver_list.dart';
import 'package:supply_app/constants.dart';

class Inscription extends StatelessWidget {
  const Inscription({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: buildAppBar(),
      body: SingleChildScrollView(
          child: Container(
        margin: const EdgeInsets.symmetric(
            vertical: kDefaultPadding, horizontal: kDefaultPadding),
        child: Form(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            /*   Text('Creation de compte',
                style: (Theme.of(context).textTheme.headline5?.copyWith(
                      fontFamily: 'DayRoman',
                      fontWeight: FontWeight.bold,
                    ))),
            Container(
              height: size.height * 0.4,
              width: size.width * 0.25,
              padding: const EdgeInsets.symmetric(
                  horizontal: kDefaultPadding, vertical: kDefaultPadding),
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      alignment: Alignment.center,
                      fit: BoxFit.fill,
                      image: AssetImage("assets/images/avatar.png"))),
            ),*/
            const SizedBox(
              height: 20.0,
            ),
            CircleAvatar(
              radius: 80,
              child: SvgPicture.asset(
                "assets/images/avatarlist.svg",
                height: 80,
                width: 80,
                alignment: Alignment.center,
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            TextFormField(
              decoration: InputDecoration(
                  labelText: 'Veuillez saisir le nom de l\'entreprise',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  filled: true,
                  hintStyle: TextStyle(color: Colors.grey[800]),
                  hintText: "Nom de l\'entreprise",
                  //  prefixIcon: const Icon(Icons.home_mini_rounded),
                  fillColor: Colors.white70),
            ),
            const SizedBox(
              height: 20.0,
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
                  hintText: "telephone",
                  hintStyle: TextStyle(color: Colors.grey[800]),
                  prefixIcon: const Icon(Icons.contact_phone_rounded),
                ),
                //  hintText: "",
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              width: size.width - 30,
              child: Row(children: [
                Expanded(
                  child: Container(
                    height: 1,
                    color: Colors.grey,
                    margin: const EdgeInsets.symmetric(horizontal: 12),
                  ),
                ),
                const Text("Saisir le code recu"),
                Expanded(
                  child: Container(
                    height: 1,
                    color: Colors.grey,
                    margin: const EdgeInsets.symmetric(horizontal: 12),
                  ),
                ),
              ]),
            ),
            const SizedBox(
              height: 30,
            ),
            OTPTextField(
              length: 5,
              width: MediaQuery.of(context).size.width - 34,
              fieldWidth: 30,
              otpFieldStyle: OtpFieldStyle(borderColor: Colors.black),
              style: const TextStyle(fontSize: 17, color: Colors.black),
              textFieldAlignment: MainAxisAlignment.spaceAround,
              fieldStyle: FieldStyle.underline,
              onCompleted: (pin) {
                print("Completed: " + pin);
              },
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
              color: kPrimaryColor,
              textColor: Colors.white,
              child: const Text(
                'creer votre compte',
                style: TextStyle(fontSize: 15),
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
            )
          ],
        )),
      )),
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
