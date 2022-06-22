// ignore_for_file: non_constant_identifier_createdBys
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/Database_Model.dart';

class CommandService {
  CollectionReference<Map<String, dynamic>> CommandCollection =
      FirebaseFirestore.instance.collection("command");

/*   CommandModel _CommandFromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> json) {
    var data = json.data();
    if (data == null) throw Exception("commande introuvable");
    return CommandModel(
        idCommand: data['idCommand'],
        createdBy: data['createdBy'],
        nameCommand: data['nameCommand'],
        description: data['description'],
        poids: data['poids'],
        statut: data['statut'],
        state: data['idPosition'],
        deliveredBy: data['deliveredBy'],
        startPoint: data['startPoint'],
        endPoint: data['endPoint'],
        updatedAt: data['updatedAt'],
        createdAt: data['createdAt']);
  } */
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

        final 
  {String? idCommand,
      String? description,
      String nameCommand
      String? poids,
      String? statut,
      String? deliveredBy}
  } */

  //Delete
  Future<void> removeCommand(String? idCommand) {
    print(
        'supressionnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnn');
    return CommandCollection.doc(idCommand).delete();
  }

  Future<void> updateCommand(CommandModel Command) async {
    print(
        'supressionnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnn');
    return CommandCollection.doc(Command.idCommand).set({
      'nameCommand': Command.nameCommand,
      'description': Command.description,
      'poids': Command.poids,
      'statut': Command.statut,
      'state': Command.state,
      'updatedAt': Command.updatedAt,
    }, SetOptions(merge: true));
  }

  //ajouter une commande
  Future<String> addCommand(CommandModel Command) async {
    print(
        "pppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppp");

    var documentRef = await CommandCollection.add({
      //  'idDoc': userCollection.doc(),
      // 'idCommand': Command.idCommand,
      'createdBy': Command.createdBy,
      'nameCommand': Command.nameCommand,
      'description': Command.description,
      'poids': Command.poids,
      'statut': Command.statut,
      'state': Command.state,
      'deliveredBy': Command.deliveredBy,
      'startPoint': Command.startPoint,
      'endPoint': Command.endPoint,
      'updatedAt': Command.updatedAt,
      'createdAt': Command.createdAt,
      
    });
    var createdId = documentRef.id;

    CommandCollection.doc(createdId).update(
      {'idCommand': createdId},
    );

    return documentRef.id;

    /*   print("commande de Madame Moguem souop ");
    var documentRef = await CommandCollection.add(Command.toMap());
    var createdId = documentRef.id;
    CommandCollection.doc(createdId).update(
      {'idCommand': createdId},
    );

    return documentRef.id; */
  }

  //liste de command d'un gerant
  Stream<List<CommandModel>> getCommandsManager(String ManagercreatedBy) {
    print(
        'historiqueeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee');

    return CommandCollection.where('createdBy', isEqualTo: ManagercreatedBy)
        .snapshots()
        .map(
      (snapshot) {
        return snapshot.docs.map((doc) {
          print("liste de commande");
          return CommandModel(
              idCommand: doc.get('idCommand'),
              createdBy: doc.get('createdBy'),
              nameCommand: doc.get('nameCommand'),
              description: doc.get('description'),
              poids: doc.get('poids'),
              statut: doc.get('statut'),
              state: doc.get('state'),
              deliveredBy: doc.get('deliveredBy'),
              startPoint: doc.get('startPoint'),
              endPoint: doc.get('endPoint'),
              updatedAt: doc.get('updatedAt'),
              createdAt: doc.get('createdAt'));
        }).toList();
      },
    );
  }

  //-------------------------------------------------------------------------------------------------------------------
//liste de command d'un gerant
  Stream<List<CommandModel>> getCommandsManagerstatut(String ManagercreatedBy,String statut) {
    print(
        'ggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggge');

    return CommandCollection.where('createdBy', isEqualTo: ManagercreatedBy).where('statut', isEqualTo: statut)
        .snapshots()
        .map(
      (snapshot) {
        return snapshot.docs.map((doc) {
          print("liste de commande");
          return CommandModel(
              idCommand: doc.get('idCommand'),
              createdBy: doc.get('createdBy'),
              nameCommand: doc.get('nameCommand'),
              description: doc.get('description'),
              poids: doc.get('poids'),
              statut: doc.get('statut'),
              state: doc.get('state'),
              deliveredBy: doc.get('deliveredBy'),
              startPoint: doc.get('startPoint'),
              endPoint: doc.get('endPoint'),
              updatedAt: doc.get('updatedAt'),
              createdAt: doc.get('createdAt'));
        }).toList();
      },
    );
  }






  //get command period
  Stream<List<CommandModel>> getCommandsDate(
      String ManagercreatedBy, String Debut, String Fin) {
    print("liste de commande");
    return CommandCollection.where('createdBy', isEqualTo: 'ManagercreatedBy')
        .where('createdAt', isLessThanOrEqualTo: 'Fin')
        .where('createdAt', isGreaterThanOrEqualTo: 'Debut')
        .snapshots()
        .map(
      (snapshot) {
        return snapshot.docs.map((doc) {
          return CommandModel(
              idCommand: doc.get('idCommand'),
              createdBy: doc.get('createdBy'),
              nameCommand: doc.get('nameCommand'),
              description: doc.get('description'),
              poids: doc.get('poids'),
              statut: doc.get('statut'),
              state: doc.get('state'),
              deliveredBy: doc.get('deliveredBy'),
              startPoint: doc.get('startPoint'),
              endPoint: doc.get('endPoint'),
              updatedAt: doc.get('updatedAt'),
              createdAt: doc.get('createdAt'));
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
            poids: resmap['poids'],
            statut: resmap['statut'],
            state: resmap['state'],
            deliveredBy: resmap['deliveredBy'],
            startPoint: resmap['startPoint'],
            endPoint: resmap['endPoint'],
            updatedAt: resmap['updatedAt'],
            createdAt: resmap['createdAt']);
      } else
        throw Exception("aucune position se trouve dans la bd");
      //return null as PositionModel;
    });
  }
}
