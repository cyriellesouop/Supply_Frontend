import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:supply_app/common/constants.dart';
import 'package:supply_app/common/palette.dart';
import 'package:supply_app/models/Database_Model.dart';
import 'package:supply_app/screen/manager/components/tracking.dart';
import 'package:supply_app/services/command_service.dart';

class ListCommand extends StatefulWidget {
  UserModel deliver;
  UserModel manager;
  List<CommandModel> Commands;
  ListCommand(
      {Key? key,
      required this.manager,
      required this.deliver,
      required this.Commands});

  @override
  _ListCommandState createState() => _ListCommandState();
}

class _ListCommandState extends State<ListCommand> {
  //supprime les doublons dans une liste
  List<CommandModel> tableauTrie(List<CommandModel> table) {
    int i, j, k;
    var n = table.length;
    for (i = 0; i < n; i++) {
      for (j = i + 1; j < n;) {
        if (table[j].updatedAt == table[i].updatedAt &&
            table[j].nameCommand == table[i].nameCommand) {
          table.removeAt(j);
          n--;
        } else
          j++;
      }
    }
    return table;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var Commandetrie = tableauTrie(widget.Commands);
    return Container(
      color: Color.fromARGB(255, 240, 229, 240),
      child: (Commandetrie).length > 0
          ? ListView.builder(
              itemCount: Commandetrie.length,
              itemBuilder: (context, index) {
                final command = Commandetrie[index];

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
                        title: Text(
                          '${command.nameCommand}'.toUpperCase(),
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: (command.statut == "en attente")
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(''),
                                  Container(
                                    //  padding: EdgeInsets.only(left: kDefaultPadding),
                                    child: Text(
                                        '${command.statut}'.toLowerCase(),
                                        style: GoogleFonts.poppins(
                                            fontSize: 12,
                                            fontStyle: FontStyle.italic,
                                            color: Palette
                                                .primarySwatch.shade400)),
                                  )
                                ],
                              )
                            : (command.statut == "en cours")
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          'En cours de livraison par ${command.deliveredBy}'),
                                      Container(
                                        //  padding: EdgeInsets.only(left: kDefaultPadding),
                                        child: Text(
                                            '${command.statut}'.toLowerCase(),
                                            style: GoogleFonts.poppins(
                                                fontSize: 12,
                                                fontStyle: FontStyle.italic,
                                                color: Palette
                                                    .primarySwatch.shade400)),
                                      ),
                                    ],
                                  )
                                : Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('Livree par ${command.deliveredBy}'),
                                      Container(
                                        //  padding: EdgeInsets.only(left: kDefaultPadding),
                                        child: Text(
                                            '${command.statut}'.toLowerCase(),
                                            style: GoogleFonts.poppins(
                                                fontSize: 12,
                                                fontStyle: FontStyle.italic,
                                                color: Palette
                                                    .primarySwatch.shade400)),
                                      )
                                    ],
                                  ),
                        trailing: command.statut == "en attente"
                            ? Column(
                                children: [
                                  Row(
                                    //  mainAxisAlignment: MainAxisAlignment.center,

                                    mainAxisSize: MainAxisSize.min,
                                    //  crossAxisAlignment: CrossAxisAlignment.baseline,
                                    children: [
                                      Text(
                                        '${_dateShow(command.updatedAt)}'
                                            .toUpperCase(),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey),
                                      ),
                                      //    SizedBox(height: 3,),
                                      IconButton(
                                          onPressed: () {
                                            _showcommandDialog(
                                                context,
                                                widget.manager,
                                                widget.deliver,
                                                command);
                                          },
                                          icon: Icon(Icons.edit,
                                              color: Palette
                                                  .primarySwatch.shade400))
                                    ],
                                  ),
                                ],
                              )
                            : Text(
                                '${_dateShow(command.updatedAt)}'.toUpperCase(),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey),
                              ),
                        onTap: () {
                          (command.statut == 'en attente')
                              ? _showcommandDialog(context, widget.manager,
                                  widget.deliver, command)
                              : (command.statut == 'termine')
                                  ? _showDetailDialog(context, command)
                                  : (command.statut == 'en cours')
                                      ? Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => Tracking(
                                                    Command: command,
                                                    deliver: widget.deliver,
                                                    manager: widget.manager,
                                                  )))
                                      : ""; /* luttertoast.showToast(
                                  msg: command.nameCommand,
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 2,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                  fontSize: 16.0); */
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

