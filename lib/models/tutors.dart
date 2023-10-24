class Tutors
{
  String? tutorUID;
  String? tutorName;
  String? tutorAvatarUrl;
  String? tutorEmail;

  Tutors({
    this.tutorUID,
    this.tutorName,
    this.tutorAvatarUrl,
    this.tutorEmail,
});

  Tutors.fromJson(Map<String, dynamic> json)
  {
    tutorUID = json["tutorUID"];
    tutorName = json["tutorName"];
    tutorAvatarUrl = json["tutorAvatarUrl"];
    tutorEmail = json["tutorEmail"];
  }

  Map<String, dynamic> toJson()
  {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["tutorUID"] = this.tutorUID;
    data["tutorName"] = this.tutorName;
    data["tutorAvatarUrl"] = this.tutorAvatarUrl;
    data["tutorEmail"] = this.tutorEmail;
    return data;
  }
}