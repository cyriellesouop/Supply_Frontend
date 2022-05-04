

// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:supply_app/components/home_screen.dart';
import 'package:supply_app/components/screen/manager/components/manager_home.dart';

/******************************************************************************************************************/
// class Position
class PositionModel {
  final String? idPosition;
  final double longitude;
  final double latitude;
 
  PositionModel(
      { this.idPosition,
       required this.longitude,
       required this.latitude
      });

  factory PositionModel.fromJson(Map<String, dynamic> json) {
    return PositionModel(
        idPosition: json['idPosition'],
        longitude:json['longitude'],
        latitude: json['latitude'],
        );
        
  }
  Map<String, dynamic> toMap() {
    return {
       'idPosition':idPosition,
        'longitude':longitude,
        'latitude': latitude,
    };
  }
}

/******************************************************************************************************************/
// class Command
class CommandModel {
  final String? idCommand;
  final String createdBy ;
  final String nameCommand;
  final String description;
  final String statut;
  final String state;
  final String? deliveredBy;
  final PositionModel startPoint;
  final PositionModel? endPoint;
  final DateTime updatedAt;
  final DateTime createAt;

 CommandModel(
      { this.idCommand,
       required this.createdBy,
       required this.nameCommand,
       required this.description,
       required this.statut,
       required this.state,
       this.deliveredBy,
       required this.startPoint,
       this.endPoint,
       required this.updatedAt,
       required this.createAt
      });

  factory CommandModel.fromJson(Map<String, dynamic> json) {
    return CommandModel(
       idCommand: json['idCommand'],
       createdBy:json['createdBy'],
       nameCommand: json['nameCommand'],
       description: json['description'],
       statut: json['statut'],
       state: json['state'],
       deliveredBy:json['deliveredBy'],
       startPoint: PositionModel.fromJson(json['startPoint']),
       endPoint: PositionModel.fromJson(json['endPoint']),
       updatedAt: json['updatedAt'],
       createAt: json['createAt']
 );
        
  }
  Map<String, dynamic> toMap() {
    return {
       'idCommand': idCommand,
       'createdBy':createdBy,
       'nameCommand':nameCommand,
       'description':description,
       'statut':statut,
       'state':state,
       'deliveredBy':deliveredBy,
       'startPoint':startPoint,
       'endPoint':endPoint,
       'updatedAt':updatedAt,
       'createAt':createAt
    };
  }
}


/******************************************************************************************************************/
// class User
class UserModel {
  final String? idUser;
  final String? adress;
  final String name;
  final int? phone;
  final String? tool;
  final String? picture;
  final PositionModel position;
 // final String idPosition;
  final bool isManager;
  final bool isClient;
  final bool isDeliver;

  UserModel(
      { this.idUser,
       this.adress,
       required this.name,
       this.phone,
       this.tool,
       this.picture,
       required this.position,
      // required this.idPosition,
       this.isManager=true,
       this.isClient=false,
       this.isDeliver=false});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
        idUser: json['idUser'],
        adress:json['adress'],
        name: json['name'],
        phone: json['phone'],
        tool: json['tool'],
        picture:json['picture'],
        position: PositionModel.fromJson(json['position']),
     //   idPosition: json['idPosition'],
        isManager: json['isManager'],
        isClient: json['isClient'],
        isDeliver: json['isDeliver']
        );
        
  }
  Map<String, dynamic> toMap() {
    return {
       'idUser':idUser,
        'adress':adress,
        'name': name,
        'phone': phone,
        'tool': tool,
        'picture':picture,
        'position': position,
        'isManager': isManager,
        'isClient': isClient,
        'isDeliver': isDeliver
    };
  }
}


/******************************************************************************************************************/
// class Chat
class ChatModel {


  final String? roomId;
  final String sendBy;
  final String message;
 
 ChatModel(
      { this.roomId,
       required this.sendBy,
       required this.message
      });

      /*constucteur d'usine utlisee pour modifier le type d'objet qui sera cree(format json) lorsqu'on instanciant la classe ChatModel
      gérera la réception des données de Firestore et la construction d'un objet Dart à partir des données.
       L'échange de Map à Json et vice-versa est géré .*/
  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
        roomId: json['roomId'],
        sendBy:json['sendBy'],
        message: json['message'],
        );      
  }
  //toMap() est chargée de renvoyer une carte lorsqu'elle est présentée avec un objet Dart
  Map<String, dynamic> toMap() {
    return {
       'roomId':roomId,
       'sendBy':sendBy,
       'message':message,
    };
  }
}




