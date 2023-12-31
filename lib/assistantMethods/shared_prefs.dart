import 'dart:convert';

import '../global/global.dart';

Map getDecodedResponseFromSharedPreference(String tutorID)
{
  final id = tutorID;
  String? response = sharedPreferences!.getString("tutor_$id");
  Map decodedResponse = jsonDecode(response!);
  return decodedResponse;
}

num getDistanceFromSharedPreference(String tutorID)
{
  final id = tutorID;
  String? response = sharedPreferences!.getString("tutor_$id");
  Map decodedResponse = json.decode(response!);
  num distance = decodedResponse['distance'];
  print(distance);
  return distance;
}

num getDurationFromSharedPreference(String tutorID)
{
  final id = tutorID;
  String? response = sharedPreferences!.getString("tutor_$id");
  Map decodedResponse = json.decode(response!);
  num duration = decodedResponse['duration'];
  return duration;
}

num getGeometryFromSharedPrefs(String tutorID) {
  final id = tutorID;
  String? response = sharedPreferences!.getString("tutor_$id");
  Map decodedResponse = json.decode(response!);
  num geometry = decodedResponse['geometry'];
  return geometry;
}