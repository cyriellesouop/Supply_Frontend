// ignore_for_file: non_constant_identifier_names

class AppUser {
  final String uid;

  AppUser({required this.uid});
  //-------------
  /*String get userId {
    return uid;
    //-----------------
  }*/

}

/******************************************************************************************************************/
// class Position
class PositionModel {
  final String? idPosition;
  final double longitude;
  final double latitude;

  PositionModel(
      {this.idPosition, required this.longitude, required this.latitude});

  factory PositionModel.fromJson(Map<String, dynamic> json) {
    return PositionModel(
      idPosition: json['idPosition'],
      longitude: json['longitude'],
      latitude: json['latitude'],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'idPosition': idPosition,
      'longitude': longitude,
      'latitude': latitude,
    };
  }
}

/******************************************************************************************************************/
// class Command
class CommandModel {
  final String? idCommand;
  final String createdBy;
  final String nameCommand;
  final String description;
  final String poids;
  final String statut;
  final String state;
  final String? deliveredBy;
  final PositionModel startPoint;
  final PositionModel? endPoint;
  final  String? updatedAt;
  final  String createAt;

  CommandModel(
      {this.idCommand,
      required this.createdBy,
      required this.nameCommand,
      required this.description,
      required this.poids,
      required this.statut,
      required this.state,
      this.deliveredBy,
      required this.startPoint,
      this.endPoint,
       this.updatedAt,
      required this.createAt});

  factory CommandModel.fromJson(Map<String, dynamic> json) {
    return CommandModel(
        idCommand: json['idCommand'],
        createdBy: json['createdBy'],
        nameCommand: json['nameCommand'],
        description: json['description'],
        poids: json['poids'],
        statut: json['statut'],
        state: json['state'],
        deliveredBy: json['deliveredBy'],
        startPoint: PositionModel.fromJson(json['startPoint']),
        endPoint: PositionModel.fromJson(json['endPoint']),
        updatedAt: json['updatedAt'],
        createAt: json['createAt']);
  }
  Map<String, dynamic> toMap() {
    return {
      'idCommand': idCommand,
      'createdBy': createdBy,
      'nameCommand': nameCommand,
      'description': description,
      'poids':poids,
      'statut': statut,
      'state': state,
      'deliveredBy': deliveredBy,
      'startPoint': startPoint,
      'endPoint': endPoint,
      'updatedAt': updatedAt,
      'createAt': createAt
    };
  }

  @override
  String toString() {
    // TODO: implement toString
    return this.createdBy;
  }
}

/******************************************************************************************************************/
// class User
class UserModel {
  String? idDoc;
  String? idUser;
  String? adress;
  String name;
  int? phone;
  String? tool;
  String? picture;
  // final PositionModel position;
  String? idPosition;
  bool isManager;
  bool isClient;
  bool isDeliver;
  String? createdAt;

  UserModel({
    this.idDoc,
    this.idUser,
    this.adress,
    required this.name,
    this.phone,
    this.tool,
    this.picture,
    //this.position,
    this.idPosition,
    this.isManager = true,
    this.isClient = false,
    this.isDeliver = false,
    this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
        idDoc: json['idDoc'],
        idUser: json['idUser'],
        adress: json['adress'],
        name: json['name'],
        phone: json['phone'],
        tool: json['tool'],
        picture: json['picture'],
        // position: PositionModel.fromJson(json['position']),
        idPosition: json['idPosition'],
        isManager: json['isManager'],
        isClient: json['isClient'],
        isDeliver: json['isDeliver'],
        createdAt: json['createdAt']);
  }
  Map<String, dynamic> toMap() {
    return {
     // 'idDoc': id,
      'idUser': idUser,
      'adress': adress,
      'name': name,
      'phone': phone,
      'tool': tool,
      'picture': picture,
      'idPosition': idPosition,
      'isManager': isManager,
      'isClient': isClient,
      'isDeliver': isDeliver,
      'createdAt': createdAt
    };
  }

  @override
  String toString() {
    // '{id: $id, name: $name}';
    // TODO: implement toString
    return '{idUser:${this.idUser}, adress:${this.adress}, name:${this.name}, phone:${this.phone}, picture:${this.picture}, tool:${this.tool}, idPosition:${this.idPosition}, isDeliver:${this.isDeliver}, isManager:${this.isManager}, isClient:${this.isClient}}';
  }
}

/******************************************************************************************************************/
// class Chat
class ChatModel {
  final String? roomId;
  final String sendBy;
  final String message;

  ChatModel({this.roomId, required this.sendBy, required this.message});

  /*constucteur d'usine utlisee pour modifier le type d'objet qui sera cree(format json) lorsqu'on instanciant la classe ChatModel
      gérera la réception des données de Firestore et la construction d'un objet Dart à partir des données.
       L'échange de Map à Json et vice-versa est géré .*/
  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      roomId: json['roomId'],
      sendBy: json['sendBy'],
      message: json['message'],
    );
  }
  //toMap() est chargée de renvoyer une carte lorsqu'elle est présentée avec un objet Dart
  Map<String, dynamic> toMap() {
    return {
      'roomId': roomId,
      'sendBy': sendBy,
      'message': message,
    };
  }
}
