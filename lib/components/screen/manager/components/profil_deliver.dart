// ignore_for_file: must_be_immutable

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:supply_app/components/models/Database_Model.dart';
import '../../../../constants.dart';

class ProfilDeliver extends StatelessWidget {
  //UserModel deliver;
 // UserModel manager;
 // double latmanager,longmanager,latdeliver,longdeliver;
 // ProfilDeliver(this.deliver,this.manager,this.latmanager,this.longmanager,this.latdeliver,this.longdeliver, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
     Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        InkWell(
          onTap: () {
            /* showModalBottomSheet(
                context: context, builder: ((builder) => bottomSheet()));*/
          },
          child: Stack(children: [
            Container(
              width: size.width*0.35,
              height: size.width*0.35,
              decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.white),
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
              bottom: size.width*0.22,
              right: size.width*0.02,
              child: Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(width: 0,color: Colors.transparent ),
                    //color: Colors.white),
                    color: kPrimaryColor,
                    image: DecorationImage(
                        fit: BoxFit.cover, image: AssetImage( 'assets/images/profil.png')
                        //  image: AssetImage("${user.tool}")
                        )),
               
              ),
            )
          ]),
        ),
        const SizedBox(
          height: 10,
        ),
        Text( 'deliver.name'),
       // Text( deliver.name),
      ],
    );
  }

  Widget distance(BuildContext context) {
    return Container(
      height: 5,
      width: 20,
      decoration:
          const BoxDecoration(shape: BoxShape.rectangle, color: kPrimaryColor),
    //  child: Text("vous etes a ${calculateDistance(this.latmanager, this.longmanager, this.latdeliver, this.longdeliver)}"),
      child: Text("vous etes a ${calculateDistance(9.9, 10.0, 10.1, 11.1)}"),
    );
  }

  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var a = 0.5 -
        cos((lat2 - lat1) * p) / 2 +
        cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }
}
