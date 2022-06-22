import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:supply_app/screen/accueil/splash.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
  configLoading();
}

//onloading bar
void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.yellow
    ..backgroundColor = Colors.green
    ..indicatorColor = Colors.yellow
    ..textColor = Colors.yellow
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = true
    ..dismissOnTap = false;
  // ..customAnimation = CustomAnimation();
}

class MyApp extends StatelessWidget {
  // final bool showHome; final String identifiant;
  const MyApp({Key? key}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
      builder: EasyLoading.init(),
    );
  }
}


/*
/* ************************************/
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
                          Navigator.pop(context);
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
                            Navigator.pop(context);

                            /*  Fluttertoast.showToast(
                                msg: "le code  est incorrect",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 5,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 16.0); */
                            /*  _timer?.cancel();
                            await EasyLoading.showSuccess(
                                "le code saisi est correct"); */
                          } else {

                            Navigator.pop(context);
                             await EasyLoading.dismiss();

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
                            /*  _timer?.cancel();
                            await EasyLoading.dismiss(); */
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
 */