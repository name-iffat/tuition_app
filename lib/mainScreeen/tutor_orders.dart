import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tuition_app/assistantMethods/assistant_methods.dart';
import 'package:tuition_app/widgets/order_card.dart';
import 'package:tuition_app/widgets/progress_bar.dart';
import 'package:tuition_app/widgets/simple_app_bar.dart';

import '../global/global.dart';

class TutorOrdersScreen extends StatefulWidget {
  const TutorOrdersScreen({super.key});

  @override
  State<TutorOrdersScreen> createState() => _TutorOrdersScreenState();
}

class _TutorOrdersScreenState extends State<TutorOrdersScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: SimpleAppBar(title: "New Orders",),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("orders")
              .where("tutorUID", isEqualTo: sharedPreferences!.getString("uid"))
              .where("status", isEqualTo: "normal")
              .orderBy("orderTime", descending: true)
              .snapshots(),
          builder: (c, snapshot)
          {
            return snapshot.hasData
                ? ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (c, index)
              {
                return FutureBuilder<QuerySnapshot>(
                  future: FirebaseFirestore.instance
                      .collection("items")
                      .where("itemID", whereIn: separateOrderItemIDs((snapshot.data!.docs[index].data()! as Map<String, dynamic>)["productIDs"]))
                      .where("orderBy", whereIn: (snapshot.data!.docs[index].data()! as Map<String, dynamic>)["uid"])
                      .orderBy("publishedDate", descending: true)
                      .get(),
                  builder: (c, snap)
                  {
                    return snap.hasData
                        ? OrderCard(
                      itemCount: snap.data!.docs.length,
                      data: snap.data!.docs,
                      orderID: snapshot.data!.docs[index].id,
                      seperateQuantitiesList: separateOrderItemQuantities((snapshot.data!.docs[index].data()!  as Map<String, dynamic>)["productIDs"]),

                    )
                        : Center(child: circularProgress(),);
                  },
                );
              },

            )
                : Center(child: circularProgress(),);
          },
        ),
      ),
    );
  }
}
