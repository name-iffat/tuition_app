import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tuition_app/assistantMethods/get_current_location.dart';
import 'package:tuition_app/global/global.dart';
import 'package:tuition_app/mainScreeen/home_screen.dart';
import 'package:tuition_app/mainScreeen/tracking_screen.dart';

import '../models/address.dart';

class TrackingAddressDesign extends StatelessWidget {
  final Address? model;
  final String? orderStatus;
  final String? orderID;
  final String? tutorID;
  final String? orderByParent;

  TrackingAddressDesign({this.model, this.orderStatus, this.orderID, this.tutorID, this.orderByParent});

  confirmedBookTutor(BuildContext context, String getOrderID, getTutorID, String purchaserId)
  {
    FirebaseFirestore.instance.collection("orders")
        .doc(getOrderID)
        .update({
      "status": "booking",
      "lat":position!.latitude,
      "lng":position!.longitude,
      "address":completeAddress,
    });

    //send tutor to tracking screen
    Navigator.push(context, MaterialPageRoute(builder: (context) => TrackingScreen(
      purchaserId: purchaserId,
      purchaserAddress: model!.fullAddress,
      purchaserLat: model!.lat,
      purchaserLng: model!.lng,
      tutorID: getTutorID,
      getOrderID: getOrderID,
    )));

  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            "Tracking Details:",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 6.0,),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 90, vertical: 5),
          width: MediaQuery.of(context).size.width,
          child: Table(
            children: [
              TableRow(
                children: [
                  const Text(
                    "Name",
                    style: TextStyle(color: Colors.black),
                  ),
                  Text(model!.name!),
                ],
              ),
              TableRow(
                children: [
                  const Text(
                    "Phone Number",
                    style: TextStyle(color: Colors.black),
                  ),
                  Text(model!.phoneNumber!),
                ],
              ),

            ],
          ),
        ),
        const SizedBox(height: 20,),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            model!.fullAddress!,
            textAlign: TextAlign.justify,
          ),
        ),
        //GO back btn

        orderStatus == "ended"
            ? Container()
            : Visibility(
          visible: sharedPreferences!.getString("usertype")! == "Tutor",
              child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
              child: InkWell(
                onTap: ()
                {
                  UserLocation? uLocation = UserLocation();
                  uLocation!.getCurrentLocation();

                  confirmedBookTutor(context, orderID!, tutorID!, orderByParent!);
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
                  width: MediaQuery.of(context).size.width - 40,
                  height: 50,
                  child: const Center(
                    child: Text(
                      "In Book",
                      style: TextStyle(color: Colors.white, fontSize: 15.0,),
                    ),
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
                Navigator.push(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
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
                width: MediaQuery.of(context).size.width - 40,
                height: 50,
                child: const Center(
                  child: Text(
                    "Go Back",
                    style: TextStyle(color: Colors.white, fontSize: 15.0,),
                  ),
                ),
              ),
            ),
          ),
        ),

      ],
    );
  }
}
