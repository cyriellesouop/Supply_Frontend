// ignore_for_file: non_constant_identifier_names
import 'dart:math';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:supply_app/components/models/Database_Model.dart';
import 'package:supply_app/components/screen/manager/components/profil_deliver.dart';
import 'package:supply_app/components/screen/manager/tri_rapide.dart';
import 'package:supply_app/components/services/user_service.dart';
import 'package:supply_app/constants.dart';

import '../../../services/position_service.dart';

class ManagerHome extends StatefulWidget {
  //UserModel currentManager;
  String currentManagerID;
  ManagerHome({required this.currentManagerID, Key? key}) : super(key: key);
  @override
  _ManagerHomeState createState() => _ManagerHomeState();
}

class _ManagerHomeState extends State<ManagerHome> {
  // initialisation du manager courant
  UserModel currentManager = new UserModel(name: 'fabiol');
  //var Deliver = Map<UserModel, double>();
  var deliver;

  List<Map<String, dynamic>> tableauJson = [];

  List<Map<String, dynamic>> tableauJsontrie = [];

  //  LatLng startLocation = LatLng(latCurrentManager,longCurrentManager);

  GoogleMapController? mapController; //controller pour Google map
  PolylinePoints polylinePoints = PolylinePoints();

  String googleAPiKey = "AIzaSyDma7ThRPGokuU_cJ2Q_qFvowIpK35RAPs"; //google api
  //Marker est un tableau qui contient toutes les positions representees sur la map

  final Set<Marker> markers = new Set(); //markers for google map
  // Map<PolylineId, Polyline> polylines = {}; //polylines to show direction

  UserModel? exampleModel = new UserModel(name: 'fabiol');

  UserService ServiceUser = new UserService();
  PositionService ServicePosition = new PositionService();
  //PositionModel x = new PositionModel(longitude: 0, latitude: 0);
  LatLng currentManagerPosition = new LatLng(0, 0);
  PositionModel xdeliver = new PositionModel(longitude: 0, latitude: 0);
  LatLng ydeliver = new LatLng(0, 0);

  //tableau des identifiants des position de tous les livreurs
  List<UserModel> exampleModelDeliver = [];
  //liste des positions de tous les livreurs
  List<LatLng> listecoordonnees = [];
  List<double> Distances = [];
  List<double> DistanceInter = [];

  @override
  void initState() {
    // _listDeliver();
    getUserPosition();
    // print(' audrey cyrielle moguem${widget.currentManagerID}');
    //  getDirections(); //fetch direction polylines from Google API/Draw polyline direction routes in Google Map
    super.initState();
  }

  /* _listDeliver() async {
    await ServiceUser.getDelivers().forEach((element) {
      setState(() {
        this.exampleModelDeliver = element;
      });

      print(
          "le nombre de livreur est exactement ${exampleModelDeliver.length}");
    });

    print("le nombre de livreur est ${exampleModelDeliver.length}");
    return exampleModelDeliver.length;
  } */

  //liste de posiition des livreur
  getUserPosition() async {
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
        });
        print(
            "dans le then la latitude manager est ${currentManagerPosition.latitude}, et sa longitude est ${currentManagerPosition.longitude}");
      },
    );
    print(
        "la latitude du manager est ${currentManagerPosition.latitude}, et sa longitude est ${currentManagerPosition.longitude}");
    //end

//Maquer le manager courant
    markers.add(Marker(
      //add distination location marker
      markerId: MarkerId(ydeliver.toString()),
      position: currentManagerPosition,
      infoWindow: InfoWindow(
        //popup info
        title: 'ma position ',
        snippet: currentManager.name,
      ),
      icon: BitmapDescriptor.defaultMarker, //Icon for Marker
    ));

    //affiche la position du current manager
    print('curent usermanager position ${this.currentManager}');
    //recupere la liste de livreurs
    print('curent userposition ${this.currentManager}');
    await ServiceUser.getDelivers().forEach((element) async {
      //modifier la letat de la liste des livreurs
      setState(() {
        this.exampleModelDeliver = element;
      });

      var n = -1;
      //pour chaque livreur, on renvoie sa posion
      for (var i in this.exampleModelDeliver) {
        n++;
        await ServicePosition.getPosition(i.idPosition).then((value) {
          LatLng coordonnees = LatLng(value.latitude, value.longitude);

          print(
              'la coordonnees est actuellement la latitude:${coordonnees.latitude} et la longitude est :${coordonnees.longitude}');
          //modifier l'etat de la liste des positions de chaque livreurs et de la table des identifiants
          setState(() {
            listecoordonnees.add(coordonnees);
            print('la liste de coordonnees mise a jour est:$listecoordonnees');
             //mise a jour du tableau contenant les infos sur les livreurs et leur distance
            tableauJson.add({
              "Deliver": i,
              "Distance": getDistance(
                      this.currentManagerPosition, coordonnees)
                  
            });
            print('lacoordonnees est:$coordonnees');
             print('le tableau json mise a jour est:$listecoordonnees');

            //  Deliver[i]=getDistanceBetween(this.currentManagerPosition, this.listecoordonnees)[n];

         /*   deliver = {
              "Deliver": i,
              "Distance": getDistance(
                      this.currentManagerPosition, coordonnees)
                  
            };*/

           

            //marquage sur la map de tous les livreurs contenus dans la precedente liste
            //-------------------------------------------
            markers.add(Marker(
              //add start location marker
              markerId: MarkerId(coordonnees.toString()),
              position: coordonnees,

              infoWindow: InfoWindow(
                //popup info
                title: 'Livreur ${i.name} ',
                //le user name envoye depuis la page de validation
                snippet:
                    ' situe a ${getDistance(this.currentManagerPosition, coordonnees)} km de vous',
              ),
              icon: BitmapDescriptor.defaultMarker, //Icon for Marker
            ));

            print(
                'la tailles de liste des marqueurs est : ${markers.length} et les marqueurs sont : $markers');

            //marquage de tous les livreurs sur la map
            //-------------------------------------------
          });
        });
      }
     /*  setState(() {
       tableauJsontrie = TriRapidejson(table: tableauJson).QSort(0, n - 1) ;
      }); */
    });
  }

