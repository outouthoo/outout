class ListNotificationModel {
  String _status;
  String _errorcode;
  String _msg;
  List<Data> _data;

  ListNotificationModel(
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

  ListNotificationModel.fromJson(Map<String, dynamic> json) {
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
  String _userId;
  String _mediaType;
  String _mediaName;
  String _mediaExtension;
  String _mediaUrl;
  String _mediaThumbnail;
  String _caption;
  String _likes;
  String _views;
  String _createdAt;
  Null _updatedAt;
  String _isDelete;
  String _fullName;
  String _city;

  Data(
      {String id,
      String userId,
      String mediaType,
      String mediaName,
      String mediaExtension,
      String mediaUrl,
      String mediaThumbnail,
      String caption,
      String likes,
      String views,
      String createdAt,
      Null updatedAt,
      String isDelete,
      String fullName,
      String city}) {
    this._id = id;
    this._userId = userId;
    this._mediaType = mediaType;
    this._mediaName = mediaName;
    this._mediaExtension = mediaExtension;
    this._mediaUrl = mediaUrl;
    this._mediaThumbnail = mediaThumbnail;
    this._caption = caption;
    this._likes = likes;
    this._views = views;
    this._createdAt = createdAt;
    this._updatedAt = updatedAt;
    this._isDelete = isDelete;
    this._fullName = fullName;
    this._city = city;
  }

  String get id => _id;

  set id(String id) => _id = id;

  String get userId => _userId;

  set userId(String userId) => _userId = userId;

  String get mediaType => _mediaType;

  set mediaType(String mediaType) => _mediaType = mediaType;

  String get mediaName => _mediaName;

  set mediaName(String mediaName) => _mediaName = mediaName;

  String get mediaExtension => _mediaExtension;

  set mediaExtension(String mediaExtension) => _mediaExtension = mediaExtension;

  String get mediaUrl => _mediaUrl;

  set mediaUrl(String mediaUrl) => _mediaUrl = mediaUrl;

  String get mediaThumbnail => _mediaThumbnail;

  set mediaThumbnail(String mediaThumbnail) => _mediaThumbnail = mediaThumbnail;

  String get caption => _caption;

  set caption(String caption) => _caption = caption;

  String get likes => _likes;

  set likes(String likes) => _likes = likes;

  String get views => _views;

  set views(String views) => _views = views;

  String get createdAt => _createdAt;

  set createdAt(String createdAt) => _createdAt = createdAt;

  Null get updatedAt => _updatedAt;

  set updatedAt(Null updatedAt) => _updatedAt = updatedAt;

  String get isDelete => _isDelete;

  set isDelete(String isDelete) => _isDelete = isDelete;

  String get fullName => _fullName;

  set fullName(String fullName) => _fullName = fullName;

  String get city => _city;

  set city(String city) => _city = city;

  Data.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _userId = json['user_id'];
    _mediaType = json['media_type'];
    _mediaName = json['media_name'];
    _mediaExtension = json['media_extension'];
    _mediaUrl = json['media_url'];
    _mediaThumbnail = json['media_thumbnail'];
    _caption = json['caption'];
    _likes = json['likes'];
    _views = json['views'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _isDelete = json['is_delete'];
    _fullName = json['full_name'];
    _city = json['city'];
  }
}
