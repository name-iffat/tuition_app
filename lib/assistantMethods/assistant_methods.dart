import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tuition_app/global/global.dart';

addItemToChart(String? subjectItemId, BuildContext context, int itemCounter)
{
  List<String>? tempList = sharedPreferences!.getStringList("userCart");
  tempList!.add("${subjectItemId!}:$itemCounter");

  FirebaseFirestore.instance.collection("parents")
      .doc(firebaseAuth.currentUser!.uid).update({
    "userCart": tempList,
  }).then((value){
    Fluttertoast.showToast(msg: "Item Added Successfully.");

    sharedPreferences!.setStringList("userCart", tempList);

      //update the badge cart number
  });
}
