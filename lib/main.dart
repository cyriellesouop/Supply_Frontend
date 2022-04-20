import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'components/screen/accueil/splash_screen.dart';

Future <void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // ignore: prefer_const_constructors
    return MaterialApp(
        //  title: 'Mon application',
        
        debugShowCheckedModeBanner: false,
        home:  SplashScreen()
       // home: HomeScreen()
        );
  }
}
