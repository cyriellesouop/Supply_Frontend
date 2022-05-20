// ignore_for_file: prefer_const_constructors, unused_local_variable
import 'dart:async';
import 'dart:ffi';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:supply_app/components/services/auth_service.dart';
import 'package:supply_app/components/services/position_service.dart';
import 'package:supply_app/components/services/user_service.dart';
import 'package:supply_app/constants.dart';

import '../../../../models/Database_Model.dart';
import '../manager_home.dart';

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
  bool otpDialog = true;
  // gerer l'etat du formulaire
  final _formKey = GlobalKey<FormState>();
  //verifier si l'authentification a reussi
  bool verified = false;
  late UserModel user;
  // creation d'une instance de firebaseauth
  FirebaseAuth auth = FirebaseAuth.instance;

// variable contenant le message de verification
  String verificationIDreceived = "";
  String actual_user = '';
  // AppUser? actual_user;
  Authclass? authClass; // = Authclass(auth.currentUser);

  //token

  String? token;
  // timer utiliser pour le onloading
  Timer? _timer;

// variables contenant les coordonees d'une position
  late double lat;
  late double long;
  //verifie si l'espace pour le code pin est visible afin de changer la valeur des boutons et les actions derrieres les boutons
  bool otploginVisible = false;

//fonction pour obtenir les coordonnees la position actuelle
  /* void getCurrentLocation() async {
    LocationPermission permission;
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      lat = position.latitude;
      long = position.longitude;
    } on PlatformException catch (e) {
      if (e.code == "PERMISSION_DENIED") {
        var error = "PERMISSION_DENIED";
        getCurrentLocation();

        // print("PERMISSION_DENIED");
      } else if (e.code == "PERMISSION_DENIED_NEVER_ASK") {
        print("PERMISSION_DENIED_NEVER_ASK");
      }
    }
  }*/

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

  UserModel? exampleModel = new UserModel(name: 'fabiol');

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
    //  print('liste de livreurs ${exampleService.getposdelivers()}');
    _currentManager();
    _DeliversPosition();

