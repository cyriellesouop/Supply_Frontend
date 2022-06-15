// ignore_for_file: prefer_const_constructors, unused_local_variable
import 'dart:async';

import 'dart:ui';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:supply_app/common/constants.dart';
import 'package:supply_app/common/palette.dart';
import 'package:supply_app/services/auth_service.dart';
import 'package:supply_app/services/position_service.dart';
import 'package:supply_app/services/user_service.dart';
import '../../../../models/Database_Model.dart';
import '../manager_home.dart';

class PhoneAuth extends StatefulWidget {
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
  bool otpDialog = true;
  // gerer l'etat du formulaire
  final _formKey = GlobalKey<FormState>();
  //verifier si l'authentification a reussi
  bool verified = false;
  bool isphonenumberNotFill = true;
  late UserModel user;
  // creation d'une instance de firebaseauth
  FirebaseAuth auth = FirebaseAuth.instance;
// variable contenant le message de verification
  String verificationIDreceived = "";
  String actual_user = '';
  // AppUser? actual_user;
  Authclass? authClass; // = Authclass(auth.currentUser);
//liste des positions de tous les livreurs
  List<LatLng> listecoordonnees = [];
//token
  String? token;
  // timer utiliser pour le onloading
  Timer? _timer;

// variables contenant les coordonees d'une position
  late double lat;
  late double long;
  //verifie si l'espace pour le code pin est visible afin de changer la valeur des boutons et les actions derrieres les boutons
  bool otploginVisible = false;
  bool isLoading = false;
//fonction pour obtenir les coordonnees la position actuelle

//obtenir la position actuelle
  Future<void> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
//Si vous souhaitez vérifier si l'utilisateur a déjà accordé des autorisations pour acquérir l'emplacement de l'appareil
    permission = await Geolocator.checkPermission();
//checkPermissionméthode renverra le LocationPermission.deniedstatut, lorsque le navigateur ne prend pas en charge l'API JavaScript Permissions
    if (permission == LocationPermission.denied) {
      //Si vous souhaitez demander l'autorisation d'accéder à l'emplacement de l'appareil, vous pouvez appeler la requestPermiss
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        getCurrentLocation();
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low);
    print(position);
    lat = position.latitude;
    long = position.longitude;

    // return await Geolocator.getCurrentPosition();
  }

  //vider les controller
  @override
  void dispose() {
    phoneController.dispose();
    otpCodeController.dispose();
    super.dispose();
  }

  UserModel? exampleModel =
      new UserModel(name: 'audrey'); //,picture: "assets/images/profil.png"

  UserService ServiceUser = new UserService();
  PositionService ServicePosition = new PositionService();
  PositionModel x = new PositionModel(longitude: 0, latitude: 0);
  LatLng y = new LatLng(0, 0);

  List<LatLng> positions = [];

  List<UserModel> exampleModelDeliver = [];

  //-----------------------------------------------------------------

//la fonction initstate  la listenOtp et la currentlocation et le easyloading lors de rechargement de la page
  @override
  void initState() {
    super.initState();

    authClass = Authclass();

    //authClass = Authclass(this.auth.currentUser);
    _listDeliver();

    _DeliversPosition();

    getCurrentLocation();
    _listenOtp();

    EasyLoading.addStatusCallback((status) {
      print('EasyLoading Status $status');
      if (status == EasyLoadingStatus.dismiss) {
        _timer?.cancel();
      }
    });
  }

  /**************************************************/

/* remplissage automatique de l'otp et */
  void _listenOtp() async {
    await SmsAutoFill().listenForCode();
  }

  // getUserPosition(List<UserModel>  users) async {

  _DeliversPosition() async {
    //  print(' le nombre identifiant est ${this._listDeliver()}');
    await ServicePosition.getPosition('OCrk7Ov4pIZXabNqnyMU').then(
      (value) {
        setState(() {
          this.x = value;
          this.y = LatLng(x.latitude, x.longitude);
        });
      },
    );
  }

  _listDeliver() async {
    await ServiceUser.getDelivers().forEach((element) {
      setState(() {
        this.exampleModelDeliver = element;
      });

      print(
          "le nombre de livreur est exactement ${exampleModelDeliver.length}");
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    //  var size = MediaQuery.of(context).size;
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
            child: Form(
              key: _formKey,
              child: ListView(
                //geestionnaire d'etat

                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 30, top: 20),
                    child: TextFormField(
                      enabled: isphonenumberNotFill,
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      //controller du champs de saisie de telephone
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r"[0-9]"),
                        )
                      ],
                      validator: (value) {
                        if (value?.length != 9) {
                          //  if (value == null || value.isEmpty) {
                          return ' Numero de telephone invalide';
                        }
                        return null;
                      },
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
                  !isLoading
                      ? FlatButton(
                          onPressed: () async {
                            if (otploginVisible == false) {
                              if (_formKey.currentState!.validate()) {
                                setState(() {
                                  isLoading = true;
                                });

                                otpDialog ? _showValidationDialog(context) : {};
                              }
                            } else {
                              print(
                                  "la latitude est : $lat et la longitude est : $long et le formulaire ${widget.nameField}");

                              print("le token est : ${this.token}");

                              /**----------------------------------------------------------------------------------*/
                              PositionModel pos =
                                  PositionModel(longitude: long, latitude: lat);
                              var identifiant = await PositionService().addPosition(
                                  pos); // renvoie l'id de la position actuelle du manager

                              //stockage local with sharedprefs
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              prefs.setString('id', this.actual_user);
                              prefs.setString('name', widget.nameField);
                              prefs.setString('adress', widget.adressField);
                              prefs.setString('picture', widget.picture);
                              prefs.setInt(
                                  'phone', int.parse(phoneController.text));
                              prefs.setString('idPosition', identifiant);
                              prefs.setBool('isAuthenticated', true);

                              UserModel userCreate = UserModel(
                                  //ajouter l'identifiant du nouvel utilisateur , le meme qui s'est cree lors de l'authentification

                                  idUser: this.actual_user,
                                  adress: widget.adressField,
                                  name: widget.nameField,
                                  idPosition: identifiant,
                                  phone: int.parse(phoneController.text),
                                  picture: widget.picture,
                                  createdAt: DateTime.now().toString());
                              _timer?.cancel();
                              setState(() {
                                isLoading = true;
                              });
                              // await EasyLoading.show(status: 'en cours...');
                              // await UserService().setUser(user).then((value) =>

                              // await UserService().updateUserData(this.actual_user,widget.nameField,int.parse(phoneController.text),widget.picture,widget.adressField,identifiant).then((value) =>
                              await UserService().addUser(userCreate).then(
                                  (value) => (EasyLoading.showSuccess(
                                              'compte cree avec succes'))
                                          .catchError((onError) {
                                        EasyLoading.showError(
                                            'echec de connexion');
                                      }));
                              setState(() {
                                phoneController.text = '';
                              });

                              _timer?.cancel();
                              EasyLoading.dismiss();

                              /**-----------------------------------------------------------------------------------*/
                              /*    Fluttertoast.showToast(
                            msg: "compte cree avec succes",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 2,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0);*/

                              Navigator.push(
                                  context,
                                  MaterialPageRoute(

                                      //builder: (context) =>  ManagerHome( user: authClass.user)));
                                      builder: (context) =>
                                          //InscriptionName()
                                          ManagerHome(
                                              currentManagerID: actual_user)));
                              _timer?.cancel();
                              await EasyLoading.dismiss();
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
                      : Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: size.width * 0.37),
                          height: 40,
                          width: 10,
                          child: CircularProgressIndicator(
                            strokeWidth: 6.0,
                            backgroundColor: Colors.grey,
                            valueColor: AlwaysStoppedAnimation(kPrimaryColor),
                          ),
                        )

                  /* Visibility(
                    visible: isLoading,
                    child: SizedBox(
                      height: 20,
                      child: CircularProgressIndicator(),
                    ),
                  ), */
                ],
              ),
            ),
          )),
    );
  }

