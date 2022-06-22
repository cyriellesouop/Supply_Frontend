import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:supply_app/common/constants.dart';
import 'package:supply_app/common/helpers.dart';
import 'package:supply_app/common/palette.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:supply_app/screen/manager/components/inscription/inscription_name.dart';

class IntroScreen extends StatelessWidget {
  const IntroScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ThemeData theme = Theme.of(context);

    return IntroductionScreen(
      globalBackgroundColor: Palette.primarySwatch.shade200,
      pages: getPages(context),
      onDone: () {
        push(context, const InscriptionName(), replace: true);
      },
      showBackButton: true,
      showNextButton: true,
      next: const Icon(Icons.arrow_right),
      back: const Icon(Icons.arrow_left),
      done: IconButton(
        icon: const Icon(Icons.check),
        onPressed: () async {
          final prefs = await SharedPreferences.getInstance();
          prefs.setBool('InscriptionName', true);
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const InscriptionName()));
        },
      ),
      showSkipButton: false,
      // skipStyle: TextButton.styleFrom(primary: Colors.red),
      doneStyle: TextButton.styleFrom(primary: Colors.white),
      nextStyle: TextButton.styleFrom(primary: Colors.white),
      backStyle: TextButton.styleFrom(primary: Colors.white),
      // skip: const Text("Sauter"),
      dotsDecorator: DotsDecorator(
          size: const Size.square(10.0),
          activeSize: const Size(30.0, 10.0),
          activeColor: Colors.white,
          // activeColor: theme.colorScheme.secondary,
          color: Colors.black26,
          spacing: const EdgeInsets.symmetric(horizontal: 3.0),
          activeShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25.0))),
    );
  }

  getPages(BuildContext context) {
    // ThemeData theme = Theme.of(context);
    PageViewModel page1 = PageViewModel(
      titleWidget: RichText(
        text: TextSpan(
          style: TextStyle(
            color: Colors.black.withOpacity(.7),
            fontSize: 48,
            fontWeight: FontWeight.bold,
          ),
          children: [
            const TextSpan(text: "your st"),
            TextSpan(
              text: "uffz",
              style: TextStyle(color: Colors.white),
            )
          ],
        ),
      ),
      bodyWidget: Container(
        margin: EdgeInsets.symmetric(horizontal: kDefaultPadding),
        child: Text(
          "Got some stuffs to be delivered ? Don't worry, a solution already ready for you.",
          style: GoogleFonts.poppins(color: Colors.white, fontSize: 17),
        ),
      ),
      image: Center(child: Image.asset("assets/images/amico.png")),
      decoration: getDeco(context),
    );

    PageViewModel page2 = PageViewModel(
      titleWidget: RichText(
        text: TextSpan(
          style: TextStyle(
            color: Colors.black.withOpacity(.7),
            fontSize: 48,
            fontWeight: FontWeight.bold,
          ),
          children: [
            const TextSpan(text: "The deliver"),
            TextSpan(
              text: "er",
              style: TextStyle(color: Colors.white),
            )
          ],
        ),
      ),
      bodyWidget: Container(
        margin: EdgeInsets.symmetric(horizontal: kDefaultPadding),
        child: Text(
            "A delivery person at your disposal at the right place, at the right time.",
            style: GoogleFonts.poppins(color: Colors.white, fontSize: 17)),
      ),
      image: Center(child: Image.asset("assets/images/agent.png")),
      decoration: getDeco(context),
    );

    PageViewModel page3 = PageViewModel(
      titleWidget: RichText(
        text: TextSpan(
          style: TextStyle(
            color: Colors.white,
            fontSize: 48,
            fontWeight: FontWeight.bold,
          ),
          children: [
            const TextSpan(text: "Their feel"),
            TextSpan(
              text: "ings",
              style: TextStyle(color: Colors.black),
            )
          ],
        ),
      ),
      //title: 'Their Feelingz',
      bodyWidget: Container(
        margin: EdgeInsets.symmetric(horizontal: kDefaultPadding),
        child: Text(
            "Have your relatives a joyfully drawn smile and an assured satisfaction.",
            style: GoogleFonts.poppins(color: Colors.white, fontSize: 17)),
      ),
      image: Center(child: Image.asset("assets/images/pana.png")),
      decoration: getDeco(context),
    );

    return [page1, page2, page3];
  }

  getDeco(BuildContext context) {
    //  ThemeData theme = Theme.of(context);
    return PageDecoration(
      bodyAlignment: Alignment.topLeft,
      pageColor: Palette.primarySwatch.shade200,
      bodyTextStyle: const TextStyle(fontSize: 26),
      titleTextStyle: const TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
