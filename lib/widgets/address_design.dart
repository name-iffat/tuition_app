import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tuition_app/assistantMethods/address_changer.dart';

import '../models/address.dart';

class AddressDesign extends StatefulWidget {

  final Address? model;
  final int? currentIndex;
  final int? value;
  final String? addressID;
  final double? totalAmount;
  final String? tutorUID;

  AddressDesign({
    this.model,
    this.currentIndex,
    this.value,
    this.addressID,
    this.totalAmount,
    this.tutorUID,
});


  @override
  State<AddressDesign> createState() => _AddressDesignState();
}

class _AddressDesignState extends State<AddressDesign> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ()
      {
        //select this address
        Provider.of<AddressChanger>(context, listen: false).displayResult(widget.value);
      },
      child: Card(
        color: Colors.cyan.withOpacity(0.4),
        child: Column(
          children: [
            //address info
            Row(
              children: [
                Radio(
                  groupValue: widget.currentIndex!,
                  value: widget.value!,
                  activeColor: Colors.amber,
                  onChanged: (val)
                  {
                    //provider
                    Provider.of<AddressChanger>(context, listen: false).displayResult(val);
                    print(val);
                  },
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        width: MediaQuery.of(context).size.width + 0.8,
                        child: Table(
                          children: [
                            TableRow(
                              children: [
                                const Text("Name: ",
                                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                                ),
                                Text(widget.model!.name.toString()),
                              ],
                            ),
                            TableRow(
                              children: [
                                const Text("Phone Number: ",
                                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                                ),
                                Text(widget.model!.phoneNumber.toString()),
                              ],
                            ),
                            TableRow(
                              children: [
                                const Text("Flat Number: ",
                                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                                ),
                                Text(widget.model!.flatNumber.toString()),
                              ],
                            ),
                            TableRow(
                              children: [
                                const Text("City: ",
                                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                                ),
                                Text(widget.model!.city.toString()),
                              ],
                            ),
                            TableRow(
                              children: [
                                const Text("State: ",
                                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                                ),
                                Text(widget.model!.state.toString()),
                              ],
                            ),
                            TableRow(
                              children: [
                                const Text("Full Address: ",
                                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                                ),
                                Text(widget.model!.fullAddress.toString()),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            //button
            ElevatedButton(
              child: Text("Check on Maps"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black54,
              ),
              onPressed: ()
              {

              },
            ),

            //button
            widget.value == Provider.of<AddressChanger>(context).count
                ? ElevatedButton(
                    child: const Text("Proceed"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
              onPressed: ()
              {

              },
            )
                : Container(),
          ],
        ),
      ),
    );
  }
}
