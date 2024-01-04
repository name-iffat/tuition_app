import 'package:flutter/material.dart';
import 'package:tuition_app/mainScreeen/item_detail_screen.dart';
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
        Navigator.push(context, MaterialPageRoute(builder: (c)=> ItemDetailScreen(model: widget.itemsModel,)));
      },
      splashColor: Colors.amber,
      child:
      Card(
        clipBehavior: Clip.antiAlias,
        elevation: 4.0,
        margin: const EdgeInsets.only(left:20.0,right:20.0,top: 10.0,bottom: 10.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),

        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Container(
            height: MediaQuery.of(context).size.width * 0.4,
            width: MediaQuery.of(context).size.width * 0.5,
            child: Column(
              children: [
                // Divider(
                //   height: 4,
                //   thickness: 3,
                //   color: Colors.grey[300],
                // ),
                ClipRRect(
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(10.0),topRight: Radius.circular(10.0)),

                  child: FadeInImage.assetNetwork(
                    image:widget.itemsModel!.thumbnailUrl! ,
                    height: MediaQuery.of(context).size.width * 0.25,
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.cover,
                    placeholder: "images/placeholder.jpg",
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left:10.0,right: 10.0),
                  child:
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10.0,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [

                          Text(
                            widget.itemsModel!.title!,
                            style: const TextStyle(
                              color: Colors.blueAccent,
                              fontSize: 14,
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.bold,

                            ),
                          ),
                        ],
                      ),
                      Text(
                        widget.itemsModel!.shortInfo!,
                        style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 10,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                ),

              ],
            ),
          ),
        ),
      ),
      // Padding(
      //   padding: const EdgeInsets.all(5.0),
      //   child: Container(
      //     height: 285,
      //     width: MediaQuery.of(context).size.width,
      //     child: Column(
      //       children: [
      //         Divider(
      //           height: 4,
      //           thickness: 3,
      //           color: Colors.grey[300],
      //         ),
      //         const SizedBox(height: 1,),
      //         Text(
      //           widget.itemsModel!.title!,
      //           style: const TextStyle(
      //             color: Colors.cyan,
      //             fontSize: 25,
      //             fontFamily: "Bebas",
      //           ),
      //         ),
      //         const SizedBox(height: 1,),
      //         Image.network(
      //           widget.itemsModel!.thumbnailUrl! ,
      //           height: 220.0,
      //           fit: BoxFit.cover,
      //         ),
      //         SizedBox(height: 10.0,),
      //         Text(
      //           widget.itemsModel!.shortInfo!,
      //           style: const TextStyle(
      //             color: Colors.cyan,
      //             fontSize: 15,
      //             fontFamily: "Bebas",
      //           ),
      //         ),
      //       ],
      //     ),
      //   ),
      // ),
    );
  }
}
