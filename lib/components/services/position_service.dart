// ignore_for_file: non_constant_identifier_names
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:supply_app/components/services/user_service.dart';
import '../models/Database_Model.dart';

class PositionService {
  CollectionReference<Map<String, dynamic>> PositionCollection =
      FirebaseFirestore.instance.collection("position");
  late UserService user;

  /* PositionModel _PositionFromSnapshot(DocumentSnapshot<Map<String, dynamic>> json) {
    var data = json.data();
    if (data == null) throw Exception("Position introuvable");
    return PositionModel(
      //idPosition: data['idPosition'],
      idPosition: data['idPosition'],
      longitude: data['longitude'],
      latitude: data['latitude'],
    );
  }*/
  //Get all Positions
  Stream<List<PositionModel>> getPositions() {
    return PositionCollection.snapshots().map(
      (snapshot) {
        return snapshot.docs.map((doc) {
          return PositionModel(
              //idUser: data['idUser'],
              idPosition: doc.get('idPosition'),
              longitude: doc.get('longitude'),
              latitude: doc.get('latitude'));
        }).toList();
      },
    );
  }

  //Get Position by ID
  Future<PositionModel> getPosition(String? idPosition) async {
    return PositionCollection.doc(idPosition).get().then((value) {
      if (value.data() != null) {
        //  var res = value.data();
        var resmap = Map<String, dynamic>.from(value.data()!);
        //  print('type var ${resmap}');
        return PositionModel(
            //idUser: data['idUser'],
            idPosition: resmap['idPosition'],
            longitude: resmap['longitude'],
            latitude: resmap['latitude']);
      } else
        throw Exception("aucune position se trouve dans la bd");
      //return null as PositionModel;
    });
  }

  //Update an position and insert if not exits
  Future<void> setPosition(PositionModel Position) async {
    var options = SetOptions(merge: true);
    return PositionCollection.doc(Position.idPosition)
        .set(Position.toMap(), options);
  }

  // add a position

  Future<String> addPosition(PositionModel Position) async {
    var documentRef = await PositionCollection.add(Position.toMap());
    var createdId = documentRef.id;
    PositionCollection.doc(createdId).update(
      {'idPosition': createdId},
    );

    return documentRef.id;
  }

  //Delete
  Future<void> removePosition(String idPosition) {
    return PositionCollection.doc(idPosition).delete();
  }
}
