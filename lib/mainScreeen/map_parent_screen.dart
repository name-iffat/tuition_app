import 'dart:typed_data';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:tuition_app/assistantMethods/get_current_location.dart';
import 'package:tuition_app/assistantMethods/shared_prefs.dart';
import 'package:tuition_app/global/global.dart';
import 'package:tuition_app/widgets/tutor_carousel.dart';

import '../models/tutors.dart';
import '../widgets/carousel_card.dart';
class FullMap extends StatefulWidget {
  const FullMap();

  @override
  State createState() => FullMapState();
}

class FullMapState extends State<FullMap> {
  late CameraOptions _initialCurrentPosition;
  List<Map> carouselData = [];

  int pageIndex = 0;
  List<Widget> carouselItems = [];



  @override
  initState() {
    super.initState();

    UserLocation uLocation = UserLocation();
    uLocation.getCurrentLocation();
    _initialCurrentPosition = CameraOptions( center: Point(coordinates: Position(position!.longitude, position!.latitude)).toJson(),
      zoom: 15.0,);


    //Future.delayed(Duration.zero, () => _fetchDataAndBuildCarousel());
  }



  String? ACCESS_TOKEN = dotenv.env['ACCESS_TOKEN'];
  MapboxMap? mapboxMap;

  _onMapCreated(MapboxMap mapboxMap) {
    this.mapboxMap = mapboxMap;
  }
  _onStyleLoadedCallback(StyleLoadedEventData data) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("Style loaded :), begin: ${data.begin}"),
      backgroundColor: Theme.of(context).primaryColor,
      duration: Duration(seconds: 1),
    ));
  }

  _onCameraChangeListener(CameraChangedEventData data) {
    print("CameraChangedEventData: begin: ${data.begin}, end: ${data.end}");
  }
  final Stream<QuerySnapshot> tutorStream = FirebaseFirestore.instance
      .collection('tutors')
      .orderBy('name') // Optional: Order tutors by name
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Map"),
      ),
        body:
        SafeArea(
          child: Stack(
            children: [
              SizedBox(
              height: MediaQuery.of(context).size.height * 0.8,
              child: MapWidget(
                key: ValueKey("mapWidget"),
                resourceOptions: ResourceOptions(accessToken: dotenv.env['ACCESS_TOKEN']!),
                onMapCreated: _onMapCreated,
                cameraOptions: CameraOptions(
                  center: Point(coordinates: Position(position!.longitude, position!.latitude)).toJson(),
                  zoom: 15.0,
                ),
                onStyleLoadedListener: _onStyleLoadedCallback,
                onCameraChangeListener: _onCameraChangeListener,
              ),
            ),
            StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('tutors')
                    .snapshots(),
                builder: (context, snapshot)
                {
                  return !snapshot.hasData
                      ? const Center(child: CircularProgressIndicator(),)
                      : CarouselSlider.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index,_)
                      {
                        Tutors sModel = Tutors.fromJson(
                            snapshot.data!.docs[index].data()! as Map<String ,dynamic>
                        );
                        String tutorID = snapshot.data!.docs[index].get("tutorUID");
                        return CarouselCard(
                            tutorsModel: sModel,
                            context: context,
                            // distance: (getDistanceFromSharedPreference(snapshot.data!.docs[index].get("tutorUID")))/1000,
                            // index: index,

                        );
                      },
                      options: CarouselOptions(
                        height: 100,
                        viewportFraction: 0.6,
                        initialPage: 0,
                        enableInfiniteScroll: false,
                        scrollDirection: Axis.horizontal,
                        onPageChanged:
                            (int index, CarouselPageChangedReason reason) async {
                          setState(() {
                            pageIndex = index;
                          });
                        },
                      ),
                  );
                }
            ),
            ]
          ),
        ),
      floatingActionButton: FloatingActionButton(
        onPressed: ()
        async {
          mapboxMap?.flyTo(
            _initialCurrentPosition,
              MapAnimationOptions(duration: 2000, startDelay: 0),
          );
          mapboxMap?.setCamera(_initialCurrentPosition);
          final ByteData bytes =
              await rootBundle.load("images/LOGO.png");
          final Uint8List list = bytes.buffer.asUint8List();

          mapboxMap?.location.updateSettings(LocationComponentSettings(
            enabled: true,
              pulsingEnabled: true,
          )
          );
        },
        child: const Icon(Icons.my_location),
      ),
    );
  }
}