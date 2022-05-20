// ignore_for_file: non_constant_identifier_names

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import 'package:supply_app/components/models/Database_Model.dart';
import 'package:supply_app/components/screen/manager/components/profil_deliver.dart';
import 'package:supply_app/components/services/user_service.dart';
import 'package:supply_app/constants.dart';

import '../../../services/position_service.dart';

class ManagerHome extends StatefulWidget {
  UserModel currentManager;
  ManagerHome({Key? key, required this.currentManager}) : super(key: key);
  @override
  _ManagerHomeState createState() => _ManagerHomeState();
}

class _ManagerHomeState extends State<ManagerHome> {
  late PositionModel positionDeliver;

  //  LatLng startLocation = LatLng(latCurrentManager,longCurrentManager);

  GoogleMapController? mapController; //controller pour Google map
  PolylinePoints polylinePoints = PolylinePoints();

  String googleAPiKey = "AIzaSyDma7ThRPGokuU_cJ2Q_qFvowIpK35RAPs"; //google api
  Set<Marker> markers = {}; //markers for google map
  Map<PolylineId, Polyline> polylines = {}; //polylines to show direction

  //liste des livreurs
  // Stream<List<UserModel>> databaseDeliver = UserService().getdelivers();

  UserModel? exampleModel = new UserModel(name: 'fabiol');

  UserService ServiceUser = new UserService();
  PositionService ServicePosition = new PositionService();
  PositionModel x = new PositionModel(longitude: 0, latitude: 0);
  LatLng y = new LatLng(0, 0);
  PositionModel xdeliver = new PositionModel(longitude: 0, latitude: 0);
  LatLng ydeliver = new LatLng(0, 0);

  List<LatLng> positions = [];

  List<UserModel> exampleModelDeliver = [];

  @override
  void initState() {
    _listDeliver();
    //  print('liste de livreurs ${exampleService.getposdelivers()}');
    _currentDeliver();
    _ManagerPosition();
    _DeliverPosition();

    //  double latCurrentManager = this.y.latitude;
    //  double longCurrentManager = this.y.longitude;
    //String? idPositionManager = widget.currentManager.position.idPosition;
    markers.add(Marker(
      //add start location marker
      markerId: MarkerId(
          //  LatLng(latCurrentManager, longCurrentManager).toString()),
          this.y.toString()),
      position: this.y,
      // LatLng(latCurrentManager, longCurrentManager), //position of marker
      infoWindow: InfoWindow(
        //popup info
        title: 'ma position ',
        //le user name envoye depuis la page de validation
        snippet: widget.currentManager.name,
      ),
      icon: BitmapDescriptor.defaultMarker, //Icon for Marker
    ));

    markers.add(Marker(
      //add distination location marker
      markerId: MarkerId(
          // LatLng(positionDeliver.latitude, positionDeliver.longitude)
          ydeliver.toString()),
      position: ydeliver,
      // LatLng(positionDeliver.latitude,
      // positionDeliver.longitude), //position of marker
      infoWindow: InfoWindow(
        //popup info
        title: 'position du livreur ',
        snippet: widget.currentManager.name,
      ),
      icon: BitmapDescriptor.defaultMarker, //Icon for Marker
    ));

    getDirections(); //fetch direction polylines from Google API/Draw polyline direction routes in Google Map

    super.initState();
  }

  _ManagerPosition() async {
    // print(' le nombre identifiant est ${this._listDeliver()}');
    await ServicePosition.getPosition('${widget.currentManager.idPosition}')
        .then(
      (value) {
        setState(() {
          this.x = value;
          this.y = LatLng(x.latitude, x.longitude);
        });
        print(
            "dans le then la latitude manager est ${y.latitude}, et sa longitude est ${y.longitude}");
      },
    );
    print(
        "la latitude du manager est ${y.latitude}, et sa longitude est ${y.longitude}");
  }

  _DeliverPosition() async {
    // print(' le nombre identifiant est ${this._listDeliver()}');
    await ServicePosition.getPosition('${this.exampleModel!.idPosition}').then(
      (value) {
        setState(() {
          this.xdeliver = value;
          this.ydeliver = LatLng(xdeliver.latitude, xdeliver.longitude);
        });
        print(
            "dans le then la latitude Deliver est ${ydeliver.latitude}, et sa longitude est ${ydeliver.longitude}");
      },
    );
    print(
        "la latitude du Deliver est ${ydeliver.latitude}, et sa longitude est ${ydeliver.longitude}");
  }

  _currentDeliver() async {
    // print('teste user !!!111 ');
    await ServiceUser.getUserbyId("OCrk7Ov4pIZXabNqnyMU").then((value) {
      setState(() {
        this.exampleModel = value;
      });
    });

    print('dikongue ${this.exampleModel}');
  }

  _listDeliver() async {
    await ServiceUser.getDelivers().forEach((element) {
      setState(() {
        this.exampleModelDeliver = element;
      });
      /* var taille = this.exampleModelDeliver.length;
      for (var i = 0; i < taille; i++) {
        print('liste de livreurs ${this.exampleModelDeliver[i]}\n');
      }*/
      print(
          "le nombre de livreur est exactement ${exampleModelDeliver.length}");
    });

    print("le nombre de livreur est ${exampleModelDeliver.length}");
    return exampleModelDeliver.length;
    // exampleModelDeliver= exampleService.getposdelivers();
  }

