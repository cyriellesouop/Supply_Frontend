import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:supply_app/common/palette.dart';
import 'package:supply_app/models/Database_Model.dart';
import 'package:supply_app/services/command_service.dart';

import 'package:google_fonts/google_fonts.dart';

import 'package:supply_app/common/constants.dart';

class MysearchDelegate extends SearchDelegate {
  List<Map<String, dynamic>> tableauJsontrie;
  
  UserModel current_user;
  final String hintText;
  MysearchDelegate(
      {required this.tableauJsontrie,
      required this.hintText,
     
      required this.current_user,
      Key? key});

      
/* 
  List<String> added = [];
  String currentText = '';
  GlobalKey<AutoCompleteTextFieldState<String>> key = GlobalKey();
  late SimpleAutoCompleteTextField textField; */

  @override
  String get searchFieldLabel => hintText;
  @override
  Widget? buildLeading(BuildContext context) => IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back));

  @override
  List<Widget>? buildActions(BuildContext context) => [
        IconButton(
            onPressed: () {
              if (query.isEmpty) {
                close(context, null);
              } else {
                query = '';
              }
            },
            icon: const Icon(Icons.clear))
      ];

  @override
  Widget buildSuggestions(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    List<String> liste = [];
    int i;
    int n = this.tableauJsontrie.length;

    for (i = 0; i < n; i++) {
      liste.add(this.tableauJsontrie[i]['Deliver']['name']);
    }

    List<Map<String, dynamic>> sorted = tableauJsontrie
      ..sort((item1, item2) => item1['Deliver']['name']
          .toLowerCase()
          .compareTo(item2['Deliver']['name'].toLowerCase()));
    /*  for (i = 0; i < n; i++) {
      liste.add(this.tableauJsontrie[i]['Deliver']['name']);
    }
    List<String> sortedItem = liste
      ..sort(
          (item1, item2) => item1.toLowerCase().compareTo(item2.toLowerCase()));
    List<String> suggestions = sortedItem; */
    //#########################################################################################
    /* _FirstPageState() {
      textField = SimpleAutoCompleteTextField(
          key: key,
          controller: TextEditingController(),
          suggestions: suggestions,
          textChanged: (text) => currentText = text,
          clearOnSubmit: true,
          textSubmitted: (text) => (text != "") ? added.add(text) : added);
    } */

    //#########################################################################################

    return (sorted.length > 0)
        ? Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.symmetric(vertical: kDefaultPadding),
                // height: 10,
                child: Text('Tous les livreurs disponibles',
                    style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 138, 130, 130))),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: sorted.length,
                  itemBuilder: (context, index) {
                    var item = sorted[index];
                    final suggestion = item['Deliver']['name'];

                    UserModel ontapDeliver = UserModel(
                      idUser: item['Deliver']['idUser'],
                      adress: item['Deliver']['adress'],
                      name: item['Deliver']['name'],
                      idPosition: item['Deliver']['idPosition'],
                      phone: item['Deliver']['phone'],
                      picture: item['Deliver']['picture'],
                      createdAt: item['Deliver']['createdAt'],
                    );

                    return Column(
                      children: <Widget>[
                        ListTile(
                          leading: CircleAvatar(
                            backgroundColor: kPrimaryColor,
                            radius: 28,
                            backgroundImage:
                                AssetImage("assets/images/profil.png"),
                          ),
                          title: Text(suggestion),
                          subtitle: Text(
                              'situe a ${getDistance(suggestion, this.tableauJsontrie)} km de vous'),
                          onTap: () {
                             _showcommandDialog(context, 
                                this.current_user, ontapDeliver);
                            print("suggestion est $suggestion");
                            query = suggestion;
                           
                          },
                        ),
                        SizedBox(
                          height: 5,
                        ),
                      ],
                    );
                  },
                ),
                //  ),
              ),
              /*  Autocomplete<String>(
                  optionsBuilder: (TextEditingValue value) {
              // When the field is empty
              if (value.text.isEmpty) {
                return [];
              }

              // The logic to find out which ones should appear
              return suggestions.where((suggestion) =>
                  suggestion.toLowerCase().contains(value.text.toLowerCase()));
            },), */
            ],
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
          );
    ;
  }

  @override
  Widget buildResults(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    List<String> liste = [];

    int i;
    int n = this.tableauJsontrie.length;

    for (i = 0; i < n; i++) {
      liste.add(this.tableauJsontrie[i]['Deliver']['name']);
    }

    List<Map<String, dynamic>> sorted = tableauJsontrie
      ..sort((item1, item2) => item1['Deliver']['name']
          .toLowerCase()
          .compareTo(item2['Deliver']['name'].toLowerCase()));

/* 
    List<String> sortedItem = liste
      ..sort(
          (item1, item2) => item1.toLowerCase().compareTo(item2.toLowerCase()));
    List<String> suggestions = sortedItem; */

    List<Map<String, dynamic>> matchQuery = [];
    for (var deliver in sorted) {
      if (deliver['Deliver']['name']
          .toLowerCase()
          .contains(query.toLowerCase())) {
        matchQuery.add(deliver);
      }
    }

    /* List<String> matchQuery = [];
    for (var deliver in suggestions) {
      if (deliver.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(deliver);
      }
    } */

    return matchQuery.length > 0
        ? ListView.builder(
            itemCount: matchQuery.length,
            itemBuilder: (context, index) {
              var result = matchQuery[index]['Deliver']['name'];
              return Column(
                children: <Widget>[
                  ListTile(
                    leading: CircleAvatar(
                      backgroundColor: kPrimaryColor,
                      radius: 28,
                      backgroundImage: AssetImage("assets/images/profil.png"),
                    ),
                    title: Text(result),
                    subtitle: Text(
                        'situe a ${getDistance(result, this.tableauJsontrie)} km de vous'),
                    onTap: () {
                      print("suggestion est $result");
                       _showcommandDialog(context, 
                          this.current_user, matchQuery[index]['Deliver']);
                      query = result;
                     
                    },
                  ),
                  const SizedBox(
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
              style: GoogleFonts.poppins(fontSize: 20, color: Colors.grey),
            ),
          );
  }

// boite de dialogue pour l'edition de la commande
  void _showcommandDialog(BuildContext context,
      UserModel user, UserModel deliver) {
    String bouton = "Annuler";
    String dropdownValue = 'Fragile';
    String dropdownValuePoids = 'kg';
    TextEditingController poidsController = TextEditingController();
    TextEditingController nameController = TextEditingController();

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
                    "commande pour ${deliver.name}",
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
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'veuillez nommer cette commande';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                                labelText: "Nom commande",
                                filled: true,
                                hintStyle: TextStyle(
                                    color: Palette.primarySwatch.shade400),
                                //  hintText: "${currentManager.adress}",
                                fillColor: Color.fromARGB(255, 240, 229, 240)),
                          ),
                          DropdownButtonFormField<String>(
                            dropdownColor: Color.fromARGB(255, 240, 229, 240),
                             hint: Text('Etat du colis',style: TextStyle(color: Colors.grey[800]),),
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
                                filled: true,
                                fillColor: Color.fromARGB(255, 240, 229, 240),
                                hintStyle: TextStyle(color: Colors.grey[800]),
                              ),
                              controller: poidsController,
                              validator: (value) {
                                if (value == null ||
                                    value.isEmpty ||
                                    value.length > 4) {
                                  return 'veuillez estimer le poids du colis';
                                }
                                return null;
                              }),
                          DropdownButtonFormField<String>(
                            dropdownColor: Color.fromARGB(255, 240, 229, 240),
                            value: dropdownValuePoids,
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
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'veuillez decrire la commande';
                              }
                              return null;
                            },
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
                                hintText: "Description de la commande ici",
                                fillColor: Color.fromARGB(255, 240, 229, 240)),
                          ),
                        ],
                      ),
                    ),
                  )),
              actions: [
                 FlatButton(
                  child: Text("Quitter", style: TextStyle(color:Color.fromARGB(255, 240, 229, 240) )),
                  padding: EdgeInsets.all(2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  color:  Palette.primarySwatch.shade400, //Color.fromARGB(255, 240, 229, 240),
                  //  textColor: kBackgroundColor,
                  onPressed: () => Navigator.pop(context), // passing true
                ),
                SizedBox(width: MediaQuery.of(context).size.width* 0.1,),
                FlatButton(
                  child: Text("Publier", style: TextStyle(color:Color.fromARGB(255, 240, 229, 240) ),),
                  padding: EdgeInsets.all(2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  color:  Palette.primarySwatch.shade400, //,
                  //  textColor: kBackgroundColor,
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      CommandModel command = CommandModel(
                          createdBy: user.idUser,
                          nameCommand: nameController.text,
                          description:
                              "${descriptionController.text} $dropdownValue",
                          poids:
                              "${poidsController.text} $dropdownValuePoids",
                          statut: "en attente",
                          state: dropdownValue,
                          startPoint: user.idPosition,
                          updatedAt: DateTime.now().toString(),
                          createdAt: DateTime.now().toString());

                      await CommandService().addCommand(command).then((value) {
                          (Fluttertoast.showToast(
                                  msg: "la commande a ete publier",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 5,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                  fontSize: 16.0));  Navigator.pop(context); })
                              .catchError((onError) {
                                Navigator.pop(context);
                            Fluttertoast.showToast(
                                msg: "Echec de publication, veuillez reesayer!",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 5,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 16.0);
                          });
                      
                    }
                  },
                ),
               
              ]);
        });
  }

  double getDistance(String query, List<Map<String, dynamic>> tableauJsontrie) {
    int n = tableauJsontrie.length;
    int i;
    double distance = 0.0;
    for (i = 0; i < n; i++) {
      if (tableauJsontrie[i]['Deliver']['name'].compareTo(query) == 0) {
        distance = tableauJsontrie[i]['Distance'];
        break;
      }
    }
    return distance;
  }

  auto(List<String> suggestions) {
    return Autocomplete<String>(
      optionsBuilder: (TextEditingValue value) {
        // When the field is empty
        if (value.text.isEmpty) {
          return [];
        }

        // The logic to find out which ones should appear
        return suggestions.where((suggestion) =>
            suggestion.toLowerCase().contains(value.text.toLowerCase()));
      },
    );
  }
}
