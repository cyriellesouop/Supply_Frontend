// ignore_for_file: non_constant_identifier_names
/*import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:supply_app/components/models/Database_Model.dart';
import 'package:supply_app/components/screen/manager/components/profil_deliver.dart';
import 'package:supply_app/components/services/user_service.dart';
import 'package:supply_app/constants.dart';

class DeliverList extends StatefulWidget {
  //
  const DeliverList({
    Key? key,
  }) : super(key: key);
  @override
  _DeliverListState createState() => _DeliverListState();
}

class _DeliverListState extends State<DeliverList> {

 
    UserModel manager = UserModel(
          idUser: 'akZH6DCCoVWleuGcefKqx23OrtI2',
          adress: 'mini prix',
          tool: null,
          phone:693033904,
          picture:'assets/images/profil.png' ,
          isClient: false,
          isDeliver: false,
          isManager: true,
          name: 'audrey',
          position:PositionModel(
            idPosition :'72XGX1m2baItp3WXQChf', longitude: 11.4926649, latitude: 3.8529998) 
        );
   

 

 

  PositionModel positionDeliver= PositionModel(longitude:11.4810984, latitude: 3.9119924 );

  //  LatLng startLocation = LatLng(latCurrentManager,longCurrentManager);

  GoogleMapController? mapController; //controller pour Google map
  PolylinePoints polylinePoints = PolylinePoints();

  String googleAPiKey = "AIzaSyDma7ThRPGokuU_cJ2Q_qFvowIpK35RAPs"; //google api
  Set<Marker> markers = {}; //markers for google map
  Map<PolylineId, Polyline> polylines = {};

  //polylines to show direction

  //liste des livreurs
  // Stream<List<UserModel>> databaseDeliver = UserService().getdelivers();

  @override
  void initState() {

  
  
    double latCurrentManager = manager.position.latitude;
    double longCurrentManager = manager.position.longitude;
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
        snippet: manager.name,
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
        snippet: manager.name,
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
    PolylineId id = const PolylineId('poly');
    Polyline polyline = Polyline(
      polylineId: id,
      color: Color.fromARGB(255, 77, 255, 130),
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
                target: LatLng(
                    manager.position.latitude, manager.position.longitude),
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
            left: kDefaultPadding/10,
            top: size.height * 0.7,
            right: kDefaultPadding/10,
            child: Container(
              color: Colors.white,
              
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
                            return ProfilDeliver(Deliver, manager);
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
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<void>('manager', manager));
  }
}


Widget Deliver(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            /* showModalBottomSheet(
                context: context, builder: ((builder) => bottomSheet()));*/
          },
          child: Stack(children: [
            Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                  border: Border.all(width: 4, color: Colors.white70),
                  boxShadow: [
                    BoxShadow(
                        spreadRadius: 2,
                        blurRadius: 10,
                        color: Colors.black.withOpacity(0.1))
                  ],
                  shape: BoxShape.circle,
                  // ignore: prefer_const_constructors
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: const AssetImage("assets/images/profil.png")
                      //  image: AssetImage("${user.tool}")
                      )),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(width: 4, color: Colors.white),
                    color: kPrimaryColor,
                    image: DecorationImage(
                        fit: BoxFit.cover, image: AssetImage(' deliver.name')
                        //  image: AssetImage("${user.tool}")
                        )),
               
              ),
            )
          ]),
        ),
        const SizedBox(
          height: 5,
        ),
        Text( 'deliver.name'),
      ],
    );
  }

  Widget distance(BuildContext context) {
    return Container(
      height: 5,
      width: 20,
      decoration:
          const BoxDecoration(shape: BoxShape.rectangle, color: kPrimaryColor),
      child: Text("vous etes a ${calculateDistance(1, 1, 1, 1)}"),
    );
  }

  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var a = 0.5 -
        cos((lat2 - lat1) * p) / 2 +
        cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

@override
Widget build(BuildContext context) {
  // TODO: implement build
  throw UnimplementedError();
}

 //late AsyncSnapshot<UserModel> usersnapshot;
  //final UserModel snapshot =snapshot.data.
                               
      


/**manager = UserModel(
          idUser: snapshot.idUser,
          adress: snapshot.adress,
          tool: snapshot.tool,
          phone: snapshot.phone,
          picture: snapshot.picture,
          isClient: snapshot.isClient,
          isDeliver: snapshot.isDeliver,
          isManager: snapshot.isManager,
          name: snapshot.name,
          position: snapshot.position) */
*/