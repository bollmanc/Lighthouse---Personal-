import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_glogin/main.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return StartState();
  }
}

class StartState extends State<SplashScreen> {
  @override 
  void initState() {
  super.initState();
  startTimer();
  }

  startTimer() async {
    var duration = Duration(seconds: 4);
    return Timer(duration, route);
  }

  route() {
    Navigator.pushReplacement(context, MaterialPageRoute(
      builder: (context) => MainScreen()//LoginPage()
  
    ));
  }
  @override
  Widget build(BuildContext context) {
   return Scaffold(
     body: Stack(
       fit: StackFit.expand,
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            color: Color(0xFF00E5FF)),
          ),
          SizedBox(height:1000),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 3,
                child: Container(
                  child: Column(
                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                       Image(
                        image: AssetImage('Assets/logo.png'),
                        width: 200,
                        height: 400,
                      ),
                    ],
                ),
                ),
               ),
               Expanded(   
                 child: Column(
                 mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                     Padding(padding: EdgeInsets.only(top:10.0),
                ), 
                     Text("", 
                       style: GoogleFonts.lobster(
                       color: Color(0xFFFFEA00), 
                       fontSize: 26.0, 
                      fontWeight: FontWeight.bold)),
               
            ]),
               ),
      ],
   )
      ]
     ),
     );
  }
}
