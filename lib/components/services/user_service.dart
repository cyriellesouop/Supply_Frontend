// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/Database_Model.dart';
class UserService {
  CollectionReference<Map<String, dynamic>> userCollection =
      FirebaseFirestore.instance.collection("user");

  UserModel _userFromSnapshot(DocumentSnapshot<Map<String, dynamic>> json) {
    var data = json.data();
    if (data == null) throw Exception("utilisateur introuvable");
    return UserModel(
        //idUser: data['idUser'],
        idUser: data['idUser'],
        adress: data['adress'],
        name: data['name'],
        phone: data['phone'],
        tool: data['tool'],
        picture: data['picture'],
        position: data['position'],
        isManager: data['isManager'],
        isClient: data['isClient'],
        isDeliver: data['isDeliver']);
  }

  //Get users
  Stream<List<UserModel>> getUsers() {
    return userCollection.snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => UserModel.fromJson(doc.data())).toList());
  }

  Stream<List<UserModel>> getposdelivers() {
    return userCollection.where('isDeliver', isEqualTo: true).snapshots().map(
        (snapshot) => snapshot.docs
            .map((doc) => UserModel.fromJson(doc.data()))
            .toList());
  }

  Stream getdeliver() {
    return userCollection.where('isDeliver', isEqualTo: true).snapshots();
  }

  //Get User by id

  Stream<UserModel> getUserbyId(String idUser) {
    return userCollection.doc(idUser).snapshots().map(_userFromSnapshot);
  }

  //Get User by phone

  Future<QuerySnapshot<Map<String, dynamic>>> getUserbyPhone(int phone) {
    return userCollection.where('phone', isEqualTo: phone).get()
      ..then((snapshot) => snapshot.docs);
  }

//add an user
  Future<void> addUser(UserModel user) async {
    // var documentRef =
    await userCollection.add(user.toMap());
    /*  var createdId = documentRef.id;
     userCollection.doc(createdId).update(
        {'idUser': createdId},
      );
     return createdId;*/
  }

  //Update an user and insert if not exits
  Future<void> setUser(UserModel user) async {
    var optionManager = SetOptions(
        mergeFields: ['adress', 'name', 'phone', 'picture', 'idPosition']);
    var optionDeliver = SetOptions(
        mergeFields: ['name', 'phone', 'tool', 'picture', 'idPosition']);
    var optionClient = SetOptions(mergeFields: ['name', 'idPosition']);

    if (user.isManager) {
      userCollection
          .doc(user.idUser)
          .set(user.toMap(), optionManager)
          .then((value) => print("User Added"))
          .catchError((error) => print("Failed to add user: $error"));
    } else if (user.isDeliver) {
      userCollection
          .doc(user.idUser)
          .set(user.toMap(), optionDeliver)
          .then((value) => print("User Added"))
          .catchError((error) => print("Failed to add user: $error"));
    } else if (user.isClient) {
      // ignore: avoid_single_cascade_in_expression_statements
      userCollection.doc(user.idUser).set(user.toMap(), optionClient)
        ..then((value) async => print("User Added"))
            .catchError((error) => print("Failed to add user: $error"));
    }
  }

//fonction de mise a jour du numero de telephone
  Future<void> updatePhoneuser(String userId, String userphone) async {
    userCollection.doc(userId).update(
      {'phone': userphone},
    );
  }
  //supprimer un utilisateur de la base de donnee

  Future<void> removeUser(String idUser) {
    return userCollection
        .doc(idUser)
        .delete()
        .then((value) => print("User Deleted"))
        .catchError((error) => print("Failed to delete user: $error"));
  }

  //idposition of deliver

/*Future<QuerySnapshot<Map<String, dynamic>>> getpositionUser(String idUser,String idposition) {
    return userCollection.where('idUser', isEqualTo:idUser).where('idPosition', isEqualTo: idposition).get('')
      ..then((snapshot) => snapshot.docs);
  }
  
  // retourne la position d'un livreur
     Future<Stream<List>> getdeliveridpos() async {
     return userCollection.where('isDeliver', isEqualTo: true).get().then((value) { return value.docs.single['idPosition'];});
    // .snapshots().map((snapshot) =>
  //     snapshot.docs.map((doc)=>doc.data()).toList());
   }

   //retourne la position d'un gerant
    Future<Stream<List>> getmanagerpos() async {
     return userCollection.where('isManager', isEqualTo: true).get().then((value) { return value.docs.single['idPosition'];});
    // .snapshots().map((snapshot) =>
  //     snapshot.docs.map((doc)=>doc.data()).toList());
   }
    //get delivers
  /*Stream<List<UserModel>> getDelivers() {
    return userCollection.snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => UserModel.fromJson(doc.data())).toList());
  }*/
  
  
  */
}
