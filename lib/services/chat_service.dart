import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/Database_Model.dart';

final FirebaseFirestore dbFirestore = FirebaseFirestore.instance;


class ChatService {
  CollectionReference<Map<String, dynamic>> chatCollection =
      FirebaseFirestore.instance.collection("rooms");

  ChatModel _chatFromSnapshot(DocumentSnapshot<Map<String, dynamic>> json) {
    var data = json.data();
    if (data == null) throw Exception("chat introuvable");
    return ChatModel(
      roomId: data['roomId'],
      uid: data['uid'],
      name: data['name'],
      message: data['message'],
      timestamp: data['timestamp']
    );
  }

  //Get room by id
  Stream<QuerySnapshot<Map<String, dynamic>>> getMessageFromRoom(String roomId) {
    return dbFirestore
        .collection("rooms")
        .doc(roomId)
        .collection('messages').orderBy('timestamp').snapshots();
  }

  // Set message to particular room

   Future<void> addMessageToRoom(String roomId, String username, String messageText, String userId) async {
     dbFirestore
         .collection("rooms")
         .doc(roomId)
         .collection('messages')
         .add({
       'uid': userId,
       'name': username,
       'message': messageText,
       'timestamp': FieldValue.serverTimestamp()
     });

    }

  //Upsert
  Future<void> setchat(ChatModel chat) async {
    var options = SetOptions(merge: true);
    return chatCollection.doc(chat.roomId).set(chat.toMap(), options);
  }

  //Delete
  Future<void> removechat(String roomId) {
    return chatCollection.doc(roomId).delete();
  }
}
