class GetBusinessListResponse {
  String status;
  String errorcode;
  String msg;
  List<BusinessAccount> data;

  GetBusinessListResponse({this.status, this.errorcode, this.msg, this.data});

  GetBusinessListResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    errorcode = json['errorcode'];
    msg = json['msg'];
    if (json['data'] != null) {
      data = new List<BusinessAccount>();
      json['data'].forEach((v) {
        data.add(new BusinessAccount.fromJson(v));
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

class BusinessAccount {
  String id;
  String firstName;
  String lastName;
  String dob;
  String gender;
  String phoneNumber;
  String countryCode;
  String email;
  String username;
  String password;
  String latitude;
  String longitude;
  String city;
  String profileImage;
  String accountType;
  String website;
  String catid;
  String isVip;
  String termsAndConditions;
  String isVerified;
  String otp;
  String createdAt;
  String updatedAt;
  String isDelete;

  BusinessAccount(
      {this.id,
      this.firstName,
      this.lastName,
      this.dob,
      this.gender,
      this.phoneNumber,
      this.countryCode,
      this.email,
      this.username,
      this.password,
      this.latitude,
      this.longitude,
      this.city,
      this.profileImage,
      this.accountType,
      this.website,
      this.catid,
      this.isVip,
      this.termsAndConditions,
      this.isVerified,
      this.otp,
      this.createdAt,
      this.updatedAt,
      this.isDelete});

  BusinessAccount.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    dob = json['dob'];
    gender = json['gender'];
    phoneNumber = json['phone_number'];
    countryCode = json['country_code'];
    email = json['email'];
    username = json['username'];
    password = json['password'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    city = json['city'];
    profileImage = json['profile_image'];
    accountType = json['account_type'];
    website = json['website'];
    catid = json['catid'];
    isVip = json['is_vip'];
    termsAndConditions = json['terms_and_conditions'];
    isVerified = json['is_verified'];
    otp = json['otp'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    isDelete = json['is_delete'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['dob'] = this.dob;
    data['gender'] = this.gender;
    data['phone_number'] = this.phoneNumber;
    data['country_code'] = this.countryCode;
    data['email'] = this.email;
    data['username'] = this.username;
    data['password'] = this.password;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['city'] = this.city;
    data['profile_image'] = this.profileImage;
    data['account_type'] = this.accountType;
    data['website'] = this.website;
    data['catid'] = this.catid;
    data['is_vip'] = this.isVip;
    data['terms_and_conditions'] = this.termsAndConditions;
    data['is_verified'] = this.isVerified;
    data['otp'] = this.otp;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['is_delete'] = this.isDelete;
    return data;
  }
}
