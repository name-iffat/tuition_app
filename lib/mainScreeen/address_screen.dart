import 'package:flutter/material.dart';
import 'package:tuition_app/mainScreeen/save_address_screen.dart';
import 'package:tuition_app/widgets/simple_app_bar.dart';

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
      appBar: SimpleAppBar(),
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
          )
        ],
      ),
    );
  }
}
