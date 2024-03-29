import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tuition_app/models/address.dart';
import 'package:tuition_app/widgets/progress_bar.dart';
import 'package:tuition_app/widgets/status_banner.dart';
import 'package:tuition_app/widgets/tracking_address_design.dart';

import '../global/global.dart';

class OrderDetailsScreen extends StatefulWidget {

  final String? orderID;

  OrderDetailsScreen({this.orderID});

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  String orderStatus = "";
  String orderByParent = "";
  String tutorUID = "";
  String rating = "";

  getOrderInfo()
  {
    FirebaseFirestore.instance
        .collection("orders")
        .doc(widget.orderID).get().then((documentSnapshot)
    {
      orderStatus = documentSnapshot.data()!['status'].toString();
      orderByParent = documentSnapshot.data()!['orderBy'].toString();
      tutorUID = documentSnapshot.data()!['tutorUID'].toString();
    });
  }

  @override
  void initState() {
    super.initState();
    getOrderInfo();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance
              .collection("parents").doc(sharedPreferences!.getString("uid"))
              .collection("orders")
              .doc(widget.orderID)
              .get(),
          builder: (c, snapshot)
          {
            Map? dataMap;
            if(snapshot.hasData)
            {
              dataMap = snapshot.data!.data()! as Map<String, dynamic>;
              orderStatus = dataMap["status"].toString();
            }
            return snapshot.hasData
                ? Container(
              child: Column(
                children: [
                  StatusBanner(
                    status: dataMap!["isSuccess"],
                    orderStatus: orderStatus,
                  ),
                  const SizedBox(height: 10.0,),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                          "RM " + dataMap["totalAmount"].toStringAsFixed(2),
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                     "Order Id = ${widget.orderID!}",
                      style: const TextStyle(
                          fontSize: 16,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Order at: ${DateFormat("dd MMMM, yyyy - hh:mn aa")
                          .format(DateTime.fromMillisecondsSinceEpoch(int.parse(dataMap["orderTime"])))}",
                      style: const TextStyle(fontSize: 15, color: Colors.grey),
                    ),
                  ),
                  const Divider(thickness: 4,),
                  orderStatus == "ended"
                      ? Image.asset(
                      "images/tutorlogin.png",
                      height: MediaQuery.of(context).size.height * 0.3,
                  )
                      : Image.asset("images/delivery.png"),
                  const Divider(thickness: 4,),
                  FutureBuilder<DocumentSnapshot>(
                    future: FirebaseFirestore.instance
                        .collection("parents")
                        .doc(sharedPreferences!.getString("uid"))
                        .collection("userAddress")
                        .doc(dataMap["addressID"])
                        .get(),
                    builder: (c, snapshot)
                    {
                      return snapshot.hasData
                          ? TrackingAddressDesign(
                              model: Address.fromJson(
                                snapshot.data!.data()! as Map<String, dynamic>
                              ),
                        orderStatus: orderStatus,
                        orderID: widget.orderID,
                        tutorID:tutorUID,
                        orderByParent: orderByParent,

                      )
                          : Center(child: circularProgress(),);
                    },
                  ),

                ],
              ),
            )
                : Center(child: circularProgress(),);
          },
        ),
      ),
    );
  }
}
