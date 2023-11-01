import 'package:cloud_firestore/cloud_firestore.dart';

class Items
{
  String? itemID;
  String? subjectID;
  String? tutorUID;
  String? tutorName;
  String? shortInfo;
  String? longDescription;
  int? price ;
  String? title;
  Timestamp? publishedDate;
  String? status;
  String? thumbnailUrl;

  Items({
    this.itemID,
    this.subjectID,
    this.tutorUID,
    this.tutorName,
    this.shortInfo,
    this.longDescription,
    this.price,
    this.title,
    this.publishedDate,
    this.status,
    this.thumbnailUrl,
  });

  Items.fromJson(Map<String, dynamic> json)
  {
    itemID = json['itemID'];
    subjectID = json['subjectID'];
    tutorUID = json['tutorUID'];
    tutorName = json['tutorName'];
    shortInfo = json['shortInfo'];
    longDescription = json['longDescription'];
    price = json['price'];
    title = json['title'];
    publishedDate = json['publishedDate'];
    status = json['status'];
    thumbnailUrl = json['thumbnailUrl'];
  }

  Map<String, dynamic> toJson()
  {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['itemID'] = itemID;
    data['subjectID'] = subjectID;
    data['tutorUID'] = tutorUID;
    data['tutorName'] = tutorName;
    data['shortInfo'] = shortInfo;
    data['longDescription'] = longDescription;
    data['price'] = price;
    data['title'] = title;
    data['publishedDate'] = publishedDate;
    data['status'] = status;
    data['thumbnailUrl'] = thumbnailUrl;
    return data;
  }
}