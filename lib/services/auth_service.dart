import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:supply_app/models/Database_Model.dart';

class Authclass extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  //user =  _auth.currentUser;
  //------------------------------------------------------------

  //----------------------------------------------------------------

  var storage = const FlutterSecureStorage();
  bool otploginVisible = false;
  var token;
  List<String> liste = [];

  AppUser? _userFromFirebase(User? user) {
    if (user != null) {
      return AppUser(uid: user.uid);
    } else {
      return null;
    }
  }

  Stream<AppUser?> get user {
    return _auth.authStateChanges().map(_userFromFirebase);
  }

  /* void storeTokenAndData(UserCredential userCredential) async {
    print("enregistrement du token et des donnees");
    await storage.write(
        key: "token", value: userCredential.credential?.token.toString());
    await storage.write(
        key: "usercredential", value: userCredential.toString());
  } */

  /*  Future<String?> getToken() async {
    return await storage.read(key: "token");
  } */

/*   Future<void> verifyPhoneNumber(
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
          timeout: const Duration(seconds: 180),
          phoneNumber: phoneNumber,
          verificationCompleted: verificationCompleted,
          verificationFailed: verificationFailed,
          codeSent: codeSent,
          codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
    } catch (e) {
      //showSnackBar(context, e.toString());
    }
  } */

  Future<User?> signInwithPhoneNumber(
      String verificationId, String smsCode, BuildContext context) async {
    try {
      AuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: smsCode);

      UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      //  Future<String> users

      /* String id = userCredential.user!.uid;
      liste[0]=id;

      userCredential.user!.getIdToken().then((value) {
        token = value.toString();
        liste[1]=value.toString();
      }); */
      

      print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! WAOU     ");
      //  print('l identifiant est ${users!.uid}');

      Navigator.pop(context);
      return userCredential.user;
    } catch (e) {
      print('error');
      return null;
    }
  }

  // ignore: unnecessary_null_comparison
  // String identifiant()=> (this.users. == null)? "":this.users!.uid.toString();

  bool isphonenumberok(String? actual_user) {
    if (actual_user?.length != null ) {
      return true;
      // final String uid= user.uid.toString();
    }
    // final String uid = user.uid.toString();
    //return uid;
    return false;
  }
}
