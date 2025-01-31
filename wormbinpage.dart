import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vermit/wormbin_sqs/fan.dart'; //Fan display
import 'package:vermit/wormbin_sqs/sm.dart'; //Soil moisture display
import 'package:vermit/wormbin_sqs/sprinkler.dart'; //Sprinkler display
import 'package:vermit/wormbin_sqs/temphumi.dart'; //Temperature and Humidity display

class WormBinPage extends StatelessWidget {
  const WormBinPage({super.key});

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
            // After the delay, show the worm bin widgets
            return ListView(
              children: [
                Column(
                  children: [
                    Center(
                      child: Text(
                        'WORM BIN',
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
                    const TempHumi(),
                    const SM(),
                    const Fan(),
                    const Sprinkler(),
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
