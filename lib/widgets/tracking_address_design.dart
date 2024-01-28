import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../assistantMethods/directions_handler.dart';
import '../assistantMethods/get_current_location.dart';
import '../global/global.dart';
import '../mainScreeen/book_incoming.dart';
import '../mainScreeen/home_screen.dart';
import '../mainScreeen/map_tutor_screen.dart';
import '../mainScreeen/tracking_screen.dart';
import '../mainScreeen/tutor_cancel_screen.dart';
import '../mainScreeen/tutor_home_screen.dart';
import '../models/address.dart';

class TrackingAddressDesign extends StatefulWidget {

  final Address? model;
  final String? orderStatus;
  final String? orderID;
  final String? tutorID;
  final String? orderByParent;
  final String? rated;

  TrackingAddressDesign({this.model, this.orderStatus, this.orderID, this.tutorID, this.orderByParent, this.rated});

  @override
  State<TrackingAddressDesign> createState() => _TrackingAddressDesignState();
}

class _TrackingAddressDesignState extends State<TrackingAddressDesign> {
  double _currentRating = 3.5; // Initial value, will be updated from Firebase
  final _ratingsRef = FirebaseFirestore.instance.collection('tutors');
  String rated = "false ";

  confirmedBookTutor(BuildContext context, String getOrderID, getTutorID, String purchaserId, String getStatus)
  {
    if(getStatus == "normal" || getStatus == "booking"){
      FirebaseFirestore.instance.collection("orders")
          .doc(getOrderID)
          .update({
        "status": "booking",
        "lat":position!.latitude,
        "lng":position!.longitude,
        "address":completeAddress,
      });
      //send tutor to tracking screen
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => TrackingScreen(
        purchaserId: purchaserId,
        purchaserAddress: widget.model!.fullAddress,
        purchaserLat: widget.model!.lat,
        purchaserLng: widget.model!.lng,
        tutorID: getTutorID,
        getOrderID: getOrderID,
      )));
    }

    else{
      FirebaseFirestore.instance.collection("orders")
          .doc(getOrderID)
          .update({
        "status": "incoming",
        "lat":position!.latitude,
        "lng":position!.longitude,
        "address":completeAddress,
      });
      //send tutor to tracking screen
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => BookIncomingScreen(
        purchaserId: purchaserId,
        purchaserAddress: widget.model!.fullAddress,
        purchaserLat: widget.model!.lat,
        purchaserLng: widget.model!.lng,
        tutorId: getTutorID,
        getOrderId: getOrderID,
      )));    }
  }
  Future<void> getDirectionAPI() async
  {
    //get and store direction API response in sharedPreference

      final parentLat = widget.model!.lat;
      final parentLng = widget.model!.lng;

      Map modifiedResponse = await getDirectionsAPIResponse(
          position!.latitude,
          position!.longitude,
          parentLat!,
          parentLng!, widget.orderByParent!

      );
      print("Position: $position");
      print("Parent Lat: $parentLat, Parent Lng: $parentLng");
      print("Modified Response: $modifiedResponse");
      SaveDirectionsParentAPIResponse( widget.orderByParent!, json.encode(modifiedResponse));

  }


  ShowParentLocation(BuildContext context, String getOrderID, getTutorID, String purchaserId )
  {
      //send tutor to tracking screen
      Navigator.push(context, MaterialPageRoute(builder: (context) => TutorMap(
        purchaserId: purchaserId,
        purchaserAddress: widget.model!.fullAddress,
        purchaserLat: widget.model!.lat,
        purchaserLng: widget.model!.lng,
        tutorId: getTutorID,
        getOrderId: getOrderID,
      )
      ));
  }

  canceledBookTutor(BuildContext context, String getOrderID, getTutorID, String purchaserId, bool popup)
  {
    FirebaseFirestore.instance.collection("orders")
        .doc(getOrderID)
        .update({
      "status": "cancel",
    });

    //send tutor to tracking screen
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => CancelScreen()));
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Hey"),
            content: const Text("You have canceled an order."),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("OK")
              ),
            ],
          );
        }
    );
  }
  Future<double> _fetchCurrentRating(String getTutorID) async
  {
    try
    {
      _ratingsRef.doc(getTutorID).get().then((DocumentSnapshot)
      {
        if(DocumentSnapshot.exists)
        {
          _currentRating = DocumentSnapshot.data()!['rating'] as double;
        }
        else
        {
          print("Rating doc not found");
        }
      });
    } catch (error)
    {
      print('Error fetching rating: $error');
    }
    return _currentRating;
  }
  _submitRating(String tutorID , String getOrderID)
  {
    try
    {
      FirebaseFirestore.instance
          .collection("orders")
          .doc(getOrderID)
          .update({
        "rated": true,
      }).then((value) {
        FirebaseFirestore.instance
            .collection("tutors")
            .doc(tutorID)
            .collection("rating")
            .doc(getOrderID)
            .update({
          "rated": true,
          "rating": _currentRating,
        });
      }).then((value) {
        FirebaseFirestore.instance
            .collection("parent")
            .doc(widget.orderByParent)
            .collection("orders")
            .doc(getOrderID)
            .update({
          "rated": true,
        });
      }).then((value)
      async {
        FirebaseFirestore.instance
            .collection("tutors")
            .doc(tutorID)
            .update(
            {
              "rating": await getAverageRating(tutorID),
            });
      });
    } catch (error)
    {
      print('Error submitting rating: $error');
    }
    //Navigator.pushReplacement(context, MaterialPageRoute(builder: (c)=> HomeScreen()));

  }

  Future<num> getAverageRating(String tutorID) async {
    num averageRating = 0;

    try {
      final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("tutors")
          .doc(tutorID)
          .collection("rating")
          .get();

      for (int index = 0; index < querySnapshot.docs.length; index++){
        averageRating += querySnapshot.docs[index].get("rating") as num; // Cast to num
      }
      if (querySnapshot.docs.isNotEmpty) {
        averageRating = averageRating / querySnapshot.docs.length;
      }
    }
    catch (error) {
      print("Error fetching average rating: $error");
      // Handle errors gracefully, e.g., return 0 or a default value
    }

    return averageRating;
  }
  getOrderInfo(String orderID)
  {
    FirebaseFirestore.instance
        .collection("orders") .doc(orderID)
        .get().then((DocumentSnapshot)
    {
      rated = DocumentSnapshot.data()!['rated'].toString() == "null" ? "false" : DocumentSnapshot.data()!['rated'].toString();

    });
  }

  @override
  void initState() {
    getDirectionAPI();
    super.initState();
    getOrderInfo(widget.orderID!);
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
                  Text(widget.model!.name!),
                ],
              ),
              TableRow(
                children: [
                  const Text(
                    "Phone Number",
                    style: TextStyle(color: Colors.black),
                  ),
                  Text(widget.model!.phoneNumber!),
                ],
              ),

            ],
          ),
        ),
        const SizedBox(height: 20,),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            widget.model!.fullAddress!,
            textAlign: TextAlign.justify,
          ),
        ),
        //GO back btn

        widget.orderStatus == "ended" || widget.orderStatus == "cancel"
            ? Container()
            : Visibility(
          visible: sharedPreferences!.getString("usertype")! == "Tutor",
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,

                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: InkWell(
                        onTap: ()
                        {
                          UserLocation? uLocation = UserLocation();
                          uLocation!.getCurrentLocation();
                          ShowParentLocation(context, widget.orderID!, widget.tutorID!, widget.orderByParent!);
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
                          width: MediaQuery.of(context).size.width * 0.4,
                          height: 50,
                          child: const Center(
                            child: Text(
                              "Show Location",
                              style: TextStyle(color: Colors.white, fontSize: 15.0,),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: InkWell(
                        onTap: ()
                        async {
                          final confirmCancel = await showDialog<bool>(
                              context: context,
                              builder: (context) => AlertDialog(
                                  title: const Text("Confirm Cancelation"),
                                  content: const Text('Are you sure you want to cancel this tutoring?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context, false), // Cancel
                                      child: const Text('No'),
                                    ),
                                    TextButton(
                                      onPressed: () => Navigator.pop(context, true), // Confirm
                                      child: const Text('Yes'),
                                      style: TextButton.styleFrom(
                                        foregroundColor: Colors.red, // Highlight the delete action
                                      ),
                                    ),
                                  ]
                              )
                          );
                          if(confirmCancel!)
                          {
                            //cancel tutoring
                            UserLocation? uLocation = UserLocation();
                            uLocation!.getCurrentLocation();
                            canceledBookTutor(context, widget.orderID!, widget.tutorID!, widget.orderByParent!, true);
                          }
                        },
                        child: Container(
                          decoration:  BoxDecoration(
                            border: Border.all(color: Colors.blue),

                          ),
                          width: MediaQuery.of(context).size.width * 0.4,
                          height: 50,
                          child: const Center(
                            child: Text(
                              "Cancel Book",
                              style: TextStyle(color: Colors.blue, fontSize: 15.0,),
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
                          UserLocation? uLocation = UserLocation();
                          uLocation!.getCurrentLocation();

                          confirmedBookTutor(context, widget.orderID!, widget.tutorID!, widget.orderByParent!, widget.orderStatus! );
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
                          width: MediaQuery.of(context).size.width * 0.4,
                          height: 50,
                          child: const Center(
                            child: Text(
                              "Accept",
                              style: TextStyle(color: Colors.white, fontSize: 15.0,),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: InkWell(
              onTap: ()
              {
                if(sharedPreferences!.getString("usertype")! =="Parent")
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
                else
                {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const TutorHomeScreen()));
                }
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
        sharedPreferences!.getString("usertype")! == "Parent" ? Padding(padding: const EdgeInsets.all(8.0),
            child: Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RatingBar.builder(
                          initialRating: _currentRating ,
                          minRating: 1,
                          maxRating: 5,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                          itemBuilder: (context, _)=> const Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          onRatingUpdate: (rating)
                          {
                            setState(() {
                              _currentRating = rating;
                            });
                          },
                        ),
                        const SizedBox(height: 10,),
                        ElevatedButton.icon(
                          onPressed:(){
                            _submitRating(widget.tutorID!, widget.orderID!);
                          }, // Submit rating
                          label: const Text(
                            "Submit Rating",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          icon: const Icon(
                            Icons.send,
                            color: Colors.white,
                            size: 25,
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            padding: EdgeInsets.symmetric(
                                horizontal: MediaQuery.of(context).size.width * 0.2,
                                vertical: 15,
                            ),
                            side: const BorderSide(width: 1, color: Colors.blue),
                          ),
                          //child: const Text("Submit Rating"),
                        ),
                        // FutureBuilder<num>(
                        //   future: getAverageRating(widget.tutorID!),
                        //   builder: (context, snapshot) {
                        //     if (snapshot.hasData) {
                        //       num average = snapshot.data!;
                        //       return Text("Average Rating: $average");
                        //     } else {
                        //       return CircularProgressIndicator();
                        //     }
                        //   },
                        // )
                       // Text("Average Rating: ${getAverageRating(widget.tutorID!).toString()}"),
                      ]
                  ),
            )) : Container(),
      ],
    );
  }
}
