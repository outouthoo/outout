class ListEventsModel {
  String _status;
  String _errorcode;
  String _msg;
  List<Data> _data;

  ListEventsModel(
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

  ListEventsModel.fromJson(Map<String, dynamic> json) {
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
  String _userid;
  String _eventName;
  String _eventDate;
  String _eventLat;
  String _eventLong;
  String _eventCity;
  String _eventInvitees;
  String _eventType;
  String _price;
  String _additionalInfo;
  String _createdAt;
  String _updatedAt;
  String _isDelete;

  Data(
      {String id,
        String userid,
        String eventName,
        String eventDate,
        String eventLat,
        String eventLong,
        String eventCity,
        String eventInvitees,
        String eventType,
        String price,
        String additionalInfo,
        String createdAt,
        String updatedAt,
        String isDelete}) {
    this._id = id;
    this._userid = userid;
    this._eventName = eventName;
    this._eventDate = eventDate;
    this._eventLat = eventLat;
    this._eventLong = eventLong;
    this._eventCity = eventCity;
    this._eventInvitees = eventInvitees;
    this._eventType = eventType;
    this._price = price;
    this._additionalInfo = additionalInfo;
    this._createdAt = createdAt;
    this._updatedAt = updatedAt;
    this._isDelete = isDelete;
  }

  String get id => _id;
  set id(String id) => _id = id;
  String get userid => _userid;
  set userid(String userid) => _userid = userid;
  String get eventName => _eventName;
  set eventName(String eventName) => _eventName = eventName;
  String get eventDate => _eventDate;
  set eventDate(String eventDate) => _eventDate = eventDate;
  String get eventLat => _eventLat;
  set eventLat(String eventLat) => _eventLat = eventLat;
  String get eventLong => _eventLong;
  set eventLong(String eventLong) => _eventLong = eventLong;
  String get eventCity => _eventCity;
  set eventCity(String eventCity) => _eventCity = eventCity;
  String get eventInvitees => _eventInvitees;
  set eventInvitees(String eventInvitees) => _eventInvitees = eventInvitees;
  String get eventType => _eventType;
  set eventType(String eventType) => _eventType = eventType;
  String get price => _price;
  set price(String price) => _price = price;
  String get additionalInfo => _additionalInfo;
  set additionalInfo(String additionalInfo) => _additionalInfo = additionalInfo;
  String get createdAt => _createdAt;
  set createdAt(String createdAt) => _createdAt = createdAt;
  String get updatedAt => _updatedAt;
  set updatedAt(String updatedAt) => _updatedAt = updatedAt;
  String get isDelete => _isDelete;
  set isDelete(String isDelete) => _isDelete = isDelete;

  Data.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _userid = json['userid'];
    _eventName = json['event_name'];
    _eventDate = json['event_date'];
    _eventLat = json['event_lat'];
    _eventLong = json['event_long'];
    _eventCity = json['event_city'];
    _eventInvitees = json['event_invitees'];
    _eventType = json['event_type'];
    _price = json['price'];
    _additionalInfo = json['additional_info'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _isDelete = json['is_delete'];
  }
}