//widget final
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // final allDelivers = Provider.of<List<UserModel>>(context);
    var n = tableauJson.length;

  tableauJsontrie = TriRapidejson(table: tableauJson).QSort(0, n - 1) ;
  print('les distances sont :$listecoordonnees');

    print(
        'la table json esst $tableauJson');
    print('le tableau json trie est $tableauJsontrie');
    /* print(
        'la liste des distance et livreurs associees est ${TriRapide(table: this.DistanceInter).tableauTrie(this.Distances)}');
 */
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: size.height * 0.58,
            //height: size.height,
            child: GoogleMap(
              zoomGesturesEnabled: true, //enable Zoom in, out on map
              mapType: MapType.normal,
              myLocationEnabled: true,
              initialCameraPosition: CameraPosition(
                target: this.currentManagerPosition,
                zoom: 10,
              ),
              markers: this.markers, //markers to show on map
              // polylines: Set<Polyline>.of(polylines.values), //polyl
              onMapCreated: (GoogleMapController controller) {
                mapController = controller;
              },
            ),
          ),
          Container(
              height: size.height * 0.4,
              margin: const EdgeInsets.symmetric(vertical: kDefaultPadding / 4),
              child: Stack(
                children: [
                  Container(
                    width: size.width,
                    height: size.height * 0.1,
                    margin:
                        const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                    child: Column(
                      children: [
                        Text(
                          'contacter un livreur ss',
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
                    bottom: -40,
                    right: 0,
                    child: SizedBox(
                      height: size.height * 0.38,
                      child: ListView.builder(
                        //  shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        // itemCount: allDelivers.length,
                        itemCount: this.exampleModelDeliver.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ProfilDeliver(
                            deliver: this.exampleModelDeliver[index],
                            manager: this.currentManager,
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ))
        ],
      ),
    );
  }

//calcul de la distance entre deux positions
  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var a = 0.5 -
        cos((lat2 - lat1) * p) / 2 +
        cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

//supprime les doublons dans une liste
  List<double> tableauTrie(List<double> table) {
    int i, j, k;
    var n = table.length;
    for (i = 0; i < n; i++) {
      for (j = i + 1; j < n;) {
        if (table[j] == table[i]) {
          table.removeAt(j);
          n--;
        } else
          j++;
      }
    }
    return table;
  }

  List<Map<String, dynamic>> tableauTriejson(List<Map<String, dynamic>> table) {
    int i, j, k;
    var n = table.length;
    for (i = 0; i < n; i++) {
      for (j = i + 1; j < n;) {
        if (table[j]['Distance'] == table[i]['Distance'] &&
            table[j]['Deliver'] == table[i]['Deliver']) {
          table.removeAt(j);
          n--;
        } else
          j++;
      }
    }
    return table;
  }

//fonction qui renvoie la dstance des livreurs par rapport a la position du gerant
  List<double> getDistanceBetween(
      LatLng currentManagerPosition, List<LatLng> positionDeliverList) {
    var dist;
    for (var i in positionDeliverList) {
      dist = calculateDistance(currentManagerPosition.latitude,
          currentManagerPosition.longitude, i.latitude, i.longitude);
      setState(() {
        DistanceInter.add(dist);
      });
    }
    var n = this.DistanceInter.length;
    setState(() {
      Distances = TriRapide(table: this.DistanceInter).QSort(0, n - 1);
    });
    //  return tableauTrie(Distances);
    return DistanceInter;
    // TriRapide(table: this.DistanceInter).tableauTrie(this.DistanceInter);
  }

  double getDistance(
      LatLng currentManagerPosition, LatLng positionDeliverList) {
    var dist;

    dist = calculateDistance(
        currentManagerPosition.latitude,
        currentManagerPosition.longitude,
        positionDeliverList.latitude,
        positionDeliverList.longitude);

    //  return tableauTrie(Distances);
    return dist;
    // TriRapide(table: this.DistanceInter).tableauTrie(this.DistanceInter);
  }
}

@override
Widget build(BuildContext context) {
  // TODO: implement build
  throw UnimplementedError();
}