// fonction d'affichage de la boite de dialogue
  void _showValidationDialog(BuildContext context) async {
    print("+237${phoneController.text}");
    await auth.verifyPhoneNumber(
        phoneNumber: "+237${phoneController.text}",
        verificationCompleted: (PhoneAuthCredential credential) {},
        verificationFailed: (FirebaseAuthException exception) {},
        codeSent: (String verificationID, int? resendtoken) {
          // _timer?.cancel();
          //  EasyLoading.dismiss();

          setState(() {
            verificationIDreceived = verificationID;
          });
          showDialog(
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
                  ),
                  actions: <Widget>[
                    FlatButton(
                        child: Text("valider",
                            style: TextStyle(
                                color: Color.fromARGB(255, 240, 229, 240))),
                        padding: EdgeInsets.all(2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        color: Palette.primarySwatch.shade400,
                        onPressed: () async {
                          // if (_formKey.currentState!.validate()) {
                          print(
                              '--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------formulaire valide');
                          // _timer?.cancel();
                          //  EasyLoading.show(
                          //     status: 'verification en cours...');

                          await authClass!
                              .signInwithPhoneNumber(
                                  // verified= await authClass!.signInwithPhoneNumber(
                                  verificationIDreceived,
                                  otpCodeController.text,
                                  context)
                              .then((value) {
                            setState(() {
                              actual_user = value!.uid.toString();
                              verified =
                                  authClass!.isphonenumberok(actual_user);
                              otpDialog = false;
                              print('verification est :$verified');
                            });
                          });
                          //  } else {
                          /*  setState(() {
                                otpDialog = false;
                              }); */
                          //  }

                          if (verified == true) {
                            isLoading = false;
                            _timer?.cancel();
                            await EasyLoading.showSuccess(
                                "le code saisi est correct");
                          } else {
                            /* _timer?.cancel();
                              await EasyLoading.showError(
                                  "le code saisi est incorrect"); */
                            /*  setState(() {
                                otpDialog = false;
                                //otpCodeController.text = '';
                              }); */
                            /** 
                              _timer?.cancel();
                              await EasyLoading.showError("verification echoue");
                              */
                            _timer?.cancel();
                            await EasyLoading.dismiss();
                            Fluttertoast.showToast(
                                msg: "le code saisi est incorrect",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 5,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 16.0);

                            /* setState(() {
                                otpDialog = false;
                              }); */
                          }

                          setState(() {
                            isphonenumberNotFill = !verified;
                            otploginVisible = verified;
                          });
                        })
                  ],
                );
              });
          final signcode = SmsAutoFill().getAppSignature;
          print(resendtoken);
          print("code envoye");
          print(signcode);
        },
        codeAutoRetrievalTimeout: (String verificationID) {});
  }

  void setData(String verificationId) {
    setState(() {
      verificationIDreceived = verificationId;
    });
  }
/*
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
        });
  }*/

  save() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('id', this.actual_user);
    prefs.setString('name', widget.nameField);
    prefs.setString('adress', widget.adressField);
    prefs.setString('picture', widget.picture);
    prefs.setInt('phone', int.parse(phoneController.text));
    /*  await ServiceUser.getUserbyId(this.actual_user).then((value) {
      prefs.setString('name', value.name);
      prefs.setInt('Phone', value.phon);
      prefs.setString('name', value.name);
      prefs.setString('name', value.name);
      prefs.setString('name', value.name);
      prefs.setString('name', value.name);
    }); */
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
