import 'package:flutter/material.dart';
import 'package:tuition_app/global/global.dart';

class TutorEarningsScreen extends StatefulWidget {
  const TutorEarningsScreen({super.key});

  @override
  State<TutorEarningsScreen> createState() => _TutorEarningsScreenState();
}

class _TutorEarningsScreenState extends State<TutorEarningsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
          child: Column(
            children: [
            Text(
            "RM $previousTutorEarnings",
            style: TextStyle(
              fontSize: 80.00,
              color: Colors.white,
              fontFamily: "Bebas",
            ),
            ),
              Text(
                "Total Earnings ",
                style: TextStyle(
                  fontSize: 20.00,
                  color: Colors.grey,
                  letterSpacing: 3,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
      ),
    );
  }
}
