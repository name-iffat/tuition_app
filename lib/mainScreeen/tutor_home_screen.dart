import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tuition_app/global/global.dart';
import 'package:tuition_app/models/subjects.dart';
import 'package:tuition_app/widgets/info_design.dart';
import 'package:tuition_app/widgets/progress_bar.dart';
import 'package:tuition_app/widgets/text_widget.dart';

import '../assistantMethods/directions_handler.dart';
import '../assistantMethods/get_current_location.dart';
import '../assistantMethods/notification_service.dart';
import '../uploadScreen/subjects_upload_screen.dart';
import '../widgets/my_drawer_tutor.dart';

class TutorHomeScreen extends StatefulWidget {
  const TutorHomeScreen({super.key});

  @override
  State<TutorHomeScreen> createState() => _TutorHomeScreenState();
}

class _TutorHomeScreenState extends State<TutorHomeScreen> {
  NotificationServices notificationServices = NotificationServices();

  @override
  void initState() {
    super.initState();

    notificationServices.requestNotificationPermission();
    notificationServices.isTokenRefresh();
    notificationServices.getDeviceToken().then((value) {
      print("Device Token:");
      print(value);
    });


    UserLocation uLocation = UserLocation();
    uLocation.getCurrentLocation();
    getPerBookTransportAmount();
    getTransportPreviousEarnings();
    getTutorPreviousEarnings();
    getDirectionAPI();
    _checkLocationPermission();
  }

  getTransportPreviousEarnings()
  {

    FirebaseFirestore.instance
        .collection("tutors")
        .doc(sharedPreferences!.getString("uid"))
        .get().then((snap)
    {
      previousTransportEarnings = snap.data()!["transport"].toString() == "null" ? "0" : previousTransportEarnings;
      //previousTransportEarnings = previousTransportEarnings == "null" ? "0" : previousTransportEarnings;
      print("chk: $previousTransportEarnings");
    });
  }

  getTutorPreviousEarnings()
  {    previousTutorEarnings = previousTutorEarnings == "null" ? "0" : previousTutorEarnings;

  FirebaseFirestore.instance
      .collection("tutors")
      .doc(sharedPreferences!.getString("uid"))
      .get().then((snap)
  {
    double rawTutorEarnings = double.parse(snap.data()!["earnings"].toString());
    previousTutorEarnings = rawTutorEarnings.toStringAsFixed(2);
  });
  }

  getPerBookTransportAmount()
  {
    FirebaseFirestore.instance
        .collection("perTransport")
        .doc("amount5km")
        .get().then((snap)
    {
      perBookTransportAmount= snap.data()!["amount"].toString();
    });
  }

  //getMapboxAPI
  Future<void> getDirectionAPI() async
  {
    //get and store direction API response in sharedPreference
    final parentsCollection = FirebaseFirestore.instance.collection("parents");
    for (var parentDoc in await parentsCollection.get().then((snapshot) => snapshot.docs))
    {
      final parentLat = parentDoc.data()["lat"];
      final parentLng = parentDoc.data()["lng"];

      Map modifiedResponse = await getDirectionsAPIResponse(
          position!.latitude,
          position!.longitude,
          parentLat,
          parentLng,
          parentDoc.data()["parentName"]
      );
      print("Position: $position");
      print("Parent Lat: $parentLat, Parent Lng: $parentLng");
      print("Modified Response: $modifiedResponse");
      print(parentDoc.data()["parentUID"]);
      SaveDirectionsParentAPIResponse(parentDoc.data()["parentUID"], json.encode(modifiedResponse));
    }

  }

  Future<void> _checkLocationPermission() async {
    var status = await Permission.location.status;
    if (status.isDenied) {
      var result = await Permission.location.request();
      if (result.isGranted) {
        // Location permission granted
        _accessLocation();
      } else {
        // Location permission denied
        _handlePermissionDenied();
      }
    } else if (status.isGranted) {
      // Location permission already granted
      _accessLocation();
    } else {
      // Location permission permanently denied
      _handlePermissionPermanentlyDenied();
    }
  }
  void _accessLocation() {
    // Access location services here
    print("Accessing location services...");
  }
  void _handlePermissionDenied() {
    // Show a rationale for using location
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Location Permission Required"),
        content: Text("This app needs location access to provide accurate features."),
        actions: [
          TextButton(
            onPressed: () async {
              // Request permission again
              await _checkLocationPermission();
            },
            child: Text("Allow"),
          ),
        ],
      ),
    );
  }
  void _handlePermissionPermanentlyDenied() {
    // Guide user to app settings to enable permission
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Location Permission Disabled"),
        content: Text("This app requires location permission to function properly. Please enable it in app settings."),
        actions: [
          TextButton(
            onPressed: () {
              openAppSettings();
            },
            child: Text("Open Settings"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        if(firebaseAuth.currentUser != null)
        {
          SystemNavigator.pop(); // Exit app on Android
          return false;
        }
        else{
          return true;
        }
      },
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
          title: Text(
            sharedPreferences!.getString("name")!,
            style: const TextStyle(fontSize: 30, fontFamily: "Bebas"),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.post_add, color: Colors.white,),
              onPressed: ()
              {
                Navigator.push(context,MaterialPageRoute(builder: (c)=> const SubjectUploadScreen()));
              },
            ),
          ],
        ),
        drawer: MyDrawerTutor(),
        body: CustomScrollView(
          slivers: [
            SliverPersistentHeader(pinned: true,delegate: TextWidgetHeader(title: "My Collections")),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("tutors")
                  .doc(sharedPreferences!.getString("uid"))
                  .collection("subject")
                  .orderBy("publishedDate", descending: true)
                  .snapshots(),
              builder: (context, snapshot)
              {
                return !snapshot.hasData
                    ? SliverToBoxAdapter(
                      child: Center(child: circularProgress(),) ,
                )
                    : SliverAlignedGrid.count(
                        crossAxisCount: 1,
                        //staggeredTileBuilder: (c) => StaggeredTile.fit(1),
                        itemBuilder: (context, index)
                        {
                          Subjects model = Subjects.fromJson(
                            snapshot.data!.docs[index].data()! as Map<String, dynamic>
                          );
                          return InfoDesignWidget.subjects(
                              subjectsModel: model,
                              context: context
                          );
                        },
                        itemCount: snapshot.data!.docs.length,
                      );
              },
            ),
          ],
        ),
      ),
    );
  }
}
