import 'package:flutter/material.dart';
import 'package:tuition_app/assistantMethods/shared_prefs.dart';
import 'package:tuition_app/mainScreeen/items_screen_parent.dart';
import 'package:tuition_app/models/subjects.dart';
import '../global/global.dart';

class SubjectsDesignWidget extends StatefulWidget {
  String userType = sharedPreferences!.getString("usertype")!;

  BuildContext? context;

   Subjects subjectsModel;

  SubjectsDesignWidget({required this.subjectsModel, required this.context});

  @override
  State<SubjectsDesignWidget> createState() => _SubjectsDesignWidgetState();


}

class _SubjectsDesignWidgetState extends State<SubjectsDesignWidget> {


  @override
  Widget build(BuildContext context) {
    distance = getDistanceFromSharedPreference(widget.subjectsModel.tutorUID!)/1000;
    duration = getDurationFromSharedPreference(widget.subjectsModel.tutorUID!)/60;

    return InkWell(
      onTap: ()
      {
        Navigator.push(context, MaterialPageRoute(builder: (c)=> ItemsScreenParent(subjectsModel: widget.subjectsModel)));
      },
      splashColor: Colors.cyan,
      child: Card(
        clipBehavior: Clip.antiAlias,
        elevation: 4.0,
        margin: const EdgeInsets.only(left:20.0,right:20.0,top: 10.0,bottom: 10.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),

        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Container(
            height: MediaQuery.of(context).size.width * 0.5,
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
                    image:widget.subjectsModel.thumbnailUrl! ,
                    height: MediaQuery.of(context).size.width * 0.3,
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
                                  widget.subjectsModel.subjectTitle!,
                                  style: const TextStyle(
                                    color: Colors.blueAccent,
                                    fontSize: 16,
                                    fontFamily: "Poppins",
                                    fontWeight: FontWeight.bold,

                                  ),
                                ),
                                const Row(
                                  children: [
                                    Icon(
                                      Icons.star_rate,
                                      color: Colors.amber,
                                      size: 15,
                                    ),
                                    Text(
                                      "4.5",
                                      style: TextStyle(
                                        color: Colors.amber,
                                        fontSize: 15,
                                        fontFamily: "Poppins",
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Text(
                              widget.subjectsModel!.subjectInfo!,
                              style: const TextStyle(
                                color: Colors.black54,
                                fontSize: 12,
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${distance.toStringAsFixed(2)}kms \u2022 ${duration.toStringAsFixed(2)} mins' ,
                              style: const TextStyle(
                                color: Colors.black54,
                                fontSize: 12,
                                fontFamily: "Poppins",
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
    );
  }
}
