import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/Database_Model.dart';

class UserService {
   FirebaseStorage firebaseStorage = FirebaseStorage.instance;

  CollectionReference<Map<String, dynamic>> userCollection =
      FirebaseFirestore.instance.collection("user");

  /*UserModel _userFromSnapshot(DocumentSnapshot<Map<String, dynamic>> json) {
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
        // position: data['position'],
        isManager: data['isManager'],
        isClient: data['isClient'],
        isDeliver: data['isDeliver']);
  }*/

  //Get users
 Stream<List<UserModel>> getUsers() {
    // int x = 0;
    print("moguem souop audrey");
    return userCollection.snapshots().map(
      (snapshot) {
        //  x = snapshot.docs.length;
        //  print('la longueur du snapshot est ${snapshot.docs.length}');
        /* try{
      if (snapshot.docs.isNotEmpty) {
         print('la longueur du snapshot est ${snapshot.docs.length}');  
      } } catch (e){print('erreur est le suivant $e');}*/
        return snapshot.docs.map((doc) {
          //  print('moguem souop${doc.runtimeType}');
          //print('mon adresse${doc.get('adress')}');
          return UserModel(
              //idUser: data['idUser'],
              idUser: doc.get('idUser'),
              adress: doc.get('adress'),
              name: doc.get('name'),
              phone: int.parse(doc.get('phone')),
              tool: doc.get('tool'),
              picture: doc.get('picture'),
              idPosition: doc.get('idPosition'),
              isManager: doc.get('isManager'),
              isClient: doc.get('isClient'),
              isDeliver: doc.get('isDeliver'),
             // createdAt: doc.get('createdAt')
              );
        }).toList();
        // return model;
      },
    );
  }

//liste de livreurs correcte

  Stream<List<UserModel>> getDelivers() {
    
    // int x = 0;
    print("moguem souop audrey");
    return userCollection.where('isDeliver', isEqualTo: true).snapshots().map(
      (snapshot) {
        //  x = snapshot.docs.length;
        //  print('la longueur du snapshot est ${snapshot.docs.length}');
        /* try{
      if (snapshot.docs.isNotEmpty) {
         print('la longueur du snapshot est ${snapshot.docs.length}');  
      } } catch (e){print('erreur est le suivant $e');}*/
        return snapshot.docs.map((doc) {
          //  print('moguem souop${doc.runtimeType}');
          //print('mon adresse${doc.get('adress')}');
          return UserModel(
              //idUser: data['idUser'],
              idUser: doc.get('idUser'),
             // adress: doc.get('adress'),
              name: doc.get('name'),
             // phone: int.parse(doc.get('phone')),
              tool: doc.get('tool'),
              picture: doc.get('picture'),
              idPosition: doc.get('idPosition'),
              isManager: doc.get('isManager'),
              isClient: doc.get('isClient'),
              isDeliver: doc.get('isDeliver'),
             // createdAt: doc.get('createdAt')
              );
        }).toList();
        // return model;
      },
    );
  }

  //liste des managers correctes
Stream<List<UserModel>> getManagers()  {
    // int x = 0;
    print("moguem souop audrey");
    return userCollection.where('isManager', isEqualTo: true).snapshots().map(
      (snapshot) {
        //  x = snapshot.docs.length;
        //  print('la longueur du snapshot est ${snapshot.docs.length}');
        /* try{
      if (snapshot.docs.isNotEmpty) {
         print('la longueur du snapshot est ${snapshot.docs.length}');  
      } } catch (e){print('erreur est le suivant $e');}*/
        return snapshot.docs.map((doc) {
          //  print('moguem souop${doc.runtimeType}');
          //print('mon adresse${doc.get('adress')}');
          return UserModel(
              //idUser: data['idUser'],
              idUser: doc.get('idUser'),
              adress: doc.get('adress'),
              name: doc.get('name'),
              phone: int.parse(doc.get('phone')),
              tool: doc.get('tool'),
              picture: doc.get('picture'),
              idPosition: doc.get('idPosition'),
              isManager: doc.get('isManager'),
              isClient: doc.get('isClient'),
              isDeliver: doc.get('isDeliver'),
              //createdAt: doc.get('createdAt')
              );
        }).toList();
        // return model;
      },
    );
  }




