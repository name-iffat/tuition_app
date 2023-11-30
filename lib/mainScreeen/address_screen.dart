import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tuition_app/mainScreeen/save_address_screen.dart';
import 'package:tuition_app/models/address.dart';
import 'package:tuition_app/widgets/address_design.dart';
import 'package:tuition_app/widgets/progress_bar.dart';
import 'package:tuition_app/widgets/simple_app_bar.dart';

import '../assistantMethods/address_changer.dart';
import '../global/global.dart';

class AddressScreen extends StatefulWidget {

  final double? totalAmount;
  final String? tutorUID;

  AddressScreen({this.totalAmount, this.tutorUID});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SimpleAppBar(title: "TutorGO",),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text("Add New Address"),
          backgroundColor: Colors.cyan,
          icon: const Icon(Icons.add_location),
          onPressed: ()
          {
            //save address to parent location
            Navigator.push(context, MaterialPageRoute(builder: (c)=> SaveAddressScreen()));
          }
          ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
                padding: EdgeInsets.all(8),
              child: Text(
                "Select Address: ",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
          ),

          Consumer<AddressChanger>(builder: (context, address, c)
              {
                return Flexible(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance.collection("parents")
                          .doc(sharedPreferences!.getString("uid"))
                          .collection("userAddress")
                          .snapshots(),
                      builder: (context, snapshot)
                      {
                        return !snapshot.hasData
                            ? Center(child: circularProgress(),)
                            : snapshot.data!.docs.length == 0
                            ? Container()
                            : ListView.builder(
                                  itemCount: snapshot.data!.docs.length,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index)
                                  {
                                    return AddressDesign(
                                      currentIndex: address.count,
                                      value: index,
                                      addressID: snapshot.data!.docs[index].id,
                                      totalAmount: widget.totalAmount,
                                      tutorUID: widget.tutorUID,
                                      model: Address.fromJson(
                                        snapshot.data!.docs[index].data()! as Map<String, dynamic>
                                      ),
                                    );
                                  },
                              );
                      },
                    ),
                );
              }),
        ],
      ),
    );
  }
}
