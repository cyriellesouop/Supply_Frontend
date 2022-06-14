import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class Storage{
 FirebaseStorage firebaseStorage = FirebaseStorage.instance;

Future <void> uploadImageFile(File image, String fileName) async{
  UploadTask uploadTask;
  try {
    await firebaseStorage.ref().child(fileName).putFile(image);
    
  } on FirebaseException catch (e) {
    print('l erreu est $e');
 
  }
    /* Reference reference = firebaseStorage.ref().child(fileName);
    UploadTask uploadTask = reference.putFile(image);
    return uploadTask; */
  }
 
}