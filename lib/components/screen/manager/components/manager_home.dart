// ignore_for_file: non_constant_identifier_names
import 'dart:convert';
import 'dart:math';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:supply_app/components/models/Database_Model.dart';
import 'package:supply_app/components/screen/manager/tri_rapide.dart';
import 'package:supply_app/components/services/user_service.dart';
import 'package:supply_app/constants.dart';

import '../../../services/position_service.dart';
import '../menu_content/nav_bar.dart';

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
  // var deliver = null;
  bool isdeliver = false;
  bool isDev = false;
//pour le appBar
  bool isSearching = false;
  var deliver =null;
  var Dev = UserModel(name: 'audrey');
  Map<String, dynamic> tab = {
    'Deliver': UserModel(name: 'audrey'),
    'Distance': 0
  };

  List<Map<String, dynamic>> tableauJson = [];
  List<Map<String, dynamic>> tableauJsontrie = [];
  List<UserModel> DeliverSort = [];

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
              //json.decode9tableaujson[i]['Deliver']
              "Deliver": i.toMap(),
              "Distance": getDistance(this.currentManagerPosition, coordonnees)
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
                icon: BitmapDescriptor.defaultMarker,
                onTap: () {
                  setState(() {
                    isDev = false;
                    // deliver=DeliverSort[index];
                    // deliver = tableauJsontrie[index];
                    Dev = i;
                  });
                  Dev != UserModel(name: 'audrey')
                      ? isDev = true
                      : isDev = false;
                } //Icon for Marker
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

    tableauJsontrie =tableauTrie(TriRapidejson(table: tableauJson).QSort(0, n - 1)) ;
    // DeliverSort = listeTrie(tableauJsontrie);
    print('les distances sont :${exampleModelDeliver}');

    print('la table json esst $tableauJson');
