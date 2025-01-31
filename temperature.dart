import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Temperature extends StatelessWidget {
  const Temperature({super.key});

  // Stream for fetching temperature data
  Stream<double> fetchTemperature() async* {
    final url =
        Uri.https('verms-79d98-default-rtdb.firebaseio.com', 'DHT_11.json');
    while (true) {
      try {
        final response = await http.get(url);
        if (response.statusCode == 200) {
          final jsonData = json.decode(response.body);
          double temperatureValue =
              double.parse(jsonData['Temperature'].toString());
          yield temperatureValue; // Yield the temperature value
        } else {
          yield 0.0; // Error handling
        }
      } catch (e) {
        yield 0.0; // Default value in case of error
      }
      await Future.delayed(
          const Duration(seconds: 5)); // Adjust the delay as needed
    }
  }

  @override
  Widget build(BuildContext context) {
    double displayWidth = MediaQuery.of(context).size.width;

    Color currentTColor(double tr) {
      if (tr >= 28) {
        return Colors.red;
      } else if (tr <= 10) {
        return Colors.blue;
      } else {
        return Colors.green;
      }
    }

    return StreamBuilder<double>(
      stream: fetchTemperature(), // Listen to the temperature stream
      builder: (context, snapshot) {
        String temperatureDisplay;

        if (snapshot.connectionState == ConnectionState.waiting) {
          temperatureDisplay =
              ''; // Show loading text while data is being fetched
        } else if (snapshot.hasError) {
          temperatureDisplay = 'Error: ${snapshot.error}'; // Handle errors
        } else if (snapshot.hasData) {
          double tr = snapshot.data!; // Get the temperature value
          temperatureDisplay =
              '${tr.toStringAsFixed(1)} °C'; // Format the temperature display string
        } else {
          temperatureDisplay =
              'No data available'; // Default message if no data
        }

        double normalizedTemperature = (snapshot.hasData)
            ? (snapshot.data! / 100) // Adjust to fit percentage scale
            : 0;

        return Container(
          padding: const EdgeInsets.all(5.0),
          child: Container(
            padding: const EdgeInsets.all(15),
            width: displayWidth * .89,
            height: displayWidth * .70,
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
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  children: [
                    Image.asset(
                      'lib/uicons/temp.png',
                      height: displayWidth * .1,
                    ),
                    const SizedBox(width: 10), // Add some space
                    Text(
                      "Temperature",
                      style: GoogleFonts.nunito(
                        color: const Color(0xff013e3e),
                        fontSize: displayWidth * .04,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                CircularPercentIndicator(
                  animation: true,
                  animateFromLastPercent: true, // Smooth transition
                  animationDuration: 1000, // Adjust duration as needed
                  backgroundColor: Colors.transparent,
                  radius: displayWidth * .25,
                  lineWidth: displayWidth * .05,
                  progressColor:
                      currentTColor(snapshot.hasData ? snapshot.data! : 0.0),
                  startAngle: 230,
                  circularStrokeCap: CircularStrokeCap.round,
                  percent: normalizedTemperature, // PERCENTAGE
                  center: Text(
                    temperatureDisplay, // NUM DISPLAY
                    style: TextStyle(
                      fontSize: displayWidth * .06,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xff013e3e),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
