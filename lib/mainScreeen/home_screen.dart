import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tuition_app/assistantMethods/assistant_methods.dart';
import 'package:tuition_app/assistantMethods/notification_service.dart';
import 'package:tuition_app/global/global.dart';
import 'package:tuition_app/mainScreeen/tutor_home_screen.dart';
import 'package:tuition_app/models/subjects.dart';
import 'package:tuition_app/uploadScreen/subjects_upload_screen.dart';
import 'package:tuition_app/widgets/my_drawer.dart';
import 'package:tuition_app/widgets/my_drawer_tutor.dart';
import 'package:tuition_app/widgets/progress_bar.dart';

import '../assistantMethods/directions_handler.dart';
import '../assistantMethods/get_current_location.dart';
import '../widgets/subjects_design.dart';

class HomeScreen extends StatefulWidget {
   const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  NotificationServices notificationServices = NotificationServices();


  bool isSelected = false;
  List<String> selectedFilters = [];
  bool isFilterVisible = false;


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

    notificationServices.requestNotificationPermission();
    notificationServices.isTokenRefresh();
    notificationServices.getDeviceToken().then((value) {
      print("Device Token:");
      print(value);
    });


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

  //getMapboxAPI
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
  void _handleFilterSelection(String value, bool selected) {
    setState(() {
      if (value == "All") {
        if (selected) {
          selectedFilters.clear(); // Clear all other selections if All is selected
        } else {
          selectedFilters.add(value);
          // Do nothing if All is deselected (other selections remain)
        }
      } else { // For other chips
        if (selected) {
          selectedFilters.add(value);
        } else {
          selectedFilters.remove(value);
        }
      }
      // Apply filtering logic based on selectedFilters
    });
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
                    height: 200,
                    aspectRatio: 16/9,
                    viewportFraction: 0.8,
                    initialPage: 0,
                    enableInfiniteScroll: true,
                    reverse: false,
                    autoPlay: true,
                    autoPlayInterval: Duration(seconds: 6),
                    autoPlayAnimationDuration: Duration(milliseconds: 600),
                    autoPlayCurve: Curves.linear,
                    enlargeCenterPage: true,
                    enlargeFactor: 0.3,
                    scrollDirection: Axis.horizontal,
                  ),
                  items: items.map((index) {
                    return Builder(builder: (BuildContext context){
                      return Container(
                        height: MediaQuery.of(context).size.height * 0.7,
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.symmetric(horizontal: 1.0),
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
                            ),
                          // color: Colors.lightBlue,
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                          child: ClipRRect(
                            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
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
           SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(left:10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                    const Text(
                      "Subjects",
                      style: TextStyle(
                        color: Colors.cyan,
                        fontSize: 30,
                        fontFamily: "Bebas",
                      ),
                    ),
                  ElevatedButton(
                      onPressed: () => setState(() => isFilterVisible = !isFilterVisible),
                      child: const Text("Filter"),
                  ),
                  Visibility(
                    visible: isFilterVisible,
                    child: Wrap(
                      children: [
                        FilterChip(
                          label: const Text("All", style: TextStyle(color: Colors.white)),
                          selected: selectedFilters.contains("All"),
                          selectedColor: selectedFilters.contains("All") ? Colors.lightGreen : Colors.lightBlueAccent, // Change color based on "All" selection, // Change color based on "All" selection
                          checkmarkColor: selectedFilters.contains("All") ? Colors.white : Colors.white,
                          onSelected: (selected) => _handleFilterSelection("All", selected),
                        ),
                        FilterChip(
                          label: const Text("Tapah", style: TextStyle(color: Colors.white)),
                          selected: selectedFilters.contains("Tapah"),
                          selectedColor: Colors.lightBlueAccent,
                          checkmarkColor: Colors.white,
                          onSelected: (selected) => _handleFilterSelection("Tapah", selected),
                        ),
                        FilterChip(
                          label: const Text("Bidor", style: TextStyle(color: Colors.white)),
                          selected: selectedFilters.contains("Bidor"),
                          selectedColor: Colors.lightBlueAccent,
                          checkmarkColor: Colors.white,
                          onSelected: (selected) => _handleFilterSelection("Bidor", selected),
                        ),
                        FilterChip(
                          label: const Text("Kampar", style: TextStyle(color: Colors.white)),
                          selected: selectedFilters.contains("Kampar"),
                          selectedColor: Colors.lightBlueAccent,
                          checkmarkColor: Colors.white,
                          onSelected: (selected) => _handleFilterSelection("Kampar", selected),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("subjects")
                .snapshots(),
            builder: (context, snapshot)
            {
              return !snapshot.hasData
                  ? SliverToBoxAdapter(child: Center(child: circularProgress(),),)
                  : SliverAlignedGrid.count(
                crossAxisCount: 1,
                //staggeredTileBuilder: (c) => StaggeredTile.fit(1),
                itemBuilder: (context, index)
                {
                  Subjects sModel = Subjects.fromJson(
                    snapshot.data!.docs[index].data()! as Map<String ,dynamic>
                  );
                  //design for display tutors
                  return SubjectsDesignWidget(
                      subjectsModel: sModel,
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
