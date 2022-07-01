import 'dart:convert';
import 'dart:core';
import 'dart:core';
import 'dart:ui';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geocoding/geocoding.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:supply_app/common/constants.dart';
import 'package:supply_app/common/palette.dart';
import 'package:supply_app/main.dart';
import 'package:supply_app/models/Database_Model.dart';
import 'package:supply_app/screen/manager/components/mySearch.dart';
import 'package:supply_app/services/command_service.dart';
import 'package:http/http.dart' as http;
import 'package:supply_app/services/user_service.dart';

import '../../../services/position_service.dart';
import '../menu_content/nav_bar.dart';
import '../tri_rapide.dart';

class ManagerHome extends StatefulWidget {
  //UserModel currentManager;
  String currentManagerID;
  ManagerHome({required this.currentManagerID, Key? key}) : super(key: key);

  String get ID {
    return this.currentManagerID;
  }

  void set ID(String managerID) {
    this.currentManagerID = managerID;
  }

  @override
  _ManagerHomeState createState() => _ManagerHomeState();
}

class _ManagerHomeState extends State<ManagerHome> {
  // initialisation du manager courant
  UserModel currentManager = new UserModel(name: 'fabiol', idDoc: 'audrey',idPosition: "");
  //var Deliver = Map<UserModel, double>();
  // var deliver = null;
  bool isdeliver = false;
  var hauteur, hauteur2;
  var taille = 0;
  var idDoc;
  var distance = [];
  var dist = 0.0;

  var NotificationCounter;

  bool isDev = false;
//pour le appBar
  bool isSearching = false;
  var deliver = UserModel(name: 'audrey', idDoc: 'audrey',idPosition: "").toMap();
  // var Dev = UserModel(name: 'audrey', idDoc: 'audrey');
  Map<String, dynamic> tab = {
    'Deliver': UserModel(name: 'audrey', idDoc: 'audrey',idPosition: "").toMap(),
    'Distance': 0
  };

  CollectionReference<Map<String, dynamic>> userCollection =
      FirebaseFirestore.instance.collection("user");

  List<Map<String, dynamic>> tableauJson = [];
  List<Map<String, dynamic>> tableauJsontrie = [];

  List<UserModel> DeliverSort = [];

  //  LatLng startLocation = LatLng(latCurrentManager,longCurrentManager);

  GoogleMapController? mapController; //controller pour Google map
  PolylinePoints polylinePoints = PolylinePoints();

  String googleAPiKey =
      "AIzaSyDMvPHsbM0l51gW4shfWTHMUD-8Df-2UKU"; //"AIzaSyDma7ThRPGokuU_cJ2Q_qFvowIpK35RAPs"; //google api
  //Marker est un tableau qui contient toutes les positions representees sur la map

  final Set<Marker> markers = {}; //markers for google map
  // Map<PolylineId, Polyline> polylines = {}; //polylines to show direction

  UserModel? exampleModel = new UserModel(name: 'fabiol', idDoc: 'audrey',idPosition: "");

  UserService ServiceUser = UserService();
  PositionService ServicePosition = PositionService();
  //PositionModel x = new PositionModel(longitude: 0, latitude: 0);
  LatLng currentManagerPosition = new LatLng(0, 0);
  PositionModel myPosition =
      new PositionModel(idPosition: '', longitude: 0, latitude: 0);
  LatLng ydeliver = new LatLng(0, 0);

  //tableau des identifiants des position de tous les livreurs
  List<UserModel> exampleModelDeliver = [];
  //liste des positions de tous les livreurs
  List<LatLng> listecoordonnees = [];
  List<double> Distances = [];
  List<double> DistanceInter = [];

