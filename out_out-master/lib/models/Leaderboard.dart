class Leaderboard {
  String status;
  String errorcode;
  String msg;
  List<Data> data;

  Leaderboard({this.status, this.errorcode, this.msg, this.data});

  Leaderboard.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    errorcode = json['errorcode'];
    msg = json['msg'];
    if (json['data'] != null) {
      data = new List<Data>();
      json['data'].forEach((v) {
        data.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['errorcode'] = this.errorcode;
    data['msg'] = this.msg;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String id;
  String firstName;
  String lastName;
  String points;
  String email;
  String profileimage;

  Data({this.id, this.firstName, this.lastName, this.points, this.email, this.profileimage});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    points = json['points'];
    email = json['email'];
    profileimage = json['profile_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['points'] = this.points;
    data['email'] = this.email;
    data['profile_image'] = this.profileimage;
    return data;
  }
}
