import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tuition_app/assistantMethods/assistant_methods.dart';
import 'package:tuition_app/global/global.dart';
import 'package:tuition_app/mainScreeen/home_screen.dart';

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

  String orderId = DateTime.now().millisecondsSinceEpoch.toString();

  addOrderDetails()
  {
    writeOrderDetailsForParent({
      "addressID": widget.addressID,
      "totalAmount": widget.totalAmount,
      "orderBy": sharedPreferences!.getString("uid"),
      "productIDs": sharedPreferences!.getStringList("userCart"),
      "paymentDetails": "Cash on Delivery",
      "orderTime": orderId,
      "isSuccess": "isSuccess",
      "tutorUID": widget.tutorUID,
      "status": "normal",
      "orderID": orderId,
    });

    writeOrderDetailsForTutor({
      "addressID": widget.addressID,
      "totalAmount": widget.totalAmount,
      "orderBy": sharedPreferences!.getString("uid"),
      "productIDs": sharedPreferences!.getStringList("userCart"),
      "paymentDetails": "Cash on Delivery",
      "orderTime": orderId,
      "isSuccess": "isSuccess",
      "tutorUID": widget.tutorUID,
      "status": "normal",
      "orderID": orderId,
    }).whenComplete((){
      clearCartNow(context);
      setState(() {
        orderId="";
        Navigator.push(context, MaterialPageRoute(builder: (context)=> const HomeScreen()));
        Fluttertoast.showToast(msg: "Congratulations, you have booked successfully!");
      });
    });
  }

  Future writeOrderDetailsForParent(Map<String, dynamic> data) async
  {
    await FirebaseFirestore.instance
        .collection("parents")
        .doc(sharedPreferences!
        .getString("uid"))
        .collection("orders")
        .doc(orderId)
        .set(data);
  }

  Future writeOrderDetailsForTutor(Map<String, dynamic> data) async
  {
    await FirebaseFirestore.instance
        .collection("orders")
        .doc(orderId)
        .set(data);
  }

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
                  addOrderDetails();
                },
              )
            ],
          ),
        )
    );
  }
}
