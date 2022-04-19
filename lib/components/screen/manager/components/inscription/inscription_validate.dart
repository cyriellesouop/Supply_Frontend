// ignore_for_file: prefer_const_constructors
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';
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
   OtpFieldController otpCodeController =  OtpFieldController();
   String  verificationIDreceived="";
   bool otploginVisible = false;
  FirebaseAuth auth=FirebaseAuth.instance;

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
                if (otploginVisible==false) {
                   verifyNumber();
                  
          
                } 

                else{
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
                  child: Text(otploginVisible? "CREER UN COMPTE":"VERIFIER",
                    
                    style: GoogleFonts.poppins(fontSize: 15),
                  ),)


             
              ],
            ),
          )),
    );
  }
 void _showValidationDialog(BuildContext context) async =>   showDialog(
    context: context, 
    builder: (context){
      return AlertDialog(
        

        title: Text("Veuillez saisir le code recu",style: GoogleFonts.poppins(
                              fontSize: 15, fontWeight: FontWeight.bold,)),
        content: OTPTextField(
          controller:otpCodeController,
         
                
                    keyboardType: TextInputType.number,
                  
                    length: 6,
                    width: MediaQuery.of(context).size.width - 28,
                    fieldWidth: 25,
                    otpFieldStyle: OtpFieldStyle(borderColor: Colors.black),
                    style: const TextStyle(fontSize: 17, color: Colors.black),
                    textFieldAlignment: MainAxisAlignment.spaceAround,
                    fieldStyle: FieldStyle.underline,
                  
                  ),
        actions:<Widget> [
          TextButton(
             child: Text("valider"),
            onPressed: (){
              
                   verifyCode()  ;
              
             Navigator.of(context).pop();
           }
            )
        ],
      );
    });

  Future <void> verifyNumber() async{

print("+237${phoneController.text}");

  await auth.verifyPhoneNumber(
    
    phoneNumber: "+237${phoneController.text}",  
    verificationCompleted: (PhoneAuthCredential credential) async{
    await auth.signInWithCredential(credential).then((value) => print("connexion reussie"));
    },
    verificationFailed: (FirebaseAuthException exception){
      if (exception.code == 'invalid-phone-number') {
      showMessage("le numero de telephone est invalid!");
    }

    }, 
    codeSent: (String verificationID, int? resendtoken){
      _showValidationDialog(context);
      print(resendtoken);
      print("code envoye");
      setState(() {
        verificationIDreceived=verificationID;
        otploginVisible=true;
      });  
      
    }, 
    codeAutoRetrievalTimeout: (String verificationID){
       
    });
}

 Future <void> verifyCode() async {
   print(otpCodeController.toString()+"verfication du code envoye");
  PhoneAuthCredential credential=PhoneAuthProvider.credential(
    verificationId: verificationIDreceived, 
    smsCode: otpCodeController.toString());

    await auth.signInWithCredential(credential).then((value){print("creation de compte reussie");});
}

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
                onPressed: ()  {
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
