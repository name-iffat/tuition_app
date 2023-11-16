import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:tuition_app/assistantMethods/assistant_methods.dart';
import 'package:tuition_app/widgets/cart_item_design.dart';
import 'package:tuition_app/widgets/progress_bar.dart';

import '../assistantMethods/cart_item_counter.dart';
import '../models/items.dart';
import '../splashScreen/splash_screen.dart';
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
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.cyan,
                  Colors.amber,
                ],
                begin: const FractionalOffset(0.0, 0.0),
                end: const FractionalOffset(1.0, 0.0),
                stops: [0.0,1.0],
                tileMode: TileMode.clamp,
              )
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.clear_all),
          onPressed: ()
          {
            clearCartNow(context);
          },
        ),
        title: const Text(
          "TutorGO",
          style: TextStyle(fontSize: 30, fontFamily: "Bebas"),
        ),
        centerTitle: true,
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_bag, color: Colors.white,),
                onPressed: ()
                {
                  //send user to cart screen
                  print("shopcart clicked");
                },
              ),
              Positioned(
                child: Stack(
                  children: [
                    const Icon(
                      Icons.brightness_1,
                      size: 20,
                      color: Colors.green,
                    ),
                    Positioned(
                      top: 3,
                      right: 5,
                      child: Center(
                        child: Consumer<CartItemCounter>(
                          builder: (context, counter, c)
                          {
                            return Text(
                                counter.count.toString(),
                                style: TextStyle(color: Colors.white, fontSize: 12)
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            ],
          ),
        ],
      ),
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
                clearCartNow(context);

                Navigator.push(context, MaterialPageRoute(builder: (c)=> const MySplashScreen()));

                Fluttertoast.showToast(msg: "Cart has been cleared.");

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
