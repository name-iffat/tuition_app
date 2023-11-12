import 'package:flutter/material.dart';
import 'package:tuition_app/assistantMethods/assistant_methods.dart';
import 'package:tuition_app/widgets/app_bar.dart';

class CartScreen extends StatefulWidget {

  final String? tutorUID;
  CartScreen({this.tutorUID});

  @override
  State<CartScreen> createState() => _CartScreenState();
}




class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    super.initState();

    separateItemQuantities();
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
    );
  }
}