  @override
  void initState() {
    getUserPosition();
    //requestPermission();
    //loadFCM();
    //listenFCM();
    listenOpenFCM();
    //   storedNotificationToken();
    // display();
    //  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackground);
    //  getDirections(); //fetch direction polylines from Google API/Draw polyline direction routes in Google Map
    super.initState();
  }

/*   Future<void> _firebaseMessagingBackground(RemoteMessage message) async {
    await Firebase.initializeApp();
    print("message just show :${message.messageId}");
  } */

/*   void showNotification() {
    setState(() {
      NotificationCounter++;
    });
    flutterLocalNotificationsPlugin.show(
        0,
        "testing $NotificationCounter",
        "is it going well ?",
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channelDescription: channel.description,
            importance: Importance.high,
            playSound: true,
          ),
        ));
  } */

//

  /*  storedNotificationToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      idDoc = prefs.getString('idDoc') ?? '';
    });
    String? token = await FirebaseMessaging.instance.getToken();
    UserService().setToken(idDoc, token);
  } */

  //liste de posiition des livreur
  getUserPosition() async {
    //obtenir l'identifiant du document
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      idDoc = prefs.getString('idDoc') ?? '';
    });

    //print('identifiant est : $id et le home est $showHome');
    LatLng coordonnees = new LatLng(0, 0);

    //get current manager and current manager position
    await ServiceUser.getUserbyId(widget.currentManagerID).then((value) {
      setState(() {
        currentManager = value;
        print('currrent user $currentManager');
      });
    });

    await ServicePosition.getPosition('${currentManager.idPosition}').then(
      (value) {
        setState(() {
          currentManagerPosition = LatLng(value.latitude, value.longitude);
          myPosition = value;
        });
      },
    );
    var monadress = await GeocodingPlatform.instance.placemarkFromCoordinates(
        currentManagerPosition.latitude, currentManagerPosition.longitude);
    var firs = monadress.first;
    //end
//Maquer le manager courant
    markers.add(Marker(
      //add distination location marker
      markerId: MarkerId(ydeliver.toString()),
      position: currentManagerPosition,
      infoWindow: InfoWindow(
          //popup info
          title: 'ma position ',
          snippet: ' ${firs.locality},${firs.street}, ${firs.name}'),
      icon: BitmapDescriptor.defaultMarkerWithHue(
          BitmapDescriptor.hueViolet), //Icon for Marker
    ));
  }

/*   void requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
      requestPermission();
    }
  } */

  /*  display() async {
    print('channel channel channel');
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
            alert: true, badge: true, sound: true);
  }

  void loadFCM() async {
    if (!kIsWeb) {
      const AndroidNotificationChannel channel = AndroidNotificationChannel(
          'high_importance_channel', //id
          'High Importance Notifications', //title

          description: 'This channel is used for important notifications.',
          importance: Importance.high,
          playSound: true,
          enableVibration: true);

      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
          FlutterLocalNotificationsPlugin();

      /// Create an Android Notification Channel.
      ///
      /// We use this channel in the `AndroidManifest.xml` file to override the
      /// default FCM channel to enable heads up notifications.
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);

      /// Update the iOS foreground notification presentation options to allow
      /// heads up notifications.
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    }
  }

  void listenFCM() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null && !kIsWeb) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              // TODO add a proper drawable resource to android, for now using
              //      one that already exists in example app.
              icon: 'launch_background',
            ),
          ),
        );
      }
    });
  }
 */
  void listenOpenFCM() async {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessage eevent was published');
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        showDialog(
            context: context,
            builder: (_) {
              return AlertDialog(
                title: Text(" ${notification.title}"),
                content: SingleChildScrollView(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [Text(" ${notification.body}")],
                )),
              );
            });
      }
    });
  }

  void sendPushMessage(String body, String title, String? token) async {
    print(
        "envoie des notionsaticioooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo");
    try {
      await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization':
              'key=AAAALOR35JE:APA91bHzS-FNsPRD-UmapTvVLGxo3-uneI7xnuk1yZdWJqZjqLH-F65UoLc3VYtkcl13NmVgkYqxg4tlzVqg78CWmWMnNhm5ziF7nv8ekaIKpl6nb5onU76eeIgq1nU3oH03l1wfCc6F',
        },
        body: jsonEncode(
          <String, dynamic>{
            'notification': <String, dynamic>{
              'body': body,
              'title': title,
            },
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'id': '1',
              'status': 'done'
            },
            "to": token,
          },
        ),
      );

      print("notification is send");
    } catch (e) {
      print("error push notification");
    }
  }

