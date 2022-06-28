 import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:supply_app/screen/accueil/splash.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); 
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackground);
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true, badge: true, sound: true);
  runApp(MyApp());
  configLoading();
}
const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', //id
    'High Importance Notifications', //title
    description: 'This channel is used for important notifications.',
    importance: Importance.high,
    playSound: true);
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
Future<void> _firebaseMessagingBackground(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("message just show :${message.messageId}");
}
//onloading bar
void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.yellow
    ..backgroundColor = Colors.green
    ..indicatorColor = Colors.yellow
    ..textColor = Colors.yellow
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = true
    ..dismissOnTap = false;
  // ..customAnimation = CustomAnimation();
}

class MyApp extends StatelessWidget {
  // final bool showHome; final String identifiant;
  const MyApp({Key? key}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
      builder: EasyLoading.init(),
    );
  }
}


/* 
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;
//import 'package:permission_handler/permission_handler.dart';
import 'package:supply_app/screen/manager/myMap.dart';

import 'services/position_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(home: MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final loc.Location location = loc.Location();
  StreamSubscription<loc.LocationData>? _locationSubscription;
  LatLng start= LatLng(0.0,0.0);

  @override
  void initState() {
    super.initState();
    // _requestPermission();
    //   location.changeSettings(interval: 30, accuracy: loc.LocationAccuracy.high);
    //  location.enableBackgroundMode(enable: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('live location tracker'),
      ),
      body: Column(
        children: [
          TextButton(
              onPressed: () {
                //  _getLocation();
              },
              child: Text('add my location')),
          TextButton(
              onPressed: () {
                // _listenLocation();
              },
              child: Text('enable live location')),
          TextButton(
              onPressed: () {
                //  _stopListening();
              },
              child: Text('stop live location')),
          Expanded(
              child: StreamBuilder(
            stream:
                FirebaseFirestore.instance.collection('position').snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }
              return ListView.builder(
                  itemCount: snapshot.data?.docs.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(snapshot.data!.docs[index]['idPosition']),
                      subtitle: Row(
                        children: [
                          Text(snapshot.data!.docs[index]['latitude']
                              .toString()),
                          SizedBox(
                            width: 20,
                          ),
                          Text(snapshot.data!.docs[index]['longitude']
                              .toString()),
                        ],
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.directions),
                        onPressed: () async {
                         await PositionService()
                              .getPosition("rn7eCZlyoIwTZGf5so8J")
                              .then((value) async {
                            // const startIn= LatLng(value.latitude, value.longitude);
                            setState(() {
                               start =
                                  LatLng(value.latitude, value.longitude);
                            });
                          }); 
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  MyMap(start: start, user_id: "rn7eCZlyoIwTZGf5so8J",)));
                        },
                      ),
                    );
                  });
            },
          )),
        ],
      ),
    );
  }



  /* _getPointsDo() async {
    await PositionService().getPosition(widget.user_id).then((value) async {
      // const startIn= LatLng(value.latitude, value.longitude);
      setState(() {
        start = LatLng(value.latitude, value.longitude);
      });

      resultDo = await polylinePoints.getRouteBetweenCoordinates(
        "AIzaSyDMvPHsbM0l51gW4shfWTHMUD-8Df-2UKU",
        PointLatLng(widget.start.latitude, widget.start.longitude),
        PointLatLng(start.latitude, start.longitude),
        travelMode: TravelMode.driving,
      );
    });

    //polilynes results ondone

    if (resultDo.status == 'OK') {
      //  polylineCoordinates.clear();
      resultDo.points.forEach((PointLatLng point) {
        polylineCoordinatesDo.add(LatLng(point.latitude, point.longitude));
      });
      final String polylineIdVal = 'polyline_id_$polyId';
      polyId++;
      final PolylineId polylineId = PolylineId(polylineIdVal);
      _polylines = new Set<Polyline>();
      setState(() {
        _polylines.add(Polyline(
            width: 6,
            // set the width of the polylines
            polylineId: polylineId,
            geodesic: true,
            consumeTapEvents: true,
            color: Colors.red,
            points: polylineCoordinatesDo));
      });
    }
  } */







