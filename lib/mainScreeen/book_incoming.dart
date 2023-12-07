import 'package:flutter/material.dart';

class BookIncomingScreeen extends StatefulWidget
{

  String? purchaserId;
  String? purchaserAddress;
  double? purchaserLat;
  double? purchaserLng;
  String? tutorId;
  String? getOrderId;

  BookIncomingScreeen({
    this.purchaserId,
    this.purchaserAddress,
    this.purchaserLat,
    this.purchaserLng,
    this.tutorId,
    this.getOrderId,
});

  @override
  State<BookIncomingScreeen> createState() => _BookIncomingScreeenState();
}

class _BookIncomingScreeenState extends State<BookIncomingScreeen> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
