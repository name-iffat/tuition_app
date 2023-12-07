import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tuition_app/maps/map_utils.dart';

import '../global/global.dart';

class TrackingScreen extends StatefulWidget
{
  String? purchaserId;
  String? purchaserAddress;
  String? tutorID;
  String? getOrderID;
  double? purchaserLat;
  double? purchaserLng;

  TrackingScreen(
  {
    this.purchaserId,
    this.purchaserAddress,
    this.tutorID,
    this.getOrderID,
    this.purchaserLat,
    this.purchaserLng,
  });

  @override
  State<TrackingScreen> createState() => _TrackingScreenState();
}

class _TrackingScreenState extends State<TrackingScreen>
{

  double? parentLat, parentLng;

  getParentData() async
  {
    FirebaseFirestore.instance
        .collection("parents")
        .doc(widget.purchaserId)
        .get()
        .then((DocumentSnapshot)
    {
          parentLat = DocumentSnapshot.data()!["lat"];
          parentLng = DocumentSnapshot.data()!["lng"];
    });
  }

  @override
  void initState() {
    super.initState();
    getParentData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "images/success.png"
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
                      "Show My Location",
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
                  //confirmed - tutor get book
                  //Navigator.push(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
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
                  width: MediaQuery.of(context).size.width - 90,
                  height: 50,
                  child: const Center(
                    child: Text(
                      "Confirmed",
                      style: TextStyle(color: Colors.white, fontSize: 15.0, fontFamily: "Poppins"),
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
