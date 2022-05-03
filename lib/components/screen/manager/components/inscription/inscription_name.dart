// ignore_for_file: dead_code, sized_box_for_whitespace, prefer_const_constructors, unnecessary_null_comparison, deprecated_member_use, no_logic_in_create_state,, must_be_immutable, prefer_typing_uninitialized_variables

import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:supply_app/components/screen/manager/components/inscription/inscription_validate.dart';

import 'package:supply_app/constants.dart';
import 'package:path/path.dart' as p;

class InscriptionName extends StatefulWidget {
  const InscriptionName({Key? key}) : super(key: key);

  @override
  _InscriptionNameState createState() => _InscriptionNameState();
}

class _InscriptionNameState extends State<InscriptionName> {
 //_image contiendra le chemin d'acces a l'image prise depuis un telephone
  var _image;

//les controleurs des champs nom, adresse et de la photo
  TextEditingController nameController = TextEditingController();
  TextEditingController adresseController = TextEditingController();
 String picture="assets/images/profil.png";
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: buildAppBar(),
      body: Container(
          padding: const EdgeInsets.symmetric(
              vertical: kDefaultPadding, horizontal: kDefaultPadding),
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Form(
               key: _formKey,
              child: ListView(
                
                children: <Widget>[
                  Center(
                    /* child: InkWell(
                      onTap: () {
                        showModalBottomSheet(
                            context: context,
                            builder: ((builder) => bottomSheet()));
                      },*/
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
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: (_image != null)
                                    ? FileImage(_image)
                                    : AssetImage("assets/images/profil.png")
                                        as ImageProvider)),
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
                              color: kPrimaryColor),
                          child: IconButton(
                            icon: Icon(Icons.camera_alt, color: Colors.white),
                            onPressed: () {
                              showModalBottomSheet(
                                  context: context,
                                  builder: ((builder) => bottomSheet()));
                            },
                          ),
                        ),
                      )
                    ]),
                    //  ),
                  ),
                  const SizedBox(
                    height: 25.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 30),
                    child: TextFormField(
                      controller: nameController,
                      style: GoogleFonts.poppins(fontSize: 15),
                       validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'veuillez saisir votre nom';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          filled: true,
                          hintStyle: TextStyle(color: Colors.grey[800]),
                          hintText: "Nom de l\'entreprise",
                          fillColor: Colors.white70),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 30),
                    child: TextFormField(
                      controller: adresseController,
                      style: GoogleFonts.poppins(fontSize: 15),
                       validator: (value) {
                        if (value == null ||  value.isEmpty) {
                          return 'veuillez saisir l adresse de votre entreprise';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          filled: true,
                          hintStyle: TextStyle(color: Colors.grey[800]),
                          hintText: "Adresse de l'entreprise",
                          fillColor: Colors.white70),
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  FlatButton(
                    onPressed: () async {
                      print("le chemin d'acces a l'image est :$picture");
                       print("le deuxieme chemin d'acces a l'image est :$_image");
                        if (_formKey.currentState!.validate()){
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PhoneAuth(
                                  nameField: nameController.text,
                                  adressField: adresseController.text,
                                  picture: picture)));}
                    },
                    padding: EdgeInsets.all(15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    color: kPrimaryColor,
                    textColor: kBackgroundColor,
                    child: Text(
                      'SUIVANT',
                      style: GoogleFonts.poppins(fontSize: 15),
                    ),
                  )
                ],
              ),
            ),
          )),
    );
  }

  Widget bottomSheet() {
    return Container(
      height: 100.0,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(
        children: <Widget>[
          Text(
            "Changer ma photo de profil",
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            FlatButton.icon(
              icon: Icon(Icons.camera),
              onPressed: () {
                selectOrTakePhoto(ImageSource.camera);
              },
              label: Text("Camera"),
            ),
            FlatButton.icon(
              icon: Icon(Icons.image),
              onPressed: () {
                selectOrTakePhoto(ImageSource.gallery);
              },
              label: Text("Gallerie"),
            ),
          ])
        ],
      ),
    );
  }

  Future<void> selectOrTakePhoto(ImageSource imageSource) async {
    final pickedFile = (await ImagePicker().pickImage(source: imageSource));
    
    if (pickedFile == null) {
      return;
    }

    final appDir = await getApplicationDocumentsDirectory();
    final fileName = p.basename(pickedFile.path);
    final savedImage =
        await File(pickedFile.path).copy('${appDir.path}/$fileName');

    setState(() {
      _image = savedImage;
      picture=pickedFile.path;
    });
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<PickedFile>('_image', _image));
    properties.add(DiagnosticsProperty<PickedFile>('_image', _image));
  }
}

AppBar buildAppBar() {
  return AppBar(
    backgroundColor: kPrimaryColor,
    title: Text(
      'Mon application',
      style: GoogleFonts.philosopher(fontSize: 20),
    ),
    centerTitle: true,
  );
}