  getDirections() async {
    List<LatLng> polylineCoordinates = [];

//Obtenez la liste des points par Geo-coordinate, cela renvoie une instance de PolylineResult,
//qui contient le statut de l'api, le errorMessage et la liste des points décodés.
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleAPiKey = "AIzaSyDMvPHsbM0l51gW4shfWTHMUD-8Df-2UKU",
      PointLatLng(positionDeliver.latitude, positionDeliver.longitude),
      PointLatLng(positionDeliver.latitude, positionDeliver.longitude),
      travelMode: TravelMode.driving,
      // travelMode: TravelMode.transit,
    );
    // inserer la liste de points reperes sur google map dans le tableau polylineCoordinates
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    } else {
      print(result.errorMessage);
    }
// appel de la gonction addPolyLine sur la liste de points
    addPolyLine(polylineCoordinates);
  }

//colorier en couleur violet tous les points de la liste sur la Map
  addPolyLine(List<LatLng> polylineCoordinates) {
    PolylineId id = PolylineId('poly');
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.deepPurpleAccent,
      points: polylineCoordinates,
      width: 8,
    );
    polylines[id] = polyline;
    setState(() {});
  }

//widget final
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Column(
        children: [
          Container(
            height: size.height * 0.58,
            child: GoogleMap(
              zoomGesturesEnabled: true, //enable Zoom in, out on map
              mapType: MapType.normal,
              myLocationEnabled: true,
              initialCameraPosition: CameraPosition(
                target: this.y,
                //LatLng(widget.currentManager.position.latitude,
                //   widget.currentManager.position.longitude),
                zoom: 14,
              ),
              markers: markers, //markers to show on map
              polylines: Set<Polyline>.of(polylines.values), //polyl
              onMapCreated: (GoogleMapController controller) {
                mapController = controller;
              },
            ),
          ),
          Container(
              height: size.height * 0.4,
                width: size.width,
              margin: const EdgeInsets.symmetric(vertical: kDefaultPadding/4),
              //padding: EdgeInsets.only(top: size.height * 0.4),
              // left: kDefaultPadding / 10,
              // top: size.height * 0.7,
              // right: kDefaultPadding / 10,
              child: Stack(
                children: [
                  Container(
                    height: size.height * 0.1,
                    margin: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                    child: Column(
                      children: [
                        Text('jjjjjjjjjjjjjjjjjjjjjjjjjjjjj'),
                        SizedBox(height: 5,),
                        Text('jjjjjjjjjjjjjjjjjjjjjjjjjjjjj'),
                        
                      ],
                    ),
                  ),
                  
                  Positioned(
                    width: size.width,
                    bottom: -50,
                    right: 0,
                    child: ListView(
                      scrollDirection: Axis.horizontal,

                      children: <Widget>[
                        ProfilDeliver(),
                        SizedBox(
                          width: 10,
                        ),
                        ProfilDeliver(),
                        SizedBox(
                          width: 10,
                        ),
                        ProfilDeliver(),
                        SizedBox(
                          width: 10,
                        ),
                        ProfilDeliver(),
                        SizedBox(
                          width: 10,
                        ),
                        ProfilDeliver(),
                      ],

                      // child:
                      /*  StreamBuilder<List>(
                                 
                                stream: FirebaseFirestore.instance
                                    .collection("user")
                                    .where('isDeliver', isEqualTo: true)
                                    .snapshots()
                                    .map((snapshot) {
                                  return snapshot.docs.map((doc) {
                                    //  print('moguem souop${doc.runtimeType}');
                                    //print('mon adresse${doc.get('adress')}');
                                    return UserModel(
                                        //idUser: data['idUser'],
                                        idUser: doc.get('idUser'),
                                        adress: doc.get('adress'),
                                        name: doc.get('name'),
                                        phone: int.parse(doc.get('phone')),
                                        tool: doc.get('tool'),
                                        picture: doc.get('picture'),
                                        idPosition: doc.get('idPosition'),
                                        isManager: doc.get('isManager'),
                                        isClient: doc.get('isClient'),
                                        isDeliver: doc.get('isDeliver'));
                                  }).toList();
                                  // return model;
                                }),
                                builder:
                                    (BuildContext context, AsyncSnapshot<List> Delivers) {
                                  if (!Delivers.hasData) {
                                    return const Text('Loading');
                                  }
                                  final int count = Delivers.data!.length;
                                  return ListView.builder(
                                    padding: const EdgeInsets.only(
                                        top: kDefaultPadding,
                                        left: kDefaultPadding / 2,
                                        right: kDefaultPadding / 2),
                                    scrollDirection: Axis.horizontal,
                                    itemCount: count,
                                    itemBuilder: (BuildContext context, int index) {
                                      /*  final DocumentSnapshot snapshot =
                                          Deliversnapshot.data!.docs[index];*/
                                      final Deliver = Delivers.data![index];
                                  
                                      // retourner pour chaque valeur de la liste, le wiget profilDeliver
                                      return ProfilDeliver();
                                      /*return ProfilDeliver(
                                          Deliver,
                                          widget.currentManager,
                                          this.y.latitude,
                                          this.y.longitude,
                                          this.y.latitude,
                                          this.y.longitude);*/
                                    },
                                  );
                                },
                              ),*/
                      //  )
                    ),
                  ),
                ],
              ))
        ],
      ),
    );
  }
}

@override
Widget build(BuildContext context) {
  // TODO: implement build
  throw UnimplementedError();
}
