class GetFriends {
  String status;
  String errorcode;
  String msg;
  Data data;

  GetFriends({this.status, this.errorcode, this.msg, this.data});

  GetFriends.fromJson(Map<String, dynamic> json) {
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
  List<Feeddata> feeddata;

  Data({this.feeddata});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['feeddata'] != null) {
      feeddata = new List<Feeddata>();
      json['feeddata'].forEach((v) {
        feeddata.add(new Feeddata.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.feeddata != null) {
      data['feeddata'] = this.feeddata.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Feeddata {
  String userid;
  String fullname;
  String city;
  String latitude;
  String longitude;
  String story;
  String profileImage;

  Feeddata({
    this.userid,
    this.fullname,
    this.city,
    this.latitude,
    this.longitude,
    this.story,
    this.profileImage,
  });

  Feeddata.fromJson(Map<String, dynamic> json) {
    userid = json['userid'];
    fullname = json['fullname'];
    city = json['city'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    story = json['story'];
    profileImage = json['profile_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userid'] = this.userid;
    data['fullname'] = this.fullname;
    data['city'] = this.city;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['story'] = this.story;
    data['profile_image'] = this.profileImage;
    return data;
  }
}
