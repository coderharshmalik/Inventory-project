import 'dart:async';
import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'package:firebase_core/firebase_core.dart';

class SplashScreen extends StatefulWidget {
  final String id = '/splashScreen';
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Firebase.initializeApp().whenComplete(() => print('FireBase is UP'));
    Timer(
      Duration(seconds: 3),
      () => Navigator.pushReplacementNamed(
        context,
        LoginScreen().id,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Center(
            child: CircleAvatar(
              backgroundColor: Colors.red,
              radius: 104,
            ),
          ),
          Center(
            child: Center(
              child: Image(
                image: AssetImage('images/Logo.PNG'),
                width: 280,
                height: 280,
              ),
            ),
            // CircleAvatar(
            //   child: Text(
            //     'LMNS',
            //     style: TextStyle(
            //       color: Colors.red,
            //       fontSize: 55,
            //       fontWeight: FontWeight.bold,
            //     ),
            //   ),
            //   backgroundColor: Colors.white,
            //   radius: 100,
            // ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 50),
            alignment: Alignment.bottomCenter,
            child: CircularProgressIndicator(
              color: Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}
