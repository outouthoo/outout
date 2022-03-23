class AddFriendModel {
  String _status;
  String _errorcode;
  String _msg;
  List<Data> _data;

  AddFriendModel(
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

  AddFriendModel.fromJson(Map<String, dynamic> json) {
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
  String _fromUserId;
  String _toUserId;
  String _status;
  String _isFollow;
  String _sendRequestDateTime;
  String _statusRequestDateTime;
  String _createdAt;
  String _updatedAt;
  String _isDelete;

  Data(
      {String id,
        String fromUserId,
        String toUserId,
        String status,
        String isFollow,
        String sendRequestDateTime,
        String statusRequestDateTime,
        String createdAt,
        String updatedAt,
        String isDelete}) {
    this._id = id;
    this._fromUserId = fromUserId;
    this._toUserId = toUserId;
    this._status = status;
    this._isFollow = isFollow;
    this._sendRequestDateTime = sendRequestDateTime;
    this._statusRequestDateTime = statusRequestDateTime;
    this._createdAt = createdAt;
    this._updatedAt = updatedAt;
    this._isDelete = isDelete;
  }

  String get id => _id;
  set id(String id) => _id = id;
  String get fromUserId => _fromUserId;
  set fromUserId(String fromUserId) => _fromUserId = fromUserId;
  String get toUserId => _toUserId;
  set toUserId(String toUserId) => _toUserId = toUserId;
  String get status => _status;
  set status(String status) => _status = status;
  String get isFollow => _isFollow;
  set isFollow(String isFollow) => _isFollow = isFollow;
  String get sendRequestDateTime => _sendRequestDateTime;
  set sendRequestDateTime(String sendRequestDateTime) =>
      _sendRequestDateTime = sendRequestDateTime;
  String get statusRequestDateTime => _statusRequestDateTime;
  set statusRequestDateTime(String statusRequestDateTime) =>
      _statusRequestDateTime = statusRequestDateTime;
  String get createdAt => _createdAt;
  set createdAt(String createdAt) => _createdAt = createdAt;
  String get updatedAt => _updatedAt;
  set updatedAt(String updatedAt) => _updatedAt = updatedAt;
  String get isDelete => _isDelete;
  set isDelete(String isDelete) => _isDelete = isDelete;

  Data.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _fromUserId = json['from_user_id'];
    _toUserId = json['to_user_id'];
    _status = json['status'];
    _isFollow = json['is_follow'];
    _sendRequestDateTime = json['send_request_date_time'];
    _statusRequestDateTime = json['status_request_date_time'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _isDelete = json['is_delete'];
  }
}