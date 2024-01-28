class Parents
{
  String? parentUID;
  String? parentName;
  String? parentAvatarUrl;
  String? parentEmail;
  double? lat;
  double? lng;

  Parents({
    this.parentUID,
    this.parentName,
    this.parentAvatarUrl,
    this.parentEmail,
    this.lat ,
    this.lng,
  });

  Parents.fromJson(Map<String, dynamic> json)
  {
    parentUID = json["parentUID"];
    parentName = json["parentName"];
    parentAvatarUrl = json["parentAvatarUrl"];
    parentEmail = json["parentEmail"];
    lat = json["lat"];
    lng = json["lng"];
  }

  Map<String, dynamic> toJson()
  {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["parentUID"] = this.parentUID;
    data["parentName"] = this.parentName;
    data["parentAvatarUrl"] = this.parentAvatarUrl;
    data["parentEmail"] = this.parentEmail;
    data["lat"] = this.lat;
    data["lng"] = this.lng;
    return data;
  }
}