import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supply_app/components/models/Database_Model.dart';
import 'package:supply_app/components/screen/accueil/home_Page.dart';
import 'package:supply_app/components/screen/manager/components/inscription/inscription_name.dart';
import 'package:supply_app/components/screen/manager/components/manager_home.dart';
import 'package:supply_app/components/screen/manager/components/profil_deliver.dart';
import 'package:supply_app/components/services/auth_service.dart';
import 'package:supply_app/components/services/command_service.dart';
import 'package:supply_app/components/services/user_service.dart';
//import 'package:supply_app/components/screen/manager/components/manager_home.dart';
import 'components/screen/accueil/splash_screen.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final prefs=await SharedPreferences.getInstance();
     final showHome = prefs.getBool('showHome')?? false;
     runApp(MyApp(showHome:showHome));
  configLoading();
}
 


//onloading bar
void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.yellow
    ..backgroundColor = Colors.green
    ..indicatorColor = Colors.yellow
    ..textColor = Colors.yellow
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = true
    ..dismissOnTap = false;
  // ..customAnimation = CustomAnimation();
}

class MyApp extends StatelessWidget {
  final bool showHome;

   //UserModel currentUser = new UserModel(name: 'audrey',picture: "assets/images/profil.png");
   MyApp({Key? key,  required this.showHome}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // ignore: prefer_const_constructors
   /* return StreamProvider<List<UserModel>>.value(
      value:UserService().getDelivers(),
       initialData: [],*/
    
    return MultiProvider(
      providers:[
        //....................................
         //StreamProvider<List<CommandModel>>.value(value: CommandService().getCommands(), initialData: [] ),
          StreamProvider<List<UserModel>>.value(value: UserService().getDelivers(), initialData: []),
          StreamProvider<AppUser?>.value(value: Authclass().user, initialData: null,),
          


        ],
     // child: StreamProvider<AppUser?>.value(
       // value: Authclass().user, initialData: null,
        child: MaterialApp(
          //  title: 'Mon application',
          debugShowCheckedModeBanner: false,
        //  home:  ManagerHome(currentManager: currentUser,),
          
           home: SplashScreen(),//SplashScreen(),// const HomePageScreen(),
         // home: showHome? const HomePageScreen(): SplashScreen(),
          builder: EasyLoading.init(),
          // home: HomeScreen()
         // )
          ),
    );
   /* return MaterialApp(
        //  title: 'Mon application',
        debugShowCheckedModeBanner: false,
        home: showHome? const InscriptionName(): SplashScreen(),
        builder: EasyLoading.init(),
        // home: HomeScreen()
        );*/
  }
}
