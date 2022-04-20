// ignore_for_file: prefer_const_constructors, unused_local_variable
import 'dart:async';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:google_fonts/google_fonts.dart';
//import 'package:otp_autofill/otp_autofill.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:supply_app/components/screen/manager/components/deliver_list.dart';

import 'package:supply_app/constants.dart';

class PhoneAuth extends StatefulWidget {
  const PhoneAuth({Key? key}) : super(key: key);

  @override
  _PhoneAuthState createState() => _PhoneAuthState();
}

class _PhoneAuthState extends State<PhoneAuth> {
  TextEditingController phoneController = TextEditingController();
  bool isLoading = false;
  TextEditingController otpCodeController = TextEditingController();
  // late OTPInteractor _otpInteractor = OTPInteractor();
  // = OTPTextEditController(codeLength: codeLength)
  // OtpFieldController otpController =  OtpFieldController();
  //  OTPInteractor _otpInteractor = OTPInteractor();
  String verificationIDreceived = "";
  bool otploginVisible = false;
  FirebaseAuth auth = FirebaseAuth.instance;

  void initState() {
    super.initState();
    _listenOtp();
  }


void _listenOtp() async {
  await SmsAutoFill().listenForCode();

}
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
                  padding: const EdgeInsets.only(bottom: 30, top: 20),
                  child: TextFormField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
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
                    ),
                  ),
                ),
                SizedBox(
                  height: 60,
                ),
                FlatButton(
                  onPressed: () {
                    if (otploginVisible == false) {
                  
                      verifyNumber();
                    } else {
                      /*  Fluttertoast.showToast(
                     msg: "compte cree avec succes",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                       timeInSecForIosWeb: 2,
                      backgroundColor: Colors.red,
                     textColor: Colors.white,
                   fontSize: 16.0
                 ); */

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const DeliverList()));
                    }
                  },
                  padding: EdgeInsets.all(15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  color: kPrimaryColor,
                  textColor: kBackgroundColor,
                  child: Text(
                    otploginVisible ? "CREER UN COMPTE" : "VERIFIER",
                    style: GoogleFonts.poppins(fontSize: 15),
                  ),
                )
              ],
            ),
          )),
    );
  }
// fonction d'affichage de la boite de dialogue
  void _showValidationDialog(BuildContext context) async => showDialog(
      context: context,
      builder: (context) {
        // final signcode = SmsAutoFill().getAppSignature();
        return AlertDialog(
          title: Text("Veuillez saisir le code recu",
              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              )),
          content: PinFieldAutoFill(
           
            controller: otpCodeController,
            keyboardType: TextInputType.number,
            codeLength: 6,
            onCodeChanged: (val) {
              print(val);
            },
            /*
                    length: 6,
                    width: MediaQuery.of(context).size.width - 28,
                    fieldWidth: 25,
                    otpFieldStyle: OtpFieldStyle(borderColor: Colors.black),
                    style: const TextStyle(fontSize: 17, color: Colors.black),
                    textFieldAlignment: MainAxisAlignment.spaceAround,
                    fieldStyle: FieldStyle.underline,*/
          ),
          actions: <Widget>[
            TextButton(
                child: Text("valider"),
                onPressed: () {
                  verifyCode();

                  Navigator.of(context).pop();
                })
          ],
        );
      });
// la fonction de verification de numero de telephone
  Future<void> verifyNumber() async {
    print("+237${phoneController.text}");

    await auth.verifyPhoneNumber(
        phoneNumber: "+237${phoneController.text}",
        verificationCompleted: (PhoneAuthCredential credential) async {
          await auth
              .signInWithCredential(credential)
              .then((value) => print("connexion reussie"));
        },
        verificationFailed: (FirebaseAuthException exception) {
          if (exception.code == 'invalid-phone-number') {
            showMessage("le numero de telephone est invalid!");
          }
        },
        codeSent: (String verificationID, int? resendtoken) {
          _showValidationDialog(context);
          final signcode = SmsAutoFill().getAppSignature;
          print(resendtoken);
          print("code envoye");
          print(signcode);
         
          setState(() {
            verificationIDreceived = verificationID;
            otploginVisible = true;
          });
        },
        codeAutoRetrievalTimeout: (String verificationID) {});
  }

  //fonction de verification du code envoye

  Future<void> verifyCode() async {
    print(otpCodeController.text + "verfication du code envoye");
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationIDreceived,
        smsCode: otpCodeController.text);

    await auth.signInWithCredential(credential).then((value) {
      print("creation de compte reussie");
    });
  }

// la fonction affichant l'erreu dans une boite de dialogue
  void showMessage(String errorMessage) {
    showDialog(
        context: context,
        builder: (BuildContext builderContext) {
          return AlertDialog(
            title: Text("Error"),
            content: Text(errorMessage),
            actions: [
              TextButton(
                child: Text("Ok"),
                onPressed: () {
                  Navigator.of(builderContext).pop();
                },
              )
            ],
          );
        }).then((value) {
      setState(() {
        isLoading = false;
      });
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
