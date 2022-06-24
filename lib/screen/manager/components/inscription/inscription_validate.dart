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

  bool isTimeExpired = false;
  //pour afficher la boite de dialogue de saisi de l'otp code

  var idDoc;

  bool otpDialog = true;
  //pour renvoyer le code
  bool resend = false;
  // gerer l'etat du formulaire
  final _formKey = GlobalKey<FormState>();
  //verifier si l'authentification a reussi
  bool verified = false;

  //si l'otp a ete saisi
  bool isphonenumberNotFill = true;
  //verifie si l'espace pour le code pin est visible afin de changer la valeur des boutons et les actions derrieres les boutons
  bool otploginVisible = false;
  //gerer l'etat du circular progress bar
  bool isLoading = false;
  var bouton = "VERIFIER";

  var idExistant;

  // bool wait = false;
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

  //tableau de tous les utilisateurs de la base de donnees

  List<UserModel> allUsers = [];
  List<String> allphone = [];
//token
  String? token;
  // timer utiliser pour le onloading
  Timer? _timer;

// variables contenant les coordonees d'une position
  late double lat;
  late double long;

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
    getAlluser();
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

  //tous les id existant dans la bd
  getAlluser() async {
    await ServiceUser.getAlluser().forEach((element) {
      setState(() {
        allUsers = element;
      });
    });
  }

  List<bool> isExist(List<UserModel?> table, UserModel user) {
    var isexist = false;
    var alreadyDeliver = false;
    for (var i in table) {
      if (i?.phone == user.phone && i?.isManager == true) {
        setState(() {
          isexist = true;
          alreadyDeliver = false;
        });

        break;
      } else if (i?.phone == user.phone && i?.isDeliver == true) {
        setState(() {
          isexist = true;
          alreadyDeliver = true;
        });
        break;
      }
    }
    return [isexist, alreadyDeliver];
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

                          otpDialog
                              ? {
                            _showValidationDialog(context),
                          }
                              : {};
                        }
                      } else {
                        print(
                            "la latitude est : $lat et la longitude est : $long et le formulaire ${widget.nameField}");

                        print(
                            "le token est : ${auth.currentUser!.getIdToken()}");

                        /**----------------------------------------------------------------------------------*/
                        PositionModel pos =
                        PositionModel(longitude: long, latitude: lat);
                        var identifiant = await PositionService().addPosition(
                            pos); // renvoie l'id de la position actuelle du manager

                        //stockage local with sharedprefs
                        SharedPreferences prefs =
                        await SharedPreferences.getInstance();

                        UserModel userCreate = UserModel(
                          //ajouter l'identifiant du nouvel utilisateur , le meme qui s'est cree lors de l'authentification

                            idUser: this.actual_user,
                            adress: widget.adressField,
                            name: widget.nameField,
                            idPosition: identifiant,
                            phone: int.parse(
                                "+237${phoneController.text}".trim()),
                            picture: widget.picture,
                            token: token,
                            createdAt: DateTime.now().toString());

                        _timer?.cancel();
                        setState(() {
                          isLoading = true;
                        });

                        if (isExist(allUsers, userCreate)[0] == false &&
                            isExist(allUsers, userCreate)[1] == false) {
                          await UserService()
                              .addUser(userCreate)
                              .then((value) {
                            setState(() {
                              idDoc = value;
                            });
                            prefs.setString('id', this.actual_user);
                            prefs.setString('name', widget.nameField);
                            prefs.setString('adress', widget.adressField);
                            prefs.setString('picture', widget.picture);
                            prefs.setInt(
                                'phone',
                                int.parse("+237${phoneController.text}"
                                    .trim()));
                            prefs.setString('idPosition', identifiant);
                            prefs.setBool('isAuthenticated', true);
                            prefs.setString('idDoc', idDoc);
                            (EasyLoading.showSuccess(
                                'compte cree avec succes'));
                          }).catchError((onError) {
                            EasyLoading.showError('echec de connexion');
                          });
                        } else if (isExist(allUsers, userCreate)[0] ==
                            true &&
                            isExist(allUsers, userCreate)[1] == true) {
                          _ShowDialog(context);
                        } else if (isExist(allUsers, userCreate)[0] ==
                            true &&
                            isExist(allUsers, userCreate)[1] == false) {
                          SharedPreferences prefs =
                          await SharedPreferences.getInstance();

                          setState(() {
                            idExistant = prefs.getString('idDoc') ?? '';
                          });

                          await UserService()
                              .updateUser(userCreate, idExistant);
                        }

                        //   if (isExist(table, user))

                        setState(() {
                          phoneController.text = '';
                        });

                        _timer?.cancel();
                        EasyLoading.dismiss();

                        Navigator.of(context).pushReplacement(
                            MaterialPageRoute(

                              //builder: (context) =>  ManagerHome( user: authClass.user)));
                                builder: (context) =>
                                //InscriptionName()
                                ManagerHome(
                                    currentManagerID: actual_user)));

                        /*  Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(

                                      //builder: (context) =>  ManagerHome( user: authClass.user)));
                                      builder: (context) =>
                                          //InscriptionName()
                                          ManagerHome(
                                              currentManagerID: actual_user))); */
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
                    height: size.width * 0.12,
                    width: size.width * 0.1,
                    child: CircularProgressIndicator(
                      strokeWidth: 6.0,
                      backgroundColor: Colors.grey,
                      valueColor: AlwaysStoppedAnimation(kPrimaryColor),
                    ),
                  )
                ],
              ),
            ),
          )),
    );
  }

  /*  void startTimer() {
    const onsec = Duration(seconds: 1);
    Timer _timer = Timer.periodic(onsec, (timer) {
      if (start == 0) {
        setState(() {
          timer.cancel();
          //   wait = false;
        });
      } else {
        setState(() {
          start--;
        });
      }
    });
  } */

