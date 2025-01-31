import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class Sprinkler extends StatelessWidget {
  const Sprinkler({super.key});

  // Stream for fetching sprinkler status
  Stream<bool> fetchSprinklerStatus() async* {
    final url = Uri.https(
        'verms-79d98-default-rtdb.firebaseio.com', 'RelayStatus.json');
    while (true) {
      try {
        final response = await http.get(url);
        if (response.statusCode == 200) {
          final jsonData = json.decode(response.body);
          yield jsonData['Waterpump'] == true; // Yield the sprinkler status
        } else {
          yield false; // Default value in case of error
        }
      } catch (e) {
        yield false; // Default value in case of error
      }
      await Future.delayed(
          const Duration(seconds: 5)); // Adjust the delay as needed
    }
  }

  @override
  Widget build(BuildContext context) {
    double displayWidth = MediaQuery.of(context).size.width;

    return StreamBuilder<bool>(
      stream: fetchSprinklerStatus(), // Listen to the sprinkler status stream
      builder: (context, snapshot) {
        String sprinklerStatus;

        if (snapshot.connectionState == ConnectionState.waiting) {
          sprinklerStatus =
              ' '; // Show loading text while data is being fetched
        } else if (snapshot.hasError) {
          sprinklerStatus = 'Error: ${snapshot.error}'; // Handle errors
        } else if (snapshot.hasData) {
          sprinklerStatus = snapshot.data!
              ? 'In Operation'
              : 'On Standby'; // Get the sprinkler status
        } else {
          sprinklerStatus = 'No data available'; // Default message if no data
        }

        return Container(
          padding: const EdgeInsets.all(5.0),
          child: Container(
            padding: const EdgeInsets.all(15),
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Image.asset(
                      'lib/uicons/sprinkler.png',
                      height: displayWidth * .1,
                    ),
                    Text(
                      "  Sprinkler",
                      style: GoogleFonts.nunito(
                        color: const Color(0xff013e3e),
                        fontSize: displayWidth * .04,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: Text(
                    sprinklerStatus, // STATUS
                    key: ValueKey<String>(
                        sprinklerStatus), // Unique key for animation
                    style: GoogleFonts.quicksand(
                      color: const Color(0xff013e3e),
                      fontSize: displayWidth * .04,
                      fontWeight: FontWeight.w500,
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
