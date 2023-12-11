import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tuition_app/mainScreeen/itemsScreen.dart';
import 'package:tuition_app/mainScreeen/subjects_screen.dart';
import 'package:tuition_app/models/subjects.dart';
import '../global/global.dart';
import '../models/tutors.dart';

class InfoDesignWidget extends StatefulWidget {
  String userType = sharedPreferences!.getString("usertype")!;

  BuildContext? context;

  late Tutors tutorsModel;
  late Subjects subjectsModel;


  InfoDesignWidget.tutors({required this.tutorsModel, required this.context});
  InfoDesignWidget.subjects({required this.subjectsModel, required this.context});

  @override
  State<InfoDesignWidget> createState() => _InfoDesignWidgetState();


}

class _InfoDesignWidgetState extends State<InfoDesignWidget>
{
  deleteSubject(String subjectID)
  {
    FirebaseFirestore.instance.collection("tutors")
        .doc(sharedPreferences!.getString("uid"))
        .collection("subject")
        .doc(subjectID)
        .delete();

    Fluttertoast.showToast(msg: "Subject Deleted Successfully.");
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
                style: TextStyle(
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
