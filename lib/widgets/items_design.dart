import 'package:flutter/material.dart';
import '../global/global.dart';
import '../models/items.dart';

class ItemsDesignWidget extends StatefulWidget {
  String userType = sharedPreferences!.getString("usertype")!;

  BuildContext? context;


  Items itemsModel;


  ItemsDesignWidget({required this.itemsModel, required this.context});

  @override
  State<ItemsDesignWidget> createState() => _ItemsDesignWidgetState();


}

class _ItemsDesignWidgetState extends State<ItemsDesignWidget> {


  @override
  Widget build(BuildContext context) {

    return InkWell(
      onTap: ()
      {
        //Navigator.push(context, MaterialPageRoute(builder: (c)=> ItemsScreen(model: model)));
      },
      splashColor: Colors.amber,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Container(
          height: 285,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Divider(
                height: 4,
                thickness: 3,
                color: Colors.grey[300],
              ),
              const SizedBox(height: 1,),
              Text(
                widget.itemsModel!.title!,
                style: const TextStyle(
                  color: Colors.cyan,
                  fontSize: 25,
                  fontFamily: "Bebas",
                ),
              ),
              const SizedBox(height: 1,),
              Image.network(
                widget.itemsModel!.thumbnailUrl! ,
                height: 220.0,
                fit: BoxFit.cover,
              ),
              SizedBox(height: 10.0,),
              Text(
                widget.itemsModel!.shortInfo!,
                style: const TextStyle(
                  color: Colors.cyan,
                  fontSize: 15,
                  fontFamily: "Bebas",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