//print('exemple model value ====>${exampleModel}');
    //print(UserService().getUserbyId("UtfTYNHAjdcNyroh7p9B"));
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

  _DeliversPosition() async {
    print(' le nombre identifiant est ${this._listDeliver()}');
    await ServicePosition.getPosition('OCrk7Ov4pIZXabNqnyMU').then(
      (value) {
        setState(() {
          this.x = value;
          this.y = LatLng(x.latitude, x.longitude);
        });
        //  print("dans le then ma latitude est ${y.latitude}, et ma longitude est ${y.longitude}");
      },
    );
    // print("ma latitude est ${y.latitude}, et ma longitude est ${y.longitude}");
    /* for (var i = 0; i < this.exampleModelDeliver.length; i++) {
      print("le compteur est:${i}");
      print('la position est ${this.exampleModelDeliver[i].idPosition}');
    /*  await ServicePosition.getPosition(
              '${this.exampleModelDeliver[i].idPosition}')
          .then(
        (value) {
          setState(() {
            this.x = value;
            this.y = LatLng(x.latitude, x.longitude);
          });
        },
      );*/

     // positions.add(y);
    //  print("ma prochaine position est ${positions.last}");
    }*/

    //  print('la premiere position est ${positions[0]}');
    // print('la deuxieme position est ${positions[1]}');
  }

  _currentManager() async {
    // print('teste user !!!111 ');
    await ServiceUser.getUserbyId("UtfTYNHAjdcNyroh7p9B").then((value) {
      setState(() {
        this.exampleModel = value;
      });
    });

    print('dikongue ${this.exampleModel}');
  }

  _listDeliver() async {
    await ServiceUser.getDelivers().forEach((element) {
      setState(() {
        this.exampleModelDeliver = element;
      });
      /* var taille = this.exampleModelDeliver.length;
      for (var i = 0; i < taille; i++) {
        print('liste de livreurs ${this.exampleModelDeliver[i]}\n');
      }*/
      print(
          "le nombre de livreur est exactement ${exampleModelDeliver.length}");
    });

    print("le nombre de livreur est ${exampleModelDeliver.length}");
    return exampleModelDeliver.length;
    // exampleModelDeliver= exampleService.getposdelivers();
  }

  /* _getToken()async{
    await authClass.getToken().then((value) {setState(() {
      this.token=value;
    });});

  }*/

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
            child: Form(
              key: _formKey,
              child: ListView(
                //geestionnaire d'etat

                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 30, top: 20),
                    child: TextFormField(
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
                          return ' ${this.exampleModel!.name}';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        /*  errorText: (phoneController.value.text.isEmpty)
                            ? 'erreur, veuillez remplir ce champ'
                            : 'en attente de verification du numero ${phoneController.text}',*/
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
                        if (_formKey.currentState!.validate()) {
                          // _timer?.cancel();
                          //  await EasyLoading.show(
                          // status: "vous allez recevoir um message");

                          //   if(otpDialog)
                          _showValidationDialog(context);
                          setState(() {});
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

                        UserModel userCreate = UserModel(
                          //ajouter l'identifiant du nouvel utilisateur , le meme qui s'est cree lors de l'authentification
                          // idUser: authClass!.identifiant(),
                          idUser: this.actual_user,
                          adress: widget.adressField,
                          name: widget.nameField,
                          //  position: pos,
                          idPosition: identifiant,
                          phone: int.parse(phoneController.text),
                          picture: widget.picture,
                        );
                        _timer?.cancel();
                        // await EasyLoading.show(status: 'en cours...');
                        // await UserService().setUser(user).then((value) =>
                        await UserService().addUser(userCreate).then((value) =>
                            (EasyLoading.showSuccess('compte cree avec succes'))
                                .catchError((onError) {
                              EasyLoading.showError('echec de connexion');
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
                                    ManagerHome(currentManager: userCreate)));
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
                  ),
                  /*  Visibility(
                    visible: isLoading,
                    child: SizedBox(
                      height: 20,
                      child: CircularProgressIndicator(),
                    ),
                  ),*/
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
                    TextButton(
                        child: Text("valider"),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
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
                                print('verification est :$verified');
                              });
                            });
                            print(
                                'formulaire valide et actuel : ${actual_user}');

                            print(
                                'formulaire valide et actuellllllllllllllll : ${actual_user}');
                          }

                          if (verified == true) {
                            _timer?.cancel();
                            await EasyLoading.showSuccess(
                                "le code saisi est correct");
                          } else {
                            setState(() {
                              otpCodeController.text = '';
                            });
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

                            setState(() {
                              otpDialog = false;
                            });
                          }

                          setState(() {
                            otploginVisible = verified;
                          });

                          /* setState(() {
                            isLoading = false;
                          });*/
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

  /*void _login(String verificationId) async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: otpCodeController.text,
    );

    var res = await auth.signInWithCredential(credential);
    print(res);

    String tel = phoneController.text;
    var response = await   authClass.verifyPhoneNumber('+237${phoneController.text}', context, setData); 

    
  }*/

  /*fonction de verification du code envoye

  Future<void> verifyCode() async {
    print(otpCodeController.text + "verfication du code envoye");
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationIDreceived,
        smsCode: otpCodeController.text);

    await auth.signInWithCredential(credential).then((authresult result){
            Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (context) => HomeScreen(result.user)
            ));
          }).catchError((e){
            print(e);
          });
  }*/

  // fonction qui retourne l'identifiant de l'utilisateur actuelle de l'application

  /*validation de formulaire
  void _submit() {
    final isValid = _formKey.currentState?.validate();
    if (!isValid!) {
      return;
    }
    _formKey.currentState?.save();
  }*/

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
