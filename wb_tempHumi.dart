import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class TempHumi extends StatefulWidget {
  const TempHumi({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _TempHumiState createState() => _TempHumiState();
}

class _TempHumiState extends State<TempHumi> {
  double? temperatureValue; // Default to null for blank display
  double? humidityValue; // Default to null for blank display

  @override
  void initState() {
    super.initState();
    _fetchDataStream().listen((data) {
      setState(() {
        temperatureValue = data['Temperature'] / 100; // Adjust as needed
        humidityValue = data['Humidity'] / 100; // Adjust as needed
      });
    });
  }

  // Function to set up a stream that listens to Firebase data changes
  Stream<Map<String, dynamic>> _fetchDataStream() async* {
    final url =
        Uri.https('verms-79d98-default-rtdb.firebaseio.com', 'DHT_11.json');
    while (true) {
      try {
        final response = await http.get(url);
        if (response.statusCode == 200) {
          final jsonData = json.decode(response.body);
          yield jsonData; // Yield the parsed data as a stream event
        } else {
          print('Failed to load data: ${response.statusCode}');
        }
      } catch (e) {
        print('Error fetching data: $e');
      }
      await Future.delayed(
          const Duration(seconds: 5)); // Adjust delay if necessary
    }
  }

  Color currentTColor() {
    if (temperatureValue != null && temperatureValue! >= .28) {
      return Colors.red;
    } else if (temperatureValue != null && temperatureValue! < .10) {
      return Colors.blue;
    } else {
      return Colors.green;
    }
  }

  Color currentHColor() {
    if (humidityValue != null && humidityValue! <= .55) {
      return Colors.red;
    } else if (humidityValue != null && humidityValue! >= .90) {
      return Colors.blue;
    } else {
      return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    double displayWidth = MediaQuery.of(context).size.width;

    // Display blanks ("") instead of "0.0" when values are null
    String temperatureDisplay = temperatureValue != null
        ? '${(temperatureValue! * 100).toStringAsFixed(1)} °C'
        : '';
    String humidityDisplay = humidityValue != null
        ? '${(humidityValue! * 100).toStringAsFixed(1)} %'
        : '';

    return Container(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
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
                  percent: temperatureValue ??
                      0.0, // Set to 0.0 but display as blank
                  center: Text(
                    temperatureDisplay, // Blank or actual value
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
                  percent:
                      humidityValue ?? 0.0, // Set to 0.0 but display as blank
                  center: Text(
                    humidityDisplay, // Blank or actual value
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
