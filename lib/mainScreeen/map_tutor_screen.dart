import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:tuition_app/assistantMethods/get_current_location.dart';
import 'package:tuition_app/assistantMethods/shared_prefs.dart';
import 'package:tuition_app/global/global.dart';
import 'package:tuition_app/widgets/review_ride_bottom_sheet.dart';

class TutorMap extends StatefulWidget {

  String? purchaserId;
  String? purchaserAddress;
  double? purchaserLat;
  double? purchaserLng;
  String? tutorId;
  String? getOrderId;


  TutorMap(
      {
        this.purchaserId,
        this.purchaserAddress,
        this.purchaserLat,
        this.purchaserLng,
        this.tutorId,
        this.getOrderId,
      }
      );

  @override
  State createState() => TutorMapState();
}

class TutorMapState extends State<TutorMap> {
  late CameraOptions _initialCurrentPosition;
  late CameraOptions _currentParentPosition;
  List<Map> carouselData = [];
  List<CameraOptions> _kTripEndPoints = [];
  //int collectionLength = int.parse( FirebaseFirestore.instance.collection('yourCollection').count() as String);

  int pageIndex = 0;
  List<Widget> carouselItems = [];




  @override
  initState() {
    super.initState();

    UserLocation uLocation = UserLocation();
    uLocation.getCurrentLocation();
    mapboxMap?.location.updateSettings(LocationComponentSettings(
      enabled: true,
      pulsingEnabled: true,
    )
    );
    _initialCurrentPosition = CameraOptions( center: Point(coordinates: Position(position!.longitude, position!.latitude)).toJson(),
      zoom: 15.0,);

     _currentParentPosition= CameraOptions(
      center: Point(coordinates: Position(widget!.purchaserLng as num, widget!.purchaserLat as num)).toJson(),
      zoom: 15.0,
    );
    getCameraOptionsFromFirebase();


    // initialize map symbols in the same order as carousel widgets
    // _kTutorsList = List<CameraOptions>.generate(
    //     collectionLength,
    //         (index) => CameraOptions(
    //             center: Point(coordinates: Position(position!.longitude, position!.latitude)).toJson(),
    //             zoom: 15.0))
    //     .toList();
  }
  Future<List<CameraOptions>?> getCameraOptionsFromFirebase() async {
    try {
        _kTripEndPoints.add(_initialCurrentPosition);

        _kTripEndPoints.add(_currentParentPosition);


      return _kTripEndPoints;

    } catch (error) {
      // Handle errors gracefully, e.g., log the error and return an empty list
      print("Error fetching camera options from Firebase: $error");
      return [];
    }
  }
  addSourceAndLayer() async {


    //Add Polyline between source and destination

    //Tutors sModel = Tutors.fromJson(tutorStream.docs[index].data()! as Map<String ,dynamic>);

    Map geometry = getGeometryParentFromSharedPrefs(widget.purchaserId as String);
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
        lineColor: Colors.indigo.value,
        lineCap: LineCap.ROUND,
        lineJoin: LineJoin.ROUND,
        lineWidth: 3.0,
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
      final ByteData bytes2 =
      await rootBundle.load('images/student_icon.png');
      Uint8List list = bytes2.buffer.asUint8List();

      var options = <PointAnnotationOptions>[];
      for (int i = 0; i < _kTripEndPoints.length; i++) {
        if(i==0)
          {
            list = bytes.buffer.asUint8List();
          }
        else
          {
            list = bytes2.buffer.asUint8List();
          }
        options.add(PointAnnotationOptions(
          geometry: _kTripEndPoints[i].center,
          image: list,
          //iconImage: "images/LOGO.png",
          iconSize: 0.5,
        ));
      }
      pointAnnotationManager?.createMulti(options);
    });
    addSourceAndLayer();
  }

  _onCameraChangeListener(CameraChangedEventData data) {
    print("CameraChangedEventData: begin: ${data.begin}, end: ${data.end}");
  }


  @override
  Widget build(BuildContext context) {
    distance = getDistanceParentFromSharedPreference(widget.purchaserId as String)/1000;
    duration = getDurationParentFromSharedPreference(widget.purchaserId as String)/60;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Tutee Location"),
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
                    zoom: 14.0,
                  ),
                  onStyleLoadedListener: _onStyleLoadedCallback,
                  onCameraChangeListener: _onCameraChangeListener,
                ),
              ),
              reviewRideBottomSheet(context, distance , duration)
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