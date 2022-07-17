import 'dart:math';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService{
  static final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  static void initialize(){
    const InitializationSettings initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings("@mipmap/ic_launcher")
    );
    _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  static Future<void> onBackgroundMessage(RemoteMessage message) async{
    await Firebase.initializeApp();

    if(message.data.containsKey('data')){
      // Handle data message
      final data = message.data['data'];
    }

    if(message.data.containsKey('notification')){
      // Handle notification message
      final data = message.data['notification'];
    }
  }
  
  static void display(RemoteMessage message) async{
    try{
      print("In notification method");
      Random random = Random();
      int id = random.nextInt(1000);
      const NotificationDetails notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails(
          "high_importance_channel",
          "High Importance Notifications",
          importance: Importance.high,
          priority: Priority.max,
          playSound: true
        )
      );

      await _flutterLocalNotificationsPlugin.show(id, message.notification!.title, message.notification!.body, notificationDetails,);
    } on Exception catch (e){
      print("Error >>>>> $e");
    }
  }

  static void serialiseAndNavigate(Map<String, dynamic> message){
    var notificationData = message['data'];
    var view = notificationData['view'];

    if(view != null){
      // Navigate to the command details
      if(view == 'command_details'){

      }
    }
  }
}