import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Nitro extends StatelessWidget {
  const Nitro({super.key});

  // Stream for fetching nitrogen data
  Stream<int> fetchNitrogen() async* {
    final url =
        Uri.https('verms-79d98-default-rtdb.firebaseio.com', 'NPK.json');
    while (true) {
      try {
        final response = await http.get(url);
        if (response.statusCode == 200) {
          final jsonData = json.decode(response.body);
          int nitrogenValue = int.parse(
              jsonData['Nitrogen'].toString()); // Adjust the key as necessary
          yield nitrogenValue; // Yield the nitrogen value
        } else {
          yield 0; // Error handling
        }
      } catch (e) {
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
      stream: fetchNitrogen(), // Listen to the nitrogen stream
      builder: (context, snapshot) {
        String nd;

        if (snapshot.connectionState == ConnectionState.waiting) {
          nd = ' '; // Show loading text while data is being fetched
        } else if (snapshot.hasError) {
          nd = 'Error: ${snapshot.error}'; // Handle errors
        } else if (snapshot.hasData) {
          int nv = snapshot.data!; // Get the nitrogen value
          nd = '$nv mg/kg'; // Format the nitrogen display string
        } else {
          nd = 'No data available'; // Default message if no data
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
                      'lib/uicons/nitrogen.png',
                      height: displayWidth * .1,
                    ),
                    Text(
                      "  Nitrogen",
                      style: GoogleFonts.nunito(
                        color: const Color(0xff013e3e),
                        fontSize: displayWidth * .04,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                // Wrap the nitrogen display in an AnimatedSwitcher
                AnimatedSwitcher(
                  duration:
                      const Duration(milliseconds: 300), // Animation duration
                  child: Text(
                    nd, // NUM DISPLAY
                    key: ValueKey<String>(nd), // Unique key for animation
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
