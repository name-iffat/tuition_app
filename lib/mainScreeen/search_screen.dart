import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tuition_app/widgets/subjects_design.dart';
import '../models/subjects.dart';
class SearchScreen extends StatefulWidget {

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}


class _SearchScreenState extends State<SearchScreen>
{
  Future<QuerySnapshot>? tutorsDocumentsList;
  String tutorNameText = "";

  initSearchingTutor(String textEntered)
  {
    tutorsDocumentsList = FirebaseFirestore.instance
        .collection("subjects")
        .where("subjectTitle", isGreaterThanOrEqualTo: textEntered)
        .get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
        title: TextField(
          onChanged: (textEntered)
          {
            setState(() {
              tutorNameText = textEntered;
            });
            //init search
            initSearchingTutor(textEntered);
          },
          decoration: InputDecoration(
            hintText: "Search Tutors...",
            hintStyle: const TextStyle(color: Colors.white),
            border: InputBorder.none,
            suffixIcon: IconButton(
              icon: const Icon(Icons.search),
              color: Colors.white,
              onPressed: ()
              {
                initSearchingTutor(tutorNameText);
              },
            ),
          ),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ),
      body: FutureBuilder<QuerySnapshot>(
        future:   tutorsDocumentsList,
        builder: (context, snapshot)
        {
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index)
                  {
                    Subjects sModel = Subjects.fromJson(
                        snapshot.data!.docs[index].data()! as Map<String ,dynamic>
                    );

                    return SubjectsDesignWidget(subjectsModel: sModel, context: context);
                  },
              )
              : const Center(child: Text("No Record Found"),);
        },
      ),
    );
  }
}
