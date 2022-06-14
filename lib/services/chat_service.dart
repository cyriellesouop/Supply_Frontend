import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/Database_Model.dart';

class ChatService {
  CollectionReference<Map<String, dynamic>> chatCollection =
      FirebaseFirestore.instance.collection("chat");

  ChatModel _chatFromSnapshot(DocumentSnapshot<Map<String, dynamic>> json) {
    var data = json.data();
    if (data == null) throw Exception("chat introuvable");
    return ChatModel(
      
      roomId: data['roomId'],
      sendBy: data['sendBy'],
      message: data['message'],
    );
  }

  //Get chats
  Stream<List<ChatModel>> getchats() {
    return chatCollection.snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => ChatModel.fromJson(doc.data())).toList());
  }

  //Get chat by id
  Stream<ChatModel> getchat(String roomId) {
    return chatCollection.doc(roomId).snapshots().map(_chatFromSnapshot);
  }

   Future<String> addchat(ChatModel chat) async {
      var documentRef = await chatCollection.add(chat.toMap());
      var createdId = documentRef.id;
      chatCollection.doc(createdId).update(
        {'roomId': createdId},
      );

      return documentRef.id;

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
