import 'package:flutter/material.dart';
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

    return InkWell(
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
                widget.subjectsModel.thumbnailUrl! ,
                height: 220.0,
                fit: BoxFit.cover,
              ),
              SizedBox(height: 10.0,),
              Text(
                widget.subjectsModel!.subjectTitle!,
                style: const TextStyle(
                  color: Colors.cyan,
                  fontSize: 20,
                  fontFamily: "Bebas",
                ),
              ),
              Text(
                widget.subjectsModel!.subjectInfo!,
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
