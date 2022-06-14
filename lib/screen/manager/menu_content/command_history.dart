// ignore_for_file: dead_code, sized_box_for_whitespace, prefer_const_constructors, unnecessary_null_comparison, deprecated_member_use, no_logic_in_create_state,, must_be_immutable, prefer_typing_uninitialized_variables

import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

import 'package:path/path.dart' as p;
import 'package:supply_app/common/constants.dart';
import 'package:supply_app/models/Database_Model.dart';
import 'package:supply_app/services/command_service.dart';
import 'package:supply_app/services/storage_service.dart';

class CommandListe extends StatefulWidget {
  String currentManagerID;
  CommandListe({required this.currentManagerID, Key? key}) : super(key: key);

  @override
  _CommandListeState createState() => _CommandListeState();
}

class _CommandListeState extends State<CommandListe> {
//les controleurs des champs date
  TextEditingController dateinput = TextEditingController();
  TextEditingController dateinputfinal = TextEditingController();

  List<CommandModel> Commands = [];
  List<CommandModel> termine = [];
  List<CommandModel> encours = [];
  List<CommandModel> enattente = [];
  // CommandModel co = CommandModel(createdBy: createdBy, nameCommand: nameCommand, description: description, statut: statut, state: state, startPoint: startPoint, updatedAt: updatedAt, createdAt: createdAt)

  //UserModel? exampleModel = new UserModel(name: 'fabiol');

  CommandService ServiceCommand = new CommandService();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Storage storage = Storage();
//vider les controller
  @override
  void dispose() {
    dateinput.dispose();
    dateinputfinal.dispose();

    super.dispose();
  }

  @override
  void initState() {
    dateinput.text = ""; //set the initial value of text field
    dateinputfinal.text = '';
    super.initState();
  }

  getCommandDeliver() async {
    await ServiceCommand.getCommandsManager(widget.currentManagerID)
        .forEach((element) async {
      setState(() {
        this.Commands = element;
      });
      for (var i in this.Commands) {
        if (i.statut == "en cours") {
          encours.add(i);
        } else if (i.statut == "termine") {
          termine.add(i);
        } else if (i.statut == "en attente") {
          enattente.add(i);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    List<CommandModel> sortedenattente = enattente
      ..sort((item1, item2) =>
          item1.createdAt.toLowerCase().compareTo(item2.createdAt.toLowerCase()));

    List<CommandModel> sortedencours = encours
      ..sort((item1, item2) =>
          item1.createdAt.toLowerCase().compareTo(item2.createdAt.toLowerCase()));

    List<CommandModel> sortedtermine = termine
      ..sort((item1, item2) =>
          item1.createdAt.toLowerCase().compareTo(item2.createdAt.toLowerCase()));

    return DefaultTabController(
        length: 4,
        child: Scaffold(
            backgroundColor: kBackgroundColor,
            appBar: buildAppBar(),
            body: TabBarView(
              children: [
                Container(
                  child: Commands.length > 0
                      ? ListView.builder(
                          itemCount: Commands.length,
                          itemBuilder: (context, index) {
                            final command = Commands[index];

                            return Column(
                              children: [
                                ListTile(
                                  title: Text('${command.nameCommand}'),
                                  subtitle: Text(
                                      'Livraison effectue par ${command.deliveredBy}'
                                          .toLowerCase()),
                                  onTap: () {
                                    print("commande du $command");
                                  },
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                              ],
                            );
                          },
                        )
                      : Container(
                          height: size.height,
                          width: size.width,
                          alignment: Alignment.center,
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
                ),
                Container(
                  child: enattente.length > 0
                      ? ListView.builder(
                          itemCount: Commands.length,
                          itemBuilder: (context, index) {
                            final command = enattente[index];

                            return Column(
                              children: [
                                ListTile(
                                  title: Text('${command.nameCommand}'),
                                  subtitle: Text(
                                      'Livraison effectue par ${command.deliveredBy}'
                                          .toLowerCase()),
                                  onTap: () {
                                    print("commande du $command");
                                  },
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                              ],
                            );
                          },
                        )
                      : Container(
                          height: size.height,
                          width: size.width,
                          alignment: Alignment.center,
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
                ),
                Container(
                  child: encours.length > 0
                      ? ListView.builder(
                          itemCount: Commands.length,
                          itemBuilder: (context, index) {
                            final command = encours[index];

                            return Column(
                              children: [
                                ListTile(
                                  title: Text('${command.nameCommand}'),
                                  subtitle: Text(
                                      'Livraison effectue par ${command.deliveredBy}'
                                          .toLowerCase()),
                                  onTap: () {
                                    print("commande du $command");
                                  },
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                              ],
                            );
                          },
                        )
                      : Container(
                          height: size.height,
                          width: size.width,
                          alignment: Alignment.center,
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
                ),
                Container(
                  child: termine.length > 0
                      ? ListView.builder(
                          itemCount: Commands.length,
                          itemBuilder: (context, index) {
                            final command = termine[index];

                            return Column(
                              children: [
                                ListTile(
                                  title: Text('${command.nameCommand}'),
                                  subtitle: Text(
                                      'Livraison effectue par ${command.deliveredBy}'
                                          .toLowerCase()),
                                  onTap: () {
                                    print("commande du $command");
                                  },
                                ),
                                SizedBox(
                                  height: 5,
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
                                    margin: EdgeInsets.only(left:kDefaultPadding*2 , right: kDefaultPadding*2,  top:kDefaultPadding*6),
                                    height: size.height * 0.8,
                                    width: size.width * 0.6,
                                    child:
                                        Image.asset("assets/images/empty.png")),

                                        
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
                ),
              ],
            )));
  } /*  {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
        backgroundColor: kBackgroundColor,
        appBar: buildAppBar(),
        body: Container(
            padding: const EdgeInsets.symmetric(vertical: kDefaultPadding),
           ));
  }
}
 */

  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: kPrimaryColor,
      title: Text(
        'Historique des commandes',
        style: GoogleFonts.philosopher(fontSize: 20),
      ),
      bottom: TabBar(tabs: [
        Tab(
          text: 'Tous'.toUpperCase(),
          icon: Icon(Icons.all_inbox),
        ),
       Tab(
          text: 'Att.'.toUpperCase(),
          icon: Icon(Icons.question_mark),
        ),
        Tab(
          text: 'Cours'.toUpperCase(),
          icon: Icon(Icons.car_rental),
        ),
        Tab(
          text: 'Term.'.toUpperCase(),
          icon: Icon(Icons.done),
        ),
      ]),

      //centerTitle: true,
      //leading: IconButton(onPressed: () {}, icon: Icon(Icons.update)),
    );
  }
}
