import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/Database_Model.dart';

class UserService {
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
              //  idDoc:doc.id ,
              idDoc:doc.get('idDoc'),
              idUser: doc.get('idUser'),
              adress: doc.get('adress'),
              name: doc.get('name'),
              phone: doc.get('phone'),
              tool: doc.get('tool'),
              picture: doc.get('picture'),
              idPosition: doc.get('idPosition'),
              isManager: doc.get('isManager'),
              isClient: doc.get('isClient'),
              isDeliver: doc.get('isDeliver'),
              token: doc.get('token')
              // createdAt: doc.get('createdAt')
              );
        }).toList();
        // return model;
      },
    );
  }

//liste de livreurs correcte

  Stream<List<UserModel>> getDelivers() {
    print("moguem souop audrey");
    return userCollection.where('isDeliver', isEqualTo: true).snapshots().map(
      (snapshot) {
        return snapshot.docs.map((doc) {
          return UserModel(

             idDoc:doc.get('idDoc'),
              idUser: doc.get('idUser'),
              // adress: doc.get('adress'),
              name: doc.get('name'),
               phone:doc.get('phone'),
              tool: doc.get('tool'),
              picture: doc.get('picture'),
              idPosition: doc.get('idPosition'),
              isManager: doc.get('isManager'),
              isClient: doc.get('isClient'),
              isDeliver: doc.get('isDeliver'),
              token: doc.get('token')
              // createdAt: doc.get('createdAt')
              );
        }).toList();
        // return model;
      },
    );
  }

  //s

  //liste des managers correctes
  Stream<List<UserModel>> getManagers() {
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
              idDoc:doc.get('idDoc'),
              idUser: doc.get('idUser'),
              adress: doc.get('adress'),
              name: doc.get('name'),
              phone: doc.get('phone'),
              tool: doc.get('tool'),
              picture: doc.get('picture'),
              idPosition: doc.get('idPosition'),
              isManager: doc.get('isManager'),
              isClient: doc.get('isClient'),
              isDeliver: doc.get('isDeliver'),
              token: doc.get('token')
              //createdAt: doc.get('createdAt')
              );
        }).toList();
        // return model;
      },
    );
  }

//liste de tous les utilisateurs 
  Stream<List<UserModel>> getAlluser() {

    print("tous les livreurs");
    return userCollection.snapshots().map(
      (snapshot) {
        return snapshot.docs.map((doc) {
          return UserModel(
           idDoc:doc.get('idDoc'),
            idUser: doc.get('idUser'),
            adress: doc.get('adress'),
            name: doc.get('name'),
            phone: doc.get('phone'),
            tool: doc.get('tool'),
            picture: doc.get('picture'),
            idPosition: doc.get('idPosition'),
            isManager: doc.get('isManager'),
            isClient: doc.get('isClient'),
            isDeliver: doc.get('isDeliver'),
            token: doc.get('token')
            //createdAt: doc.get('createdAt')
          );
        }).toList();
      },
    );
  }


//recuperer la photo d'un user

  Future<void> updateUser(UserModel user, String id) async {
    userCollection.doc(id).set(
      {
        'adress': user.adress,
        'name': user.name,
        'phone': user.phone,
        'picture': user.picture,
        'idPosition': user.idPosition,
        'token':user.token,
        'idUser':user.idUser
      }, SetOptions(merge: true)
    );
  }



  Future<void> setToken(String uid, token) async{
    userCollection
        .doc(uid)
        .set({'tokenNotification': token}, SetOptions(merge: true));
  }

/*   A tester
  Future<void> updateUserData(String idUser, String name, int phone,
      String picture, String adress, String idPosition) {
    DocumentReference<Map<String, dynamic>> idkey = userCollection.doc();
    String id = idkey.id;
    return userCollection.doc(id).set({
      'idDoc': id,
      'idUser': idUser,
      
      'adress': adress,
      'name': name,
      'phone': phone,
      'picture': picture,
      'idPosition': idPosition,
    });
  } */

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
              idDoc:doc.get('idDoc'),
              idUser: doc.get('idUser'),
              adress: doc.get('adress'),
              name: doc.get('name'),
              phone: doc.get('phone'),
              tool: doc.get('tool'),
              picture: doc.get('picture'),
              idPosition: doc.get('idPosition'),
              isManager: doc.get('isManager'),
              isClient: doc.get('isClient'),
              isDeliver: doc.get('isDeliver'),
              token: doc.get('token')
              //createdAt: doc.get('createdAt')
              );
        }).toList();
        // return model;
      },
    );
  }

//retourner un utilisateur grace a son identifiant sous format de userModel correcte
  Future<UserModel> getUserbyId(String idUsersearch) async {
    print('identifianttttttttt $idUsersearch');
    //userCollection.doc(idUsersearch).get().then((value)=>print(value.data()));

    return userCollection
        .where('idUser', isEqualTo: idUsersearch)
        .get()
        .then((value) {
      //  if (value.docs == null) throw Exception("user not found");
      if (value != null) {
        var res = value.docs.first.data();
        print('le premier resultat de la requete  $res');
        var resmap = Map<String, dynamic>.from(res);
        print('typereeeeeeeee varrrrrrrrrrr $resmap');
        return UserModel(
          //idUser: data['idUser'],
          idDoc: resmap['idDoc'],
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
          token: resmap['token'],
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
  Future<String> addUser(UserModel user) async {
    // DocumentReference<Map<String, dynamic>> idkey = userCollection.doc();
    /*  DocumentReference idkey = userCollection.doc();
    String id = idkey.id; */

    // await userCollection.add(user.toMap());

    var documentRef = await userCollection.add({
      //  'idDoc': userCollection.doc(),
      'idUser': user.idUser,
      'adress': user.adress,
      'name': user.name,
      'phone': user.phone,
      'tool': user.tool,
      'picture': user.picture,
      'idPosition': user.idPosition,
      'isManager': user.isManager,
      'isClient': user.isClient,
      'isDeliver': user.isDeliver,
      'createdAt': user.createdAt,
      'token': user.token
    });
    var createdId = documentRef.id;

    userCollection.doc(createdId).update(
      {'idDoc': createdId},
    );

    return documentRef.id;
  }

//fonction de mise a jour du numero de telephone
  Future<void> updatePhoneuser(String userId, String userphone) async {
    userCollection.doc(userId).update(
      {'phone': userphone},
    );
  }
  //supprimer un utilisateur de la base de donnee

  Future<void> removeUser(String idUser) async {
    return userCollection
        .doc(idUser)
        .delete()
        .then((value) => print("User Deleted"))
        .catchError((error) => print("Failed to delete user: $error"));
  }

/*



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

*/

}
