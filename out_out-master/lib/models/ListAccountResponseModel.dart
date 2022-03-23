class ListAccountResponseModel {
  String status;
  String errorcode;
  String msg;
  List<ListAccountItem> data;

  ListAccountResponseModel({this.status, this.errorcode, this.msg, this.data});

  ListAccountResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    errorcode = json['errorcode'];
    msg = json['msg'];
    if (json['data'] != null) {
      data = <ListAccountItem>[];
      json['data'].forEach((v) {
        data.add(new ListAccountItem.fromJson(v));
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

class ListAccountItem {
  String userId;
  String fullName;
  String dob;
  String gender;
  String phoneNumber;
  String email;
  String username;
  String city;
  String profileImage;
  String accountType;
  String isVip;

  ListAccountItem(
      {this.userId,
        this.fullName,
        this.dob,
        this.gender,
        this.phoneNumber,
        this.email,
        this.username,
        this.city,
        this.profileImage,
        this.accountType,
        this.isVip});

  ListAccountItem.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    fullName = json['full_name'];
    dob = json['dob'];
    gender = json['gender'];
    phoneNumber = json['phone_number'];
    email = json['email'];
    username = json['username'];
    city = json['city'];
    profileImage = json['profile_image'];
    accountType = json['account_type'];
    isVip = json['is_vip'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['full_name'] = this.fullName;
    data['dob'] = this.dob;
    data['gender'] = this.gender;
    data['phone_number'] = this.phoneNumber;
    data['email'] = this.email;
    data['username'] = this.username;
    data['city'] = this.city;
    data['profile_image'] = this.profileImage;
    data['account_type'] = this.accountType;
    data['is_vip'] = this.isVip;
    return data;
  }
}