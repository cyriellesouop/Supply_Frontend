
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:supply_app/services/chat_service.dart';
import './constants.dart';
import 'package:intl/intl.dart';
import 'package:supply_app/models/Database_Model.dart';



// final _firestore = Firestore.instance;
final FirebaseFirestore _firestore = FirebaseFirestore.instance;
String username = 'User';
String userId = 'user@123';
String messageText = '';
ChatService chatService = ChatService();
ChatModel chatModel = ChatModel(roomId: 'r9hOIhF4qhKnpWmqB2RL', uid: '', name: 'User', message: '', timestamp: '');


class ChatterScreen extends StatefulWidget {
  const ChatterScreen({Key? key}) : super(key: key);

  @override
  _ChatterScreenState createState() => _ChatterScreenState();

}

class _ChatterScreenState extends State<ChatterScreen> {
  final chatMsgTextController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  @override
  void initState() {
    super.initState();
    getCurrentUser();
    // getMessages();
  }

  void getCurrentUser() async {
    try {
      // final user = await _auth.currentUser();
      /*if (user != null) {
        loggedInUser = user;

      }*/
     /* setState(() {
        username = "Nakeva";
        userId = "nakeva@gmail.com";
      });*/
      chatModel.name = "Entreprise";
      chatModel.uid = "entreprise@gmail.com";
    } catch (e) {
      Fluttertoast.showToast(
          msg: "Une erreur est survenue",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 5,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.pink),
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size(25, 10),
          child: Container(
            decoration: const BoxDecoration(
                // color: Colors.blue,

                // borderRadius: BorderRadius.circular(20)
                ),
            constraints: const BoxConstraints.expand(height: 1),
            child: LinearProgressIndicator(
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
              backgroundColor: Colors.pink[100],
            ),
          ),
        ),
        backgroundColor: Colors.white10,
        // leading: Padding(
        //   padding: const EdgeInsets.all(12.0),
        //   child: CircleAvatar(backgroundImage: NetworkImage('https://cdn.clipart.email/93ce84c4f719bd9a234fb92ab331bec4_frisco-specialty-clinic-vail-health_480-480.png'),),
        // ),
        title: Row(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                /*Text(
                  'Commande 1',
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),*/
                TyperAnimatedTextKit(
                  isRepeatingAnimation: false,
                  speed:const Duration(milliseconds: 60),
                  text:["Commande 1".toUpperCase()],
                  textStyle: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                const Text('Livraison',
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 8,
                        color: Colors.pink))
              ],
            ),
          ],
        ),
      ),

      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const ChatStream(),
          Container(
            padding: const EdgeInsets.symmetric(vertical:10,horizontal: 10),
            decoration: kMessageContainerDecoration,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Material(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.white,
                    elevation:5,
                    child: Padding(
                      padding: const EdgeInsets.only(left:8.0,top:2,bottom: 2),
                      child: TextField(
                        onChanged: (value) {
                          // messageText = value;
                          chatModel.message = value;
                        },
                        controller: chatMsgTextController,
                        decoration: kMessageTextFieldDecoration,
                      ),
                    ),
                  ),
                ),
                MaterialButton(
                  shape: const CircleBorder(),
                  color: Colors.pink,
                  onPressed: () {
                    chatMsgTextController.clear();
                    chatService.addMessageToRoom(chatModel.roomId, chatModel.name, chatModel.message, chatModel.uid);
                  },
                  child:const Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Icon(Icons.send,color: Colors.white,),
                  ) 
                  // Text(
                  //   'Send',
                  //   style: kSendButtonTextStyle,
                  // ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ChatStream extends StatelessWidget {
  const ChatStream({Key? key}) : super(key: key);


  DateTime timeSource(message){
    return message.timestamp?.toDate();
  }

  String convertToDateTime(String preConverted){
    if(preConverted.length>42){
      final int seconds = int.parse(preConverted.substring(18, 28));
      final int nanoseconds =  int.parse(preConverted.substring(42, preConverted.lastIndexOf(')')));
      final Timestamp postConverted = Timestamp(seconds, nanoseconds);
      final DateTime dateTime = postConverted.toDate();
      return dateTime.toString();
    }
    return "";
  }
  String showDate(String dateTime)  {
    String teal;
    if(dateTime.length>16){
      if (dateTime.substring(0, 10) ==
          DateTime.now().toString().substring(0, 10)) {
        teal = dateTime.substring(11, 16);
      } else {
        teal = dateTime.substring(0, 10);
      }

      return teal;
    }

    return "";

  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: chatService.getMessageFromRoom('r9hOIhF4qhKnpWmqB2RL'),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          final List<QueryDocumentSnapshot<Object?>>? messages = snapshot.data?.docs;
          List<MessageBubble> messageWidgets = [];
          for (var message in messages!) {
            final msgText = message['message'];
            final msgSender = message['name'];

            final String msgTimestamp = showDate(convertToDateTime(message['timestamp'].toString()));

            // final msgSenderEmail = message.data['senderemail'];
            // final currentUser = loggedInUser.displayName;
            const currentUser = "Entreprise";

            // print('MSG'+msgSender + '  CURR'+currentUser);
            final msgBubble = MessageBubble(
                msgText: msgText,
                msgSender: msgSender,
                msgTimestamp: msgTimestamp,
                user: currentUser == msgSender);
            messageWidgets.add(msgBubble);
          }
          return Expanded(
            child: ListView(
              reverse: false,
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              children: messageWidgets,
            ),
          );
        } else {
          return const Center(
            child:
                CircularProgressIndicator(backgroundColor: Colors.pinkAccent),
          );
        }
      },
    );
  }
}

class MessageBubble extends StatelessWidget {
  final String msgText;
  final String msgSender;
  final String msgTimestamp;
  final bool user;
  MessageBubble({required this.msgText, required this.msgSender, required this.msgTimestamp, required this.user});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment:
            user ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              msgSender,
              style: const TextStyle(
                  fontSize: 13, fontFamily: 'Poppins', color: Colors.black87),
            ),
          ),
          Material(
            borderRadius: BorderRadius.only(
              bottomLeft: const Radius.circular(50),
              topLeft: user ? const Radius.circular(50) : const Radius.circular(0),
              bottomRight: const Radius.circular(50),
              topRight: user ? const Radius.circular(0) : const Radius.circular(50),
            ),
            color: user ? Colors.pinkAccent : Colors.white,
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Text(
                msgText,
                style: TextStyle(
                  color: user ? Colors.white : Colors.pink,
                  fontFamily: 'Poppins',
                  fontSize: 15,
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
             /* DateFormat('dd MMM kk:mm')
                  .format(DateTime.fromMillisecondsSinceEpoch(int.parse(msgTimestamp.toString(), radix: 16))),
              */
              msgTimestamp,
              style: const TextStyle(
                  fontSize: 13, fontFamily: 'Poppins', color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}
