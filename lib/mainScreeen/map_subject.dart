import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:tuition_app/widgets/subjects_design.dart';
import 'package:tuition_app/widgets/tutor_img.dart';

import '../models/subjects.dart';
import '../models/tutors.dart';
import '../widgets/item_app_bar.dart';
import '../widgets/progress_bar.dart';


class MapSubjectScreen extends StatefulWidget {
  final Tutors tutorsModel;
  MapSubjectScreen({required this.tutorsModel});

  @override
  State<MapSubjectScreen> createState() => _MapSubjectScreenState();
}

class _MapSubjectScreenState extends State<MapSubjectScreen> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: ItemAppBar(tutorUID: widget.tutorsModel?.tutorUID??"",),
      body:CustomScrollView(
        slivers: [
          // SliverPersistentHeader(pinned: true,delegate: TextWidgetHeader(title: "Items of ${widget.subjectsModel!.subjectTitle}")),
          SliverToBoxAdapter(
            child: TutorImg(tutorUID: widget.tutorsModel?.tutorUID??"",),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("tutors")
                .doc(widget.tutorsModel!.tutorUID)
                .collection("subject")
                .orderBy("publishedDate", descending: true)
                .snapshots(),
            builder: (context, snapshot)
            {
              return !snapshot.hasData
                  ? SliverToBoxAdapter(
                child: Center(child: circularProgress(),) ,
              )
                  : SliverAlignedGrid.count(
                crossAxisCount: 1,
                //staggeredTileBuilder: (c) => StaggeredTile.fit(1),
                itemBuilder: (context, index)
                {
                  Subjects model = Subjects.fromJson(
                      snapshot.data!.docs[index].data()! as Map<String, dynamic>
                  );
                  return SubjectsDesignWidget(subjectsModel: model, context: context);
                },
                itemCount: snapshot.data!.docs.length,
              );
            },
          ),
        ],
      ),
    );
  }
}
