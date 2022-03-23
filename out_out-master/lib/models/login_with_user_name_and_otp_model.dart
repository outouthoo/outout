class LoginWithUsernameAndOTPModel {
  String _status;
  String _errorcode;
  String _msg;
  Data _data;

  LoginWithUsernameAndOTPModel(
      {String status, String errorcode, String msg, Data data}) {
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

  Data get data => _data;

  set data(Data data) => _data = data;

  LoginWithUsernameAndOTPModel.fromJson(Map<String, dynamic> json) {
    _status = json['status'];
    _errorcode = json['errorcode'];
    _msg = json['msg'];
    _data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }
}

class Data {
  Userdetails _userdetails;
  String _accessToken;

  Data({Userdetails userdetails, String accessToken}) {
    this._userdetails = userdetails;
    this._accessToken = accessToken;
  }

  Userdetails get userdetails => _userdetails;

  set userdetails(Userdetails userdetails) => _userdetails = userdetails;

  String get accessToken => _accessToken;

  set accessToken(String accessToken) => _accessToken = accessToken;

  Data.fromJson(Map<String, dynamic> json) {
    _userdetails = json['userdetails'] != null
        ? new Userdetails.fromJson(json['userdetails'])
        : null;
    _accessToken = json['access_token'];
  }
}

class Userdetails {
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
  String _termsAndConditions;
  String _isVerified;
  String _otp;
  String _createdAt;
  String _updatedAt;
  String payment_status;
  String _isDelete;
  String _packageId;
  String _isVIP;
  String _website;
  String _bio;
  String _isTrialCompleted;
  String _catid;

  Userdetails(
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
      String termsAndConditions,
      String isVerified,
      String otp,
      String payment_status,
      String createdAt,
      String package_id,
      String updatedAt,
      String isDelete,
      String website,
      String bio,
      String is_trial_completed,
      String catid,
      String isVIP}) {
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
    this._termsAndConditions = termsAndConditions;
    this._isVerified = isVerified;
    this.payment_status = payment_status;
    this._otp = otp;
    this._createdAt = createdAt;
    this._updatedAt = updatedAt;
    this._isDelete = isDelete;
    this._packageId = package_id;
    this._website = website;
    this._isVIP = isVIP;
    this._bio = bio;
    this._isTrialCompleted = is_trial_completed;
    this._catid = catid;
  }

  String get isVIP => _isVIP;

  set isVIP(String isVIP) => _isVIP = isVIP;

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

  String get packageId => _packageId;

  set packageId(String packageId) => _packageId = packageId;

  String get website => _website;

  set website(String website) => _website = website;

  String get bio => _bio;

  set bio(String bio) => _bio = bio;

  String get catid => _catid;

  set catid(String catid) => _catid = catid;

  String get is_trial_completed => _isTrialCompleted;

  set is_trial_completed(String is_trial_completed) =>
      _isTrialCompleted = is_trial_completed;

  Userdetails.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _firstName = json['first_name'] ?? '';
    _lastName = json['last_name'] ?? '';
    _dob = json['dob'] ?? '';
    _gender = json['gender'] ?? '0';
    _phoneNumber = json['phone_number'] ?? '';
    _email = json['email'] ?? '';
    _username = json['username'] ?? '';
    _password = json['password'] ?? '';
    _latitude = json['latitude'] ?? 0.0;
    _longitude = json['longitude'] ?? 0.0;
    _city = json['city'] ?? '';
    _profileImage = json['profile_image'] ?? '';
    _accountType = json['account_type'] ?? '0';
    _termsAndConditions = json['terms_and_conditions'] ?? '1';
    _isVerified = json['is_verified'] ?? '0';
    _otp = json['otp'] ?? '';
    payment_status = json['payment_status'] ?? '0';
    _createdAt = json['created_at'] ?? '';
    _updatedAt = json['updated_at'] ?? '';
    _isDelete = json['is_delete'] ?? '0';
    _isVIP = json['is_vip'];
    _packageId = json['package_id'];
    _website = json['website'];
    _bio = json['biography'];
    _catid = json['catid'];
    _isTrialCompleted = json['is_trial_completed'];
  }
}
