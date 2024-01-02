import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:tuition_app/assistantMethods/assistant_methods.dart';
import 'package:tuition_app/models/tutors.dart';
import 'package:tuition_app/widgets/subjects_design.dart';

import '../models/subjects.dart';
import '../splashScreen/splash_screen.dart';
import '../widgets/progress_bar.dart';
import '../widgets/text_widget.dart';


class SubjectsScreen extends StatefulWidget {

  final Tutors? model;
  SubjectsScreen({this.model});

  @override
  State<SubjectsScreen> createState() => _SubjectsScreenState();
}

class _SubjectsScreenState extends State<SubjectsScreen> {
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
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: ()
            {
              clearCartNow(context);

              Navigator.push(context, MaterialPageRoute(builder: (c)=> const MySplashScreen()));
            },
          ),
          title: const Text(
            "TutorGO",
            style: TextStyle(fontSize: 30, fontFamily: "Bebas"),
          ),
          centerTitle: true,
          actions: [
            // IconButton(
            //   icon: const Icon(Icons.shopping_bag, color: Colors.white,),
            //   onPressed: ()
            //   {
            //     //send user to cart screen
            //     //Navigator.push(context,MaterialPageRoute(builder: (c)=> const SubjectUploadScreen()));
            //   },
            // ),
            // const Positioned(
            //   child: Stack(
            //     children: [
            //       Icon(
            //         Icons.brightness_1,
            //         size: 20,
            //         color: Colors.green,
            //       ),
            //       Positioned(
            //         top: 3,
            //         right: 4,
            //         child: Center(
            //           child: Text("0", style: TextStyle(color: Colors.white, fontSize: 12),),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
          ],
        ),
        body:CustomScrollView(
      slivers: [
        SliverPersistentHeader(pinned: true,delegate: TextWidgetHeader(title: widget.model!.tutorName.toString() + " Subjects")),
        StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("tutors")
              .doc(widget.model!.tutorUID)
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
                return SubjectsDesignWidget(
                    subjectsModel: model,
                    context: context
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
