import 'package:flutter/material.dart';

class TrackingScreen extends StatefulWidget
{
  String? purchaserId;
  String? purchaserAddress;
  String? tutorID;
  String? getOrderID;
  double? purchaserLat;
  double? purchaserLng;

  TrackingScreen(
  {
    this.purchaserId,
    this.purchaserAddress,
    this.tutorID,
    this.getOrderID,
    this.purchaserLat,
    this.purchaserLng,
  });

  @override
  State<TrackingScreen> createState() => _TrackingScreenState();
}

class _TrackingScreenState extends State<TrackingScreen>
{

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
