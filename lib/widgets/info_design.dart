import 'package:flutter/material.dart';
import 'package:tuition_app/mainScreeen/itemsScreen.dart';
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

class _InfoDesignWidgetState extends State<InfoDesignWidget> {


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
      {
        Navigator.push(context, MaterialPageRoute(builder: (c)=> ItemsScreen(model: model)));
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
              Image.network(
                userType == "Parent" ? model.tutorAvatarUrl! : model.thumbnailUrl! ,
                height: 220.0,
                fit: BoxFit.cover,
              ),
              SizedBox(height: 10.0,),
              Text(
                userType == "Parent" ? model!.tutorName! : model!.subjectTitle!,
                style: const TextStyle(
                  color: Colors.cyan,
                  fontSize: 20,
                  fontFamily: "Bebas",
                ),
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
