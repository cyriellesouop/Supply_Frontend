// ignore_for_file: prefer_const_constructors, unused_local_variable
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:supply_app/components/screen/manager/components/deliver_list.dart';
import 'package:supply_app/components/services/position_service.dart';
import 'package:supply_app/components/services/user_service.dart';

import 'package:supply_app/constants.dart';

import '../../../../models/Database_Model.dart';

class PhoneAuth extends StatefulWidget {
  //  final InscriptionName formulaireinit;
  // const PhoneAuth({Key? key, required this.formulaireinit}) : super(key: key);
  final String nameField;
  final String adressField;
  final String picture;
  const PhoneAuth(
      {Key? key,
      required this.nameField,
      required this.adressField,
      required this.picture})
      : super(key: key);

  @override
  _PhoneAuthState createState() => _PhoneAuthState();
}

class _PhoneAuthState extends State<PhoneAuth> {
//controleur du champs de remplissage du numero de telephone et de l'Ot code
  TextEditingController phoneController = TextEditingController();
  TextEditingController otpCodeController = TextEditingController();
  bool isLoading = false;
  // variable contenant le message de verification
  String verificationIDreceived = "";

// variables contenant les coordonees d'une position
  late double lat;
  late double long;
  //verifie si l'espace pour le code pin est visible afin de changer la valeur des boutons et les actions derrieres les boutons
  bool otploginVisible = false;

  // creation d'une instance de firebaseauth
  FirebaseAuth auth = FirebaseAuth.instance;

//fonction pour obtenir les coordonnees la position actuelle
  void getCurrentLocation() async {
    LocationPermission permission;
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      lat = position.latitude;
      long = position.longitude;
    } on PlatformException catch (e) {
      if (e.code == "PERMISSION_DENIED") {
        var error = "PERMISSION_DENIED";
        print("PERMISSION_DENIED");
      } else if (e.code == "PERMISSION_DENIED_NEVER_ASK") {
        print("PERMISSION_DENIED_NEVER_ASK");
      }
    }
    /* permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        return Future.error('Location Not Available');
      }
    } else {
      throw Exception('Error');
    }*/
    //fonction Geolocator qui donne la localisation

    //coordonee obtenue grace a Geolocator
  }

  //-----------------------------------------------------------------

//la fonction initstate  la listenOtp lors de rechargement de la page
  @override
  void initState() {
    super.initState();
    getCurrentLocation();
    _listenOtp();
  }

/* remplissage automatique de l'otp et */
  void _listenOtp() async {
    await SmsAutoFill().listenForCode();
  }

/* ************************************/
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
                  onPressed: () async {
                    if (otploginVisible == false) {
                      verifyNumber();
                    } else {
                      print(
                          "la latitude est : $lat et la longitude est : $long et le formulaire ${widget.nameField}");

                      /**----------------------------------------------------------------------------------*/
                      PositionModel pos =
                          PositionModel(longitude: long, latitude: lat);
                      var identifiant = await PositionService().addPosition(
                          pos); // renvoie l'id de la position actuelle du manager

                      UserModel user = UserModel(
                        adress: widget.adressField,
                        name: widget.nameField,
                        idPosition: identifiant,
                        phone:  int.parse(phoneController.text),
                        picture: 'add',
                      );
                      await UserService().addUser(user);
                      /**-----------------------------------------------------------------------------------*/
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

  // fonction qui retourne l'identifiant de l'utilisateur actuelle de l'application

  Future<String> currentUserid() async {
    final User user = auth.currentUser!;
    final id = user.uid;
    return id;
  }

// la fonction affichant l'erreur dans une boite de dialogue
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
