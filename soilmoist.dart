import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class SM extends StatelessWidget {
  const SM({super.key});

  // Stream for fetching soil moisture data
  Stream<double> fetchSoilMoistureData() async* {
    final url =
        Uri.https('verms-79d98-default-rtdb.firebaseio.com', 'Chamber.json');

    while (true) {
      try {
        final response = await http.get(url);
        if (response.statusCode == 200) {
          final jsonData = json.decode(response.body);
          double soilMoistureValue = (jsonData['Soil Moisture'] is int)
              ? (jsonData['Soil Moisture'] as int).toDouble()
              : jsonData['Soil Moisture'];

          yield soilMoistureValue / 100; // Adjust based on your data structure
        } else {
          yield 0.0; // Default value in case of error
        }
      } catch (e) {
        yield 0.0; // Default value in case of error
      }
      await Future.delayed(
          const Duration(seconds: 10)); // Adjust the delay as needed
    }
  }

  Color _getMoistureColor(double value) {
    if (value <= 0.5) {
      return Colors.red; // Change this threshold as needed
    } else if (value >= 0.9) {
      return Colors.blue; // Default color
    } else {
      return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    double displayWidth = MediaQuery.of(context).size.width;

    return StreamBuilder<double>(
      stream: fetchSoilMoistureData(), // Listen to the soil moisture stream
      builder: (context, snapshot) {
        double soilMoistureValue;

        if (snapshot.connectionState == ConnectionState.waiting) {
          soilMoistureValue = 0.0; // Initial value while loading
        } else if (snapshot.hasError) {
          soilMoistureValue = 0.0; // Default value in case of error
        } else if (snapshot.hasData) {
          soilMoistureValue = snapshot.data!; // Get the soil moisture value
        } else {
          soilMoistureValue = 0.0; // Default if no data
        }

        // Display blank if loading or if there's an error
        String soilMoistureDisplay = (snapshot.connectionState ==
                    ConnectionState.waiting ||
                snapshot.hasError)
            ? '' // Show blank during loading or error
            : '${(soilMoistureValue * 100).toStringAsFixed(1)} %'; // Display with one decimal

        return Container(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            padding: const EdgeInsets.all(15.0),
            width: displayWidth * .89,
            height: displayWidth * .30,
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
                          'lib/uicons/sm.png',
                          height: displayWidth * .1,
                        ),
                        Text(
                          "  Soil Moisture",
                          style: GoogleFonts.nunito(
                            color: const Color(0xff013e3e),
                            fontSize: displayWidth * .04,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      soilMoistureDisplay, // NUM DISPLAY
                      style: GoogleFonts.quicksand(
                        color: const Color(0xff013e3e),
                        fontSize: displayWidth * .04,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                LinearPercentIndicator(
                  animation: true,
                  animateFromLastPercent: true,
                  animationDuration: 1000,
                  lineHeight: displayWidth * .04,
                  backgroundColor: Colors.transparent,
                  progressColor: _getMoistureColor(
                      soilMoistureValue), // Use the moisture color method
                  barRadius: const Radius.circular(50),
                  percent: soilMoistureValue, // PERCENTAGE
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
