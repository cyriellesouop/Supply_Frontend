import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:supply_app/components/screen/manager/components/inscription/inscription_name.dart';
import 'package:supply_app/components/screen/manager/components/manager_home.dart';
import 'package:supply_app/constants.dart';
import 'package:supply_app/main.dart';

import '../../models/Database_Model.dart';
import '../../services/user_service.dart';

/*Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final showInscription = prefs.getBool('showInscription') ?? false;

  // runApp(MyApp(showInscription : showInscription));
}

class MyApp extends StatelessWidget {
  final bool showInscription;

  const MyApp(
    Key? key,
    required this.showInscription,
  )
} : super( Key : key); */

class IntroductionScreen extends StatefulWidget {
  @override
  _IntroductionScreenState createState() => _IntroductionScreenState();
}

class _IntroductionScreenState extends State<IntroductionScreen> {
  late  UserModel exampleModel;
late UserService exampleService;


 
 
  final controller = PageController();
  bool isLastPage = false;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(bottom: 80),
        child: PageView(
          controller: controller,
          onPageChanged: (index) {
            setState(() => isLastPage = index == 2);
          },
          children: [
            Container(
              color: Colors.blue,
              child: Center(child: Text('page 1')),
            ),
            Container(
              color: Colors.yellow,
              child: Center(child: Text('page 2')),
            ),
            Container(
              color: Color.fromARGB(255, 252, 250, 251),
              child: Center(child: Text('page 3')),
            ),
          ],
        ),
      ),
      bottomSheet: isLastPage
          ? TextButton(
              style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  primary: Colors.white,
                  backgroundColor: kPrimaryColor,
                  minimumSize: const Size.fromHeight(80)),
              onPressed: () async {
                //navigate directly on the inscription page
                 final prefs = await SharedPreferences.getInstance();
                prefs.setBool('InscriptionName', true);
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const InscriptionName()));
              }, 
              child: Text(
                'COMMENCER',
                style: GoogleFonts.philosopher(
                    fontSize: 15,
                    //   color: kPrimaryColor,
                    fontWeight: FontWeight.w100),
              ))
          : Container(
              padding: EdgeInsets.symmetric(horizontal: 30),
              height: 80,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                      onPressed: () => controller.jumpToPage(2),
                      child: Text(
                        'SAUTER',
                        style: GoogleFonts.poppins(
                            fontSize: 15, color: kPrimaryColor),
                      )),
                  Center(
                    child: SmoothPageIndicator(
                      controller: controller,
                      count: 3,
                      effect: WormEffect(
                          spacing: 16,
                          dotColor: Colors.black26,
                          activeDotColor: Colors.teal.shade700),
                      onDotClicked: (index) => controller.animateToPage(index,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeIn),
                    ),
                  ),
                  TextButton(
                      onPressed: () => controller.nextPage(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeInOut),
                      child: Text(
                        'SUIVANT',
                        style: GoogleFonts.poppins(
                            fontSize: 15, color: kPrimaryColor),
                      ))
                ],
              ),
            ),
    );
  }
}
