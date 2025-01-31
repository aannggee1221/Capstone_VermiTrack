import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; //Google fonts package
import 'package:google_nav_bar/google_nav_bar.dart'; //Google navigation bar package
import 'package:vermit/pages/compostpage.dart'; //Compost page contents
import 'package:vermit/pages/motorspage.dart'; //Motors page contents
import 'package:vermit/pages/soilcontentpage.dart'; //Soil content page contents
import 'package:vermit/pages/wormbinpage.dart'; //Worm bin page contents

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;

  static const List<Widget> _pages = <Widget>[
    WormBinPage(),
    SoilContentPage(),
    CompostPage(),
    MotorsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    double displayWidth = MediaQuery.of(context).size.width;
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xff77e5b6),
            Color(0xffffffff),
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text(
            "VermiTrack",
            style: GoogleFonts.nunito(
              textStyle: TextStyle(
                color: const Color(0xff013e3e),
                fontSize: displayWidth * .058,
                letterSpacing: 1,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          titleSpacing: displayWidth * .07,
        ),
        body: Center(
          child: _pages.elementAt(currentIndex),
        ),
        bottomNavigationBar: Container(
          color: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 25,
              vertical: 15,
            ),
            child: GNav(
              backgroundColor: Colors.transparent,
              color: Colors.black,
              activeColor: const Color(0xff026c6d),
              tabActiveBorder: Border.all(
                color: const Color(0xff013e3e),
              ),
              gap: 8,
              padding: const EdgeInsets.all(10),
              tabs: const [
                GButton(
                  icon: Icons.ad_units_rounded,
                  text: 'Worm Bin',
                ),
                GButton(
                  icon: Icons.terrain_rounded,
                  text: 'Soil Content',
                ),
                GButton(
                  icon: Icons.compost_rounded,
                  text: 'Compost',
                ),
                GButton(
                  icon: Icons.miscellaneous_services_rounded,
                  text: 'Motors',
                ),
              ],
              selectedIndex: currentIndex,
              onTabChange: (index) {
                setState(() {
                  currentIndex = index;
                });
              },
            ),
          ),
        ),
      ),
    );
  }
}
