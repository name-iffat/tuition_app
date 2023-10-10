import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tuition_app/authentication/auth_screen.dart';

class MySplashScreen extends StatefulWidget {
  const MySplashScreen({super.key});
  //const MySplashScreen({Key?key}) : super(key:key);

  @override
  State<MySplashScreen> createState() => _MySplashScreenState();
}

class _MySplashScreenState extends State<MySplashScreen>
{

  startTimer()
  {
    Timer(const Duration(seconds: 5), () async {
      Navigator.push(context, MaterialPageRoute(builder: (c)=> const AuthScreen()));
    });
  }

  @override
  void initState() {
    super.initState();

    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: Color(0xFF71B6DD),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset("images/LOGO.png"),
                const SizedBox(height: 10,),
                const Padding(
                  padding: EdgeInsets.all(18.0),
                  child: Text(
                    "Book Tutor Online",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 40,
                      fontFamily: "Signatra",
                      letterSpacing: 3,
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: 0,
              child: Image.asset("images/building.png"),
            ),
          ],
        ),
      ),
    );
  }
}
