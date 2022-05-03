// ignore_for_file: non_constant_identifier_names

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:supply_app/components/models/Database_Model.dart';
import 'package:supply_app/components/models/Database_Model.dart';
import 'package:supply_app/components/models/Database_Model.dart';
import 'package:supply_app/components/screen/manager/profil_deliver.dart';
import 'package:supply_app/components/services/user_service.dart';
import 'package:supply_app/constants.dart';

import '../../../bloc/application_bloc.dart';

class ManagerHome extends StatefulWidget {
  const ManagerHome({Key? key}) : super(key: key);

  @override
  _ManagerHomeState createState() => _ManagerHomeState();
}

class _ManagerHomeState extends State<ManagerHome> {
  late PositionModel positionUser, positionDeliver;

  //  LatLng startLocation = LatLng(positionUser.latitude,positionUser.longitude);

  GoogleMapController? mapController; //controller pour Google map
  PolylinePoints polylinePoints = PolylinePoints();
  late UserModel user;
  String googleAPiKey = "AIzaSyDma7ThRPGokuU_cJ2Q_qFvowIpK35RAPs"; //google api
  Set<Marker> markers = {}; //markers for google map
  Map<PolylineId, Polyline> polylines = {}; //polylines to show direction
  //liste des livreurs
  Stream<List<UserModel>> databaseDeliver = UserService().getdelivers();
  @override
  void initState() {
    markers.add(Marker(
      //add start location marker
      markerId: MarkerId(
          LatLng(positionUser.latitude, positionUser.longitude).toString()),
      position: LatLng(
          positionUser.latitude, positionUser.longitude), //position of marker
      infoWindow: InfoWindow(
        //popup info
        title: 'ma position ',
        snippet: '${user.name}',
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
        title: 'position de livreur ',
        snippet: '${user.name}',
      ),
      icon: BitmapDescriptor.defaultMarker, //Icon for Marker
    ));

    getDirections(); //fetch direction polylines from Google API

    super.initState();
  }

  getDirections() async {
    List<LatLng> polylineCoordinates = [];

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleAPiKey = "AIzaSyDMvPHsbM0l51gW4shfWTHMUD-8Df-2UKU",
      PointLatLng(positionDeliver.latitude, positionDeliver.longitude),
      PointLatLng(positionDeliver.latitude, positionDeliver.longitude),
      travelMode: TravelMode.driving,
    );

    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    } else {
      print(result.errorMessage);
    }

    addPolyLine(polylineCoordinates);
  }

  addPolyLine(List<LatLng> polylineCoordinates) {
    PolylineId id = PolylineId('${positionUser.idPosition}');
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
    final applicationBloc = Provider.of<ApplicationBloc>(context);
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: size.height,
            child: GoogleMap(
              mapType: MapType.normal,
              myLocationEnabled: true,
              initialCameraPosition: CameraPosition(
                target: LatLng(positionUser.latitude, positionUser.longitude),
                zoom: 14,
              ),
              onMapCreated: (GoogleMapController controller) {
                mapController = controller;
              },
              markers: Set<Marker>.of(applicationBloc.markers),
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
                            final user = Deliversnapshot.data!.docs
                                .map((doc) => UserModel.fromJson(
                                    doc.data() as Map<String, dynamic>))
                                .toList()[index];

                            return ProfilDeliver(user);
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
