import 'dart:async';
import 'package:flutter/material.dart';
import 'package:version_1/services/auth_screen.dart';
import 'package:version_1/screens/loginScreen.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>{
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 5), () {
      Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => AuthPage(),
        ));
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: double.infinity,
              height: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                        child: Image.asset('assets/images/logo/Splaash_screen260x193.png',
                          fit: BoxFit.cover,
                        )
                    ),
                    // Text('Created by \nMohit Kumar \n& \nNaval Thanik',
                    //   textAlign: TextAlign.center,
                    //   style: TextStyle(
                    //     color: Color(0xff2A5794),
                    //     fontFamily: 'LogoFont',
                    //     fontSize: 30,
                    // ),)
                  ],
                )
            ),
          )
      ),
    );
  }
}
