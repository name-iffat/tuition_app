

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

import 'dio_exceptions.dart';

String baseUrl = "https://api.mapbox.com/directions/v5/mapbox";
String accessToken = "pk.eyJ1IjoiaWZmYXRoYWlrYWwiLCJhIjoiY2xxNzY3ajY3MDJmbTJqb3lzYzZndXQxdyJ9.Bgd0yPQCN_cV6v7KTGn_-A";
String navType = "driving";

Dio _dio = Dio();

Future getDrivingRouteUsingMapbox(double lat1, double lng1, double lat2, double lng2) async
{
  String url = "$baseUrl/$navType/$lng1,$lat1;$lng2,$lat2?alternatives=true&geometries=geojson&steps=true&access_token=$accessToken";
  try
  {
    _dio.options.contentType = Headers.jsonContentType;
    final responseData = await _dio.get(url);
    return responseData.data;
  } catch (e) {
    final errorMessage = DioExceptions.fromDioError(e as DioException).toString();
    debugPrint(errorMessage);
  }

}

