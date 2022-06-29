import 'dart:async';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;
import 'package:geolocator/geolocator.dart';
import 'package:supply_app/models/Database_Model.dart';
import '../../../services/position_service.dart';

class MyMap extends StatefulWidget {
  UserModel deliver;
  CommandModel command;
  LatLng start;
  MyMap({required this.deliver, required this.command, required this.start});
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
  List<LatLng> polylineCoordinatesDo = [];
  PolylineResult result = PolylineResult();
  PolylineResult resultDo = PolylineResult();
  PolylinePoints polylinePoints = PolylinePoints();
  bool _added = false;
  LatLng end = LatLng(3.9947403, 9.7623602);
  LatLng start = LatLng(0, 0);
  var lat, long;
  int polyId = 1;

  @override
  void initState() {
    print(
        'sequence , sequence, sequence, sequence,sequence sequence sequence sequence sequence sequence sequence sequence ');
    print("position position et id ${""}");
    location.changeSettings(interval: 30, accuracy: loc.LocationAccuracy.high);
    location.enableBackgroundMode(enable: true);
    Timer.periodic(const Duration(seconds: 3), (timer) async {
      //obtenir la position du livreur actuelle et l'affecter a deliverPosition
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      await PositionService()
          .updatePosition(
              "WEEl08mc4fIo0WoVKtEI", position.latitude, position.longitude)//widget.deliver.idPosition
          .then(
        (value) {
          _getPoints();
        },
      );
    });
    super.initState();
  }

  /* _getPointsDo() async {
    await PositionService().getPosition("").then((value) async {
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
        polylineCoordinatesDo.clear();
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
  }

 */
  _getPoints() async {
    //  print("object polylineCoordinates object polylineCoordinates object polylineCoordinates object polylineCoordinates");
    /*  await PositionService().getPosition("").then((value) async {
      setState(() {
        start = LatLng(value.latitude, value.longitude);
      });
      result = await PolylinePoints().getRouteBetweenCoordinates(
        "AIzaSyDMvPHsbM0l51gW4shfWTHMUD-8Df-2UKU",
        PointLatLng(start.latitude, start.longitude),
        PointLatLng(3.9947403, 9.7623602),
        travelMode: TravelMode.driving,
      );
   /*    resultDo = await polylinePoints.getRouteBetweenCoordinates(
        "AIzaSyDMvPHsbM0l51gW4shfWTHMUD-8Df-2UKU",
        PointLatLng(widget.start.latitude, widget.start.longitude),
        PointLatLng(start.latitude, start.longitude),
        travelMode: TravelMode.driving,
      ); */
    }); */
    result = await PolylinePoints().getRouteBetweenCoordinates(
      "AIzaSyDMvPHsbM0l51gW4shfWTHMUD-8Df-2UKU",
      PointLatLng(3.9950251, 9.753057),
      PointLatLng(3.9947403, 9.7623602),
      travelMode: TravelMode.driving,
    );
    if (result.status == 'OK' || resultDo.status == 'OK') {
      //  polylineCoordinates.clear();
      print("object $polylineCoordinates ");
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
      final String polylineIdVal = 'polyline_id_$polyId';
      polyId++;
      final PolylineId polylineId = PolylineId(polylineIdVal);
      _polylines = new Set<Polyline>();
    //  setState(() {
        _polylines.add(Polyline(
            width: 6,
            // set the width of the polylines
            polylineId: polylineId,
            geodesic: true,
            consumeTapEvents: true,
            color: Colors.blue,
            points: polylineCoordinates));
     // });
    }
  }

  @override
  Widget build(BuildContext context) {
    print(
        "widdddddddddddddddddddddddddddddddddddddddget ${widget.start.latitude}");
    print("del del del ${widget.deliver}");
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
          markers: (!(getDistance( LatLng(3.9950251, 9.753057), end) == 0.001)) //position start LatLng(3.9950251, 9.753057)
              ? {
                  Marker(
                    //position start
                      position: LatLng(3.9950251, 9.753057),
                      markerId: MarkerId('start'),
                      infoWindow: InfoWindow(
                          title: 'position Initial ',
                          snippet: '$lat et $long '),
                      icon: BitmapDescriptor.defaultMarker),
                  Marker(
                    
                      position: LatLng(
                        lat = snapshot.data!.docs.singleWhere((element) =>
                            element.id == "WEEl08mc4fIo0WoVKtEI")['latitude'],//widget.deliver.idPosition
                        long = snapshot.data!.docs.singleWhere((element) =>
                            element.id == "WEEl08mc4fIo0WoVKtEI")['longitude'],//widget.deliver.idPosition
                      ),
                      markerId: MarkerId('start'),
                      infoWindow: InfoWindow(
                          title: '${widget.deliver.name} ',
                          snippet: '$lat et $long '),
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
                snapshot.data!.docs.singleWhere((element) =>
                    element.id == "WEEl08mc4fIo0WoVKtEI")['latitude'],//widget.deliver.idPosition
                snapshot.data!.docs.singleWhere((element) =>
                    element.id == "WEEl08mc4fIo0WoVKtEI")['longitude'],//widget.deliver.idPosition
              ),
              zoom: 14),
          onMapCreated: (GoogleMapController controller) async {
            setState(() {
              _controller = controller;
              _getPoints();
              //  _getPointsDo();
              _added = true;
            });
          },
        );
      },
    ));
  }

  /*  Future<Placemark> getCity(double latitude, double longitude) async {
    var addresses = await GeocodingPlatform.instance
        .placemarkFromCoordinates(latitude, longitude);
    var first = addresses.first;
    return first;
  } */

  Future<void> mymap(AsyncSnapshot<QuerySnapshot> snapshot) async {
    var lat = snapshot.data!.docs.singleWhere(
        (element) => element.id == "WEEl08mc4fIo0WoVKtEI")['latitude'];//widget.deliver.idPosition
    var long = snapshot.data!.docs.singleWhere(
        (element) => element.id == "WEEl08mc4fIo0WoVKtEI")['longitude'];//widget.deliver.idPosition
    var isOk = LatLng(lat, long);

    if (!(getDistance(isOk, end) == 0.001)) {
      await _controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
            target: LatLng(
              snapshot.data!.docs.singleWhere((element) =>
                  element.id == "WEEl08mc4fIo0WoVKtEI")['latitude'],//widget.deliver.idPosition
              snapshot.data!.docs.singleWhere((element) =>
                  element.id == "WEEl08mc4fIo0WoVKtEI")['longitude'],//widget.deliver.idPosition
            ),
            zoom: 14),
      ));
    } else {
      _added = false;
    }
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

  //calcul de la distance entre deux positions
  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var a = 0.5 -
        cos((lat2 - lat1) * p) / 2 +
        cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
    var x = 12742 * asin(sqrt(a));
    return roundDouble(x, 3);
  }

  //fonction pour arrondir
  double roundDouble(double value, int places) {
    num mod = pow(10.0, places);
    return ((value * mod).round().toDouble() / mod);
  }
}
