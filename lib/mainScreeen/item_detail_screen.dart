import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:number_inc_dec/number_inc_dec.dart';
import 'package:tuition_app/global/global.dart';
import 'package:tuition_app/mainScreeen/home_screen.dart';
import 'package:tuition_app/widgets/app_bar.dart';
import 'package:tuition_app/widgets/simple_app_bar.dart';

import '../assistantMethods/assistant_methods.dart';
import '../models/items.dart';

class ItemDetailScreen extends StatefulWidget
{
  final Items? model;
  const ItemDetailScreen({this.model});

  @override
  State<ItemDetailScreen> createState() => _ItemDetailScreenState();
}

class _ItemDetailScreenState extends State<ItemDetailScreen> {
  TextEditingController counterTextEditingController = TextEditingController();

  deleteItem(String itemID)
  {
    FirebaseFirestore.instance
        .collection("tutors")
        .doc(sharedPreferences!.getString("uid"))
        .collection("subject")
        .doc(widget.model!.subjectID!)
        .collection("items")
        .doc(itemID)
        .delete().then((value)
    {
      FirebaseFirestore.instance
          .collection("items")
          .doc(itemID)
          .delete();
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (c)=> const HomeScreen()));
      Fluttertoast.showToast(msg: "Subject Deleted Successfully.");
    });
  }

  @override
  Widget build(BuildContext context)
  {
    String userType = sharedPreferences!.getString("usertype")!;

    return Scaffold(
      appBar: userType=="Parent" ? MyAppBar(tutorUID: widget.model!.tutorUID) : SimpleAppBar(title: sharedPreferences!.getString("name"),),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Image.network(widget.model!.thumbnailUrl.toString(),height:MediaQuery.sizeOf(context).width * 0.6,fit: BoxFit.cover ,),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              widget.model!.title.toString(),
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30,),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              widget.model!.longDescription.toString(),
              textAlign: TextAlign.justify,
              style: TextStyle(fontWeight: FontWeight.normal, fontSize: 14,),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "RM ${widget.model!.price} per session",
              textAlign: TextAlign.justify,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20,),
            ),
          ),

          Center(
            child: Visibility(
              visible: userType == "Parent",
              child: Container(
                width: MediaQuery.of(context).size.width * 0.6,
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: NumberInputWithIncrementDecrement(
                    widgetContainerDecoration: const BoxDecoration(
                      border: Border.symmetric(),
                    ),
                    incIconSize: 55,
                    decIconSize: 50,
                    incIconColor: Colors.lightBlue[800],
                    decIconColor: Colors.lightBlue[800],
                    numberFieldDecoration: const InputDecoration(
                      border: InputBorder.none,
                    ),
                    style: const TextStyle(fontSize: 35,fontFamily: "Poppins", fontWeight: FontWeight.bold),
                    incIcon: Icons.add,
                    decIcon: Icons.remove,
                    controller: counterTextEditingController,
                    incDecBgColor: Colors.white,
                    incIconDecoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.blueAccent,
                        width: 1.5,
                      ),
                      borderRadius: const BorderRadius.all(Radius.circular(15)),
                    ),
                    decIconDecoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.blueAccent,
                        width: 1.5,
                      ),
                      borderRadius: const BorderRadius.all(Radius.circular(15)),
                    ),

                    min: 1,
                    max: 9,
                    initialValue: 1,
                    buttonArrangement: ButtonArrangement.incRightDecLeft,
                  ),
                ),
              ),
            ),
          ),


          const SizedBox(height: 10,),
          Center(
            child: userType =="Parent"
            ? InkWell(
              onTap: ()
              {
                int itemCounter = int.parse(counterTextEditingController.text);

                List<String> separateItemIDsList = separateItemIDs();

                //check if item exist already in cart
                separateItemIDsList.contains(widget.model!.itemID)
                ? Fluttertoast.showToast(msg: "Item is already in cart.")
                :

                // add to cart
                addItemToChart(widget.model!.itemID, context, itemCounter);
              },
              child: Container(
                margin: const EdgeInsets.only(top: 5),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                    gradient: LinearGradient(
                      colors: [
                        Colors.cyan,
                        Colors.blue,
                      ],
                      begin: const FractionalOffset(0.0, 0.0),
                      end: const FractionalOffset(1.0, 0.0),
                      stops: [0.0,1.0],
                      tileMode: TileMode.clamp,
                    )
                ),
                width: MediaQuery.of(context).size.width * 0.9,
                height: 60,
                child: const Center(
                  child: Text(
                    "Add to Cart",
                    style: TextStyle(color: Colors.white, fontSize: 20, fontFamily: "Poppins"),
                  ),
                ),

              ),
            )
            : InkWell(
              onTap: ()
              {
                //delete item
                deleteItem(widget!.model!.itemID!);
              },
              child: Container(
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.cyan,
                        Colors.blueAccent,
                      ],
                      begin: const FractionalOffset(0.0, 0.0),
                      end: const FractionalOffset(1.0, 0.0),
                      stops: [0.0,1.0],
                      tileMode: TileMode.clamp,
                    )
                ),
                width: MediaQuery.of(context).size.width - 45,
                height: 50,
                child: const Center(
                  child: Text(
                    "Delete this Subject",
                    style: TextStyle(color: Colors.white, fontSize: 16, fontFamily: "Poppins"),
                  ),
                ),

              ),
            ),
          ),
        ],
      ),
    );
  }
}