  ////////////////////////////////////////////////////////////////////////
  Future<Stream<List<UserModel>>> getDeliverss() async {
    // int x = 0;
    print("moguem souop audrey");
    return userCollection.where('isDeliver', isEqualTo: true).snapshots().map(
      (snapshot) {
        //  x = snapshot.docs.length;
        //  print('la longueur du snapshot est ${snapshot.docs.length}');
        /* try{
      if (snapshot.docs.isNotEmpty) {
         print('la longueur du snapshot est ${snapshot.docs.length}');  
      } } catch (e){print('erreur est le suivant $e');}*/
        return snapshot.docs.map((doc) {
          //  print('moguem souop${doc.runtimeType}');
          //print('mon adresse${doc.get('adress')}');
          return UserModel(
              //idUser: data['idUser'],
              idUser: doc.get('idUser'),
              adress: doc.get('adress'),
              name: doc.get('name'),
              phone: int.parse(doc.get('phone')),
              tool: doc.get('tool'),
              picture: doc.get('picture'),
              idPosition: doc.get('idPosition'),
              isManager: doc.get('isManager'),
              isClient: doc.get('isClient'),
              isDeliver: doc.get('isDeliver'),
              //createdAt: doc.get('createdAt')
              );
        }).toList();
        // return model;
      },
    );
  }


UploadTask uploadImageFile(File image, String fileName) {
 Reference reference = firebaseStorage.ref().child(fileName);
 UploadTask uploadTask = reference.putFile(image);
 return uploadTask;
}  

//retourner un utilisateur grace a son identifiant sous format de userModel correcte
  Future<UserModel> getUserbyId(String idUsersearch) async {
    print('identifianttttttttt $idUsersearch');
    //userCollection.doc(idUsersearch).get().then((value)=>print(value.data()));

    return  userCollection.where('idUser', isEqualTo: idUsersearch).get().then((value) {
    //  if (value.docs == null) throw Exception("user not found");
      if (value != null) {
        var res = value.docs.first.data();
        print('le premier resultat de la requete  $res');
        var resmap = Map<String, dynamic>.from(res);
       print('typereeeeeeeee varrrrrrrrrrr $resmap');
        return UserModel(
            //idUser: data['idUser'],
            idUser: resmap['idUser'],
            adress: resmap['adress'],
            name: resmap['name'],
            // phone: int.parse(resmap['phone']),
            phone: resmap['phone'],
            tool: resmap['tool'],
            picture: resmap['picture'],
            idPosition: resmap['idPosition'],
            isManager: resmap['isManager'],
            isClient: resmap['isClient'],
            isDeliver: resmap['isDeliver'],
           // createdAt:resmap['createdAt']
            );
      } else
      throw Exception("aucun utilisateur trouve dans la bd");
       // return null as UserModel;
    });
   
  }



  //get an user
/*   Future<UserModel> getUserbyId(String idUsersearch) async {
   // print(idUsersearch);
    //userCollection.doc(idUsersearch).get().then((value)=>print(value.data()));

    return  userCollection.doc(idUsersearch).get().then((value) {
      if (value != null) {
        var res = value.data();
        var resmap = Map<String, dynamic>.from(res!);
      //  print('type var ${resmap}');
        return UserModel(
            //idUser: data['idUser'],
            idUser: resmap['idUser'],
            adress: resmap['adress'],
            name: resmap['name'],
            phone: int.parse(resmap['phone']),
            tool: resmap['tool'],
            picture: resmap['picture'],
            idPosition: resmap['idPosition'],
            isManager: resmap['isManager'],
            isClient: resmap['isClient'],
            isDeliver: resmap['isDeliver']);
      } else
        return null as UserModel;
    });
    //print('samuel ${userCollection.doc(idUsersearch).get().then((value)=>print(value.data.data()))}');
  } */
  


//add an user correcte
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

  Future<void> removeUser(String idUser)  async {
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
  *
  //Get User by id

  Stream<UserModel> getUserbyId(String idUser) {
    return userCollection.doc(idUser).snapshots().map(_userFromSnapshot);
  }

  // get un livreur
  Stream getdeliver() {
    return userCollection.where('isDeliver', isEqualTo: true).snapshots();
  }


  Future<UserModel> getUserbyId(String idUsersearch)  async {
    return userCollection
        .doc(idUsersearch)
        .get()
        .then((snapshot) => UserModel.fromJson(snapshot.data()as Map<String, dynamic>));
  }

  Future<void> getUserbyId(String idUsersearch) async {
    return userCollection.doc(idUsersearch).get().then((snapshot) => snapshot);
  }

   //Get User by phone

  Future<QuerySnapshot<Map<String, dynamic>>> getUserbyPhone(int phone) {
    return userCollection.where('phone', isEqualTo: phone).get()
      ..then((snapshot) => snapshot.docs);
  }


  Stream<List<UserModel>> getposdelivers() {
    return userCollection.where('isDeliver', isEqualTo: true).snapshots().map(
        (snapshot) => snapshot.docs
            .map((doc) => UserModel.fromJson(doc.data()))
            .toList());
  }

*/

}
