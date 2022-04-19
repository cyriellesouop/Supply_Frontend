import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../home_screen.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Lottie.asset("assets/images/loading.json"),
      /* Column(
        children: [
          Image.asset("assets/images/liv.png"),
          Text("Mon application", style: GoogleFonts.philosopher(
                        fontSize: 40, fontWeight: FontWeight.bold))

        ],
      ), */
      nextScreen: const HomeScreen(),
      splashIconSize: 110,
      duration: 5000,
      splashTransition: SplashTransition.fadeTransition,
      animationDuration:  const Duration(seconds: 2),
      )
   /* return Scaffold(
      
      backgroundColor: kPrimaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment:  MainAxisAlignment.center,
          children: [
            Image.asset("assets/images/liv.png", height: 120,),
            SizedBox(
              height: 20,
            ),
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            )

          ]),

      ) ,
    )*/
    ;
  }
}