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
      // flexibleSpace: Container(
      //   child:
      //   FadeInImage.assetNetwork(
      //       image: tutorAvatarUrl ?? "https://cdn.discordapp.com/attachments/1186076047872110712/1192522621678534716/image.png?ex=65a9623d&is=6596ed3d&hm=ed7c4b2dcda7bc3cc27f342fe91fbfb3685d475a16820e3425ee486e2aa211f8&" , // Use placeholder if image loading fails
      //       height: MediaQuery.of(context).size.height,
      //       width: MediaQuery.of(context).size.width,
      //       fit: BoxFit.cover,
      //       placeholder: "images/placeholder.jpg",
      //     )
      // ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: ()
        {
          Navigator.pop(context);
        },
      ),
      // title:  Text(
      //   tutorName ?? "TutorGO",
      //   style: TextStyle(fontSize: 30, fontFamily: "Bebas"),
      // ),
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
