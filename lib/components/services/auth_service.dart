import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:supply_app/components/screen/manager/components/manager_home.dart';

class Authclass {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late User user;// =  _auth.currentUser;
 

  final storage = const FlutterSecureStorage();
  bool otploginVisible = false;

  Authclass(){
    user= _auth.currentUser!;
  }

  void storeTokenAndData(UserCredential userCredential) async {
    print("enregistrement du token et des donnees");
    await storage.write(
        key: "token", value: userCredential.credential?.token.toString());
    await storage.write(
        key: "usercredential", value: userCredential.toString());
  }

  Future<String?> getToken() async {
    return await storage.read(key: "token");
  }

  Future<void> verifyPhoneNumber(
      String phoneNumber, BuildContext context, Function setData) async {
    // ignore: prefer_function_declarations_over_variables
    PhoneVerificationCompleted verificationCompleted =
        (PhoneAuthCredential phoneAuthCredential) async {
      //showSnackBar(context, "Verification Completed");
    };
    // ignore: prefer_function_declarations_over_variables
    PhoneVerificationFailed verificationFailed =
        (FirebaseAuthException exception) {
      //showSnackBar(context, exception.toString());
    };
    // ignore: prefer_function_declarations_over_variables
    PhoneCodeSent codeSent =
        (String verificationID, [int? forceResnedingtoken]) {
      setData(verificationID);
      //
      //  showSnackBar(context, "Time out");
    };

    // ignore: prefer_function_declarations_over_variables
    PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationID) {};
    try {
      await _auth.verifyPhoneNumber(
          timeout: const Duration(seconds: 300),
          phoneNumber: phoneNumber,
          verificationCompleted: verificationCompleted,
          verificationFailed: verificationFailed,
          codeSent: codeSent,
          codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
    } catch (e) {
      //showSnackBar(context, e.toString());
    }
  }

/*
  void showSnackBar(BuildContext context, String text) {
    final snackBar = SnackBar(content: Text(text));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
*/
  Future<bool> signInwithPhoneNumber(
      String verificationId, String smsCode, BuildContext context) async {
    try {
      AuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: smsCode);

      UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      storeTokenAndData(userCredential);
      // otploginVisible=true;
      // Navigator.pop(context,otploginVisible);
      Navigator.pop(context);
      /* Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (builder) =>const ManagerHome()),
          (route) => false);*/
      // showSnackBar(context, "logged In");
      return true;
    } catch (e) {
      // showSnackBar(context, e.toString());
      return false;
    }
  }

 // ignore: unnecessary_null_comparison
 String identifiant()=> (user.uid == null)? "":user.uid.toString();

  /*Future<String> getCurrentUserId() async {
    if (signInwithPhoneNumber){
      final String uid= user.uid.toString();

    }
   
    final String uid = user.uid.toString();
    return uid;
  }*/
}