//widget final
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      drawer: NavBar(),
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: Text('Mon application'),
        actions: [
          IconButton(
            onPressed: () {
              showSearch(
                context: context,
                delegate: MysearchDelegate(
                    tableauJsontrie: tableauJson, //tableauJsontrie
                    hintText: " rechercher un livreur",
                    current_user: currentManager),
              );
            },
            icon: const Icon(Icons.search),
          )
        ],
      ),

      body: Column(
        children: <Widget>[
          Container(
              height: size.height * 0.42,
              //height: size.height,
              child: StreamBuilder<Future<Set<Marker>>>(
                  stream: userCollection
                      .where('isDeliver', isEqualTo: true)
                      .snapshots()
                      .map((event) async {
                    var users = event.docs;
                    for (var i in users) {
                      final user = i.data();
                      final UserModel Adeliver = UserModel(
                          idDoc: user['idDoc'],
                          idUser: user['idUser'],
                          adress: user['adress'],
                          name: user['name'],
                          phone: user['phone'],
                          tool: user['tool'],
                          picture: user['picture'],
                          idPosition: user['idPosition'],
                          isManager: user['isManager'],
                          isClient: user['isClient'],
                          isDeliver: user['isDeliver'],
                          token: user['token']);
                      await PositionService()
                          .getPosition(Adeliver.idPosition)
                          .then((value) async {
                        LatLng coordonnees =
                            LatLng(value.latitude, value.longitude);
                        var addresses = await GeocodingPlatform.instance
                            .placemarkFromCoordinates(
                                value.latitude, value.longitude);
                        var first = addresses.first;
                        print(
                            ' ${first.locality},${first.subLocality}, ${first.administrativeArea}, ${first.subAdministrativeArea},${first.street}, ${first.name},${first.thoroughfare}, ${first.subThoroughfare}');

                        setState(() {
                          final LatLng pos = currentManagerPosition;

                          markers.add(Marker(
                              //add start location marker
                              markerId: MarkerId(coordonnees.toString()),
                              position: coordonnees,
                              infoWindow: InfoWindow(
                                //popup info
                                title:
                                    'Livreur ${Adeliver.name} A ${getDistance(pos, coordonnees)} km de vous',
                                //le user name envoye depuis la page de validation
                                snippet:
                                    '${first.locality}, ${first.street}, ${first.name}',
                              ),
                              icon: BitmapDescriptor.defaultMarker,
                              onTap: () {} //Icon for Marker
                              ));
                        });
                      });
                    }
                    return markers;
                  }),
                  builder:
                      (context, AsyncSnapshot<Future<Set<Marker>>> snapshot) {
                    if (!snapshot.hasData) {
                      // ignore: prefer_const_constructors
                      return Center(
                        child: const CircularProgressIndicator(),
                      );
                    }
                    return GoogleMap(
                      zoomGesturesEnabled: true, //enable Zoom in, out on map
                      mapType: MapType.normal,
                      myLocationEnabled: true,
                      initialCameraPosition: CameraPosition(
                        target: this.currentManagerPosition,
                        zoom: 10,
                      ),
                      markers: markers, //markers to show on map
                      // polylines: Set<Polyline>.of(polylines.values), //polyl
                      onMapCreated: (GoogleMapController controller) {
                        mapController = controller;
                      },
                    );
                  })),
          Container(
              height: size.height * 0.43,
              margin: const EdgeInsets.symmetric(vertical: kDefaultPadding / 5),
              child: Stack(
                children: <Widget>[
                  Container(
                    width: size.width,
                    height: size.height * 0.08,
                    margin:
                        const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                    child: Column(
                      children: <Widget>[
                        Text(
                          'contacter un livreur ',
                          style: GoogleFonts.philosopher(
                              fontSize: 17, fontWeight: FontWeight.w600),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          'Economique, rapide et fiable',
                          style: GoogleFonts.poppins(
                              color: Colors.grey, fontSize: 13),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    width: size.width,
                    top: 42,
                    bottom: 0,
                    right: 0,
                    child: Container(
                      child: Column(
                        children: <Widget>[
                          Expanded(
                            // flex: 2,
                            child: StreamBuilder<
                                    Future<List<Map<String, dynamic>>>>(
                                stream: userCollection
                                    .where('isDeliver', isEqualTo: true)
                                    .snapshots()
                                    .map((event) async {
                                  print(
                                      "doc doc doc doc      $event $event, $event , $event , $event       doc doc doc doc             doc doc doc doc ");
                                  var liste = [];
                                  var users = event.docs;
                                  for (var i in users) {
                                    final user = i.data();

                                    print(
                                        "charline charline charline charline     $user , $user, $user, $user         charline charline charline             charline charline charline ");

                                    final UserModel Adeliver = UserModel(
                                        idDoc: user['idDoc'],
                                        idUser: user['idUser'],
                                        adress: user['adress'],
                                        name: user['name'],
                                        phone: user['phone'],
                                        tool: user['tool'],
                                        picture: user['picture'],
                                        idPosition: user['idPosition'],
                                        isManager: user['isManager'],
                                        isClient: user['isClient'],
                                        isDeliver: user['isDeliver'],
                                        token: user['token']);

                                    await PositionService()
                                        .getPosition(Adeliver.idPosition)
                                        .then((value) {
                                      LatLng coordonnees = LatLng(
                                          value.latitude, value.longitude);
                                      /*  var dis = getDistance(
                                          currentManagerPosition, coordonnees); */
                                      print(
                                          "coordonnees cooordonneeees   $coordonnees $coordonnees $coordonnees  coordonnees cooordonneeees  coordonnees cooordonneeees  coordonnees cooordonneeees  coordonnees cooordonneeees  ");

                                      setState(() {
                                        print("charles  ");
                                        print(
                                            "currentManagerPosition currentManagerPosition  $currentManagerPosition   $currentManagerPosition $currentManager  currentManagerPosition currentManagerPosition currentManagerPosition currentManagerPosition currentManagerPosition ");
                                        final LatLng pos =
                                            currentManagerPosition;
                                        tableauJson.add({
                                          "Deliver": Adeliver.toMap(),
                                          "Distance":
                                              getDistance(pos, coordonnees)
                                        });
                                        tableauJsontrie = tableauTrie(
                                            TriRapidejson(table: tableauJson)
                                                .QSort(
                                                    0, tableauJson.length - 1));
                                      });
                                    });
                                    print(
                                        "longitude  longitude longitude longitude  $tableauJson, $tableauJson   longitude longitude longitude longitude ");
                                  }
                                  setState(() {});

                                  print(
                                      "tableau json tableau json tableau json $tableauJsontrie, $tableauJsontrie  tableau json tableau json tableau json tableau json tableau json");
                                  return tableauJsontrie;
                                }),
                                builder: (context,
                                    AsyncSnapshot<
                                            Future<List<Map<String, dynamic>>>>
                                        snapshot) {
                                  if (!snapshot.hasData) {
                                    // ignore: prefer_const_constructors
                                    return Center(
                                      child: const CircularProgressIndicator(),
                                    );
                                  }
                                  //   var snap = snapshot.data.docs;

                                  return ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    //  this.tableauJsontrie.length,
                                    itemCount: tableauJsontrie.length,
                                    // tableauTrie(this.tableauJson).length,
                                    //  itemCount: this.exampleModelDeliver.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return InkWell(
                                          child: Container(
                                            child:
                                                GetItem(tableauJsontrie[index]),
                                          ),
                                          onTap: () {
                                            setState(() {
                                              isdeliver = false;
                                              deliver = tableauJsontrie[index]
                                                  ['Deliver'];
                                              tab = tableauJsontrie[index];
                                            });

                                            deliver !=
                                                    UserModel(idPosition: "",
                                                            name: 'audrey',
                                                            idDoc: 'audrey')
                                                        .toMap()
                                                ? isdeliver = true
                                                : isdeliver = false;
                                          });
                                    },
                                  );
                                }),
                          ),
                          Visibility(
                              visible: (isdeliver || isDev),
                              child: Column(
                                children: <Widget>[
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Container(
                                      margin: EdgeInsets.only(left: 10),
                                      padding: EdgeInsets.all(5),
                                      height: 40,
                                      width: size.width * 0.68,
                                      color: Color.fromARGB(255, 248, 246, 248),
                                      child: Text(
                                        'situe a ${tab["Distance"]} km de vous',
                                        // Text('${tableauJsontrie[index]['Deliver']['name']}',
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        FlatButton(
                                          minWidth: size.width * 0.7,
                                          onPressed: () {
                                            UserModel ontapDeliver = UserModel(
                                              idUser: tab['Deliver']['idUser'],
                                              adress: tab['Deliver']['adress'],
                                              name: tab['Deliver']['name'],
                                              idPosition: tab['Deliver']
                                                  ['idPosition'],
                                              phone: tab['Deliver']['phone'],
                                              picture: tab['Deliver']
                                                  ['picture'],
                                              createdAt: tab['Deliver']
                                                  ['createdAt'],
                                              idDoc: tab['Deliver']['idDoc'],
                                            );
                                            _showcommandDialog(
                                                context,
                                                myPosition,
                                                currentManager,
                                                ontapDeliver);
                                          },
                                          padding: EdgeInsets.all(5),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          color: kPrimaryColor,
                                          textColor: kBackgroundColor,
                                          child: Text(
                                            'CONFIRMER ${deliver["name"]} '
                                                .toUpperCase(),
                                            style: GoogleFonts.poppins(
                                                fontSize: 15),
                                          ),
                                        ),
                                        Container(
                                          width: size.width * 0.25,
                                          height: 40,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  width: 1,
                                                  color: Colors.white70),
                                              shape: BoxShape.circle,
                                              image: DecorationImage(
                                                  fit: BoxFit.cover,
                                                  image: AssetImage(
                                                      "assets/images/profil.png"))),
                                        ),
                                      ]),
                                ],
                              ))
                        ],
                      ),
                    ),
                  ),
                ],
              )),
          // )
        ],
      ),
      // ),
    );
  }

  Widget GetItem(Map<String, dynamic> tableauJsontrie) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: <Widget>[
        Stack(children: <Widget>[
          Container(
            margin: EdgeInsets.symmetric(horizontal: kDefaultPadding / 2),
            width: size.width * 0.25,
            height: size.width * 0.25,
            decoration: BoxDecoration(
                border: Border.all(width: 1, color: Colors.white),
                boxShadow: [
                  BoxShadow(
                      spreadRadius: 2,
                      blurRadius: 10,
                      color: Colors.black.withOpacity(0.1))
                ],
                shape: BoxShape.circle,
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: const AssetImage("assets/images/profil.png"))),
          ),
          Positioned(
            bottom: size.width * 0.14,
            right: size.width * 0.06,
            child: Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(width: 0, color: Colors.transparent),
                  //color: Colors.white),
                  color: kPrimaryColor,
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage('assets/images/profil.png')
                      //  image: AssetImage("${user.tool}")
                      )),
            ),
          )
        ]),
        // ),
        const SizedBox(
          height: 2,
        ),
        Text(tableauJsontrie['Deliver']['name'],
            style:
                GoogleFonts.poppins(fontWeight: FontWeight.w500, fontSize: 15)),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }

