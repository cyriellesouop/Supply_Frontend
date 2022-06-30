// ignore_for_file: must_be_immutable
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supply_app/common/constants.dart';

import '../../../models/Database_Model.dart';


class ProfilDeliver extends StatelessWidget {
 // final UserModel deliver;
 final Map<String, dynamic> deliver;
  UserModel manager;
  // CachedNetworkImage.logLevel = CacheManagerLogLevel.debug;
  //double latmanager,longmanager,latdeliver,longdeliver;
  ProfilDeliver({required this.deliver, required this.manager, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        InkWell(
          onTap: () {
            Container(
              margin: EdgeInsets.only(top: size.height* 0.8, left: 2, right: 2, bottom: 2),
              width: size.width,
              height: 40,
              child: Row(
                children: [
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
                      'CONFIRMER ${deliver['Deliver']['name']} ',
                      style: GoogleFonts.poppins(fontSize: 15),
                    ),

                    // width: size.width * 0.7 ,
                    // child: FlatButton,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                    width: size.width * 0.25,
                    height: 40,
                    decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.white70),
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage("assets/images/profil.png"))),
                  ),
                ],
              ),
            );
            /* showModalBottomSheet(
                context: context, builder: ((builder) => bottomSheet()));*/
          },
          child: Stack(children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: kDefaultPadding / 2),
              width: size.width * 0.35,
              height: size.width * 0.35,
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
                  /*  image:  CachedNetworkImageProvider(
                  'https://via.placeholder.com/350x150',
                ), */
                  image: DecorationImage(
                      fit: BoxFit
                          .cover, //image: AssetImage("${deliver.picture}")

                      image: const AssetImage("assets/images/profil.png"))),
            ),
            //   CachedNetworkImage(imageUrl: 'https://via.placeholder.com/350x150'),
            Positioned(
              bottom: size.width * 0.22,
              right: size.width * 0.02,
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
        ),
        const SizedBox(
          height: 8,
        ),
        // Text( 'deliver.name'),
        Text(deliver['Deliver']['name'],
            style:
                GoogleFonts.poppins(fontWeight: FontWeight.w500, fontSize: 15)),
      ],
    );
  }



  /* Widget distance(BuildContext context) {
    return Container(
      height: 5,
      width: 20,
      decoration:
          const BoxDecoration(shape: BoxShape.rectangle, color: kPrimaryColor),
      child: Text("vous etes a ${calculateDistance(this.latmanager, this.longmanager, this.latdeliver, this.longdeliver)}"),
    //  child: Text("vous etes a ${calculateDistance(9.9, 10.0, 10.1, 11.1)}"),
    );
  }*/

}
