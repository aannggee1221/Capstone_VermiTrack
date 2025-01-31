import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Separator extends StatefulWidget {
  const Separator({super.key});

  @override
  State<Separator> createState() => _SeparatorState();
}

class _SeparatorState extends State<Separator> {
  bool isSwitched = false;

  @override
  void initState() {
    super.initState();
    _fetchSeparatorStatus();
  }

  Future<void> _fetchSeparatorStatus() async {
    final url = Uri.https('verms-79d98-default-rtdb.firebaseio.com',
        'Separator.json'); // Update with your URL

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        setState(() {
          isSwitched = jsonData; // Directly assign the boolean value
        });
      }
    } catch (e) {
      print('Error fetching separator status: $e');
    }
  }

  Future<void> _updateSeparatorStatus(bool value) async {
    final url = Uri.https('verms-79d98-default-rtdb.firebaseio.com',
        'Separator.json'); // Update with your URL

    try {
      await http.put(url, body: json.encode(value));
    } catch (e) {
      print('Error updating separator status: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    double displayWidth = MediaQuery.of(context).size.width;

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
                  'lib/uicons/sepa.png',
                  height: displayWidth * .1,
                ),
                Text(
                  "  Trommel",
                  style: GoogleFonts.nunito(
                    color: const Color(0xff013e3e),
                    fontSize: displayWidth * .04,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Switch(
              value: isSwitched,
              onChanged: (value) {
                setState(() {
                  isSwitched = value;
                });
                _updateSeparatorStatus(value); // Update status on toggle
              },
              activeColor: Colors.green[900],
            ),
          ],
        ),
      ),
    );
  }
}
