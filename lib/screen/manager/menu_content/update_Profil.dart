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
import 'package:supply_app/models/Database_Model.dart';
import 'package:supply_app/services/storage_service.dart';
import 'package:supply_app/services/user_service.dart';

class UpdateProfil extends StatefulWidget {
  String currentManagerID;
  UpdateProfil({required this.currentManagerID, Key? key}) : super(key: key);

  @override
  _UpdateProfilState createState() => _UpdateProfilState();
}

class _UpdateProfilState extends State<UpdateProfil> {
  //_image contiendra le chemin d'acces a l'image prise depuis un telephone
  var _image;
  File? image;
  File? avatarImageFile;
  bool? isLoading;
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;

//les controleurs des champs nom, adresse et de la photo
  TextEditingController nameController = TextEditingController();
  TextEditingController adresseController = TextEditingController();
  UserService ServiceUser = new UserService();
  UserModel currentManager = new UserModel(name: 'fabiol',idDoc: "audrey");
  String picture = "assets/images/profil.png";
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Storage storage = Storage();
//vider les controller
  @override
  void dispose() {
    nameController.dispose();
    adresseController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    getCuurrentUser();

    super.initState();
  }

  getCuurrentUser() async {
    //get current manager and current manager position
    await ServiceUser.getUserbyId(widget.currentManagerID).then((value) {
      setState(() {
        currentManager = value;
        print('currrent user $currentManager');
      });
    });
  }

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
                      /* validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'veuillez saisir votre nom';
                        }
                        return null;
                      }, */
                      decoration: InputDecoration(
                          labelText: "Votre nom",
                          //  labelStyle: s
                          filled: true,
                          hintStyle: TextStyle(color: Colors.grey[800]),
                          hintText: "${currentManager.name}",
                          fillColor: Colors.white70),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 30),
                    child: TextFormField(
                      controller: adresseController,
                      style: GoogleFonts.poppins(fontSize: 15),
                 /*      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'veuillez saisir l adresse de votre entreprise';
                        }
                        return null;
                      }, */
                      decoration: InputDecoration(
                          labelText: "Adresse de l'entreprise",
                          filled: true,
                          hintStyle: TextStyle(color: Colors.grey[800]),
                          hintText: "${currentManager.adress}",
                          fillColor: Colors.white70),
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  FlatButton(
                    onPressed: () async {
                      print("le chemin d'acces a l'image est :$picture");
                      print(
                          "le deuxieme chemin d'acces a l'image est :$_image");
                    },
                    padding: EdgeInsets.all(15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    color: kPrimaryColor,
                    textColor: kBackgroundColor,
                    child: Text(
                      'ENREGISTRER LES MODIFICATIONS',
                      style: GoogleFonts.poppins(fontSize: 13),
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
    //-------------------------------------------------------
    image = File(pickedFile.path);
    final fileName = p.basename(pickedFile.path);
    final savedImage =
        await File(pickedFile.path).copy('${appDir.path}/$fileName');
    setState(() {
      _image = savedImage;
      // picture = pickedFile.path;

      //======================================================
      avatarImageFile = image;
      isLoading = true;
      //======================================================
    });
    uploadFile();
  }

  Future uploadFile() async {
    var photo;
    String fileName =
        '${nameController.text} prise le ${DateTime.now().toString()}';
    UploadTask uploadTask = uploadImageFile(avatarImageFile!, fileName);
    try {
      TaskSnapshot snapshot = await uploadTask;
      photo = await snapshot.ref.getDownloadURL();

      //  photoUrl = await snapshot.ref.getDownloadURL();
      // await profileProvider.setPrefs(FirestoreConstants.photoUrl, photoUrl);
      setState(() {
        isLoading = false;
        picture = photo;
      });
      print('mise a jour du profil reussi');
    } on FirebaseException catch (e) {
      setState(() {
        isLoading = false;
      });
      print('l erreur sur profil est : $e');
    }
  }

  UploadTask uploadImageFile(File image, String fileName) {
    Reference reference = firebaseStorage.ref(); //.child(fileName);
    UploadTask uploadTask = reference.putFile(image);
    return uploadTask;
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
      'Profil',
      style: GoogleFonts.philosopher(fontSize: 20),
    ),
    centerTitle: true,
  );
}
 