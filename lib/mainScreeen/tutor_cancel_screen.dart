import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../assistantMethods/assistant_methods.dart';
import '../global/global.dart';
import '../widgets/order_card.dart';
import '../widgets/progress_bar.dart';
import '../widgets/simple_app_bar.dart';

class CancelScreen extends StatefulWidget {

   const CancelScreen({
     super.key,
    //required this.popUp,
});

  @override
  State<CancelScreen> createState() => _CancelScreenState();
}

class _CancelScreenState extends State<CancelScreen> {


  @override
  Widget build(BuildContext context) {
    String userType = sharedPreferences!.getString("usertype")! ;
    String iD = userType == "Parent" ? "orderBy" : "tutorUID";
    return SafeArea(
      child: Scaffold(
        appBar: SimpleAppBar(title: "Canceled Order",),
        body:
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("orders")
                  .where(iD, isEqualTo: sharedPreferences!.getString("uid"))
                  .where("status", isEqualTo: "cancel")
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
