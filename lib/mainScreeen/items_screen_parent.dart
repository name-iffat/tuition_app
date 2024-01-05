import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:tuition_app/widgets/items_design.dart';
import 'package:tuition_app/widgets/tutor_img.dart';

import '../models/items.dart';
import '../models/subjects.dart';
import '../widgets/item_app_bar.dart';
import '../widgets/progress_bar.dart';


class ItemsScreenParent extends StatefulWidget {
  final Subjects subjectsModel;
  ItemsScreenParent({required this.subjectsModel});

  @override
  State<ItemsScreenParent> createState() => _ItemsScreenParentState();
}

class _ItemsScreenParentState extends State<ItemsScreenParent> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: ItemAppBar(tutorUID: widget.subjectsModel?.tutorUID??"",),
      body:CustomScrollView(
        slivers: [
          // SliverPersistentHeader(pinned: true,delegate: TextWidgetHeader(title: "Items of ${widget.subjectsModel!.subjectTitle}")),
          SliverToBoxAdapter(
            child: TutorImg(tutorUID: widget.subjectsModel?.tutorUID??"",),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("tutors")
                .doc(widget.subjectsModel!.tutorUID)
                .collection("subject")
                .doc(widget.subjectsModel!.subjectID)
                .collection("items")
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
                  Items model = Items.fromJson(
                      snapshot.data!.docs[index].data()! as Map<String, dynamic>
                  );
                  return ItemsDesignWidget(
                      itemsModel: model,
                      context: context,
                  );
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
