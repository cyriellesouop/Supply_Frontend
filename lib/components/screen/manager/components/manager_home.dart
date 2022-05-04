// ignore_for_file: non_constant_identifier_names

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import 'package:supply_app/components/models/Database_Model.dart';
import 'package:supply_app/components/screen/manager/profil_deliver.dart';
import 'package:supply_app/components/services/user_service.dart';
import 'package:supply_app/constants.dart';

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

  @override
  void initState() {
    double latCurrentManager = widget.currentManager.position.latitude;
    double longCurrentManager = widget.currentManager.position.longitude;
    //String? idPositionManager = widget.currentManager.position.idPosition;
    markers.add(Marker(
      //add start location marker
      markerId:
          MarkerId(LatLng(latCurrentManager, longCurrentManager).toString()),
      position:
          LatLng(latCurrentManager, longCurrentManager), //position of marker
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
          LatLng(positionDeliver.latitude, positionDeliver.longitude)
              .toString()),
      position: LatLng(positionDeliver.latitude,
          positionDeliver.longitude), //position of marker
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
      body: Stack(
        children: [
          Container(
            height: size.height,
            child: GoogleMap(
              zoomGesturesEnabled: true, //enable Zoom in, out on map
              mapType: MapType.normal,
              myLocationEnabled: true,
              initialCameraPosition: CameraPosition(
                target: LatLng(widget.currentManager.position.latitude,
                    widget.currentManager.position.longitude),
                zoom: 14,
              ),
              markers: markers, //markers to show on map
              polylines: Set<Polyline>.of(polylines.values), //polyl
              onMapCreated: (GoogleMapController controller) {
                mapController = controller;
              },
            ),
          ),
          Positioned(
            bottom: 0,
            top: size.height * 0.6,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(kDefaultPadding),
              child: Column(
                children: <Widget>[
                  const Text("commander ici"),
                  const SizedBox(
                    height: 5,
                  ),
                  const Text("contacter un livreur"),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection("user")
                          .where('isDeliver', isEqualTo: true)
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> Deliversnapshot) {
                        if (!Deliversnapshot.hasData) {
                          return const Text('Loading');
                        }
                        final int count = Deliversnapshot.data!.docs.length;
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
                            final Deliver = Deliversnapshot.data!.docs
                                .map((doc) => UserModel.fromJson(
                                    doc.data() as Map<String, dynamic>))
                                .toList()[index];
                            // retourner pour chaque valeur de la liste, le wiget profilDeliver
                            return ProfilDeliver(
                                Deliver, widget.currentManager);
                          },
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
          )
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
