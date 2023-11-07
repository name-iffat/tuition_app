import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:tuition_app/assistantMethods/cart_item_counter.dart';
import 'package:tuition_app/global/global.dart';

separateItemIDs()
{
  List<String> separateItemIDsList =[], defaultItemList=[];
  int i=0;

  defaultItemList = sharedPreferences!.getStringList("userCart")!;

  for(i; i<defaultItemList.length;i++)
    {
      //5565757:7
      String item = defaultItemList[i].toString();
      var pos = item.lastIndexOf(":");
              //5565757
      String getItemId = (pos != -1) ? item.substring(0, pos) : item;
      print("This is itemID now = $getItemId");

      separateItemIDsList.add(getItemId);
    }
  print("/nThis is Items List now = ");
  print(separateItemIDsList);

  return separateItemIDsList;
}

addItemToChart(String? subjectItemId, BuildContext context, int itemCounter)
{
  List<String>? tempList = sharedPreferences!.getStringList("userCart");
  tempList!.add("${subjectItemId!}:$itemCounter"); //5565757:7

  FirebaseFirestore.instance.collection("parents")
      .doc(firebaseAuth.currentUser!.uid).update({
    "userCart": tempList,
  }).then((value){
    Fluttertoast.showToast(msg: "Item Added Successfully.");

    sharedPreferences!.setStringList("userCart", tempList);

      //update the badge cart number
    Provider.of<CartItemCounter>(context, listen: false).displayCartListItemsNumber();

  });
}
