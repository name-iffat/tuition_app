import 'package:flutter/material.dart';
import 'package:tuition_app/assistantMethods/shared_prefs.dart';
import 'package:tuition_app/mainScreeen/map_subject.dart';
import '../global/global.dart';
import '../models/tutors.dart';

class CarouselCard extends StatefulWidget {
  late Tutors tutorsModel;
  BuildContext? context;


  CarouselCard({required this.tutorsModel, required this.context});




  @override
  State<CarouselCard> createState() => _CarouselCardState();
}

class _CarouselCardState extends State<CarouselCard> {
  @override
  Widget build(BuildContext context) {
    distance = getDistanceFromSharedPreference(widget.tutorsModel.tutorUID!)/1000;
    duration = getDurationFromSharedPreference(widget.tutorsModel.tutorUID!)/60;

    return GestureDetector(
      onTap: ()
      {
        Navigator.push(
          context, MaterialPageRoute(builder: (c)=> MapSubjectScreen(tutorsModel: widget.tutorsModel))
        );
      },
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(widget.tutorsModel!.tutorAvatarUrl!),
                radius: 20,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.tutorsModel!.tutorName!,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${distance.toStringAsFixed(2)}kms, ${duration.toStringAsFixed(2)} mins',
                      style: const TextStyle(color: Colors.blueAccent, fontFamily: "Poppins",fontSize: 13),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


