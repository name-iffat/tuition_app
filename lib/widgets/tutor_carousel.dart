// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:tuition_app/models/tutors.dart';
//
// import '../assistantMethods/shared_prefs.dart';
// import 'carousel_card.dart';
//
//
//
//
//
//   class TutorCarousel extends StatefulWidget {
//     late Tutors tutorsModel;
//
//      TutorCarousel();
//
//     @override
//     State<TutorCarousel> createState() => _TutorCarouselState();
//   }
//
//   class _TutorCarouselState extends State<TutorCarousel> {
//     int pageIndex = 0;
//
//
//     final Stream<QuerySnapshot> tutorStream = FirebaseFirestore.instance
//         .collection('tutors')
//         .orderBy('name') // Optional: Order tutors by name
//         .snapshots();
//
//     calculateDistanceAndTime() async
//     {
//
//             List<Widget> carouselItems = []; // Initialize as empty
//
//             final tutorsCollection = FirebaseFirestore.instance.collection("tutors");
//             for (var tutorDoc in await tutorsCollection.get().then((snapshot) => snapshot.docs))
//               {
//               // Calculate distance and duration based on your logic
//                 final tutorID = tutorDoc.data()["tutorUID"]  ;
//               final distance = getDistanceFromSharedPreference(tutorDoc.data()["tutorUID"])/1000;
//               final duration = getDurationFromSharedPreference(tutorDoc.data()["tutorUID"])/60;
//
//               // Build and add the carousel widget using tutor data and calculated values
//               carouselItems.add(carouselCard(
//                 tutorID,
//                 distance,
//                 duration,
//                 tutorDoc.data()["tutorName"],
//                 tutorDoc.data()["tutorAvatarUrl"],
//
//               ));
//             }
//
//             return carouselItems;
//
//     }
//
//
//     @override
//     Widget build(BuildContext context) {
//       return
//         StreamBuilder(
//             stream: tutorStream,
//             builder: (context, snapshot) {
//               if (!snapshot.hasData) {
//                 return const Center(
//                   child: CircularProgressIndicator(),
//                 );
//               }
//               else {
//                 final tutors = (snapshot.data! as QuerySnapshot).docs.map((
//                     doc) => doc.data()).toList();
//                 List<Widget> carouselItems = [];
//                 for (var tutor in tutors) {
//                   final tutorData = tutor as Map<String, dynamic>;
//                   final tutorID = tutorData["tutorUID"];
//                   final distance = getDistanceFromSharedPreference(tutorID) /
//                       1000;
//                   final duration = getDurationFromSharedPreference(tutorID) /
//                       60;
//
//                   carouselItems.add(carouselCard(
//                     tutorID,
//                     distance,
//                     duration,
//                     tutorData["tutorName"],
//                     tutorData["tutorAvatarUrl"],
//                   ));
//                 }
//                 return CarouselSlider.builder(
//                   options: CarouselOptions(
//                 height: 100,
//                 viewportFraction: 0.6,
//                 initialPage: 0,
//                 enableInfiniteScroll: false,
//                 scrollDirection: Axis.horizontal,
//                 onPageChanged:
//                 (int index, CarouselPageChangedReason reason) async {
//                 setState(() {
//                 pageIndex = index;
//                 });
//                 },
//                   ),
//                   , itemCount: null, itemBuilder: (BuildContext context, int index, int realIndex) {  },
//                 );
//               }
//             }
//         );
//       }
//     }
//
//
//
//
//
//
//
