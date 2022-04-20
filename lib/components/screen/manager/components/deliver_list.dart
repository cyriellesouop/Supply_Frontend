// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supply_app/components/screen/manager/components/command_page.dart';
import 'package:supply_app/components/screen/manager/components/edit_command.dart';
import '../../../../constants.dart';
import '../menu_content/nav_bar.dart';
import 'deliver_model.dart';

class DeliverList extends StatefulWidget {
  const DeliverList({Key? key}) : super(key: key);

  @override
  _DeliverListState createState() => _DeliverListState();
}

class _DeliverListState extends State<DeliverList> {
  bool isSearching = false;
  List<Deliver> delivers = [
    Deliver(1, "romeo", "voiture", 10, "assets/images/avar.svg"),
    Deliver(2, "Luc", "Moto", 1, "assets/images/avar.svg"),
    Deliver(3, "leo", "voiture", 8, "assets/images/avar.svg"),
    Deliver(4, "Luc", "Moto", 1, "assets/images/avar.svg"),
    Deliver(5, "leo", "voiture", 8, "assets/images/avar.svg"),
    Deliver(6, "Luc", "Moto", 1, "assets/images/avar.svg"),
    Deliver(7, "leo", "voiture", 8, "assets/images/avar.svg"),
    Deliver(8, "Luc", "Moto", 1, "assets/images/avar.svg"),
    Deliver(9, "leo", "voiture", 8, "assets/images/avar.svg"),
    Deliver(10, "Luc", "Moto", 1, "assets/images/avar.svg"),
    Deliver(11, "leo", "voiture", 8, "assets/images/avar.svg"),
    Deliver(12, "Luc", "Moto", 1, "assets/images/avar.svg"),
  ];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Stack(
      children: <Widget>[
        Image.asset(
          "assets/images/maps.jpeg",
          height: size.height,
          width: size.width,
          fit: BoxFit.cover,
        ),
        Scaffold(
          backgroundColor: Colors.transparent.withBlue(20),
          drawer: Visibility(visible: isVisible(), child: NavBar()),
          appBar: AppBar(
              backgroundColor: Colors.transparent,
              title: !isSearching
                  ? Text(
                      'Mon application',
                      style: GoogleFonts.philosopher(fontSize: 20),
                    )
                  : TextField(
                      decoration: InputDecoration(
                          icon: Icon(
                            Icons.search,
                            color: Colors.white,
                            size: 26,
                          ),
                          hintText: "Rechercher un livreur",
                          hintStyle: TextStyle(color: Colors.white70),
                          fillColor: kPrimaryColor),
                    ),
                    //visibilite des elements de la appbar
              actions: <Widget>[
                // !isSearching ?
                Visibility(
                  visible: isVisible(),
                  child: Padding(
                      padding: EdgeInsets.only(right: 10.0),
                      child: IconButton(
                        icon: Icon(
                          Icons.search,
                          size: 26,
                        ),
                        onPressed: () {
                          setState(() {
                            this.isSearching = !this.isSearching;
                          });
                        },
                      )),
                ),
                Visibility(
                  visible: isVisible(),
                  child: Padding(
                      padding: EdgeInsets.only(right: 10.0),
                      child: GestureDetector(
                        onTap: () {},
                        child: Icon(Icons.more_vert),
                      )),
                ),
              ]),
          body: ListView.builder(
            padding: EdgeInsets.only(
                top: kDefaultPadding,
                left: kDefaultPadding / 2,
                right: kDefaultPadding / 2),
            itemCount: delivers.length,
            itemBuilder: (BuildContext context, int index) {
              return SingleChildScrollView(
                child: Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Color.fromARGB(255, 243, 235, 245),
                      radius: 30,
                      child: SvgPicture.asset(
                        delivers[index].picture,
                      ),
                    ),
                    title: Text(delivers[index].name),
                    subtitle: Text(delivers[index].outil),
                    trailing: Text(
                      "10 km",
                      style:
                          GoogleFonts.poppins(fontSize: 12, color: Colors.grey),
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              // builder: (context) => DetailPage(delivers[index])
                              builder: (context) => EditCommand()));
                    },
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  bool isVisible() {
    if (isSearching == false) {
      return true;
    } else {
      return false;
    }
  }
}

class DetailPage extends StatelessWidget {
  final Deliver deliver;
  DetailPage(this.deliver);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(deliver.name),
      ),
    );
  }
}
