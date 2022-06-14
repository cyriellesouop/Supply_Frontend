// ignore_for_file: dead_code, sized_box_for_whitespace, prefer_const_constructors, unnecessary_null_comparison, deprecated_member_use, no_logic_in_create_state,, must_be_immutable, prefer_typing_uninitialized_variables

import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';


import 'package:path/path.dart' as p;
import 'package:supply_app/common/constants.dart';
import 'package:supply_app/common/palette.dart';
import 'package:supply_app/components/form/text_field.dart';
import 'package:supply_app/screen/manager/components/inscription/inscription_validate.dart';
import 'package:supply_app/services/storage_service.dart';

class InscriptionName extends StatefulWidget {
  const InscriptionName({Key? key}) : super(key: key);

  @override
  _InscriptionNameState createState() => _InscriptionNameState();
}

class _InscriptionNameState extends State<InscriptionName> {
  // bool remember = false;
  var _image;
  File? image;
  File? avatarImageFile;
  bool? isLoading;
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;

  String dropdownValueTools = 'Voiture';

//les controleurs des champs nom, adresse et de la photo
  TextEditingController nameController = TextEditingController();
  TextEditingController adresseController = TextEditingController();
  String picture = "assets/images/profil.png";
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Storage storage = Storage();
  List<Map<String, dynamic>> listTools = [
    {'Tool': 'Voiture', 'picture': "photos image"},
    {'Tool': 'moto', 'picture': "photos image"},
    {'Tool': 'camion', 'picture': "photos image"},
    {'Tool': 'tricycle', 'picture': "photos image"}
  ];
//vider les controller
  @override
  void dispose() {
    nameController.dispose();
    adresseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Palette.primarySwatch.shade700,
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                /*   Palette.primarySwatch.shade200,
                Palette.primarySwatch.shade50, */

                Palette.primarySwatch.shade50,
                Palette.primarySwatch.shade100,
                Palette.primarySwatch.shade300,
                Palette.primarySwatch.shade400,
              ],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
          ),
          child: Column(
            children: [
              Expanded(
                  child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  
                  Expanded(
                    child: Center(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(30),
                          child: Wrap(
                            alignment: WrapAlignment.center,
                            runSpacing: 0,
                            children: [
                              Container(
                                height: size.height * 0.3,
                                width: size.width * 0.6,
                                child: Center(
                                  child: Image.asset("assets/images/bro.png"),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(
                                    vertical: kDefaultPadding),
                                child: Text(
                                  'Creer votre compte !',
                                  textAlign: TextAlign.center,
                                  style: theme.textTheme.headline4?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              /* Form(
                                 key: _formKey,
                                child: */
                              Form(
                                key: _formKey,
                                child: Wrap(
                                  runSpacing: 25,
                                  children: [
                                  /*   DropdownButtonFormField<String>(

                                      value: dropdownValueTools,
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          dropdownValueTools = newValue!;
                                        });
                                      },
                                      items: <String>[
                                        'moto',
                                        'voiture',
                                        'tricycle',
                                        'camion'
                                      ].map<DropdownMenuItem<String>>(
                                          (String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                    ),
                                     */

                                  
                                    DTextField(
                                      controller: nameController,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'veuillez saisir votre nom';
                                        }
                                        return null;
                                      },
                                      hint: 'votre nom d utilisateur',
                                      prefix: Icons.person,
                                    ),
                                    DTextField(
                                      controller: adresseController,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'veuillez saisir l adresse de votre entreprise';
                                        }
                                        return null;
                                      },
                                      hint: 'votre adresse',
                                      prefix: Icons.local_activity,
                                      isLast: true,
                                    )
                                  ],
                                ),
                              ),

                              
                              Container(
                                margin:
                                    EdgeInsets.only(top: kDefaultPadding * 2),
                                child: Center(
                                  // heightFactor: 3,
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      if (_formKey.currentState!.validate()) {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => PhoneAuth(
                                                    nameField:
                                                        nameController.text,
                                                    adressField:
                                                        adresseController.text,
                                                    picture: picture)));
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Text(
                                        'Suivant',
                                        style: TextStyle(
                                          color: Palette.primarySwatch.shade600,
                                          fontSize: 24,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ))
            ],
          ),
        ),
      ),
    );
  }

  _onSignIn() {
    // Sign in logic here
  }
}
