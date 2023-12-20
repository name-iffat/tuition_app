

import 'package:tuition_app/global/global.dart';
import 'package:tuition_app/models/tutors.dart';

import 'mapbox_request.dart';
Tutors? tutorsModel;
Future<Map> getDirectionsTutorAPIResponse( double sourceLat,double  sourceLng, double lat2,double lng2,String tutorName) async
{


  final response = await getDrivingRouteUsingMapbox(
      sourceLat, sourceLng,
      lat2, lng2
  );

  Map geometry = response['routes'][0]['geometry'];
  num distance = response['routes'][0]['distance'];
  num duration = response['routes'][0]['duration'];
  
  print(tutorName);
  print(distance);
  print(duration);

  Map modifiedResponse = {
    "geometry": geometry,
    "distance": distance,
    "duration": duration,
  };
  return modifiedResponse;

}

void SaveDirectionsTutorAPIResponse(String tutorID, String response)
{
  final id = tutorID;
  sharedPreferences!.setString("tutor_$id", response);
}