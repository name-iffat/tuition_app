class Tutors
{
  String? tutorUID;
  String? tutorName;
  String? tutorAvatarUrl;
  String? tutorEmail;
  double? lat;
  double? lng;
  double? rating;

  Tutors({
    this.tutorUID,
    this.tutorName,
    this.tutorAvatarUrl,
    this.tutorEmail,
    this.lat ,
    this.lng,
    this.rating,
});

  Tutors.fromJson(Map<String, dynamic> json)
  {
    tutorUID = json["tutorUID"];
    tutorName = json["tutorName"];
    tutorAvatarUrl = json["tutorAvatarUrl"];
    tutorEmail = json["tutorEmail"];
    lat = json["lat"];
    lng = json["lng"];
    rating = json["rating"];
  }

  Map<String, dynamic> toJson()
  {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["tutorUID"] = this.tutorUID;
    data["tutorName"] = this.tutorName;
    data["tutorAvatarUrl"] = this.tutorAvatarUrl;
    data["tutorEmail"] = this.tutorEmail;
    data["lat"] = this.lat;
    data["lng"] = this.lng;
    data["rating"] = this.rating;
    return data;
  }
}