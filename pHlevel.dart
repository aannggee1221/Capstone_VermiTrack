import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PHLevel extends StatelessWidget {
  const PHLevel({super.key});

  // Stream for fetching pH level data
  Stream<double> fetchPHLevel() async* {
    final url =
        Uri.https('verms-79d98-default-rtdb.firebaseio.com', 'NPK.json');
    while (true) {
      try {
        final response = await http.get(url);
        if (response.statusCode == 200) {
          final jsonData = json.decode(response.body);
          double phValue = double.parse(
              jsonData['SoilPH'].toString()); // Adjust the key as necessary
          yield phValue; // Yield the pH value
        } else {
          yield 7.0; // Default neutral value in case of error
        }
      } catch (e) {
        print('Error: $e');
        yield 0.0; // Default value in case of error
      }
      await Future.delayed(
          const Duration(seconds: 10)); // Adjust the delay as needed
    }
  }

  @override
  Widget build(BuildContext context) {
    double displayWidth = MediaQuery.of(context).size.width;

    return StreamBuilder<double>(
      stream: fetchPHLevel(), // Listen to the pH level stream
      builder: (context, snapshot) {
        String stat = '';
        String phd = '';

        if (snapshot.connectionState == ConnectionState.waiting) {
          phd = ''; // Default while loading, making it blank
        } else if (snapshot.hasError) {
          phd = 'Error'; // Display error message
        } else if (snapshot.hasData) {
          double phv = snapshot.data!; // Get the pH value from the stream
          if (phv > 0.0 && phv < 7.0) {
            stat = '  Acidic';
          } else if (phv == 7.0) {
            stat = '  Neutral';
          } else if (phv > 7.0 && phv <= 14.0) {
            stat = '  Alkaline';
          }
          phd =
              '${phv.toStringAsFixed(1)}$stat'; // Update display value with 1 decimal place
        } else {
          phd = ''; // Default if no data available
        }

        return Container(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            // PH LEVEL
            padding: const EdgeInsets.all(15.0),
            width: displayWidth * .89,
            height: displayWidth * .20,
            decoration: BoxDecoration(
              color: const Color(0xffffffff).withOpacity(.55),
              border: Border.all(
                color: const Color(0xff013e3e),
              ),
              borderRadius: const BorderRadius.all(
                Radius.circular(25),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Image.asset(
                          'lib/uicons/ph level.png',
                          height: displayWidth * .1,
                        ),
                        Text(
                          "  pH Scale",
                          style: GoogleFonts.nunito(
                            color: const Color(0xff013e3e),
                            fontSize: displayWidth * .04,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    // Wrap the pH display in an AnimatedSwitcher
                    AnimatedSwitcher(
                      duration: const Duration(
                          milliseconds: 300), // Animation duration
                      child: Text(
                        phd, // NUM DISPLAY
                        key: ValueKey<String>(phd), // Unique key for animation
                        style: GoogleFonts.quicksand(
                          color: const Color(0xff013e3e),
                          fontSize: displayWidth * .04,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
