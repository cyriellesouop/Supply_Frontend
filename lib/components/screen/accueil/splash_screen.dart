import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../home_screen.dart';

class SplashScreen extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Lottie.asset("assets/images/loading.json"),  
      nextScreen: const HomeScreen(),
      splashIconSize: 110,
      duration: 5000,
      splashTransition: SplashTransition.fadeTransition,
      animationDuration:  const Duration(seconds: 2),
      )
    ;
  }
}