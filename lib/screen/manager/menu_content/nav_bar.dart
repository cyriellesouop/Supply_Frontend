import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supply_app/common/constants.dart';
import 'package:supply_app/screen/manager/menu_content/command_history.dart';
import 'package:supply_app/screen/manager/menu_content/update_Profil.dart';

import '../../../models/Database_Model.dart';
import '../../../services/user_service.dart';
//import 'package:supply_app/constants.dart';

/* class ManagerHome extends StatefulWidget {
  //UserModel currentManager;
  String currentManagerID;
  ManagerHome({required this.currentManagerID, Key? key}) : super(key: key);
  @override
  _ManagerHomeState createState() => _ManagerHomeState();
}

class _ManagerHomeState extends State<ManagerHome> { */

class NavBar extends StatefulWidget {
  String currentManagerID;
  NavBar({required this.currentManagerID, Key? key}) : super(key: key);
  @override
  _NavBarState createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  UserService ServiceUser = new UserService();
   UserModel currentManager = new UserModel(name: '');

  @override
  void initState() {
    getCuurrentUser();

    super.initState();
  }

  getCuurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getString('id') ?? '';

    //get current manager and current manager position
    await ServiceUser.getUserbyId(id).then((value) {
      setState(() {
        currentManager = value;
        print('currrent user $currentManager');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
      padding: EdgeInsets.zero,
      children: [
        InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => UpdateProfil(
                        currentManagerID: widget.currentManagerID)));
          },
          child: UserAccountsDrawerHeader(
            accountName: Text(
              '${currentManager.name.toLowerCase()}',
              style: GoogleFonts.philosopher(
                  fontSize: 15, fontWeight: FontWeight.bold),
            ),

            accountEmail: Text(
              '${currentManager.phone}',
              style: GoogleFonts.poppins(fontSize: 15),
            ),
            currentAccountPicture: Container(
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
                          as ImageProvider)),
            ),

            /*  CircleAvatar(
              backgroundColor: Color.fromARGB(255, 243, 235, 245),
              child: ClipOval(
                child: SvgPicture.asset(
                  "assets/images/avar.svg",
                  height: 90,
                  width: 90,
                  fit: BoxFit.cover,
                ),
              ),
            ), */
            decoration: BoxDecoration(color: kPrimaryColor),

            //color: Color.fromARGB(255, 203, 56, 248)
          ),
        ),
        ListTile(
          leading: Icon(Icons.favorite),
          title: Text('Mes preferences'),
          onTap: () {},
        ),
        ListTile(
          leading: Icon(Icons.save),
          title: Text('Commandes enregistrees'),
          onTap: () {},
        ),
        ListTile(
          leading: Icon(Icons.history),
          title: Text('historique des commandes'),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CommandListe(
                        currentManagerID: widget.currentManagerID)));
          },
        ),
        ListTile(
          leading: Icon(Icons.settings),
          title: Text('Parametres'),
          onTap: () {},
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.contact_page),
          title: Text('Inviter des livreurs/entreprises'),
          onTap: () {},
        ),
        ListTile(
          leading: Icon(Icons.help_center_rounded),
          title: Text('Aide'),
          onTap: () {},
        ),
        ListTile(
          leading: Icon(Icons.exit_to_app_rounded),
          title: Text('Quitter'),
          onTap: () {},
        ),
      ],
    ));
  }
}
