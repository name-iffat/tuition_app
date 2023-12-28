import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tuition_app/assistantMethods/assistant_methods.dart';
import 'package:tuition_app/global/global.dart';
import 'package:tuition_app/mainScreeen/tutor_home_screen.dart';
import 'package:tuition_app/uploadScreen/subjects_upload_screen.dart';
import 'package:tuition_app/widgets/info_design.dart';
import 'package:tuition_app/widgets/my_drawer.dart';
import 'package:tuition_app/widgets/my_drawer_tutor.dart';
import 'package:tuition_app/widgets/progress_bar.dart';

import '../assistantMethods/directions_handler.dart';
import '../assistantMethods/get_current_location.dart';
import '../models/tutors.dart';

class HomeScreen extends StatefulWidget {
   const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final items ={
    "slider/a.jpeg",
    "slider/b.png",
    "slider/c.jpg",
    "slider/d.jpeg",
    "slider/e.png",
    "slider/f.jpg",
    "slider/g.jpg",
  };
  @override
  void initState() {
    super.initState();

    clearCartNow(context);

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
      previousTransportEarnings = snap.data()!["transport"].toString();
    });
  }

  getTutorPreviousEarnings()
  {
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

  Future<void> getDirectionAPI() async
   {
    //get and store direction API response in sharedPreference
    final tutorsCollection = FirebaseFirestore.instance.collection("tutors");
    for (var tutorDoc in await tutorsCollection.get().then((snapshot) => snapshot.docs))
    {
      final tutorLat = tutorDoc.data()["lat"];
      final tutorLng = tutorDoc.data()["lng"];

      Map modifiedResponse = await getDirectionsTutorAPIResponse(
          position!.latitude,
          position!.longitude,
          tutorLat,
          tutorLng,
          tutorDoc.data()["tutorName"]
      );
      print("Position: $position");
      print("Tutor Lat: $tutorLat, Tutor Lng: $tutorLng");
      print("Modified Response: $modifiedResponse");
      print(tutorDoc.data()["tutorUID"]);
      SaveDirectionsTutorAPIResponse(tutorDoc.data()["tutorUID"], json.encode(modifiedResponse));
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
    String userType = sharedPreferences!.getString("usertype")! ;
    //getDirectionAPI();
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
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
        ),
        title: Text(
          sharedPreferences!.getString("name")!,
          style: const TextStyle(fontSize: 30, fontFamily: "Bebas"),
        ),
        centerTitle: true,
        actions: userType == "Tutor"
        ? [
          IconButton(
            icon: const Icon(Icons.post_add, color: Colors.white,),
            onPressed: ()
            {
              Navigator.push(context,MaterialPageRoute(builder: (c)=> const SubjectUploadScreen()));
            },
          ),
        ] : null,
      ),
      drawer: userType == "Parent" ? MyDrawer() : MyDrawerTutor(),
      body: userType == "Parent"
          ? CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                height: MediaQuery.of(context).size.height * .3 ,
                width: MediaQuery.of(context).size.width,
                child: CarouselSlider(
                  options: CarouselOptions(
                    height: 400,
                    aspectRatio: 16/9,
                    viewportFraction: 0.8,
                    initialPage: 0,
                    enableInfiniteScroll: true,
                    reverse: false,
                    autoPlay: true,
                    autoPlayInterval: Duration(seconds: 2),
                    autoPlayAnimationDuration: Duration(milliseconds: 500),
                    autoPlayCurve: Curves.fastOutSlowIn,
                    enlargeCenterPage: true,
                    enlargeFactor: 0.3,
                    scrollDirection: Axis.horizontal,
                  ),
                  items: items.map((index) {
                    return Builder(builder: (BuildContext context){
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.symmetric(horizontal: 1.0),
                        decoration: const BoxDecoration(
                          color: Colors.black,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Image.asset(
                            index,
                            fit: BoxFit.fill,
                          ),
                        ),
                      );
                    });
                  }).toList(),
                ),
              ),
            ),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("tutors")
                .snapshots(),
            builder: (context, snapshot)
            {
              return !snapshot.hasData
                  ? SliverToBoxAdapter(child: Center(child: circularProgress(),),)
                  : SliverStaggeredGrid.countBuilder(
                crossAxisCount: 1,
                staggeredTileBuilder: (c) => StaggeredTile.fit(1),
                itemBuilder: (context, index)
                {
                  Tutors sModel = Tutors.fromJson(
                    snapshot.data!.docs[index].data()! as Map<String ,dynamic>
                  );
                  //design for display tutors
                  return InfoDesignWidget.tutors(
                      tutorsModel: sModel,
                      context: context
                  );
                },
                itemCount: snapshot.data!.docs.length,
              );
            },
          ),
        ],
      )
      : TutorHomeScreen(),
    );
  }
}
