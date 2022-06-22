// ignore_for_file: prefer_const_constructors, unused_local_variable, non_constant_identifier_names
import 'dart:async';
import 'dart:ffi';

import 'dart:ui';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supply_app/common/constants.dart';
import 'package:supply_app/common/palette.dart';
import 'package:supply_app/services/auth_service.dart';
import 'package:supply_app/services/position_service.dart';
import 'package:supply_app/services/user_service.dart';
import 'package:telephony/telephony.dart';
import '../../../../models/Database_Model.dart';

class Tracking extends StatefulWidget {
  UserModel deliver;
  UserModel manager;
  CommandModel Command;
  Tracking(
      {Key? key,
      required this.deliver,
      required this.manager,
      required this.Command})
      : super(key: key);

  @override
  _TrackingState createState() => _TrackingState();
}

class _TrackingState extends State<Tracking> {
  GoogleMapController? mapController;
  // variables contenant les coordonees d'une position
  late double lat;
  late double long;
  PositionModel deliverPosition = new PositionModel(longitude: 0, latitude: 0);
  PositionModel myPosition = new PositionModel(longitude: 0, latitude: 0);
  PolylinePoints polylinePoints = PolylinePoints();
  Set<Polyline> _polylines = Set<Polyline>();
  LatLng currentManagerPosition = new LatLng(0, 0);
  // Map<PolylineId, Polyline> polylines = {}; //polylines to show direction
  String googleAPiKey ="AIzaSyDMvPHsbM0l51gW4shfWTHMUD-8Df-2UKU";                     //"AIzaSyDma7ThRPGokuU_cJ2Q_qFvowIpK35RAPs";
  List<LatLng> polylineCoordinates = [];
  Set<Marker> _markers= Set<Marker>();
   BitmapDescriptor? sourceIcon;
  BitmapDescriptor? destinationIcon;

  @override
  void initState() {
    // getCurrentLocation();

     getDirections();

    // polylinePoints=PolylinePoints();
    //this.setSourceAndDestinationMarkerIcon();
    super.initState();
  }

  void setSourceAndDestinationMarkerIcon(BuildContext context)  {
     sourceIcon =
        BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow);

     destinationIcon =
        BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange);
  }

  getDirections() async {
    await PositionService().getPosition('${widget.manager.idPosition}').then(
      (value) {
        setState(() {
          deliverPosition = value;
          currentManagerPosition = LatLng(value.latitude, value.longitude);
        });
        print(
            "dans le then la latitude manager est ${deliverPosition.latitude}, et sa longitude est ${deliverPosition.longitude}");
      },
    );

     _markers.add(Marker(
      //add distination location marker
      markerId: MarkerId(widget.manager.name),
      position: currentManagerPosition,
      infoWindow: InfoWindow(
        //popup info
        title: 'ma position Start ',
        snippet: widget.manager.name,
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow) //Icon for Marker
    ));

     _markers.add(Marker(
      //add distination location marker
      markerId: MarkerId("End"),
      position: LatLng(3.9954712, 9.7587145),
      infoWindow: InfoWindow(
        //popup info
        title: ' position End ',
        snippet: "End",
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange) //Icon for Marker
    ));

/*

3.9954712         9.7587145
 */
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      "AIzaSyDMvPHsbM0l51gW4shfWTHMUD-8Df-2UKU",
      PointLatLng(deliverPosition.latitude, deliverPosition.longitude),
      PointLatLng(4.000049, 9.7566187),
      travelMode: TravelMode.driving,
    );

    if (result.points.isNotEmpty && result.status == 'OK') {
      print("polines polines polines");
      result.points.forEach((PointLatLng point) {

         print(" coordinate coordinate coordinate");
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    } else {
      print('error de position  ${result.errorMessage}');

      setState(() {
         print('changer changer changer');
        _polylines.add(Polyline(
            polylineId: PolylineId('polylineId'),
            width: 10,
            color: Color.fromARGB(255, 145, 243, 33),
            points: polylineCoordinates));
      });
    }

    //  addPolyLine(polylineCoordinates);
  }

/*   addPolyLine(List<LatLng> polylineCoordinates) {
    PolylineId id = PolylineId('');
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.deepPurpleAccent,
      points: polylineCoordinates,
      width: 8,
    );
    polylines[id] = polyline;
    setState(() {});
  }

  //obtenir la position actuelle
  Future<void> getCurrentLocation() async {
    Timer.periodic(const Duration(seconds: 30), (timer) async {
      //obtenir la position du livreur actuelle et l'affecter a deliverPosition

      await PositionService().getPosition('${widget.deliver.idPosition}').then(
        (value) {
          setState(() {
            deliverPosition = value;
          });
          print(
              "dans le then la latitude manager est ${deliverPosition.latitude}, et sa longitude est ${deliverPosition.longitude}");
        },
      );

//obtenir la position actuelle du livreur
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.low);
      print(position);
      lat = position.latitude;
      long = position.longitude;

//definir le trajet a parcourir, le point de depart correspond a la position du livreur et le point d'arriver correspond a la position actuelle
      PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        "AIzaSyDma7ThRPGokuU_cJ2Q_qFvowIpK35RAPs",
        PointLatLng(deliverPosition.latitude, deliverPosition.longitude),
        PointLatLng(lat, long),
        travelMode: TravelMode.driving,
      );
      if (result.points.isNotEmpty) {
        result.points.forEach((PointLatLng point) {
          polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        });
      } else {
        print(result.errorMessage);
      }

//mettre a jour la position du livreur dans la bd
      deliverPosition.Latitude = lat;
      deliverPosition.Longitude = long;
      await PositionService().updatePosition(deliverPosition).then((value) {
        print("update reussi");
      });

      print('Cancel timer');
      timer.cancel();
    });

    // return await Geolocator.getCurrentPosition();
  } */

  @override
  Widget build(BuildContext context) {
    this.setSourceAndDestinationMarkerIcon(context);
    return Scaffold(
      //Visibility(visible: isVisible(), child: NavBar()),
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        //   backgroundColor: Colors.transparent,
        title: /* !isSearching
                  ? Text(
                      'Mon application',
                      style: GoogleFonts.philosopher(fontSize: 20),
                    )
                  : */
            Text('Mon application'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
          )
        ],
      ),
      body: /* SingleChildScrollView(
        child: */
          GoogleMap(
        zoomGesturesEnabled: true, //enable Zoom in, out on map
        mapType: MapType.normal,
        myLocationEnabled: true,
        initialCameraPosition: CameraPosition(
          target: this.currentManagerPosition,
          zoom: 10,
        ),
        //markers to show on map
        // polylines: Set<Polyline>.of(polylines.values), //polyl
        onMapCreated: (GoogleMapController controller) {
          mapController = controller;
        },
        markers: _markers,
        polylines: _polylines,
      ),

      // )

      // ),
    );
  }
}

AppBar buildAppBar() {
  return AppBar(
    backgroundColor: kPrimaryColor,
    title: Text(
      'suivi de la livraison',
      style: GoogleFonts.philosopher(fontSize: 20),
    ),
    centerTitle: true,
  );
}

/*


3.9954712          9.7587145


 */