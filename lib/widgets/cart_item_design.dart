import 'package:flutter/material.dart';

import '../models/items.dart';

class CartItemDesign extends StatefulWidget {
  final Items? model;
  BuildContext? context;
  final int? quanNumber;

  CartItemDesign({
    this.model,
    this.context,
    this.quanNumber,
});

  @override
  State<CartItemDesign> createState() => _CartItemDesignState();
}

class _CartItemDesignState extends State<CartItemDesign> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.cyan,
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Container(
          height: 100,
          width: MediaQuery.of(context).size.width,
          child: Row(
            children: [

              Image.network(widget.model!.thumbnailUrl!, width: 140, height: 120,),

              const SizedBox(width: 6,),

              //title
              //quantity number
              //price
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  //title
                  Text(widget.model!.title!,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontFamily: "Poppins",
                  ),
                  ),
                  const SizedBox(
                    height: 1,
                  ),
                  //quantity number //x 7
                  Row( // x(multiply) 7
                    children: [
                      const Text(
                        "x ",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 25,
                          fontFamily: "Poppins",
                        ),
                      ),
                      Text(
                        widget.quanNumber.toString(),
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 25,
                          fontFamily: "Poppins",
                        ),
                      ),

                    ],
                  ),

                  //price
                  Row(
                    children: [
                      const Text(
                        "Price:  ",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 15,
                        ),
                      ),
                      const Text(
                        "RM ",
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 16.0,
                        ),
                      ),
                      Text(
                        widget.model!.price.toString(),
                        style: const TextStyle(
                          color: Colors.blue,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
