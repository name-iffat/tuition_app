import 'package:flutter/material.dart';

class PlacedOrderScreen extends StatefulWidget
{
  String? addressID;
  double? totalAmount;
  String? tutorUID;

  PlacedOrderScreen({this.tutorUID, this.totalAmount, this.addressID});

  @override
  State<PlacedOrderScreen> createState() => _PlacedOrderScreenState();
}

class _PlacedOrderScreenState extends State<PlacedOrderScreen> {
  @override
  Widget build(BuildContext context)
  {
    return Material(
        child: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.cyan,
                  Colors.cyanAccent,
                ],
                begin: FractionalOffset(0.0, 0.0),
                end:  FractionalOffset(1.0, 0.0),
                stops: [0.0,1.0],
                tileMode: TileMode.clamp,
              )
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("images/delivery.png"),
              const SizedBox(height: 12,),
              ElevatedButton(
                child: const Text("Place Book"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                ),
                onPressed: ()
                {

                },
              )
            ],
          ),
        )
    );
  }
}