/*   _getLocation() async {
    try {
      final loc.LocationData _locationResult = await location.getLocation();
      await FirebaseFirestore.instance.collection('location').doc('user1').set({
        'latitude': _locationResult.latitude,
        'longitude': _locationResult.longitude,
        'name': 'john'
      }, SetOptions(merge: true));
    } catch (e) {
      print(e);
    }
  }

  Future<void> _listenLocation() async {
    _locationSubscription = location.onLocationChanged.handleError((onError) {
      print(onError);
      _locationSubscription?.cancel();
      setState(() {
        _locationSubscription = null;
      });
    }).listen((loc.LocationData currentlocation) async {
      await FirebaseFirestore.instance.collection('position').doc('rn7eCZlyoIwTZGf5so8J').set({
        'latitude': currentlocation.latitude,
        'longitude': currentlocation.longitude,
        //'name': 'john'
      }, SetOptions(merge: true));
    });
  }

  _stopListening() {
    _locationSubscription?.cancel();
    setState(() {
      _locationSubscription = null;
    });
  } */

  /* _requestPermission() async {
    var status = await Permission.location.request();
    if (status.isGranted) {
      print('done');
    } else if (status.isDenied) {
      _requestPermission();
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
    }
  } */

  //obtenir la position actuelle
  Future<void> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
//Si vous souhaitez vérifier si l'utilisateur a déjà accordé des autorisations pour acquérir l'emplacement de l'appareil
    permission = await Geolocator.checkPermission();
//checkPermissionméthode renverra le LocationPermission.deniedstatut, lorsque le navigateur ne prend pas en charge l'API JavaScript Permissions
    if (permission == LocationPermission.denied) {
      //Si vous souhaitez demander l'autorisation d'accéder à l'emplacement de l'appareil, vous pouvez appeler la requestPermiss
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        getCurrentLocation();
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // return await Geolocator.getCurrentPosition();
  }
}


import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
//import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;
import 'package:geolocator/geolocator.dart';
import '../../services/position_service.dart';

class MyMap extends StatefulWidget {
  final String user_id;
  MyMap(this.user_id);
  @override
  _MyMapState createState() => _MyMapState();
}

class _MyMapState extends State<MyMap> {
  var adress, latitude, longitude;
  final loc.Location location = loc.Location();
  late GoogleMapController _controller;
  StreamSubscription<loc.LocationData>? _locationSubscription;
  Set<Marker> _markers = Set<Marker>();
  Set<Polyline> _polylines = Set<Polyline>();
  List<LatLng> polylineCoordinates = [];
  PolylineResult result = PolylineResult();
  PolylinePoints polylinePoints = PolylinePoints();
  bool _added = false;
  LatLng end = LatLng(3.9947403, 9.7623602);
  LatLng start = LatLng(0, 0);
  var lat, long;
  int polyId = 1;

  @override
  void initState() {
    location.changeSettings(interval: 30, accuracy: loc.LocationAccuracy.high);
    location.enableBackgroundMode(enable: true);
    //_listenLocation();
    Timer.periodic(const Duration(seconds: 3), (timer) async {
     
      //obtenir la position du livreur actuelle et l'affecter a deliverPosition
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      await PositionService()
          .updatePosition(widget.user_id, position.latitude, position.longitude)
          .then(
        (value) {

          print("new position ${position.latitude} and ${position.longitude}");
             print("wwwwwwwwwwwwwwwwolylineCoordinates object polylineCoordinates object polylineCoordinates object polylineCoordinates");
          _getPoints();
        },
      );
    });
    super.initState();
  }

