import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Potass extends StatelessWidget {
  const Potass({super.key});

  // Stream for fetching potassium data
  Stream<int> fetchPotassium() async* {
    final url =
        Uri.https('verms-79d98-default-rtdb.firebaseio.com', 'NPK.json');
    while (true) {
      try {
        final response = await http.get(url);
        if (response.statusCode == 200) {
          final jsonData = json.decode(response.body);
          int potassiumValue = int.parse(
              jsonData['Potassium'].toString()); // Adjust the key as necessary
          yield potassiumValue; // Yield the potassium value
        } else {
          yield 0; // Default value in case of error
        }
      } catch (e) {
        print('Error: $e');
        yield 0; // Default value in case of error
      }
      await Future.delayed(
          const Duration(seconds: 10)); // Adjust the delay as needed
    }
  }

  @override
  Widget build(BuildContext context) {
    double displayWidth = MediaQuery.of(context).size.width;

    return StreamBuilder<int>(
      stream: fetchPotassium(), // Listen to the potassium stream
      builder: (context, snapshot) {
        String kd; // Display string for potassium value

        if (snapshot.connectionState == ConnectionState.waiting) {
          kd = ''; // Display blank while loading
        } else if (snapshot.hasError) {
          kd = ''; // Display blank in case of error
        } else if (snapshot.hasData) {
          int kv = snapshot.data!; // Get the potassium value from the stream
          kd = '$kv mg/kg'; // Format the value for display
        } else {
          kd = ''; // Default if no data available
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
                      'lib/uicons/potassium.png',
                      height: displayWidth * .1,
                    ),
                    Text(
                      "  Potassium",
                      style: GoogleFonts.nunito(
                        color: const Color(0xff013e3e),
                        fontSize: displayWidth * .04,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                // Wrap the potassium display in an AnimatedSwitcher
                AnimatedSwitcher(
                  duration:
                      const Duration(milliseconds: 300), // Animation duration
                  child: Text(
                    kd, // Display value
                    key: ValueKey<String>(kd), // Unique key for animation
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
