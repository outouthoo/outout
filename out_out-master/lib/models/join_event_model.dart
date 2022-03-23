class JoinEventModel {
  String _status;
  String _errorcode;
  String _msg;
  List<Data> _data;

  JoinEventModel(
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

  JoinEventModel.fromJson(Map<String, dynamic> json) {
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
  String _eventId;
  String _userId;
  String _createdAt;
  String _updatedAt;
  String _isDelete;

  Data(
      {String id,
        String eventId,
        String userId,
        String createdAt,
        String updatedAt,
        String isDelete}) {
    this._id = id;
    this._eventId = eventId;
    this._userId = userId;
    this._createdAt = createdAt;
    this._updatedAt = updatedAt;
    this._isDelete = isDelete;
  }

  String get id => _id;
  set id(String id) => _id = id;
  String get eventId => _eventId;
  set eventId(String eventId) => _eventId = eventId;
  String get userId => _userId;
  set userId(String userId) => _userId = userId;
  String get createdAt => _createdAt;
  set createdAt(String createdAt) => _createdAt = createdAt;
  String get updatedAt => _updatedAt;
  set updatedAt(String updatedAt) => _updatedAt = updatedAt;
  String get isDelete => _isDelete;
  set isDelete(String isDelete) => _isDelete = isDelete;

  Data.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _eventId = json['event_id'];
    _userId = json['user_id'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _isDelete = json['is_delete'];
  }
}