import 'dart:async';

import 'package:flutter/material.dart';
import 'package:note_app_using_firebase/pages/homepage.dart';
import 'package:note_app_using_firebase/pages/user_onboarding/login_page.dart';
import 'package:note_app_using_firebase/share_pref/share_pref.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(Duration(seconds: 5), () {
      getShareValues();
    });
  }

  getShareValues() async {
    var userID = await SharePreference.getSharedUserid();
    var isLogin = await SharePreference.getSharedisLogin();

    if (isLogin) {
      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(
            userID: userID,
          ),
        ),
      );
      print('Go To Home Page');
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoginPage(),
        ),
      );
      print('Go To Login Page');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [
            Color.fromARGB(255, 255, 82, 134),
            Color(0xfffa709a),
            Color.fromARGB(255, 254, 210, 64),
          ], begin: Alignment.topLeft, end: Alignment.bottomRight),
        ),
        child: const Center(
          child: Text(
            'My Notes',
            style: TextStyle(
              color: Colors.black,
              fontSize: 40,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
