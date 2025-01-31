import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Phospo extends StatelessWidget {
  const Phospo({super.key});

  // Stream for fetching phosphorus data
  Stream<int> fetchPhosphorus() async* {
    final url =
        Uri.https('verms-79d98-default-rtdb.firebaseio.com', 'NPK.json');
    while (true) {
      try {
        final response = await http.get(url);
        if (response.statusCode == 200) {
          final jsonData = json.decode(response.body);
          int phosphorusValue = int.parse(
              jsonData['Phosphorus'].toString()); // Adjust the key as necessary
          yield phosphorusValue; // Yield the phosphorus value
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
      stream: fetchPhosphorus(), // Listen to the phosphorus stream
      builder: (context, snapshot) {
        String pd; // Display string for phosphorus value

        if (snapshot.connectionState == ConnectionState.waiting) {
          pd = ''; // Display blank while loading
        } else if (snapshot.hasError) {
          pd = ''; // Display blank in case of error
        } else if (snapshot.hasData) {
          int pv = snapshot.data!; // Get the phosphorus value from the stream
          pd = '$pv mg/kg'; // Format the value for display
        } else {
          pd = ''; // Default if no data available
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
                      'lib/uicons/phosphorus.png',
                      height: displayWidth * .1,
                    ),
                    Text(
                      "  Phosphorus",
                      style: GoogleFonts.nunito(
                        color: const Color(0xff013e3e),
                        fontSize: displayWidth * .04,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                // Wrap the phosphorus display in an AnimatedSwitcher
                AnimatedSwitcher(
                  duration:
                      const Duration(milliseconds: 300), // Animation duration
                  child: Text(
                    pd, // Display value
                    key: ValueKey<String>(pd), // Unique key for animation
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
