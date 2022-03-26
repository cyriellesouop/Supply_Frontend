// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:supply_app/components/screen/manager/components/command_page.dart';
import 'deliver_model.dart';

class DeliverList extends StatefulWidget {
  const DeliverList({Key? key}) : super(key: key);

  @override
  _DeliverListState createState() => _DeliverListState();
}

class _DeliverListState extends State<DeliverList> {
  List<Deliver> delivers = [
    Deliver(1, "romeo", "voiture", 10, "assets/images/avatarlist.svg"),
    Deliver(2, "Luc", "Moto", 1, "assets/images/avatarlist.svg"),
    Deliver(3, "leo", "voiture", 8, "assets/images/avatarlist.svg"),
    Deliver(4, "Luc", "Moto", 1, "assets/images/avatarlist.svg"),
    Deliver(5, "leo", "voiture", 8, "assets/images/avatarlist.svg"),
    Deliver(6, "Luc", "Moto", 1, "assets/images/avatarlist.svg"),
    Deliver(7, "leo", "voiture", 8, "assets/images/avatarlist.svg"),
    Deliver(8, "Luc", "Moto", 1, "assets/images/avatarlist.svg"),
    Deliver(9, "leo", "voiture", 8, "assets/images/avatarlist.svg"),
    Deliver(10, "Luc", "Moto", 1, "assets/images/avatarlist.svg"),
    Deliver(11, "leo", "voiture", 8, "assets/images/avatarlist.svg"),
    Deliver(12, "Luc", "Moto", 1, "assets/images/avatarlist.svg"),
    Deliver(13, "leo", "voiture", 8, "assets/images/avatarlist.svg"),
    Deliver(14, "Luc", "Moto", 1, "assets/images/avatarlist.svg"),
    Deliver(15, "leo", "voiture", 8, "assets/images/avatarlist.svg")
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: ListView.builder(
        itemCount: delivers.length,
        itemBuilder: (BuildContext context, int index) {
          return SingleChildScrollView(
            child: Card(
              child: ListTile(
                leading: CircleAvatar(
                  radius: 30,
                  child: SvgPicture.asset(
                    delivers[index].picture,
                  ),
                  // backgroundImage: NetworkImage(delivers[index].picture),
                  // backgroundColor: Colors.grey,
                ),
                title: Text(delivers[index].name),
                subtitle: Text(delivers[index].outil),
                trailing: const Text(
                  "10 km",
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          // builder: (context) => DetailPage(delivers[index])
                          builder: (context) => CommandPage()));
                },
              ),
            ),
          );
        },
      ),
    );

    //   }
  }
  //   );
  // }
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

AppBar buildAppBar() {
  return AppBar(
      title: Text("Mon application"),
      leading: GestureDetector(
        onTap: () {/* Write listener code here */},
        child: Icon(
          Icons.menu, // add custom icons also
        ),
      ),
      actions: <Widget>[
        Padding(
            padding: EdgeInsets.only(right: 10.0),
            child: GestureDetector(
              onTap: () {},
              child: Icon(
                Icons.search,
                size: 26.0,
              ),
            )),
        Padding(
            padding: EdgeInsets.only(right: 10.0),
            child: GestureDetector(
              onTap: () {},
              child: Icon(Icons.more_vert),
            )),
      ]);
}
