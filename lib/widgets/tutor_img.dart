import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../assistantMethods/shared_prefs.dart';
import '../global/global.dart';

class TutorImg extends StatefulWidget {
  final String? tutorUID;

  TutorImg({this.tutorUID});

  @override
  State<TutorImg> createState() => _TutorImgState();
}

class _TutorImgState extends State<TutorImg> {
  String? tutorAvatarUrl; // State variable for the fetched image URL
  String? tutorName;
  String? phone;
  String? email;


  String skeletonImg = "https://cdn.discordapp.com/attachments/1186076047872110712/1192522621678534716/image.png?ex=65a9623d&is=6596ed3d&hm=ed7c4b2dcda7bc3cc27f342fe91fbfb3685d475a16820e3425ee486e2aa211f8&";

  String rating = "";

  @override
  initState() {
    super.initState();
    _fetchTutorData();
  }



  _fetchTutorData() {
    FirebaseFirestore.instance.collection('tutors').doc(widget.tutorUID).get().then((snap)
    {
      tutorAvatarUrl = snap.data()!["tutorAvatarUrl"].toString();
      tutorName = snap.data()!["tutorName"].toString();
      phone = snap.data()!["phone"].toString();
      email = snap.data()!["tutorEmail"].toString();
      rating = snap.data()!["rating"].toStringAsFixed(2);
      setState(() {
        tutorAvatarUrl = tutorAvatarUrl;
        tutorName = tutorName;
        phone = phone;
        email = email;
        rating = rating;
      });
    });
  }

Widget _buildTextIcon(IconData icon,Color color, String text) {
  return  Row(
      children: [
        Icon(icon, color: color, size: 25,),
        Text(text, style: const TextStyle(fontSize: 16, fontFamily: "Poppins")),
      ],
    );

}


@override
  Widget build(BuildContext context) {
  distance = getDistanceFromSharedPreference(widget.tutorUID!)/1000;
  duration = getDurationFromSharedPreference(widget.tutorUID!)/60;

  return Column(
      children: [
        Container(
          height: MediaQuery.of(context).size.width * 0.7,
          margin: const EdgeInsets.only(top: 10),
          child: Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("images/backdrop.png"),
                    fit: BoxFit.cover,
                  ),
                  color: Colors.cyan,
                ),
              ),
              Column(
              children:[
                Expanded(
                  flex: 1,
                  child: Container(),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    margin: const EdgeInsets.only(top: 50),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(50),
                        topRight: Radius.circular(50),
                      ),
                      color: Colors.white,
                    ),
                  ),
                ),
              ]
            ),
              Align(
                alignment: Alignment.center,
                child: Container(
                  height: MediaQuery.of(context).size.width * 0.5,
                  width: MediaQuery.of(context).size.width * 0.5,
                  margin: const EdgeInsets.only(top: 50),
                  decoration: BoxDecoration(
                  shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(-1, 7), // changes position of shadow
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    radius: 70,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(90),
                        child: FadeInImage.assetNetwork(
              image: tutorAvatarUrl ?? skeletonImg, // Use placeholder if image loading fails
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover,
              placeholder: "images/placeholder.jpg",
            ),
                      ),
                    ),
                ),
              ),
        ],
          ),
        ),
        Column(
          children: [
            Text(
              tutorName ?? "Tutor",
              style: const TextStyle(fontSize: 30, fontFamily: "Bebas"),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildTextIcon(Icons.email_outlined, Colors.blueAccent, email ?? ""),
                _buildTextIcon(Icons.phone_outlined, Colors.blueAccent, phone ?? ""),
              ],
            ),
            const SizedBox(height: 5,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildTextIcon(Icons.location_on_outlined, Colors.cyan, "${distance.toStringAsFixed(2)}kms"),
                const Text("|"),
                _buildTextIcon(Icons.star_outline, Colors.amber, rating),
                const Text("|"),
                _buildTextIcon(Icons.access_time, Colors.cyan, "${duration.toStringAsFixed(2)}mins"),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
