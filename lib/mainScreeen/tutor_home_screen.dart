import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:tuition_app/assistantMethods/get_current_location.dart';
import 'package:tuition_app/global/global.dart';
import 'package:tuition_app/models/subjects.dart';
import 'package:tuition_app/widgets/info_design.dart';
import 'package:tuition_app/widgets/progress_bar.dart';
import 'package:tuition_app/widgets/text_widget.dart';

class TutorHomeScreen extends StatefulWidget {
  const TutorHomeScreen({super.key});

  @override
  State<TutorHomeScreen> createState() => _TutorHomeScreenState();
}

class _TutorHomeScreenState extends State<TutorHomeScreen> {

  @override
  void initState() {
    super.initState();

    UserLocation uLocation = UserLocation();
    uLocation.getCurrentLocation();
    getPerBookTransportAmount();
    getTransportPreviousEarnings();
  }
  
  getTransportPreviousEarnings()
  {
    FirebaseFirestore.instance
        .collection("tutors")
        .doc(sharedPreferences!.getString("uid"))
        .get().then((snap)
    {
      previousTransportEarnings = snap.data()!["earnings"].toString();
    });
  }

  getPerBookTransportAmount()
  {
    FirebaseFirestore.instance
        .collection("perTransport")
        .doc("amount5km")
        .get().then((snap)
    {
      perBookTransportAmount= snap.data()!["amount"].toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverPersistentHeader(pinned: true,delegate: TextWidgetHeader(title: "My Subjects")),
        StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("tutors")
              .doc(sharedPreferences!.getString("uid"))
              .collection("subject")
              .orderBy("publishedDate", descending: true)
              .snapshots(),
          builder: (context, snapshot)
          {
            return !snapshot.hasData
                ? SliverToBoxAdapter(
                  child: Center(child: circularProgress(),) ,
            )
                : SliverStaggeredGrid.countBuilder(
                    crossAxisCount: 1,
                    staggeredTileBuilder: (c) => StaggeredTile.fit(1),
                    itemBuilder: (context, index)
                    {
                      Subjects model = Subjects.fromJson(
                        snapshot.data!.docs[index].data()! as Map<String, dynamic>
                      );
                      return InfoDesignWidget.subjects(
                          subjectsModel: model,
                          context: context
                      );
                    },
                    itemCount: snapshot.data!.docs.length,
                  );
          },
        ),
      ],
    );
  }
}
