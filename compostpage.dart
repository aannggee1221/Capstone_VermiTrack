import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vermit/compo_sqs/humidity.dart'; //humidity display
import 'package:vermit/compo_sqs/temperature.dart'; //temperature display

class CompostPage extends StatelessWidget {
  const CompostPage({super.key});

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
            // While waiting, you can show an empty space or placeholder
            return const SizedBox.shrink(); // Invisible widget during loading
          } else {
            // After the delay, show the compost chamber widgets with a smooth transition
            return AnimatedOpacity(
              opacity: 1.0, // Fully opaque after loading
              duration: const Duration(
                  milliseconds: 500), // Duration for the fade-in effect
              child: ListView(
                children: [
                  Column(
                    children: [
                      Center(
                        child: Text(
                          'COMPOST CHAMBER',
                          style: GoogleFonts.nunito(
                            textStyle: TextStyle(
                              color: const Color(0xff013e3e),
                              fontSize: displayWidth * 0.468,
                              letterSpacing: 2,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const Temperature(),
                      const Humidity(),
                    ],
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
