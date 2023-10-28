import 'package:cloud_firestore/cloud_firestore.dart';

class Subjects
{
  String? subjectID;
  String? tutorUID;
  String? subjectTitle;
  String? subjectInfo;
  Timestamp? publishedDate;
  String? thumbnailUrl;
  String? status;

  Subjects({
    this.subjectID,
    this.tutorUID,
    this.subjectTitle,
    this.subjectInfo,
    this.publishedDate,
    this.thumbnailUrl,
    this.status,
  });

  Subjects.fromJson(Map <String, dynamic> json)
  {
    subjectID = json['subjectID'];
    tutorUID = json['tutorUID'];
    subjectTitle = json['subjectTitle'];
    subjectInfo = json['subjectInfo'];
    publishedDate = json['publishedDate'];
    thumbnailUrl = json['thumbnailUrl'];
    status = json['status'];
  }

  Map<String, dynamic> toJson()
  {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['subjectID'] = subjectID;
    data['tutorUID'] = tutorUID;
    data['menuTitle'] = subjectTitle;
    data['subjectInfo'] = subjectInfo;
    data['publishedDate'] =  publishedDate;
    data['thumbnailUrl'] = thumbnailUrl;
    data['status'] = status;

    return data;
  }
}