import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Humidity extends StatelessWidget {
  const Humidity({super.key});

  // Stream for fetching humidity data
  Stream<double> fetchHumidity() async* {
    final url =
        Uri.https('verms-79d98-default-rtdb.firebaseio.com', 'DHT_11.json');
    while (true) {
      try {
        final response = await http.get(url);
        if (response.statusCode == 200) {
          final jsonData = json.decode(response.body);
          double humidityValue = double.parse(jsonData['Humidity'].toString());
          yield humidityValue; // Yield the humidity value
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

    return StreamBuilder<double>(
      stream: fetchHumidity(), // Listen to the humidity stream
      builder: (context, snapshot) {
        String humidityDisplay;

        if (snapshot.connectionState == ConnectionState.waiting) {
          humidityDisplay = ''; // Show loading text while data is being fetched
        } else if (snapshot.hasError) {
          humidityDisplay = 'Error: ${snapshot.error}'; // Handle errors
        } else if (snapshot.hasData) {
          double humidityValue = snapshot.data!; // Get the humidity value
          humidityDisplay =
              '${humidityValue.toStringAsFixed(1)} %'; // Format the humidity display string
        } else {
          humidityDisplay = 'No data available'; // Default message if no data
        }

        double normalizedHumidity =
            (snapshot.hasData) ? (snapshot.data! / 100) : 0;

        Color currentHumidityColor() {
          if (snapshot.hasData) {
            if (snapshot.data! <= 55) {
              return Colors.red;
            } else if (snapshot.data! >= 90) {
              return Colors.blue;
            } else {
              return Colors.green;
            }
          }
          return Colors.grey; // Default color when no data
        }

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
                      'lib/uicons/humidity.png',
                      height: displayWidth * .1,
                    ),
                    const SizedBox(width: 10), // Add some space
                    Text(
                      "Humidity",
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
                  animateFromLastPercent: true, // Maintain the previous percent
                  animationDuration: 1000, // Duration for animation
                  backgroundColor: Colors.transparent,
                  radius: displayWidth * .25,
                  lineWidth: displayWidth * .05,
                  progressColor: currentHumidityColor(),
                  startAngle: 230,
                  circularStrokeCap: CircularStrokeCap.round,
                  percent: normalizedHumidity, // PERCENTAGE
                  center: Text(
                    humidityDisplay, // NUM DISPLAY
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
