class ListShoutoutModel {
  String _status;
  String _errorcode;
  String _msg;
  List<Data> _data;

  ListShoutoutModel(
      {String status, String errorcode, String msg, List<Data> data}) {
    this._status = status;
    this._errorcode = errorcode;
    this._msg = msg;
    this._data = data;
  }

  String get status => _status;
  set status(String status) => _status = status;
  String get errorcode => _errorcode;
  set errorcode(String errorcode) => _errorcode = errorcode;
  String get msg => _msg;
  set msg(String msg) => _msg = msg;
  List<Data> get data => _data;
  set data(List<Data> data) => _data = data;

  ListShoutoutModel.fromJson(Map<String, dynamic> json) {
    _status = json['status'];
    _errorcode = json['errorcode'];
    _msg = json['msg'];
    if (json['data'] != null) {
      _data = new List<Data>();
      json['data'].forEach((v) {
        _data.add(new Data.fromJson(v));
      });
    }
  }
}

class Data {
  String _id;
  String _firstName;
  String _lastName;
  String _dob;
  String _gender;
  String _phoneNumber;
  String _email;
  String _username;
  String _password;
  String _latitude;
  String _longitude;
  String _city;
  String _profileImage;
  String _accountType;
  String _isVip;
  String _termsAndConditions;
  String _isVerified;
  String _otp;
  String _createdAt;
  String _updatedAt;
  String _isDelete;

  Data(
      {String id,
        String firstName,
        String lastName,
        String dob,
        String gender,
        String phoneNumber,
        String email,
        String username,
        String password,
        String latitude,
        String longitude,
        String city,
        String profileImage,
        String accountType,
        String isVip,
        String termsAndConditions,
        String isVerified,
        String otp,
        String createdAt,
        String updatedAt,
        String isDelete}) {
    this._id = id;
    this._firstName = firstName;
    this._lastName = lastName;
    this._dob = dob;
    this._gender = gender;
    this._phoneNumber = phoneNumber;
    this._email = email;
    this._username = username;
    this._password = password;
    this._latitude = latitude;
    this._longitude = longitude;
    this._city = city;
    this._profileImage = profileImage;
    this._accountType = accountType;
    this._isVip = isVip;
    this._termsAndConditions = termsAndConditions;
    this._isVerified = isVerified;
    this._otp = otp;
    this._createdAt = createdAt;
    this._updatedAt = updatedAt;
    this._isDelete = isDelete;
  }

  String get id => _id;
  set id(String id) => _id = id;
  String get firstName => _firstName;
  set firstName(String firstName) => _firstName = firstName;
  String get lastName => _lastName;
  set lastName(String lastName) => _lastName = lastName;
  String get dob => _dob;
  set dob(String dob) => _dob = dob;
  String get gender => _gender;
  set gender(String gender) => _gender = gender;
  String get phoneNumber => _phoneNumber;
  set phoneNumber(String phoneNumber) => _phoneNumber = phoneNumber;
  String get email => _email;
  set email(String email) => _email = email;
  String get username => _username;
  set username(String username) => _username = username;
  String get password => _password;
  set password(String password) => _password = password;
  String get latitude => _latitude;
  set latitude(String latitude) => _latitude = latitude;
  String get longitude => _longitude;
  set longitude(String longitude) => _longitude = longitude;
  String get city => _city;
  set city(String city) => _city = city;
  String get profileImage => _profileImage;
  set profileImage(String profileImage) => _profileImage = profileImage;
  String get accountType => _accountType;
  set accountType(String accountType) => _accountType = accountType;
  String get isVip => _isVip;
  set isVip(String isVip) => _isVip = isVip;
  String get termsAndConditions => _termsAndConditions;
  set termsAndConditions(String termsAndConditions) =>
      _termsAndConditions = termsAndConditions;
  String get isVerified => _isVerified;
  set isVerified(String isVerified) => _isVerified = isVerified;
  String get otp => _otp;
  set otp(String otp) => _otp = otp;
  String get createdAt => _createdAt;
  set createdAt(String createdAt) => _createdAt = createdAt;
  String get updatedAt => _updatedAt;
  set updatedAt(String updatedAt) => _updatedAt = updatedAt;
  String get isDelete => _isDelete;
  set isDelete(String isDelete) => _isDelete = isDelete;

  Data.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _firstName = json['first_name'];
    _lastName = json['last_name'];
    _dob = json['dob'];
    _gender = json['gender'];
    _phoneNumber = json['phone_number'];
    _email = json['email'];
    _username = json['username'];
    _password = json['password'];
    _latitude = json['latitude'];
    _longitude = json['longitude'];
    _city = json['city'];
    _profileImage = json['profile_image'];
    _accountType = json['account_type'];
    _isVip = json['is_vip'];
    _termsAndConditions = json['terms_and_conditions'];
    _isVerified = json['is_verified'];
    _otp = json['otp'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _isDelete = json['is_delete'];
  }
}