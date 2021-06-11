import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rent_app/Welcome/welcome_screen.dart';
class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  startTimer(){
    Timer(Duration(seconds: 5), () async {
      Route newRoute = MaterialPageRoute(builder: (context) => WelcomeScreen());
      Navigator.pushReplacement(context, newRoute);
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startTimer();
  }
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        decoration: new BoxDecoration(
          gradient: new LinearGradient(
              colors:[
                Colors.blue,
                Colors.lightBlueAccent,
              ],
            begin: const FractionalOffset(0.0,0.0),
            end: const FractionalOffset(1.0, 0.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset('images/logo.png', width: 300.0, height: 100.0),
              ),
              SizedBox(height: 20.0,),
              Center(
                child: Text(
                  "Rent In and Save, Rent Out and Make. It has never been easier!",
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.white,
                    fontFamily: "Lobster"
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

