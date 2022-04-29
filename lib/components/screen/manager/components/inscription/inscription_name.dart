// ignore_for_file: dead_code, sized_box_for_whitespace, prefer_const_constructors, unnecessary_null_comparison, deprecated_member_use, no_logic_in_create_state,, must_be_immutable

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:supply_app/components/screen/manager/components/inscription/inscription_validate.dart';
import 'package:supply_app/constants.dart';
import 'package:path/path.dart' show join;

class InscriptionName extends StatefulWidget {
 
  //les controleurs des champs nom, adresse et de la photo
  /*TextEditingController? nameController = TextEditingController();
  TextEditingController? adresseController = TextEditingController();
  TextEditingController? pictureController = TextEditingController(); */

  // InscriptionName(this.nameController,this.adresseController,this.pictureController, {Key? key}) : super(key: key);

  // const InscriptionName({Key? key}) : super(key: key);


  @override
  _InscriptionNameState createState() => _InscriptionNameState();
}

class _InscriptionNameState extends State<InscriptionName> {
  late PickedFile _imageFile;
  final ImagePicker _picker = ImagePicker();
  late File _image;
  final picker = ImagePicker();


//les controleurs des champs nom, adresse et de la photo
  TextEditingController nameController = TextEditingController();
  TextEditingController adresseController = TextEditingController();
  TextEditingController pictureController = TextEditingController(); 

// creation du constructeur avec les elements caracteristiques de la page inscription name
  
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
            child: ListView(
              children: <Widget>[
                Center(
                  child: InkWell(
                    onTap: () {
                      showModalBottomSheet(
                          context: context,
                          builder: ((builder) => bottomSheet()));
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
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: AssetImage("assets/images/profil.png")

                                /*  image: (_imageFile != null)
                                    ? FileImage(File(_imageFile.path))
                                    : AssetImage("assets/images/profil.png")
                                        as ImageProvider
                                */
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
                              color: kPrimaryColor),
                          child: IconButton(
                            icon: Icon(Icons.camera_alt, color: Colors.white),
                            onPressed: () {},
                          ),
                        ),
                      )
                    ]),
                  ),
                ),
                const SizedBox(
                  height: 25.0,
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 30),
                  child: TextFormField(
                    controller: nameController,
                   
                    style: GoogleFonts.poppins(fontSize: 15),
                    decoration: InputDecoration(
                        //  labelText: 'Veuillez saisir le nom de l\'entreprise',

                        filled: true,
                        hintStyle: TextStyle(color: Colors.grey[800]),
                        hintText: "Nom de l\'entreprise",
                        //  prefixIcon: const Icon(Icons.home_mini_rounded),
                        fillColor: Colors.white70),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 30),
                  child: TextFormField(
                    controller: adresseController,
                    style: GoogleFonts.poppins(fontSize: 15),
                    decoration: InputDecoration(
                        //  labelText: 'Veuillez saisir le nom de l\'entreprise',

                        filled: true,
                        hintStyle: TextStyle(color: Colors.grey[800]),
                        hintText: "Adresse de l'entreprise",
                        //  prefixIcon: const Icon(Icons.home_mini_rounded),
                        fillColor: Colors.white70),
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                FlatButton(
                  onPressed: () async {
                      
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>  PhoneAuth(nameField :nameController.text,adressField:adresseController.text, picture:pictureController.text))
                            );
                            
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
               // takePhoto(ImageSource.camera);
              },
              label: Text("Camera"),
            ),
            FlatButton.icon(
              icon: Icon(Icons.image),
              onPressed: () {
                selectOrTakePhoto(ImageSource.camera);
               // takePhoto(ImageSource.gallery);
              },
              label: Text("Gallerie"),
            ),
          ])
        ],
      ),
    );
  }

Future selectOrTakePhoto(ImageSource imageSource) async {
    final pickedFile = await picker.getImage(source: imageSource);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        print(pickedFile.path);
     //   Navigator.pushNamed(context, routeEdit, arguments: _image);
      } else
        print('No photo was selected or taken');
    });
  }







  

  /*void takePhoto(ImageSource source) async {

    try{
    String pathImage = join((await getTemporaryDirectory()).path,'${DateTime.now().millisecondsSinceEpoch}.jpg');
    final pickedFile = await _picker.getImage(
      source: source,
      
    );
    setState(() {
      _imageFile = pickedFile!;
    });
    } catch (e){
      print(e);
    }
  }*/

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<PickedFile>('_imageFile', _imageFile));
    properties.add(DiagnosticsProperty<PickedFile>('_imageFile', _imageFile));
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
