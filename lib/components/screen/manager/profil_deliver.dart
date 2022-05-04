// ignore_for_file: must_be_immutable

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:supply_app/components/models/Database_Model.dart';
import '../../../constants.dart';

class ProfilDeliver extends StatelessWidget {
   UserModel deliver;
  UserModel manager;
  ProfilDeliver(this.deliver,this.manager, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                        fit: BoxFit.cover, image: AssetImage( deliver.name)
                        //  image: AssetImage("${user.tool}")
                        )),
               
              ),
            )
          ]),
        ),
        const SizedBox(
          height: 5,
        ),
        Text( deliver.name),
      ],
    );
  }

  Widget distance(BuildContext context) {
    return Container(
      height: 5,
      width: 20,
      decoration:
          const BoxDecoration(shape: BoxShape.rectangle, color: kPrimaryColor),
      child: Text("vous etes a ${calculateDistance(manager.position.latitude, manager.position.longitude, deliver.position.latitude, deliver.position.longitude)}"),
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