  _getPoints() async {
   //  print("object polylineCoordinates object polylineCoordinates object polylineCoordinates object polylineCoordinates");
    await PositionService().getPosition(widget.user_id).then((value) async {
      setState(() {
        start = LatLng(value.latitude, value.longitude);
      });
      result = await polylinePoints.getRouteBetweenCoordinates(
        "AIzaSyDMvPHsbM0l51gW4shfWTHMUD-8Df-2UKU",
        PointLatLng(start.latitude, start.longitude),
        PointLatLng(3.9947403, 9.7623602),
        travelMode: TravelMode.driving,
      );
    });
    

    if (result.status == 'OK') {
      polylineCoordinates.clear();
       print("object $polylineCoordinates ");
       
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
      final String polylineIdVal = 'polyline_id_$polyId';
      polyId++;
      final PolylineId polylineId = PolylineId(polylineIdVal);
      _polylines = new Set<Polyline>();
      setState(() {
       
        _polylines.add(Polyline(
            width: 6,
            // set the width of the polylines
            polylineId: polylineId,
            geodesic: true,
            consumeTapEvents: true,
            color: Colors.blue,
            points: polylineCoordinates));
       
      });
    }
  }

/*   _stopListening() {
    _locationSubscription?.cancel();
    setState(() {
      _locationSubscription = null;
    });
  } */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder(
      stream: FirebaseFirestore.instance.collection('position').snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (_added) {
          mymap(snapshot);
        }
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        return GoogleMap(
          mapType: MapType.normal,
          markers: (!(start.latitude == end.latitude) &&
                  !(start.longitude == end.longitude))
              ? {
                  Marker(
                      position: LatLng(
                        lat = snapshot.data!.docs.singleWhere((element) =>
                            element.id == widget.user_id)['latitude'],
                        long = snapshot.data!.docs.singleWhere((element) =>
                            element.id == widget.user_id)['longitude'],
                      ),
                      markerId: MarkerId('start'),
                      infoWindow: InfoWindow(
                          title: 'ma position ', snippet: '$lat et $long '),
                      icon: BitmapDescriptor.defaultMarkerWithHue(
                          BitmapDescriptor.hueMagenta)),
                  Marker(
                      //add distination location marker
                      markerId: MarkerId("End"),
                      position: end,
                      infoWindow: InfoWindow(
                        //popup info
                        title: ' position End ',
                        snippet: "${end.latitude} et ${end.longitude}",
                      ),
                      icon: BitmapDescriptor.defaultMarkerWithHue(
                          BitmapDescriptor.hueOrange) //Icon for Marker
                      )
                }
              : {
                  Marker(
                      //add distination location marker
                      markerId: MarkerId("End"),
                      position: end,
                      infoWindow: InfoWindow(
                        //popup info
                        title: ' position End ',
                        snippet: "${end.latitude} et ${end.longitude}",
                      ),
                      icon: BitmapDescriptor.defaultMarkerWithHue(
                          BitmapDescriptor.hueOrange) //Icon for Marker
                      ),
                },
          polylines: _polylines,
          initialCameraPosition: CameraPosition(
              target: LatLng(
                snapshot.data!.docs.singleWhere(
                    (element) => element.id == widget.user_id)['latitude'],
                snapshot.data!.docs.singleWhere(
                    (element) => element.id == widget.user_id)['longitude'],
              ),
              zoom: 15.5),
          onMapCreated: (GoogleMapController controller) async {
            setState(() {
              _controller = controller;
            //  showPinsOnMap();
              _getPoints();
              _added = true;
            });
          },
        );
      },
    ));
  }

/*   void showPinsOnMap() {
    if (!(start.latitude == start.latitude) &&
        !(end.longitude == end.longitude)) {
      var pinPosition = LatLng(start.latitude, start.longitude);

      _markers.add(Marker(
          markerId: MarkerId('sourcePin'),
          position: pinPosition,
          onTap: () {},
          icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueViolet)));
      // destination pin
      _markers.add(Marker(
          markerId: MarkerId('destPin'),
          position: end,
          onTap: () {},
          icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueYellow)));
      _getPoints();
    }
  } */

  /*  Future<Placemark> getCity(double latitude, double longitude) async {
    var addresses = await GeocodingPlatform.instance
        .placemarkFromCoordinates(latitude, longitude);
    var first = addresses.first;
    return first;
  } */

  Future<void> mymap(AsyncSnapshot<QuerySnapshot> snapshot) async {
    if (!(snapshot.data!.docs.singleWhere(
                (element) => element.id == widget.user_id)['latitude'] ==
            end.latitude) &&
        !(snapshot.data!.docs.singleWhere(
                (element) => element.id == widget.user_id)['longitude'] ==
            end.longitude)) {
      await _controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
            target: LatLng(
              snapshot.data!.docs.singleWhere(
                  (element) => element.id == widget.user_id)['latitude'],
              snapshot.data!.docs.singleWhere(
                  (element) => element.id == widget.user_id)['longitude'],
            ),
            zoom: 15.5),
      ));
    } else {
      _added = false;
     // _stopListening();
    }
  }
}




 */