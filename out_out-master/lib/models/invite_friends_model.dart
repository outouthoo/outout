class InviteFriendsModel {
  String _status;
  String _errorcode;
  String _msg;
  List<Data> _data;

  InviteFriendsModel(
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

  InviteFriendsModel.fromJson(Map<String, dynamic> json) {
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
  String _userId;
  String _fullName;
  String _dob;
  String _gender;
  String _phoneNumber;
  String _email;
  String _username;
  String _city;
  String _profileImage;
  String _accountType;
  String _isVip;
  String _isFollow;

  Data(
      {String userId,
        String fullName,
        String dob,
        String gender,
        String phoneNumber,
        String email,
        String username,
        String city,
        String profileImage,
        String accountType,
        String isVip,
        String isFollow}) {
    this._userId = userId;
    this._fullName = fullName;
    this._dob = dob;
    this._gender = gender;
    this._phoneNumber = phoneNumber;
    this._email = email;
    this._username = username;
    this._city = city;
    this._profileImage = profileImage;
    this._accountType = accountType;
    this._isVip = isVip;
    this._isFollow = isFollow;
  }

  String get userId => _userId;
  set userId(String userId) => _userId = userId;
  String get fullName => _fullName;
  set fullName(String fullName) => _fullName = fullName;
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
  String get city => _city;
  set city(String city) => _city = city;
  String get profileImage => _profileImage;
  set profileImage(String profileImage) => _profileImage = profileImage;
  String get accountType => _accountType;
  set accountType(String accountType) => _accountType = accountType;
  String get isVip => _isVip;
  set isVip(String isVip) => _isVip = isVip;
  String get isFollow => _isFollow;
  set isFollow(String isFollow) => _isFollow = isFollow;

  Data.fromJson(Map<String, dynamic> json) {
    _userId = json['user_id'];
    _fullName = json['full_name'];
    _dob = json['dob'];
    _gender = json['gender'];
    _phoneNumber = json['phone_number'];
    _email = json['email'];
    _username = json['username'];
    _city = json['city'];
    _profileImage = json['profile_image'];
    _accountType = json['account_type'];
    _isVip = json['is_vip'];
    _isFollow = json['is_follow'];
  }
}