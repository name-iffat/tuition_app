import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tuition_app/assistantMethods/cart_item_counter.dart';
import 'package:tuition_app/mainScreeen/cart_screen.dart';

class MyAppBar extends StatefulWidget implements PreferredSizeWidget
{
  final PreferredSizeWidget? bottom;
  final String? tutorUID;
  MyAppBar({this.bottom, this.tutorUID});

  @override
  State<MyAppBar> createState() => _MyAppBarState();

  @override
  // TODO: implement preferredSize
  Size get preferredSize => bottom==null?Size(56, AppBar().preferredSize.height):Size(56,80 + AppBar().preferredSize.height);
}

class _MyAppBarState extends State<MyAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
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
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: ()
          {
            Navigator.pop(context);
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
                  Navigator.push(context,MaterialPageRoute(builder: (c)=> CartScreen(tutorUID: widget.tutorUID)));
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
      );
  }
}
