// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:supply_app/common/constants.dart';
import 'package:google_fonts/google_fonts.dart';
class EditCommand extends StatefulWidget {
  @override
  _EditCommandState createState() => _EditCommandState();
}

class _EditCommandState extends State<EditCommand> {
  String bouton = "Annuler";
  String dropdownValue = 'Fragile';
  String dropdownValuePoids = 'Kg';
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: kBackgroundColor,
        //debugShowCheckedModeBanner: false,
        body: Container(
          color: Colors.white,
          child: ListView(
            children: [
              Center(
                child:
                    Stack(alignment: AlignmentDirectional.topCenter, children: [
                  Container(
                    height: 220,
                    color: kPrimaryColor,
                  ),
                  Container(
                    child: Positioned(
                        top: 40,
                        child: Container(
                          height: 200,
                          width: 200,
                          child: CircleAvatar(
                            radius: 10,
                            backgroundColor: kBackgroundColor,
                            child: CircleAvatar(
                              radius: 80,
                              backgroundColor:
                                  Color.fromARGB(255, 228, 171, 228),
                              child: SvgPicture.asset(
                                "assets/images/avar.svg",
                                height: size.height / 4,
                                width: size.width / 4,
                                alignment: Alignment.center,
                              ),
                            ),
                          ),
                        )),
                  ),
                ]),
              ),
              SizedBox(
                height: 10,
              ),
              Center(
                child: Text(
                  "Moguem Souop Audrey",
                  style: GoogleFonts.poppins(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.none),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Center(
                child: Text(
                  "Voiture         ",
                  style: GoogleFonts.poppins(
                      color: Colors.redAccent,
                      fontSize: 13,
                      decoration: TextDecoration.none),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Center(
                child: Text(
                  "distance",
                  style: GoogleFonts.poppins(
                      color: Colors.grey,
                      fontSize: 13,
                      decoration: TextDecoration.none),
                ),
              ),
              SizedBox(
                height: 25,
              ),
              Padding(
                padding: const EdgeInsets.only(
                    bottom: 30, right: kDefaultPadding, left: kDefaultPadding),
                child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Etat du colis',
                    hintStyle: TextStyle(color: Colors.grey[800]),
                  ),
                  value: dropdownValue,
                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownValue = newValue!;
                    });
                  },
                  items: <String>['Fragile', 'non-fragile', 'autres']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    bottom: 30, right: kDefaultPadding, left: kDefaultPadding),
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.,
                  children: [
                    Container(
                      width: size.width * 0.6,
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            labelText: 'Estimer le poids',
                            hintStyle: TextStyle(color: Colors.grey[800]),
                            fillColor: Colors.white70),
                      ),
                    ),
                    Expanded(
                      //  width: size.width * 0.2,
                      child: DropdownButtonFormField<String>(
                        value: dropdownValuePoids,
                        onChanged: (String? newValue) {
                          setState(() {
                            dropdownValuePoids = newValue!;
                          });
                        },
                        items: <String>['tonnes', 'Kg', 'g', 'mg']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    bottom: 30, right: kDefaultPadding, left: kDefaultPadding),
                child: TextFormField(
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.newline,
                  minLines: 1,
                  maxLines: 5,
                  decoration: InputDecoration(
                      labelText: 'Decrire clairement la commande ici',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      filled: true,
                      hintStyle: TextStyle(color: Colors.grey[800]),
                      // prefixIcon: const Icon(Icons.write),
                      hintText: "Description de la commande ici",
                      fillColor: Colors.white70),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(
                    bottom: kDefaultPadding,
                    right: kDefaultPadding,
                    left: kDefaultPadding),
                child: FlatButton(
                  onPressed: () {
                   
                  },
                  padding: EdgeInsets.all(15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  color: kPrimaryColor,
                  textColor: kBackgroundColor,
                  child: const Text(
                    'PUBLIER',
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
