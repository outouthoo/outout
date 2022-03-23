class HomeResponse {
  String status;
  String errorcode;
  String msg;
  Data data;

  HomeResponse({this.status, this.errorcode, this.msg, this.data});

  HomeResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    errorcode = json['errorcode'];
    msg = json['msg'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['errorcode'] = this.errorcode;
    data['msg'] = this.msg;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  String id;
  String firstName;
  String lastName;
  String profileImage;
  String dob;
  String city;
  String friends;
  String followers;
  String unreadNotifications;
  String readNotifications;
  String points;
  String is_verified;
  String biography;
  String website;
  double overallrating;

  Data(
      {this.id,
        this.firstName,
        this.lastName,
        this.profileImage,
        this.dob,
        this.city,
        this.friends,
        this.followers,
        this.is_verified,
        this.unreadNotifications,
        this.points,
        this.website,
        this.overallrating,
        this.readNotifications});
  /*"website": "",
  "biography": "",*/
  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    profileImage = json['profile_image'];
    dob = json['dob'];
    city = json['city'];
    friends = json['friends'];
    followers = json['followers'];
    is_verified = json['is_verified'];
    unreadNotifications = json['unreadNotifications'];
    points = json['points'];
    website = json['website'];
    biography = json['biography'];
    overallrating = json['overallrating'];
    readNotifications = json['readNotifications'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['profile_image'] = this.profileImage;
    data['dob'] = this.dob;
    data['city'] = this.city;
    data['friends'] = this.friends;
    data['is_verified'] = this.is_verified;
    data['followers'] = this.followers;
    data['unreadNotifications'] = this.unreadNotifications;
    data['points'] = this.points;
    data['website'] = this.website;
    data['biography'] = this.biography;
    data['readNotifications'] = this.readNotifications;
    data['overallrating'] = this.overallrating;
    return data;
  }
}