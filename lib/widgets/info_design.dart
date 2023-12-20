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
      splashColor: Colors.amber,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Container(
          height: 300,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Divider(
                height: 4,
                thickness: 3,
                color: Colors.grey[300],
              ),
              Image.network(
                userType == "Parent" ? model.tutorAvatarUrl! : model.thumbnailUrl! ,
                height: 220.0,
                fit: BoxFit.cover,
              ),
              SizedBox(height: 10.0,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    userType == "Parent" ? model!.tutorName! : model!.subjectTitle!,
                    style: const TextStyle(
                      color: Colors.cyan,
                      fontSize: 20,
                      fontFamily: "Bebas",
                    ),
                  ),
                  userType=="Tutor"
                    ? IconButton(
                    icon: const Icon(
                      Icons.delete_sweep,
                      color: Colors.pinkAccent,
                    ),
                      onPressed: ()
                  {
                    //delete subject
                    deleteSubject(widget.subjectsModel!.subjectID!);
                  },
                    )
                      : const Text("")
                ],
              ),
              Text(
                userType == "Parent" ? model!.tutorEmail! : model!.subjectInfo!,
                style: const TextStyle(
                  color: Colors.cyan,
                  fontSize: 12,
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
