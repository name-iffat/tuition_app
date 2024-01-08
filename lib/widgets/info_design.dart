import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tuition_app/mainScreeen/itemsScreen.dart';
import 'package:tuition_app/mainScreeen/subjects_screen.dart';
import 'package:tuition_app/models/subjects.dart';
import '../global/global.dart';
import '../models/items.dart';
import '../models/tutors.dart';

class InfoDesignWidget extends StatefulWidget {
  String userType = sharedPreferences!.getString("usertype")!;

  BuildContext? context;

  late Tutors tutorsModel;
  late Subjects subjectsModel;
  late Items itemsModel;


  InfoDesignWidget.tutors({required this.tutorsModel, required this.context});
  InfoDesignWidget.subjects({required this.subjectsModel, required this.context});

  @override
  State<InfoDesignWidget> createState() => _InfoDesignWidgetState();


}

class _InfoDesignWidgetState extends State<InfoDesignWidget>
{
  Future<void> deleteSubject(String subjectID) async {
    try {
      final batch = FirebaseFirestore.instance.batch();

      // Delete main subject document
      batch.delete(FirebaseFirestore.instance.collection("tutors").doc(sharedPreferences!.getString("uid")).collection("subject").doc(subjectID));

      // Delete subject document from main subjects collection (if needed)
      // separate "subjects" collection
      batch.delete(FirebaseFirestore.instance.collection("subjects").doc(subjectID));

      final itemCollection = FirebaseFirestore.instance.collection("tutors").doc(sharedPreferences!.getString("uid")).collection("subject").doc(subjectID);
      // Delete all subcollections and documents
      await deleteAllSubcollectionsAndDocumentsWithRoot(batch, itemCollection);

      await batch.commit();

      Fluttertoast.showToast(msg: "Subject Deleted Successfully.");
    } catch (error) {
      // Handle any potential errors here
      print(error);
      Fluttertoast.showToast(msg: "Error deleting subject: $error");
    }
  }

  Future<void> deleteAllSubcollectionsAndDocumentsWithRoot(batch, DocumentReference subcollectionRef) async {
    final querySnapshot = await subcollectionRef.collection("items").get();

    for (var doc in querySnapshot.docs) {
      await deleteAllSubcollectionsAndDocumentsWithRoot(batch, doc.reference);
    }

    await subcollectionRef.delete();
  }


  @override
  Widget build(BuildContext context) {
    String userType = sharedPreferences!.getString("usertype")!;
     dynamic model;

    if (userType == "Parent") {
      model = widget.tutorsModel;
    } else if (userType == "Tutor") {
      model = widget.subjectsModel;
    }


    return InkWell(
      onTap: ()
      { userType == "Parent"
      ? Navigator.push(context, MaterialPageRoute(builder: (c)=> SubjectsScreen(model: model)))
      : Navigator.push(context, MaterialPageRoute(builder: (c)=> ItemsScreen(model: model)));
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
                          //subjecttitle
                          Text(
                            widget.subjectsModel.subjectTitle!,
                            style: const TextStyle(
                              color: Colors.blueAccent,
                              fontSize: 16,
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.bold,

                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.delete_sweep,
                              color: Colors.pinkAccent,
                            ),
                            onPressed: ()
                            async {
                              final confirmDelete = await showDialog<bool>(
                              context: context,
                            builder: (context) => AlertDialog(
                            title: const Text("Confirm Deletion"),
                            content: const Text('Are you sure you want to delete this subject?'),
                            actions: [
                            TextButton(
                            onPressed: () => Navigator.pop(context, false), // Cancel
                            child: const Text('Cancel'),
                            ),
                            TextButton(
                            onPressed: () => Navigator.pop(context, true), // Confirm
                            child: const Text('Delete'),
                            style: TextButton.styleFrom(
                            foregroundColor: Colors.red, // Highlight the delete action
                            ),
                            ),
                            ]
                            )
                              );
                              if(confirmDelete!)
                              {
                              //delete subject
                              deleteSubject(widget.subjectsModel.subjectID!);
                              }

                            },
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            widget.subjectsModel!.subjectInfo!,
                            style: const TextStyle(
                              color: Colors.black54,
                              fontSize: 12,
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
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