print('le tableau json trie est ${tableauJsontrie.length}');
    /* print(
        'la liste des distance et livreurs associees est ${TriRapide(table: this.DistanceInter).tableauTrie(this.Distances)}');
 */
    return Scaffold(
      drawer: NavBar(), //Visibility(visible: isVisible(), child: NavBar()),
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: /* !isSearching
                  ? Text(
                      'Mon application',
                      style: GoogleFonts.philosopher(fontSize: 20),
                    )
                  : */
              TextField(
            decoration: InputDecoration(
              /*  icon: Icon(
                  Icons.search,
                  color: Colors.white,
                  size: 26,
                ), */
              hintText: "Rechercher un livreur",
              hintStyle: TextStyle(color: Colors.white70),
              // fillColor: kPrimaryColor
            ),
          ),
          //visibilite des elements de la appbar
          actions: <Widget>[
            // !isSearching ?
            Visibility(
              visible: isVisible(),
              child: Padding(
                  padding: EdgeInsets.only(right: 10.0),
                  child: IconButton(
                    icon: Icon(
                      Icons.search,
                      size: 26,
                    ),
                    onPressed: () {
                      setState(() {
                        this.isSearching = !this.isSearching;
                      });
                    },
                  )),
            ),
            /*  Visibility(
              visible: isVisible(),
              child: Padding(
                  padding: EdgeInsets.only(right: 10.0),
                  child: GestureDetector(
                    onTap: () {},
                    child: Icon(Icons.more_vert),
                  )),
            ), */
          ]),
      body: /* SingleChildScrollView(
        child: */
          Column(
        children: [
          Container(
            height: size.height * 0.42,
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
              height: size.height * 0.43,
              margin: const EdgeInsets.symmetric(vertical: kDefaultPadding / 5),
              child: Stack(
                children: [
                  Container(
                    width: size.width,
                    height: size.height * 0.08,
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
                    top: 42,
                    bottom: 0,
                    right: 0,
                    //  child: SizedBox(
                    child: Container(
                      // height: size.height * 0.5,
                      child: Column(
                        //  mainAxisSize: MainAxisSize.min,
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        // scrollDirection: Axis.vertical,
                        children: [
                          Expanded(
                            // flex: 2,
                            child: ListView.builder(
                              //  shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              // itemCount: allDelivers.length,
                              itemCount: this.tableauJsontrie.length,
                              //  itemCount: this.exampleModelDeliver.length,
                              itemBuilder: (BuildContext context, int index) {
                                return InkWell(
                                  child: Container(
                                    child: GetItem(index),
                                  ),
                                  onTap: () {
                                    setState(() {
                                      isdeliver = false;
                                      // deliver=DeliverSort[index];
                                      // deliver = tableauJsontrie[index];
                                      deliver = this.tableauJsontrie[index];
                                      tab = this.tableauJsontrie[index];
                                    });
                                    deliver != UserModel(name: 'audrey')
                                        ? isdeliver = true
                                        : isdeliver = false;
                                    print(
                                        'livreur est : $deliver et $isdeliver');

                                    //  });
                                  },
                                );
                              },
                            ),
                          ),
                          /*  Visibility(
                            visible: isdeliver,

                            child: Text(
                                'situe a ${tab['Distance']} km de vous',
                                // Text('${tableauJsontrie[index]['Deliver']['name']}',
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w500, fontSize: 15)),
                            // ),
                          ), */
                          /*   Visibility(
                                visible: isdeliver,
                                child: */
                          //  Expanded(
                          //   flex: 1,
                          //  child:
                         Visibility(
                            visible: isdeliver,
                            child: Column(
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Container(
                                    margin: EdgeInsets.only(left: 10),
                                    padding: EdgeInsets.all(5),
                                    height: 40,
                                    width: size.width * 0.68,
                                    color: Color.fromARGB(255, 248, 246, 248),
                                    
                                      child: Text(
                                          'situe a ${tab['Distance']} km de vous',
                                          // Text('${tableauJsontrie[index]['Deliver']['name']}',
                                          style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 15,
                                          ),),
                                    
                                  ),
                                ),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      FlatButton(
                                        minWidth: size.width * 0.7,
                                        onPressed: () {},

                                        padding: EdgeInsets.all(5),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        color: kPrimaryColor,
                                        textColor: kBackgroundColor,
                                        child: Text(
                                          'CONFIRMER   ${deliver['Deliver']['name']} '.toUpperCase(),
                                          //${this.exampleModelDeliver[index].name}',
                                          //${user.name} ',
                                          style:
                                              GoogleFonts.poppins(fontSize: 15),
                                        ),

                                        // width: size.width * 0.7 ,
                                        // child: FlatButton,
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
                            ) 
                          )
                         
                          //  ),
                          //  )
                          //  Visibility(child: bottom(deliver),visible: true,)
                          // isdeliver?Container():bottom(deliver)//:Container()
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
  Widget GetItem(int index) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        Stack(children: [
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
                    fit: BoxFit.cover, //image: AssetImage("${deliver.picture}")

                    image: const AssetImage("assets/images/profil.png"))),
          ),
          Positioned(
            bottom: size.width * 0.14,
            right: size.width * 0.005,
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
        // Text( 'deliver.name'),
     //   Text('${this.exampleModelDeliver[index].name}',
               Text( tableauJsontrie[index]['Deliver']['name'],
            style:
                GoogleFonts.poppins(fontWeight: FontWeight.w500, fontSize: 15)),
        const SizedBox(
          height: 10,
        ),
        // Text( 'deliver.name'),

        //   isdeliver ? bottom(index) : Container(),
      ],
    );
  }

  Widget bottom(Map<String,dynamic> tab) {
    // Widget bottom(index) {
    Size size = MediaQuery.of(context).size;

    return Row(children: [
      FlatButton(
        minWidth: size.width * 0.7,
        onPressed: () {},
        padding: EdgeInsets.all(15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        color: kPrimaryColor,
        textColor: kBackgroundColor,
        child: Text(
          'CONFIRMER ${tab['Deliver']['name']} ',
          //${this.exampleModelDeliver[index].name}',
          //${user.name} ',
          style: GoogleFonts.poppins(fontSize: 15),
        ),

        // width: size.width * 0.7 ,
        // child: FlatButton,
      ),
      SizedBox(
        width: 10,
      ),
      Container(
        height: 30,
        width: 30,
        decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.white70),
            shape: BoxShape.circle,
            image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage("assets/images/profil.png"))),
      ),
    ]);
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
        if (table[j]['Distance'] == table[i]['Distance'] && table[j]['Deliver']['name'] == table[i]['Deliver']['name']&&table[j]['Deliver']['adress'] == table[i]['Deliver']['adress']) {
          table.removeAt(j);
          n--;
        } else
          j++;
      }
    }
    return table;
  }

  

  
//fonction qui renvoie la dstance des livreurs par rapport a la position du gerant
  /* List<double> getDistanceBetween(
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
  } */

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
