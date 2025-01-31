import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart'; //package for startup tutorial
import 'package:vermit/onboarding_pages.dart'; //startup pages contents
import 'package:vermit/homepage.dart'; //homepage contents

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final onboarding = prefs.getBool("onboarding") ?? false;
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );
  runApp(VermiT(onboarding: onboarding));
}

class VermiT extends StatelessWidget {
  final bool onboarding;
  const VermiT({super.key, this.onboarding = false}); //after 2nd time of opening the app, tutorial wouldn't appear
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: onboarding ? const HomePage() : const onboarding_pages(),
    );
  }
}