//pour le appbar
  bool isVisible() {
    if (isSearching == false) {
      return true;
    } else {
      return false;
    }
  }

  //calcul de la distance entre deux positions
  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var a = 0.5 -
        cos((lat2 - lat1) * p) / 2 +
        cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
    var x = 12742 * asin(sqrt(a));
    return roundDouble(x, 2);
  }
  //fonction pour arrondir

  double roundDouble(double value, int places) {
    num mod = pow(10.0, places);
    return ((value * mod).round().toDouble() / mod);
  }

//supprime les doublons dans une liste
  List<Map<String, dynamic>> tableauTrie(List<Map<String, dynamic>> table) {
    int i, j, k;
    var n = table.length;
    for (i = 0; i < n; i++) {
      for (j = i + 1; j < n;) {
        if (table[j]['Deliver']['idUser'] == table[i]['Deliver']['idUser']) {
          table.removeAt(j);
          n--;
        } else
          j++;
      }
    }
    return table;
  }

  double getDistance(
      LatLng currentManagerPosition, LatLng positionDeliverList) {
    var dist;
    dist = calculateDistance(
        currentManagerPosition.latitude,
        currentManagerPosition.longitude,
        positionDeliverList.latitude,
        positionDeliverList.longitude);
    return dist;
  }

// boite de dialogue pour l'edition de la commande
  void _showcommandDialog(BuildContext context, PositionModel position,
      UserModel user, UserModel deliver) {
    String bouton = "Annuler";
    String dropdownValue = 'Fragile';
    String dropdownValuePoids = 'kg';
    TextEditingController poidsController = TextEditingController();
    TextEditingController nameController = TextEditingController();

    CommandService ServiceCommand = new CommandService();

    TextEditingController descriptionController = TextEditingController();
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              backgroundColor: Colors.white,
              title: Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.symmetric(horizontal: kDefaultPadding),
                child: Center(
                  child: Text(
                    "commande pour ${deliver.name}",
                    style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Palette.primarySwatch.shade400
                        //  color: Colors.white

                        //  backgroundColor: Colors.white
                        ),
                  ),
                ),
              ),
              content: Form(
                  key: _formKey,
                  child: Container(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          TextFormField(
                            controller: nameController,
                            style: GoogleFonts.poppins(fontSize: 15),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'veuillez nommer cette commande';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                                labelText: "Nom commande",
                                filled: true,
                                hintStyle: TextStyle(
                                    color: Palette.primarySwatch.shade400),
                                //  hintText: "${currentManager.adress}",
                                fillColor: Color.fromARGB(255, 240, 229, 240)),
                          ),
                          DropdownButtonFormField<String>(
                            dropdownColor: Color.fromARGB(255, 240, 229, 240),
                            hint: Text(
                              'Etat du colis',
                              style: TextStyle(color: Colors.grey[800]),
                            ),
                            value: dropdownValue,
                            onChanged: (String? newValue) {
                              // setState(() {
                              dropdownValue = newValue!;
                              // });
                            },
                            items: <String>['Fragile', 'non-fragile', 'autres']
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          TextFormField(
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: 'Estimer le poids',
                                filled: true,
                                fillColor: Color.fromARGB(255, 240, 229, 240),
                                hintStyle: TextStyle(color: Colors.grey[800]),
                              ),
                              controller: poidsController,
                              validator: (value) {
                                if (value == null ||
                                    value.isEmpty ||
                                    value.length > 4) {
                                  return 'veuillez estimer le poids du colis';
                                }
                                return null;
                              }),
                          DropdownButtonFormField<String>(
                            dropdownColor: Color.fromARGB(255, 240, 229, 240),
                            value: dropdownValuePoids,
                            onChanged: (String? newValue) {
                              // setState(() {
                              dropdownValuePoids = newValue!;
                              // });
                            },
                            items: <String>['tonnes', 'kg', 'g', 'mg']
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          TextFormField(
                            controller: descriptionController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'veuillez decrire la commande';
                              }
                              return null;
                            },
                            keyboardType: TextInputType.multiline,
                            textInputAction: TextInputAction.newline,
                            minLines: 1,
                            maxLines: 5,
                            decoration: InputDecoration(
                                filled: true,
                                hintStyle: TextStyle(color: Colors.grey[800]),
                                // prefixIcon: const Icon(Icons.write),
                                hintText: "Description de la commande ici",
                                fillColor: Color.fromARGB(255, 240, 229, 240)),
                          ),
                        ],
                      ),
                    ),
                  )),
              actions: [
                FlatButton(
                  child: Text("Quitter",
                      style:
                          TextStyle(color: Color.fromARGB(255, 240, 229, 240))),
                  padding: EdgeInsets.all(2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  color: Palette.primarySwatch
                      .shade400, //Color.fromARGB(255, 240, 229, 240),
                  //  textColor: kBackgroundColor,
                  onPressed: () => Navigator.pop(context), // passing true
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.1,
                ),
                FlatButton(
                  child: const Text(
                    "Publier",
                    style: TextStyle(color: Color.fromARGB(255, 240, 229, 240)),
                  ),
                  padding: const EdgeInsets.all(2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  color: Palette.primarySwatch.shade400, //,
                  //  textColor: kBackgroundColor,
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      Navigator.pushNamed(context, '/chat');
                      /*CommandModel command = CommandModel(
                          createdBy: user.idUser,
                          nameCommand: nameController.text,
                          description:
                              "${descriptionController.text} $dropdownValue",
                          poids: "${poidsController.text} $dropdownValuePoids",
                          statut: "en attente",
                          state: dropdownValue,
                          startPoint: user.idPosition,
                          updatedAt: DateTime.now().toString(),
                          createdAt: DateTime.now().toString());

                      Navigator.pop(context);
                      _ShowcreateDialog(context, command, deliver);*/
                    }
                  },
                ),
              ]);
        });
  }

  double _getUserDistance(List<Map<String, dynamic>> tableau, UserModel user) {
    var distance = -1.0;
    for (var i in tableau) {
      if (i['Deliver']['idUser'] == user.idUser) {
        distance = i['Distance'];
        break;
      }
    }
    return distance;
  }

  void _ShowcreateDialog(
      // BuildContext context, CommandModel command, void Function() fonction) {  _deleteAction()
      BuildContext context,
      CommandModel command,
      UserModel deliver) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              backgroundColor: Colors.white,
              content: Container(
                  child: Text(
                      "Etes vous sur de vouloir publier cette commande ?")),
              actions: [
                FlatButton(
                  child: Text(
                    "Non".toUpperCase(),
                    style: TextStyle(color: Color.fromARGB(255, 240, 229, 240)),
                  ),
                  padding: EdgeInsets.all(2),
                  //  minWidth: MediaQuery.of(context).size.width,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  color: Palette.primarySwatch.shade400, //,
                  //  textColor: kBackgroundColor,
                  onPressed: () async {
                    Navigator.pop(context);
                  },
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.1,
                ),
                FlatButton(
                  child: Text("Oui".toUpperCase(),
                      style:
                          TextStyle(color: Color.fromARGB(255, 240, 229, 240))),
                  padding: EdgeInsets.all(2),
                  // minWidth: MediaQuery.of(context).size.width,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  color: Palette.primarySwatch.shade400,
                  onPressed: () async {
                    Navigator.pop(context);
                    await CommandService().addCommand(command).then((value) {
                      print(
                          "commande commande commande commande commande commande commande");
                      Fluttertoast.showToast(
                          msg: "la commande a ete publier",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 5,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0);
                    }).catchError((onError) {
                      Navigator.pop(context);
                      Fluttertoast.showToast(
                          msg: "Echec de publication, veuillez reesayer!",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 5,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0);
                    });
                    sendPushMessage(command.description, command.nameCommand,
                        deliver.token);
                  }, // passing true
                ),
              ]);
        });
  }
}
