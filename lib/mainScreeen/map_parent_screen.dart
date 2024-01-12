import 'dart:convert';
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
  List<CameraOptions>? _kTutorsList;
  //int collectionLength = int.parse( FirebaseFirestore.instance.collection('yourCollection').count() as String);

  int pageIndex = 0;
  List<Widget> carouselItems = [];



  @override
  initState() {
    super.initState();

    UserLocation uLocation = UserLocation();
    uLocation.getCurrentLocation();
    _initialCurrentPosition = CameraOptions( center: Point(coordinates: Position(position!.longitude, position!.latitude)).toJson(),
      zoom: 15.0,);


    // initialize map symbols in the same order as carousel widgets
    getCameraOptionsFromFirebase();
    // _kTutorsList = List<CameraOptions>.generate(
    //     collectionLength,
    //         (index) => CameraOptions(
    //             center: Point(coordinates: Position(position!.longitude, position!.latitude)).toJson(),
    //             zoom: 15.0))
    //     .toList();
  }
  Future<List<CameraOptions>?> getCameraOptionsFromFirebase() async {
    try {
      final QuerySnapshot tutorStream = await FirebaseFirestore.instance
          .collection('tutors')
          .get();
      //List<CameraOptions> cameraOptions = [];
      tutorStream.docs.length;
      for (int index = 0; index < tutorStream.docs.length; index++) {
        //Tutors sModel = Tutors.fromJson(tutorStream.docs[index].data()! as Map<String ,dynamic>);
        // double lat = tutorStream.docs[index].get("lat");
        // double lng = tutorStream.docs[index].get("lng");

        // initialize map symbols in the same order as carousel widgets
        _kTutorsList = List<CameraOptions>.generate(
            tutorStream.docs.length,
                (index) => CameraOptions(
                    center: Point(coordinates: Position(
                    tutorStream.docs[index].get("lng"),
                    tutorStream.docs[index].get("lat")
                    )).toJson(),
                    zoom: 15.0)
                    );
        // _kTutorsList?.add(
        //     CameraOptions(
        //         center: Point(coordinates: Position(
        //             tutorStream.docs[index].get("lng"),
        //             tutorStream.docs[index].get("lat")
        //         )).toJson(),
        //         zoom: 15));
      }

      return _kTutorsList;
    } catch (error) {
      // Handle errors gracefully, e.g., log the error and return an empty list
      print("Error fetching camera options from Firebase: $error");
      return [];
    }
  }
  addSourceAndLayer(int index, bool removeLayer) async {
    //animate camera to current item

    mapboxMap?.flyTo(
      _kTutorsList![index],
      MapAnimationOptions(duration: 2000, startDelay: 0),
    );
    mapboxMap?.setCamera(_kTutorsList![index]);


    // Add an image to use as a marker
    final ByteData bytes =
    await rootBundle.load("images/LOGO.png");
    final Uint8List list = bytes.buffer.asUint8List();
    PointAnnotation(
      iconImage: "images/LOGO.png",
      iconSize: 1.0, id: 'marker',
    );

    //Add Polyline between source and destination
    final QuerySnapshot tutorStream = await FirebaseFirestore.instance
        .collection('tutors')
        .get();

      //Tutors sModel = Tutors.fromJson(tutorStream.docs[index].data()! as Map<String ,dynamic>);
      String tutorID = tutorStream.docs[index].get("tutorUID");

      Map geometry = getGeometryFromSharedPrefs(tutorID);
      final fills =
      {
        "type": "FeatureCollection",
        "features": [
          {
            "type": "Feature",
            "id": 0,
            "properties": <String, dynamic>{},
            "geometry": geometry,
          },
        ],
      };

      // Remove lineLayer and source if it exists
      if (removeLayer == true) {
        await mapboxMap!.style.removeStyleLayer('lines'); //removeLayer('lineLayer');
        await mapboxMap!.style.removeStyleSource('fills'); //removeSource('lineSource');
      }

      // Add a source and layer displaying a point which will be animated in a circle.
      await mapboxMap!.style.addSource(
        GeoJsonSource(
          id: 'fills',
          data: json.encode(fills),
        ),

      );

      await mapboxMap!.style.addLayer(
        LineLayer(
          id: 'lines',
          sourceId: 'fills',
          lineColor: Colors.lightGreen.value,
          lineCap: LineCap.ROUND,
          lineJoin: LineJoin.ROUND,
          lineWidth: 2.0,
        ),
      );

  }



  String? ACCESS_TOKEN = dotenv.env['ACCESS_TOKEN'];
  MapboxMap? mapboxMap;


  _onMapCreated(MapboxMap mapboxMap) {
    this.mapboxMap = mapboxMap;
  }
   _onStyleLoadedCallback(StyleLoadedEventData data)  async {
     // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
     //   content: Text("Style loaded :), begin: ${data.begin}"),
     //   backgroundColor: Theme.of(context).primaryColor,
     //   duration: Duration(seconds: 1),
     // ));
      await mapboxMap?.annotations.createPointAnnotationManager().then((pointAnnotationManager) async
      {
        final ByteData bytes =
        await rootBundle.load('images/LOGO.png');
        final Uint8List list = bytes.buffer.asUint8List();
        var options = <PointAnnotationOptions>[];
        for(CameraOptions kTutors in _kTutorsList!) {
          options.add(PointAnnotationOptions(
            geometry: kTutors.center,
            image: list,
            //iconImage: "images/LOGO.png",
            iconSize: 0.5,
          ));
        }
        pointAnnotationManager?.createMulti(options);
      });
      addSourceAndLayer(0,false);
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
              height: MediaQuery.of(context).size.height,
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
                        //String tutorID = snapshot.data!.docs[index].get("tutorUID");
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
                          addSourceAndLayer(index, true);
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