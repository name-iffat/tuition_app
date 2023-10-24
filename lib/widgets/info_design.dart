import 'package:flutter/material.dart';
import '../models/tutors.dart';

class InfoDesignWidget extends StatefulWidget {
  Tutors model;
  BuildContext? context;

  InfoDesignWidget({required this.model, required this.context});



  @override
  State<InfoDesignWidget> createState() => _InfoDesignWidgetState();
}

class _InfoDesignWidgetState extends State<InfoDesignWidget> {
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
              Image.network(widget.model.tutorAvatarUrl!,
                height: 220.0,
                fit: BoxFit.cover,
              ),
              SizedBox(height: 10.0,),
              Text(
                widget.model!.tutorName!,
                style: const TextStyle(
                  color: Colors.cyan,
                  fontSize: 20,
                  fontFamily: "Bebas",
                ),
              ),
              Text(
                widget.model!.tutorEmail!,
                style: TextStyle(
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
