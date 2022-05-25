import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supply_app/components/models/Database_Model.dart';
import 'package:supply_app/components/screen/accueil/splash_screen.dart';
import 'package:supply_app/components/screen/manager/components/inscription/inscription_name.dart';
import 'package:supply_app/components/screen/manager/components/manager_home.dart';
import 'package:supply_app/components/services/user_service.dart';

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({Key? key}) : super(key: key);

  @override
  _HomePageScreenState createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  @override
  Widget build(BuildContext context) {
    // List<Agence> listAg = Provider.of<List<Agence>>(context);
    final user = Provider.of<AppUser?>(context);
    
    UserService ServiceUser = new UserService();
    UserModel currentUser = new UserModel(name: 'audrey');//,picture: "assets/images/profil.png"

    if (user == null) {
      return SplashScreen();
     // return InscriptionName();
    } else {
      print("in my home page the user id isssssssssssssssssssssssssssssssssssssssssssssssssssss:${user.uid}");
      ServiceUser.getUserbyId(user.uid).then((value) {currentUser=value;});

    /*  setState(() {
        currentUser = ServiceUser.getUserbyId(user.uid) as UserModel;
      });*/

      return ManagerHome(currentManagerID: user.uid);
    }
  }
}
