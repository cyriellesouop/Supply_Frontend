 // ignore_for_file: dead_code, sized_box_for_whitespace, prefer_const_constructors, unnecessary_null_comparison, deprecated_member_use, no_logic_in_create_state,, must_be_immutable, prefer_typing_uninitialized_variables

import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:supply_app/components/models/Database_Model.dart';
import 'package:supply_app/components/screen/manager/components/inscription/inscription_validate.dart';
import 'package:supply_app/components/services/command_service.dart';
import 'package:supply_app/components/services/storage_service.dart';
import 'package:supply_app/constants.dart';
import 'package:path/path.dart' as p;

class CommandList extends StatefulWidget {
  String currentManagerID;
  CommandList({required this.currentManagerID, Key? key}) : super(key: key);

  @override
  _CommandListState createState() => _CommandListState();
}

class _CommandListState extends State<CommandList> {
//les controleurs des champs date
  TextEditingController dateinput = TextEditingController();
  TextEditingController dateinputfinal = TextEditingController();

  List<CommandModel> Commands = [];
  List<CommandModel> termine = [];
  List<CommandModel> encours = [];
  List<CommandModel> enattente = [];
  // CommandModel co = CommandModel(createdBy: createdBy, nameCommand: nameCommand, description: description, statut: statut, state: state, startPoint: startPoint, updatedAt: updatedAt, createAt: createAt)

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

    return Scaffold(
        backgroundColor: kBackgroundColor,
        appBar: buildAppBar(),
        body: Container(
            padding: const EdgeInsets.symmetric(vertical: kDefaultPadding),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: kDefaultPadding),
                  child: Text('Veuillez specifier la periode'),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(top: kDefaultPadding),
                    child: Row(
                      children: [
                        ListTile(
                          title: Text(' Date'),
                        ),
                        Expanded(
                          child: TextField(
                            controller:
                                dateinput, //editing controller of this TextField
                            decoration: InputDecoration(
                                icon: Icon(
                                    Icons.calendar_today), //icon of text field
                                labelText: "Debut", //label text of field
                                hintText: "Debut"),
                            readOnly:
                                true, //set it true, so that user will not able to edit text
                            onTap: () async {
                              DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(
                                      2000), //DateTime.now() - not to allow to choose before today.
                                  lastDate: DateTime(2101));

                              if (pickedDate != null) {
                                print(
                                    pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                                String formattedDate =
                                    DateFormat('yyyy-MM-dd').format(pickedDate);
                                print(
                                    formattedDate); //formatted date output using intl package =>  2021-03-16
                                //you can implement different kind of Date Format here according to your requirement

                                setState(() {
                                  dateinput.text =
                                      formattedDate; //set output date to TextField value.
                                });
                              } else {
                                print("Date is not selected");
                              }
                            },
                          ),
                        ),
                        SizedBox(
                          width: 2,
                        ),
                        Expanded(
                          child: TextField(
                            controller:
                                dateinputfinal, //editing controller of this TextField
                            decoration: InputDecoration(
                                icon: Icon(
                                    Icons.calendar_today), //icon of text field
                                labelText: "Debut", //label text of field
                                hintText: "Debut"),
                            readOnly:
                                true, //set it true, so that user will not able to edit text
                            onTap: () async {
                              DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(
                                      2000), //DateTime.now() - not to allow to choose before today.
                                  lastDate: DateTime(2101));

                              if (pickedDate != null) {
                                print(
                                    pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                                String formattedDate =
                                    DateFormat('yyyy-MM-dd').format(pickedDate);
                                print(
                                    formattedDate); //formatted date output using intl package =>  2021-03-16
                                //you can implement different kind of Date Format here according to your requirement

                                setState(() {
                                  dateinputfinal.text =
                                      formattedDate; //set output date to TextField value.
                                });
                              } else {
                                print("Date is not selected");
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                termine.length > 0
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
            )));
  }
}

AppBar buildAppBar() {
  return AppBar(
    backgroundColor: kPrimaryColor,
    title: Text(
      'Historique des commandes',
      style: GoogleFonts.philosopher(fontSize: 20),
    ),
    //centerTitle: true,
    leading: IconButton(onPressed: () {}, icon: Icon(Icons.update)),
  );
}
 