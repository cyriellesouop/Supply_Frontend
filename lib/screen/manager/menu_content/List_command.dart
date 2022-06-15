import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:supply_app/common/constants.dart';
import 'package:supply_app/models/Database_Model.dart';

class ListCommand extends StatelessWidget {
  UserModel deliver;
  List<CommandModel> Commands;
  ListCommand({Key? key, required this.deliver, required this.Commands});
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      color: Color.fromARGB(255, 240, 229, 240),
      child: Commands.length > 0
          ? ListView.builder(
              itemCount: Commands.length,
              itemBuilder: (context, index) {
                final command = Commands[index];

                return Column(
                  children: [
                    Card(
                      child: ListTile(
                      /*    leading: CircleAvatar(
                          backgroundColor: Color.fromARGB(255, 240, 229, 240),
                          radius: 28,
                          backgroundImage: Image.asset("assets/images/profil.png", height:100,
                        width: 100,),
                        ),  */
                        title: Text('${command.nameCommand}'.toUpperCase(), style: TextStyle(fontWeight: FontWeight.bold),),
                        subtitle: (command.deliveredBy?.toLowerCase().length == 0)? Text("en attente d'un livreur".toLowerCase()): Text(
                            'livre par ${command.deliveredBy}'.toLowerCase()),
                        trailing: Text('${_dateShow(command.createdAt)}'.toUpperCase(),style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),),
                        onTap: () {
                          print("commande du $command");
                        },
                      ),
                    ),
                  ],
                );
              },
            )
          : Container(
              height: size.height,
              width: size.width,
              alignment: Alignment.center,
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                        margin: EdgeInsets.only(
                            left: kDefaultPadding * 2,
                            right: kDefaultPadding * 2,
                            top: kDefaultPadding * 6),
                        height: size.height * 0.8,
                        width: size.width * 0.6,
                        child: Image.asset("assets/images/empty.png")),

                    //flex: 2,
                  ),
                  Expanded(
                    child: Text(
                      "Aucun resultat ",
                      style: GoogleFonts.poppins(
                          fontSize: 20,
                          //  fontWeight: FontWeight.bold,
                          color: Colors.grey

                          //  backgroundColor: Colors.white
                          ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }


    String _dateShow(String dateTime) {
    var teal;
    if (dateTime.substring(0,10) == DateTime.now().toString().substring(0,10)) {
      teal = dateTime.substring(11, 16);
    } else {
      teal = dateTime.substring(0, 10);
    }
    return teal;
  }
}