// fonction pour afficher la date a laquelle a livraison a ete publiee
  String _dateShow(String dateTime) {
    var teal;
    if (dateTime.substring(0, 10) ==
        DateTime.now().toString().substring(0, 10)) {
      teal = dateTime.substring(11, 16);
    } else {
      teal = dateTime.substring(0, 10);
    }
    return teal;
  }

  // boite de dialogue pour l'edition de la commande
  void _showDetailDialog(BuildContext context, CommandModel command) {
    var title = "${command.nameCommand}".toUpperCase();
    var body =
        "Livre par :  ${command.deliveredBy}\nHeure :  ${command.updatedAt}\nEtat :  ${command.state}\nPoids :  ${command.poids}\n\nDetails:  ${command.description}";
    //CommandService ServiceCommand = new CommandService();
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            title: Center(child: Text("$title")),
            content: Text("$body"),
            actions: [
              FlatButton(
                  child: Text("ok".toUpperCase(),
                      style:
                          TextStyle(color: Color.fromARGB(255, 240, 229, 240))),
                  padding: EdgeInsets.all(2),
                  /*  minWidth: MediaQuery.of(context)
                                                .size
                                                .width, */
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  color: Palette.primarySwatch
                      .shade400, //Color.fromARGB(255, 240, 229, 240),
                  //  textColor: kBackgroundColor,
                  onPressed: () async {
                    Navigator.pop(context);
                  } // passing true
                  ),
            ],
          );
        });
  }

  // boite de dialogue pour l'edition de la commande

  /* void _showcommandDialog(BuildContext context, UserModel user,
      UserModel deliver, CommandModel command) {
    var poidscomplet = command.poids.split(' ');
    var poidsexacte = poidscomplet[0];
    var unit = poidscomplet[1];
    String bouton = "Annuler";
    String dropdownValue = 'Fragile';
    String dropdownValuePoids = 'kg';
    TextEditingController poidsController = TextEditingController();
    TextEditingController nameController = TextEditingController();

    //CommandService ServiceCommand = new CommandService();

    TextEditingController descriptionController = TextEditingController();
    // final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              backgroundColor: Colors.white,
              title: Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.symmetric(horizontal: kDefaultPadding),
                child: Center(
                  child: Text(
                    "Modifications",
                    style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Palette.primarySwatch.shade400
                        //  color: Colors.white

                        //  backgroundColor: Colors.white
                        ),
                  ),
                ),
              ),
              content: Form(
                  //  key: _formKey,
                  child: Container(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      TextFormField(
                        controller: nameController,
                        style: GoogleFonts.poppins(fontSize: 15),
                        decoration: InputDecoration(
                            labelText: "Nom commande",
                            filled: true,
                            hintText: command.nameCommand,
                            /* hintStyle: TextStyle(
                                    color: Palette.primarySwatch.shade400), */
                            //  hintText: "${currentManager.adress}",
                            fillColor: Color.fromARGB(255, 240, 229, 240)),
                      ),
                      DropdownButtonFormField<String>(
                        dropdownColor: Color.fromARGB(255, 240, 229, 240),
                        /* decoration: InputDecoration(
                              labelText: 'Etat du colis',
                              //  fillColor:Palette.primarySwatch.shade50,
                              hintStyle: TextStyle(color: Colors.grey[800]),
                            ), */
                        hint: Text(
                          'Etat du colis',
                          style: TextStyle(color: Colors.grey[800]),
                        ),
                        value: dropdownValue,
                        onChanged: (String? newValue) {
                          // setState(() {
                          dropdownValue = newValue!;
                          // });
                        },
                        items: <String>['Fragile', 'non-fragile', 'autres']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Estimer le poids',
                          hintText: poidsexacte,
                          filled: true,
                          fillColor: Color.fromARGB(255, 240, 229, 240),
                          hintStyle: TextStyle(color: Colors.grey[800]),
                        ),
                        controller: poidsController,
                        /*       validator: (value) {
                                if (value == null ||
                                    value.isEmpty ||
                                    value.length > 4) {
                                  return 'veuillez estimer le poids du colis';
                                }
                                return null;
                              } */
                      ),
                      DropdownButtonFormField<String>(
                        dropdownColor: Color.fromARGB(255, 240, 229, 240),
                        value: dropdownValuePoids,
                        hint: Text(
                          command.poids,
                          style: TextStyle(color: Colors.grey[800]),
                        ),
                        onChanged: (String? newValue) {
                          // setState(() {
                          dropdownValuePoids = newValue!;
                          // });
                        },
                        items: <String>['tonnes', 'Kg', 'g', 'mg']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        controller: descriptionController,
                        keyboardType: TextInputType.multiline,
                        textInputAction: TextInputAction.newline,
                        minLines: 1,
                        maxLines: 5,
                        decoration: InputDecoration(
                            labelText: 'Estimation du prix et heure ',
                            /*  border: OutlineInputBorder(
                                  
                                  Color: Colors.white,
                                  borderRadius: BorderRadius.circular(10.0),
                                ), */
                            filled: true,
                            hintStyle: TextStyle(color: Colors.grey[800]),
                            // prefixIcon: const Icon(Icons.write),
                            hintText: command.description,
                            fillColor: Color.fromARGB(255, 240, 229, 240)),
                      ),
                    ],
                  ),
                ),
              )),
              actions: [
                FlatButton(
                    child: Text("Annuler la commande".toUpperCase(),
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
                    onPressed: () {
                      _ShowConfirmDialog(context, command);
                    } // passing true
                    ),
                SizedBox(height: 2 //MediaQuery.of(context).size.height * 0.1,
                    ),
                FlatButton(
                  child: Text(
                    "Modifier".toUpperCase(),
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
                    print(" controller ............. $descriptionController");
                    //  if (_formKey.currentState!.validate()) {
                    command.Description = descriptionController.text;
                    command.NameCommand = nameController.text;
                    command.Poids =
                        "${poidsController.text} $dropdownValuePoids";
                    command.State = dropdownValue;
                    command.UpdateDate = DateTime.now().toString();

                    await CommandService().updateCommand(command).then((value) {
                      Navigator.pop(context);
                      (Fluttertoast.showToast(
                          msg: "modification reussie",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 5,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0));
                    }).catchError((onError) {
                      Navigator.pop(context);
                      Fluttertoast.showToast(
                          msg: "Echec de modification, veuillez reesayer!",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 5,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0);
                    });
                    //  }
                  },
                ),
              ]);
        });
  } */

  void _showcommandDialog(BuildContext context, UserModel user,
      UserModel deliver, CommandModel command) {
    var poidscomplet = command.poids.split(' ');
    var poidsexacte = poidscomplet[0];
    var unit = poidscomplet[1];
    String bouton = "Annuler";
    String dropdownValue = 'Fragile';
    String dropdownValuePoids = poidscomplet[1];
    TextEditingController poidsController = TextEditingController();
    TextEditingController nameController = TextEditingController();
    var commandinit = command;

    //CommandService ServiceCommand = new CommandService();

    TextEditingController descriptionController = TextEditingController();
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              backgroundColor: Colors.white,
              title: Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.symmetric(horizontal: kDefaultPadding),
                child: Center(
                  child: Text(
                    "Modifications",
                    style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Palette.primarySwatch.shade400
                        //  color: Colors.white

                        //  backgroundColor: Colors.white
                        ),
                  ),
                ),
              ),
              content: Form(
                  key: _formKey,
                  child: Container(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          TextFormField(
                            controller: nameController,
                            style: GoogleFonts.poppins(fontSize: 15),
                            decoration: InputDecoration(
                                labelText: "Nom commande",
                                filled: true,
                                hintText: command.nameCommand,
                                fillColor: Color.fromARGB(255, 240, 229, 240)),
                          ),
                          DropdownButtonFormField<String>(
                            dropdownColor: Color.fromARGB(255, 240, 229, 240),
                            hint: Text(
                              'Etat du colis',
                              style: TextStyle(color: Colors.grey[800]),
                            ),
                            value: dropdownValue,
                            onChanged: (String? newValue) {
                              dropdownValue = newValue!;
                            },
                            items: <String>['Fragile', 'non-fragile', 'autres']
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          TextFormField(
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'Estimer le poids',
                              hintText: poidsexacte,
                              filled: true,
                              fillColor: Color.fromARGB(255, 240, 229, 240),
                              hintStyle: TextStyle(color: Colors.grey[800]),
                            ),
                            controller: poidsController,
                          ),
                          DropdownButtonFormField<String>(
                            dropdownColor: Color.fromARGB(255, 240, 229, 240),
                            value: dropdownValuePoids,
                            hint: Text(
                              command.poids,
                              style: TextStyle(color: Colors.grey[800]),
                            ),
                            onChanged: (String? newValue) {
                              // setState(() {
                              dropdownValuePoids = newValue!;
                              // });
                            },
                            items: <String>['tonnes', 'kg', 'g', 'mg']
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          TextFormField(
                            controller: descriptionController,
                            keyboardType: TextInputType.multiline,
                            textInputAction: TextInputAction.newline,
                            minLines: 1,
                            maxLines: 5,
                            decoration: InputDecoration(
                                labelText: 'Estimation du prix et heure ',
                                filled: true,
                                hintStyle: TextStyle(color: Colors.grey[800]),
                                hintText: command.description,
                                fillColor: Color.fromARGB(255, 240, 229, 240)),
                          ),
                        ],
                      ),
                    ),
                  )),
              actions: [
                FlatButton(
                    child: Text("Annuler la commande".toUpperCase(),
                        style: TextStyle(
                            color: Color.fromARGB(255, 240, 229, 240))),
                    padding: EdgeInsets.all(2),
                    minWidth: MediaQuery.of(context).size.width,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    color: Palette.primarySwatch.shade400,
                    onPressed: () {
                      Navigator.pop(context);
                      _ShowdeleteDialog(context, command);
                    } // passing true
                    ),
                SizedBox(height: 2 //MediaQuery.of(context).size.height * 0.1,
                    ),
                FlatButton(
                  child: Text(
                    "Modifier".toUpperCase(),
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
                    print(" controller ............. $descriptionController");
                    if (_formKey.currentState!.validate()) {
                      command.Description = descriptionController.text.isEmpty
                          ? commandinit.description
                          : descriptionController.text;
                      command.NameCommand = nameController.text.isEmpty
                          ? commandinit.nameCommand
                          : nameController.text;
                      command.Poids = poidsController.text.isEmpty
                          ? commandinit.poids
                          : "${poidsController.text} $dropdownValuePoids";
                      command.State = dropdownValue;
                      command.UpdateDate = DateTime.now().toString();
                      Navigator.pop(context);
                      _ShowUpdateDialog(context, command);
                    }
                  },
                ),
              ]);
        });
  }

  void _ShowdeleteDialog(
      // BuildContext context, CommandModel command, void Function() fonction) {  _deleteAction()
      BuildContext context,
      CommandModel command) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              backgroundColor: Colors.white,
              content: Container(
                  child: Text("Etes vous sur de vouloir supprimer ?")),
              actions: [
                FlatButton(
                  child: Text(
                    "Non".toUpperCase(),
                    style: TextStyle(color: Color.fromARGB(255, 240, 229, 240)),
                  ),
                  padding: EdgeInsets.all(2),
                  //  minWidth: MediaQuery.of(context).size.width,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  color: Palette.primarySwatch.shade400, //,
                  //  textColor: kBackgroundColor,
                  onPressed: () async {
                    Navigator.pop(context);
                  },
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.1,
                ),
                FlatButton(
                  child: Text("Oui".toUpperCase(),
                      style:
                          TextStyle(color: Color.fromARGB(255, 240, 229, 240))),
                  padding: EdgeInsets.all(2),
                  // minWidth: MediaQuery.of(context).size.width,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  color: Palette.primarySwatch
                      .shade400, //Color.fromARGB(255, 240, 229, 240),
                  //  textColor: kBackgroundColor,
                  onPressed: () async {
                    await CommandService()
                        .removeCommand(command.idCommand)
                        .then((value) {
                      Navigator.pop(context);
                      (Fluttertoast.showToast(
                          msg: "suppression reussie",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 5,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0));
                    }).catchError((onError) {
                      Navigator.pop(context);
                      (Fluttertoast.showToast(
                          msg: "echec de suppression",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 5,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0));
                    });
                  }, // passing true
                ),
              ]);
        });
  }

  void _ShowUpdateDialog(
      // BuildContext context, CommandModel command, void Function() fonction) {  _deleteAction()
      BuildContext context,
      CommandModel command) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              backgroundColor: Colors.white,
              content: Container(
                  child: Text(
                      "Etes vous sur de vouloir modifier cette commande ?")),
              actions: [
                FlatButton(
                  child: Text(
                    "Non".toUpperCase(),
                    style: TextStyle(color: Color.fromARGB(255, 240, 229, 240)),
                  ),
                  padding: EdgeInsets.all(2),
                  //  minWidth: MediaQuery.of(context).size.width,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  color: Palette.primarySwatch.shade400, //,
                  //  textColor: kBackgroundColor,
                  onPressed: () async {
                    Navigator.pop(context);
                  },
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.1,
                ),
                FlatButton(
                  child: Text("Oui".toUpperCase(),
                      style:
                          TextStyle(color: Color.fromARGB(255, 240, 229, 240))),
                  padding: EdgeInsets.all(2),
                  // minWidth: MediaQuery.of(context).size.width,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  color: Palette.primarySwatch
                      .shade400, //Color.fromARGB(255, 240, 229, 240),
                  //  textColor: kBackgroundColor,
                  onPressed: () async {
                    await CommandService().updateCommand(command).then((value) {
                      Navigator.pop(context);
                      (Fluttertoast.showToast(
                          msg: "modification reussie",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 5,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0));
                    }).catchError((onError) {
                      Navigator.pop(context);
                      Fluttertoast.showToast(
                          msg: "Echec de modification, veuillez reesayer!",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 5,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0);
                    });
                  }, // passing true
                ),
              ]);
        });
  }

  _deleteAction(CommandModel command) async {
    await CommandService().removeCommand(command.idCommand).then((value) {
      Navigator.pop(context);
      (Fluttertoast.showToast(
          msg: "suppression reussie",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 5,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0));
    }).catchError((onError) {
      Navigator.pop(context);
      (Fluttertoast.showToast(
          msg: "echec de suppression",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 5,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0));
    });
  }
}
