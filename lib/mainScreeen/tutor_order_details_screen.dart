import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tuition_app/models/address.dart';
import 'package:tuition_app/widgets/progress_bar.dart';
import 'package:tuition_app/widgets/status_banner.dart';
import 'package:tuition_app/widgets/tracking_address_design.dart';

class TutorOrderDetailsScreen extends StatefulWidget {

  final String? orderID;

  TutorOrderDetailsScreen({this.orderID});

  @override
  State<TutorOrderDetailsScreen> createState() => _TutorOrderDetailsScreenState();
}

class _TutorOrderDetailsScreenState extends State<TutorOrderDetailsScreen> {

  String orderStatus = "";
  String orderByParent = "";
  String tutorUID = "";



  getOrderInfo()
  {
    FirebaseFirestore.instance
        .collection("orders")
        .doc(widget.orderID).get().then((DocumentSnapshot)
    {
      orderStatus = DocumentSnapshot.data()!['status'].toString();
      orderByParent = DocumentSnapshot.data()!['orderBy'].toString();
      tutorUID = DocumentSnapshot.data()!['tutorUID'].toString();

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
                      "Order Id = " + widget.orderID!,
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Order at: " +
                          DateFormat("dd MMMM, yyyy - hh:mn aa")
                              .format(DateTime.fromMillisecondsSinceEpoch(int.parse(dataMap["orderTime"]))),
                      style: const TextStyle(fontSize: 15, color: Colors.grey),
                    ),
                  ),
                  const Divider(thickness: 4,),
                  orderStatus == "ended"
                      ? Image.asset("images/success.png", height: MediaQuery.of(context).size.width * 0.5,)
                      : Image.asset("images/delivery.png", height: MediaQuery.of(context).size.width * 0.5),
                  const Divider(thickness: 4,),
                  FutureBuilder<DocumentSnapshot>(
                    future: FirebaseFirestore.instance
                        .collection("parents")
                        .doc(orderByParent)
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
