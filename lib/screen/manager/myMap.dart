import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
//import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;
import 'package:geolocator/geolocator.dart';
import 'package:supply_app/models/Database_Model.dart';
import '../../services/position_service.dart';

class MyMap extends StatefulWidget {
  UserModel deliver; CommandModel command;
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
    location.changeSettings(interval: 30, accuracy: loc.LocationAccuracy.high);
    location.enableBackgroundMode(enable: true);
    
    //_listenLocation();

    Timer.periodic(const Duration(seconds: 3), (timer) async {
      //obtenir la position du livreur actuelle et l'affecter a deliverPosition
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      await PositionService()
          .updatePosition(widget.deliver.idPosition, position.latitude, position.longitude)
          .then(
        (value) {
          print("new position ${position.latitude} and ${position.longitude}");
          print(
              "wwwwwwwwwwwwwwwwolylineCoordinates object polylineCoordinates object polylineCoordinates object polylineCoordinates");
          _getPoints();
          _getPointsDo();
        },
      );
    });
    super.initState();
  }

 _getPointsDo() async {
    await PositionService().getPosition(widget.deliver.idPosition).then((value) async {
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
  }





  _getPoints() async {
    //  print("object polylineCoordinates object polylineCoordinates object polylineCoordinates object polylineCoordinates");
    await PositionService().getPosition(widget.deliver.idPosition).then((value) async {
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
    });

    if (result.status == 'OK' || resultDo.status == 'OK') {
      polylineCoordinates.clear();

      print("object $polylineCoordinates ");

      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
     /*  resultDo.points.forEach((PointLatLng point) {
        polylineCoordinatesDo.add(LatLng(point.latitude, point.longitude));
      }); */

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
            
            
/* 
             _polylines.add(Polyline(
              width: 6,
              // set the width of the polylines
              polylineId: polylineId,
              geodesic: true,
              consumeTapEvents: true,
              color: Colors.red,
              points: polylineCoordinatesDo)); */
      });
      
      /*  if (resultDo.status == 'OK') {
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
      } */
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
                            element.id == widget.deliver.idPosition)['latitude'],
                        long = snapshot.data!.docs.singleWhere((element) =>
                            element.id == widget.deliver.idPosition)['longitude'],
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
                    (element) => element.id ==widget.deliver.idPosition)['latitude'],
                snapshot.data!.docs.singleWhere(
                    (element) => element.id == widget.deliver.idPosition)['longitude'],
              ),
              zoom: 15.5),
          onMapCreated: (GoogleMapController controller) async {
            setState(() {
              _controller = controller;
              //  showPinsOnMap();
             // _getPoints();
              _getPointsDo();
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
    if (!(snapshot.data!.docs.singleWhere(
                (element) => element.id == widget.deliver.idPosition)['latitude'] ==
            end.latitude) &&
        !(snapshot.data!.docs.singleWhere(
                (element) => element.id ==widget.deliver.idPosition)['longitude'] ==
            end.longitude)) {
      await _controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
            target: LatLng(
              snapshot.data!.docs.singleWhere(
                  (element) => element.id == widget.deliver.idPosition)['latitude'],
              snapshot.data!.docs.singleWhere(
                  (element) => element.id == widget.deliver.idPosition)['longitude'],
            ),
            zoom: 15.5),
      ));
    } else {
      _added = false;
      // _stopListening();
    }
  }
}
