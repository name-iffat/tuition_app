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
num getDistanceParentFromSharedPreference(String parentID)
{
  final id = parentID;
  String? response = sharedPreferences!.getString("parent_$id");
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

num getDurationParentFromSharedPreference(String parentID)
{
  final id = parentID;
  String? response = sharedPreferences!.getString("parent_$id");
  Map decodedResponse = json.decode(response!);
  num duration = decodedResponse['duration'];
  return duration;
}

Map getGeometryFromSharedPrefs(String tutorID) {
  final id = tutorID;
  String? response = sharedPreferences!.getString("tutor_$id");
  Map decodedResponse = json.decode(response!);
  Map geometry = decodedResponse['geometry'];
  return geometry;
}

Map getGeometryParentFromSharedPrefs(String parentID) {
  final id = parentID;
  String? response = sharedPreferences!.getString("parent_$id");
  Map decodedResponse = json.decode(response!);
  Map geometry = decodedResponse['geometry'];
  return geometry;
}