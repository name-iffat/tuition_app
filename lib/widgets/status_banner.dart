import 'package:flutter/material.dart';
import 'package:tuition_app/mainScreeen/home_screen.dart';
import 'package:tuition_app/mainScreeen/tutor_home_screen.dart';

import '../global/global.dart';

class StatusBanner extends StatelessWidget {

  final bool? status;
  final String? orderStatus;

  StatusBanner({this.status, this.orderStatus});

  @override
  Widget build(BuildContext context)
  {
    String userType = sharedPreferences!.getString("usertype")!;
    String message;
    IconData iconData;

    status! ? iconData = Icons.done : iconData = Icons.cancel;
    status! ? message = "Successful" : message = "Unsuccessful";

    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.cyan,
              Colors.amber,
            ],
            begin: const FractionalOffset(0.0, 0.0),
            end: const FractionalOffset(1.0, 0.0),
            stops: [0.0,1.0],
            tileMode: TileMode.clamp,
          )
      ),
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: ()
            {
              if(userType=="Parent")
                Navigator.push(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
              else if(userType=="Tutor")
              {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const TutorHomeScreen()));
              }
            },
            child: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 20,),
          Text(
            orderStatus == "ended"
                ? "Tutor Booked $message"
                : "Subject $message",
            style: const TextStyle(color: Colors.white),
          ),
          const SizedBox(width: 5,),
          CircleAvatar(
            radius: 8,
            backgroundColor: Colors.grey,
            child: Center(
              child: Icon(
                iconData,
                color: Colors.white,
                size: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
