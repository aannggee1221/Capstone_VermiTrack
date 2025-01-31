import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vermit/motor_sqs/conveyor.dart'; //Conveyor display
import 'package:vermit/motor_sqs/separator.dart'; //Separator display

class MotorsPage extends StatelessWidget {
  const MotorsPage({super.key});

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
            // After the delay, show the motors widgets
            return ListView(
              children: [
                Column(
                  children: [
                    Center(
                      child: Text(
                        'MOTORS',
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
                    const Conveyor(),
                    const Separator(),
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
