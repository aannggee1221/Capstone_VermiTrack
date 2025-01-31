import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SCtemphumi extends StatefulWidget {
  const SCtemphumi({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SctemphumiState createState() => _SctemphumiState();
}

class _SctemphumiState extends State<SCtemphumi> {
  double temperature = 0.0;
  double humidity = 0.0;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    final url =
        Uri.https('verms-79d98-default-rtdb.firebaseio.com', 'NPK.json');

    while (true) {
      try {
        final response = await http.get(url);
        if (response.statusCode == 200) {
          final jsonData = json.decode(response.body);
          setState(() {
            temperature = double.parse(jsonData['SoilTemperature'].toString());
            humidity = double.parse(jsonData['SoilHumidity'].toString());
          });
        }
      } catch (e) {
        print('Error: $e');
      }
      await Future.delayed(
          const Duration(seconds: 10)); // Fetch every 10 seconds
    }
  }

  @override
  Widget build(BuildContext context) {
    double displayWidth = MediaQuery.of(context).size.width;

    double tv = temperature / 100; // Convert to percentage
    double hv = humidity / 100; // Convert to percentage
    String td = temperature > 0
        ? '${temperature.toStringAsFixed(1)} °C'
        : ''; // Show blank initially
    String hd = humidity > 0
        ? '${humidity.toStringAsFixed(1)} %'
        : ''; // Show blank initially

    Color currentTColor() {
      if (temperature <= 27) return Colors.green;
      if (temperature < 20) return Colors.blue;
      return Colors.red;
    }

    Color currentHColor() {
      if (humidity >= 51) return Colors.green;
      if (humidity > 90) return Colors.blue;
      return Colors.red;
    }

    return Container(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            // TEMPERATURE
            padding: const EdgeInsets.all(10),
            width: displayWidth * .43,
            height: displayWidth * .47,
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
                  children: [
                    Image.asset(
                      'lib/uicons/temp.png',
                      height: displayWidth * .1,
                    ),
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
                  animateFromLastPercent: true,
                  animationDuration: 1000,
                  backgroundColor: Colors.transparent,
                  radius: displayWidth * .13,
                  lineWidth: displayWidth * .04,
                  progressColor: currentTColor(),
                  startAngle: 230,
                  circularStrokeCap: CircularStrokeCap.round,
                  percent: tv, // PERCENTAGE
                  center: Text(
                    td, // NUM DISPLAY
                    style: TextStyle(
                      fontSize: displayWidth * .04,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xff013e3e),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            // HUMIDITY
            padding: const EdgeInsets.all(10),
            width: displayWidth * .43,
            height: displayWidth * .47,
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
                  children: [
                    Image.asset(
                      'lib/uicons/humidity.png',
                      height: displayWidth * .1,
                    ),
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
                  animateFromLastPercent: true,
                  animationDuration: 1000,
                  backgroundColor: Colors.transparent,
                  radius: displayWidth * .13,
                  lineWidth: displayWidth * .04,
                  progressColor: currentHColor(),
                  startAngle: 230,
                  circularStrokeCap: CircularStrokeCap.round,
                  percent: hv, // PERCENTAGE
                  center: Text(
                    hd, // NUM DISPLAY
                    style: TextStyle(
                      fontSize: displayWidth * .04,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xff013e3e),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
