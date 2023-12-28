import 'package:firebase_auth/firebase_auth.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences? sharedPreferences;
FirebaseAuth firebaseAuth = FirebaseAuth.instance;

Position? position;
List<Placemark>? placeMark;
String completeAddress="";

String perBookTransportAmount="";
String previousEarnings =''; //tutoring old earnings
String previousTransportEarnings =""; //tutor transporting old earnings
String previousTutorEarnings="";

num distance = 0;
num duration = 0;