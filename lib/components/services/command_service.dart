// ignore_for_file: non_constant_identifier_createdBys
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/Database_Model.dart';

class CommandService {
  CollectionReference<Map<String, dynamic>> CommandCollection =
      FirebaseFirestore.instance.collection("command");

  CommandModel _CommandFromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> json) {
    var data = json.data();
    if (data == null) throw Exception("commande introuvable");
    return CommandModel(
        idCommand: data['idCommand'],
        createdBy: data['createdBy'],
        nameCommand: data['nameCommand'],
        description: data['description'],
        statut: data['statut'],
        state: data['idPosition'],
        deliveredBy: data['deliveredBy'],
        startPoint: data['startPoint'],
        endPoint: data['endPoint'],
        updatedAt: data['updatedAt'],
        createAt: data['createAt']);
  }
/* 
  //Get Commands
  Stream<List<CommandModel>> getCommands() {
    return CommandCollection.snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => CommandModel.fromJson(doc.data())).toList());
  } */

  // add a command

  /* Future addCommand(CommandModel Command) async {
  //  var documentRef = 
    await CommandCollection.add(Command.toMap());
   /*  var createdId = documentRef.id;
    CommandCollection.doc(documentRef.id).update(
      {'idCommand': createdId}, 
    ); 

   return documentRef.id;*/
  } */

 /*  //Upsert
  Future<void> setCommand(CommandModel Command) async {
    var options = SetOptions(merge: true);
    return CommandCollection.doc(Command.idCommand)
        .set(Command.toMap(), options);
  } */

  //Delete
  Future<void> removeCommand(String idCommand) {
    return CommandCollection.doc(idCommand).delete();
  }


  //ajouter une commande
  Future<String> addCommand(CommandModel Command) async { 
    var documentRef = await  CommandCollection.add(Command.toMap());
    var createdId = documentRef.id;
    CommandCollection.doc(createdId).update(
      {'idCommand': createdId},
    );

    return documentRef.id;
  }
  //liste de command d'un gerant
  Stream<List<CommandModel>> getCommandsManager(String ManagercreatedBy) {
    print("liste de commande");
    return CommandCollection.where('createdBy', isEqualTo: 'ManagercreatedBy')
        .snapshots()
        .map(
      (snapshot) {
        return snapshot.docs.map((doc) {
          return CommandModel(
              idCommand: doc.get('idCommand'),
              createdBy: doc.get('createdBy'),
              nameCommand: doc.get('nameCommand'),
              description: doc.get('description'),
              statut: doc.get('statut'),
              state: doc.get('state'),
              deliveredBy: doc.get('deliveredBy'),
              startPoint: doc.get('startPoint'),
              endPoint: doc.get('endPoint'),
              updatedAt: doc.get('updatedAt'),
              createAt: doc.get('createAt'));
        }).toList();
      },
    );
  }

  //get command period
  Stream<List<CommandModel>> getCommandsDate(
      String ManagercreatedBy, String Debut, String Fin) {
    print("liste de commande");
    return CommandCollection.where('createdBy', isEqualTo: 'ManagercreatedBy')
        .where('createAt', isLessThanOrEqualTo: 'Fin')
        .where('createAt', isGreaterThanOrEqualTo: 'Debut')
        .snapshots()
        .map(
      (snapshot) {
        return snapshot.docs.map((doc) {
          return CommandModel(
              idCommand: doc.get('idCommand'),
              createdBy: doc.get('createdBy'),
              nameCommand: doc.get('nameCommand'),
              description: doc.get('description'),
              statut: doc.get('statut'),
              state: doc.get('state'),
              deliveredBy: doc.get('deliveredBy'),
              startPoint: doc.get('startPoint'),
              endPoint: doc.get('endPoint'),
              updatedAt: doc.get('updatedAt'),
              createAt: doc.get('createAt'));
        }).toList();
      },
    );
  }

//Get command by ID
  Future<CommandModel> getCommand(String? idPosition) async {
    return CommandCollection.doc(idPosition).get().then((value) {
      if (value.data() != null) {
        //  var res = value.data();
        var resmap = Map<String, dynamic>.from(value.data()!);
        //  print('type var ${resmap}');
        return CommandModel(
            idCommand: resmap['idCommand'],
            createdBy: resmap['createdBy'],
            nameCommand: resmap['nameCommand'],
            description: resmap['description'],
            statut: resmap['statut'],
            state: resmap['state'],
            deliveredBy: resmap['deliveredBy'],
            startPoint: resmap['startPoint'],
            endPoint: resmap['endPoint'],
            updatedAt: resmap['updatedAt'],
            createAt: resmap['createAt']);
      } else
        throw Exception("aucune position se trouve dans la bd");
      //return null as PositionModel;
    });
  }
}