/* 
//verifier si le tmps de verification de code a expirer
  verificationCompleted(params) async {

    print("time time is ok");
    if (isTimeExpired) {
      await auth.signOut();
       print("time time is expired");
      //your code
      Fluttertoast.showToast(
          msg: "temps expire",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 5,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  } */

  // ignore: non_constant_identifier_names
  void _ShowDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              backgroundColor: Colors.white,
              content: Container(
                  child: Text(
                      "Un compte livreur a deja ete cree sur ce numero ?")),
              actions: [
                FlatButton(
                  child: Text("OK".toUpperCase(),
                      style:
                      TextStyle(color: Color.fromARGB(255, 240, 229, 240))),
                  padding: EdgeInsets.all(2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  color: Palette.primarySwatch.shade400,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ]);
        });
  }

// fonction d'affichage de la boite de dialogue
  void _showValidationDialog(BuildContext context) async {
    /* setState(() {
      start = 30;
    }); */
    print("+237${phoneController.text}");
    await auth.verifyPhoneNumber(
        phoneNumber: "+237${phoneController.text}".trim(),
        verificationCompleted: (PhoneAuthCredential credential) {},
        timeout: const Duration(seconds: 60),
        verificationFailed: (FirebaseAuthException e) {
          if (e.code == 'invalid-phone-number') {
            print('The provided phone number is not valid.');
            Fluttertoast.showToast(
                msg: "le numero de telephone n'est pas valide  ",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 5,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0);
          }

          setState(() {
            isLoading = false;
          });
          Navigator.pop(context);
        },
        codeSent: (String verificationID, int? resendtoken) {
          setState(() {
            verificationIDreceived = verificationID;
          });

          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text("Veuillez saisir le code recu",
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      )),
                  content: /* Container(
                    height: 100,
                    child: Column(
                      children: [ */
                  PinFieldAutoFill(
                    controller: otpCodeController,
                    keyboardType: TextInputType.number,
                    codeLength: 6,
                    onCodeChanged: (val) {
                      print(val);
                    },
                  ),
                  /*  SizedBox(
                          height: 5,
                        ),
                        RichText(
                            text: TextSpan(
                          children: [
                            TextSpan(
                              text: "Renvoie d'un nouveau code dans ",
                              style: TextStyle(
                                  fontSize: 16, color: Colors.yellowAccent),
                            ),
                            TextSpan(
                              text: "00:$start",
                              style: TextStyle(
                                  fontSize: 16, color: Colors.pinkAccent),
                            ),
                            TextSpan(
                              text: " sec ",
                              style: TextStyle(
                                  fontSize: 16, color: Colors.yellowAccent),
                            ),
                          ],
                      /*   )), */
                      ],
                    ),
                  ), */
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
                          //  Navigator.pop(context);
                          print(
                              '--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------formulaire valide');
                          await authClass!
                              .signInwithPhoneNumber(verificationIDreceived,
                              otpCodeController.text, context)
                              .then((value) {
                            setState(() {
                              actual_user = value!.uid;
                              value.getIdToken().then((value) {
                                setState(() {
                                  token = value.toString();
                                });
                              });
                              verified =
                                  authClass!.isphonenumberok(actual_user);
                              otpDialog = false;
                              print('verification est :$verified');
                              print("actual $actual_user");
                            });
                          }).catchError((onError) {
                            print("erreur du token est : $onError");
                            isLoading = false;

                            Fluttertoast.showToast(
                                msg:
                                "le code saisi est incorrect , veuillez verifier a nouveau ",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 10,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 16.0);
                            Navigator.pop(context);
                          });
                          if (verified == true) {
                            //  otploginVisible = verified;

                            print("le token token tonken est : $token ");
                            isLoading = false;
                            _timer?.cancel();
                            await EasyLoading.showSuccess(
                                "le code saisi est correct");
                          } else {}
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
