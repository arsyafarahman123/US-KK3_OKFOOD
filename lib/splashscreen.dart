import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:okfoodd/auth/Login.dart';
import 'dart:async';
import 'package:okfoodd/home_screen.dart';

class SplashScreen extends StatefulWidget {

  _SplashScreen createState() => _SplashScreen();

}

class _SplashScreen extends State<SplashScreen>{

  void initState(){
    super.initState();
    splashscreenStart();
  }
  
  splashscreenStart() async{
    var duration = const Duration(seconds: 2);
    return Timer(duration,  () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Login()),

      );
    });
  }
  @override
  Widget build (BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Image.asset(
          'assets/images/logo.png',
          fit: BoxFit.fill,
        ),
      )
    );
  }
}