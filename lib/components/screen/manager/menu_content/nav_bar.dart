import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supply_app/constants.dart';

class NavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
      padding: EdgeInsets.zero,
      children: [
        UserAccountsDrawerHeader(
          accountName: Text(
            'Souop audrey',
            style: GoogleFonts.poppins(fontSize: 15),
          ),
          accountEmail: Text(
            '693033904',
            style: GoogleFonts.poppins(fontSize: 15),
          ),
          currentAccountPicture: CircleAvatar(
            backgroundColor: Color.fromARGB(255, 243, 235, 245),
            child: ClipOval(
              child: SvgPicture.asset(
                "assets/images/avar.svg",
                height: 90,
                width: 90,
                fit: BoxFit.cover,
              ),
            ),
          ),
          decoration: BoxDecoration(color: kPrimaryColor),

          //color: Color.fromARGB(255, 203, 56, 248)
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
          onTap: () {},
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
