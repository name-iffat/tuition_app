import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tuition_app/mainScreeen/home_screen.dart';

import '../assistantMethods/get_current_location.dart';
import '../global/global.dart';
import '../maps/map_utils.dart';

class BookIncomingScreen extends StatefulWidget
{

  String? purchaserId;
  String? purchaserAddress;
  double? purchaserLat;
  double? purchaserLng;
  String? tutorId;
  String? getOrderId;

  BookIncomingScreen({
    this.purchaserId,
    this.purchaserAddress,
    this.purchaserLat,
    this.purchaserLng,
    this.tutorId,
    this.getOrderId,
});

  @override
  State<BookIncomingScreen> createState() => _BookIncomingScreenState();
}

class _BookIncomingScreenState extends State<BookIncomingScreen>
{
  String uniqueIdName = DateTime.now().millisecondsSinceEpoch.toString();

  String orderTotalAmount = "";
  confirmStartTutor(getOrderId,tutorId, purchaserId,purchaserAddress, purchaserLat, purchaserLng )
  {
    previousTransportEarnings = previousTransportEarnings == "null" ? "0" : previousTransportEarnings;
    String transportNewTotalEarningAmount = (double.parse(previousTransportEarnings) + double.parse(perBookTransportAmount)).toString();

    FirebaseFirestore.instance
        .collection("orders")
        .doc(getOrderId)
        .update({
      "rated": false,
      "status": "ended",
      "address": completeAddress,
      "lat": position!.latitude,
      "lng": position!.longitude,
      "transport":perBookTransportAmount, //pay per tutor
    }).then((value)
    {
      FirebaseFirestore.instance
          .collection("tutors")
          .doc(sharedPreferences!.getString("uid"))
          .update(
          {
            "rating": 0,
            "transport": transportNewTotalEarningAmount, //total earnings of tutor transporting
          });
    }).then((value)
    {
      FirebaseFirestore.instance
          .collection("tutors")
          .doc(widget.tutorId)
          .update(
          {
            "earnings":(double.parse(orderTotalAmount) + double.parse(previousEarnings) + double.parse(perBookTransportAmount)).toString(), //total earnings tutoring
          });
    }).then((value)
    {
      FirebaseFirestore.instance
          .collection("parents")
          .doc(purchaserId)
          .collection("orders")
          .doc(getOrderId).update(
          {
            "rated": false,
            "status":"ended",
            "tutorUID": sharedPreferences!.getString("uid"),
          });
    }).then((value)
    {
      final ref = FirebaseFirestore.instance
          .collection("tutors")
          .doc(sharedPreferences!.getString("uid"))
          .collection("rating");
      ref.doc(getOrderId).set({
        "rateID" : getOrderId,
        "tutorUID" : sharedPreferences!.getString("uid"),
        "rating" : 0,
        "publishedDate" : DateTime.now(),
      });
    });

    Navigator.pushReplacement(context, MaterialPageRoute(builder: (c)=> HomeScreen()));
  }
  
  getBookTotalAmount()
  {
    FirebaseFirestore.instance
        .collection("orders")
        .doc(widget.getOrderId)
        .get().then((snap)
    {
      orderTotalAmount = snap.data()!["totalAmount"].toString();
      widget.tutorId = snap.data()!["tutorUID"].toString();
    }).then((value)
    {
      getTutorData();
    });
  }

  getTutorData()
  {
    FirebaseFirestore.instance
        .collection("tutors")
        .doc(widget.tutorId)
        .get().then((snap)
    {
      previousEarnings = snap.data()!["earnings"].toString();
    });
  }
  @override
  void initState() {
    super.initState();

    UserLocation uLocation = UserLocation();
    uLocation.getCurrentLocation();
    getBookTotalAmount();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
              "images/tutorlogin.png"
          ),
          const SizedBox(height: 5,),

          GestureDetector(
            onTap: ()
            {
              //show tutor current location towards
              MapUtility.launchMapFromSourceToDestination(position!.latitude, position!.longitude, widget.purchaserLat, widget.purchaserLng);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                Image.asset(
                  "images/LOGO.png",
                  width: 50,
                ),
                const SizedBox(width: 7,),

                Column(
                  children: [
                    const SizedBox(height: 12,),
                    const Text(
                      "Show Tutee Location",
                      style: TextStyle(
                        fontFamily: "Bebas",
                        fontSize: 18,
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                ),

              ],
            ),
          ),
          const SizedBox(height: 13,),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: InkWell(
                onTap: ()
                {
                  //tutor location
                  UserLocation uLocation = UserLocation();
                  uLocation.getCurrentLocation();
                  //confirmed - tutor get book
                  confirmStartTutor(
                      widget.getOrderId,
                      widget.tutorId,
                      widget.purchaserId,
                      widget.purchaserAddress,
                      widget.purchaserLat,
                      widget.purchaserLng);
                },
                child: Container(
                  decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.cyan,
                          Colors.blue,
                        ],
                        begin: FractionalOffset(0.0, 0.0),
                        end: FractionalOffset(1.0, 0.0),
                        stops: [0.0,1.0],
                        tileMode: TileMode.clamp,
                      )
                  ),
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: 50,
                  child: const Center(
                    child: Text(
                      "Done Tutoring",
                      style: TextStyle(color: Colors.white, fontSize: 17.0, fontFamily: "Poppins"),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: InkWell(
                onTap: ()
                {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
                },
                child: Container(
                  decoration:  BoxDecoration(
                    border: Border.all(color: Colors.blue),

                  ),
                  width: MediaQuery.of(context).size.width * 0.7,
                  height: 50,
                  child: const Center(
                    child: Text(
                      "Not Yet",
                      style: TextStyle(color: Colors.blue, fontSize: 18.0,),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
