import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:tuition_app/uploadScreen/items_upload_screen.dart';
import 'package:tuition_app/widgets/my_drawer_tutor.dart';
import 'package:tuition_app/widgets/text_widget.dart';

import '../global/global.dart';
import '../models/items.dart';
import '../models/subjects.dart';
import '../widgets/items_design.dart';
import '../widgets/progress_bar.dart';

class ItemsScreen extends StatefulWidget {

  final Subjects model;
  ItemsScreen({required this.model});

  @override
  State<ItemsScreen> createState() => _ItemsScreenState();
}

class _ItemsScreenState extends State<ItemsScreen>
{

  @override
  Widget build(BuildContext context) {
    String userType = sharedPreferences!.getString("usertype")! ;

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
        title: Text(
          sharedPreferences!.getString("name")!,
          style: const TextStyle(fontSize: 30, fontFamily: "Bebas"),
        ),
        centerTitle: true,
        actions: userType == "Tutor"
            ? [
          IconButton(
            icon: const Icon(Icons.library_add, color: Colors.white,),
            onPressed: ()
            {
              Navigator.push(context,MaterialPageRoute(builder: (c)=> ItemsUploadScreen(model: widget.model)));
            },
          ),
        ] : null,
      ),
      drawer: MyDrawerTutor(),
      body: CustomScrollView(
        slivers: [
          SliverPersistentHeader(pinned: true, delegate: TextWidgetHeader(title: "My ${widget.model.subjectTitle}'s Items")),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("tutors")
                .doc(sharedPreferences!.getString("uid"))
                .collection("subject")
                .doc(widget.model!.subjectID)
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
                      context: context);
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
