import 'package:flutter/material.dart';
import 'package:supply_app/models/Database_Model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supply_app/common/constants.dart';

import '../../common/palette.dart';

class ConfirmDialog extends StatelessWidget {
  
  CommandModel? command;
  UserModel? user;
  String action;
  void Function() fonction;
  ConfirmDialog({
    Key? key,
    this.command,
    this.user,
    required this.action,
    required this.fonction,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return
    AlertDialog(
              backgroundColor: Colors.white,
              title: Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.symmetric(horizontal: kDefaultPadding),
                child: Center(
                  child: Text(
                    "Confirmation",
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                      //  color: Colors.white

                      //  backgroundColor: Colors.white
                    ),
                  ),
                ),
              ),
              content: Container(
                  child: Text("Etes vous sur de vouloir $action?")),
              actions: [
                FlatButton(
                    child: Text("Oui".toUpperCase(),
                        style: TextStyle(
                            color: Color.fromARGB(255, 240, 229, 240))),
                    padding: EdgeInsets.all(2),
                    minWidth: MediaQuery.of(context).size.width,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    color: Palette.primarySwatch
                        .shade400, //Color.fromARGB(255, 240, 229, 240),
                    //  textColor: kBackgroundColor,
                    onPressed:fonction, // passing true
                    ),
                SizedBox(height: 2 //MediaQuery.of(context).size.height * 0.1,
                    ),
                FlatButton(
                  child: Text(
                    "Non".toUpperCase(),
                    style: TextStyle(color: Color.fromARGB(255, 240, 229, 240)),
                  ),
                  padding: EdgeInsets.all(2),
                  minWidth: MediaQuery.of(context).size.width,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  color: Palette.primarySwatch.shade400, //,
                  //  textColor: kBackgroundColor,
                  onPressed: () async {
                    Navigator.pop(context);
                  },
                ),
              ]);
  }
}
