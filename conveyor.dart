import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Aerator extends StatefulWidget {
  const Aerator({super.key});

  @override
  State<Aerator> createState() => _AeratorState();
}

class _AeratorState extends State<Aerator> {
  bool isSwitched = false;

  @override
  void initState() {
    super.initState();
    _fetchConveyorStatus();
  }

  Future<void> _fetchConveyorStatus() async {
    final url = Uri.https('verms-79d98-default-rtdb.firebaseio.com',
        'Conveyor.json'); // Update with your URL

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        setState(() {
          isSwitched = jsonData; // Directly assign the boolean value
        });
      }
    } catch (e) {
      print('Error fetching conveyor status: $e');
    }
  }

  Future<void> _updateConveyorStatus(bool value) async {
    final url = Uri.https('verms-79d98-default-rtdb.firebaseio.com',
        'Conveyor.json'); // Update with your URL

    try {
      await http.put(url, body: json.encode(value));
    } catch (e) {
      print('Error updating conveyor status: $e');
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
                  'lib/uicons/conveyor.png',
                  height: displayWidth * .1,
                ),
                Text(
                  "  Conveyor",
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
                _updateConveyorStatus(value); // Update status on toggle
              },
              activeColor: Colors.green[900],
            ),
          ],
        ),
      ),
    );
  }
}
