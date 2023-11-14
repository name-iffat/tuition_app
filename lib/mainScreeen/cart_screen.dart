import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tuition_app/assistantMethods/assistant_methods.dart';
import 'package:tuition_app/widgets/app_bar.dart';
import 'package:tuition_app/widgets/cart_item_design.dart';
import 'package:tuition_app/widgets/progress_bar.dart';

import '../models/items.dart';
import '../widgets/text_widget.dart';

class CartScreen extends StatefulWidget {

  final String? tutorUID;
  CartScreen({this.tutorUID});

  @override
  State<CartScreen> createState() => _CartScreenState();
}




class _CartScreenState extends State<CartScreen> {

  List<int>? separateItemQuantityList;
  @override
  void initState() {
    super.initState();

    separateItemQuantityList = separateItemQuantities();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(tutorUID: widget.tutorUID,),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SizedBox(width: 10,),
          Align(
            alignment: Alignment.bottomLeft,
            child: FloatingActionButton.extended(
                label: const Text("Clear Cart"),
              backgroundColor: Colors.cyan,
              icon: const Icon(Icons.clear_all),
              onPressed: ()
              {

              },
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: FloatingActionButton.extended(
              label: const Text("Check Out"),
              backgroundColor: Colors.cyan,
              icon: const Icon(Icons.navigate_next),
              onPressed: ()
              {

              },
            ),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [

          //overall total price
          SliverPersistentHeader(
              pinned: true,
              delegate: TextWidgetHeader(title: "Total Amount = 120")
          ),

          //display cart item with quantity
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("items")
                .where("itemID", whereIn: separateItemIDs())
                .orderBy("publishedDate", descending: true)
                .snapshots(),
            builder: (context, snapshot)
            {
              return !snapshot.hasData
                  ? SliverToBoxAdapter(child: Center(child: circularProgress(),),)
                  : snapshot.data!.docs.length == 0
                  ? //startBuiildingCart()
                    Container()
                  : SliverList(
                delegate: SliverChildBuilderDelegate((context, index)
                {
                  Items model = Items.fromJson(
                    snapshot.data!.docs[index].data()! as Map<String, dynamic>,
                  );

                  return CartItemDesign(
                    model: model,
                    context: context,
                    quanNumber: separateItemQuantityList![index] ,
                  );
                },
                childCount: snapshot.hasData ? snapshot.data!.docs.length : 0,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
