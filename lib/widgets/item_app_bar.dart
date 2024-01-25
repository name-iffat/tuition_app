import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tuition_app/assistantMethods/cart_item_counter.dart';
import 'package:tuition_app/mainScreeen/cart_screen.dart';

import '../models/tutors.dart';

class ItemAppBar extends StatefulWidget implements PreferredSizeWidget
{
  final PreferredSizeWidget? bottom;
  final String? tutorUID;
  Tutors? tutor;
  ItemAppBar({this.bottom, this.tutorUID});


  @override
  State<ItemAppBar> createState() => _ItemAppBarState();

  @override
  // TODO: implement preferredSize
  Size get preferredSize => bottom==null?Size(56, AppBar().preferredSize.height):Size(56,80 + AppBar().preferredSize.height);
}


class _ItemAppBarState extends State<ItemAppBar> {
  String? tutorAvatarUrl; // State variable for the fetched image URL
  String? tutorName;

  @override
  initState() {
    super.initState();
    _fetchTutorData();
  }

  _fetchTutorData() {
      FirebaseFirestore.instance.collection('tutors').doc(widget.tutorUID).get().then((snap)
      {
        tutorAvatarUrl = snap.data()!["tutorAvatarUrl"].toString();
        tutorName = snap.data()!["tutorName"].toString();
        setState(() {
          tutorAvatarUrl = tutorAvatarUrl;
          tutorName = tutorName;
        });
      });
  }
  @override
  Widget build(BuildContext context) {

    return AppBar(
      // toolbarHeight: 200,
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: const CircleAvatar(child: Icon(Icons.arrow_back)),
        onPressed: ()
        {
          Navigator.pop(context);
        },
      ),
      centerTitle: true,
      actions: [
        Stack(
          children: [
            IconButton(
              icon: const CircleAvatar(child: Icon(Icons.shopping_bag, color: Colors.white, )),
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
                    color: Colors.cyan,
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
