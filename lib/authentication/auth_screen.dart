import 'package:flutter/material.dart';
import 'package:tuition_app/authentication/choose_user.dart';
import 'package:tuition_app/authentication/login.dart';
import 'package:tuition_app/authentication/register.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key, required this.userType});
  final String userType;

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    // Accessing the userType property of the AuthScreen widget
    String userType = widget.userType;
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.cyan,
                    Colors.blue,
                  ],
                  begin: const FractionalOffset(0.0, 0.0),
                  end: const FractionalOffset(1.0, 0.0),
                  stops: [0.0,1.0],
                  tileMode: TileMode.clamp,
                )
              ),
            ),
            title: const Text(
              "Tutor GO",
              style: TextStyle(
                fontSize: 60,
                color: Colors.white,
                fontFamily: "Bebas",
              ),
            ),
            centerTitle: true,
            bottom: const TabBar(
                tabs: [
                  Tab(
                    icon: Icon(Icons.lock, color: Colors.white,),
                    text: "Login",
                  ),
                  Tab(
                    icon: Icon(Icons.person, color: Colors.white,),
                    text: "Register",
                  ),
                ],
                indicatorColor: Colors.white38,
                indicatorWeight: 6,
            ),
          ),
          body: Container(
            decoration:  BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  Colors.cyan.shade200,
                  Colors.white
                ]
              )
            ),
            child:  TabBarView(
              children: [
                LoginScreen(userType: widget.userType),
                RegisterScreen(userType: widget.userType),
              ],
            ),
          ),
        )
    );
  }
}
