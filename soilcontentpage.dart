import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vermit/sc_sqs/nitro.dart'; //Nitrogen display
import 'package:vermit/sc_sqs/phlevel.dart'; //pH scale display
import 'package:vermit/sc_sqs/phospo.dart'; //Phosphorus display
import 'package:vermit/sc_sqs/potass.dart'; //Postassium display
import 'package:vermit/sc_sqs/sctemphumi.dart'; //Temperature and Humidity display

class SoilContentPage extends StatelessWidget {
  const SoilContentPage({super.key});

  // Future to simulate delay
  Future<void> loadData() async {
    await Future.delayed(const Duration(milliseconds: 20)); // 500 ms delay
  }

  @override
  Widget build(BuildContext context) {
    double displayWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: FutureBuilder(
        future: loadData(), // Simulate a delay before loading widgets
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Instead of showing a loading spinner, show a blank container
            return const SizedBox.shrink(); // Invisible widget during loading
          } else {
            // After the delay, show the soil content widgets
            return ListView(
              children: [
                Column(
                  children: [
                    Center(
                      child: Text(
                        'SOIL CONTENT',
                        style: GoogleFonts.nunito(
                          textStyle: TextStyle(
                            color: const Color(0xff013e3e),
                            fontSize: displayWidth * 0.0468,
                            letterSpacing: 2,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SCtemphumi(),
                    const PHLevel(),
                    const Nitro(),
                    const Phospo(),
                    const Potass(),
                  ],
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
