// ignore_for_file: non_constant_identifier_names

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

  //Get Commands
  Stream<List<CommandModel>> getCommands() {
    return CommandCollection.snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => CommandModel.fromJson(doc.data())).toList());
  }

  //get Command by ID

  Stream<CommandModel> getCommand(String idCommand) {
    return CommandCollection.doc(idCommand)
        .snapshots()
        .map(_CommandFromSnapshot);
  }


  // add a command

   Future<String> addCommand(CommandModel Command) async {
      var documentRef = await CommandCollection.add(Command.toMap());
      var createdId = documentRef.id;
      CommandCollection.doc(createdId).update(
        {'idCommand': createdId},
      );

      return documentRef.id;

    }

  //Upsert
  Future<void> setCommand(CommandModel Command) async {
    var options = SetOptions(merge: true);
    return CommandCollection.doc(Command.idCommand)
        .set(Command.toMap(), options);
  }

  //Delete
  Future<void> removeCommand(String idCommand) {
    return CommandCollection.doc(idCommand).delete();
  }
}
