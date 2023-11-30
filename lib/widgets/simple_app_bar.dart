import 'package:flutter/material.dart';

class SimpleAppBar extends StatelessWidget implements PreferredSizeWidget{

  String? title;
  final PreferredSizeWidget? bottom;

  SimpleAppBar({this.bottom, this.title});

  @override
  Size get preferredSize => bottom==null?Size(56, AppBar().preferredSize.height):Size(56,80 + AppBar().preferredSize.height);


  @override
  Widget build(BuildContext context) {
    return AppBar(
      iconTheme: const IconThemeData(
        color: Colors.white,
      ),
      flexibleSpace: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.cyan,
                Colors.amber,
              ],
              begin: const FractionalOffset(0.0, 0.0),
              end: const FractionalOffset(1.0, 0.0),
              stops: [0.0,1.0],
              tileMode: TileMode.clamp,
            )
        ),
      ),
      title: Text(
        title!,
        style: const TextStyle(fontSize: 30, fontFamily: "Bebas"),
      ),
      centerTitle: true,
    );
  }
}
