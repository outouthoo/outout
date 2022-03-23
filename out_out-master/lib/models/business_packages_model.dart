class BusinessPackagesModel {
  String _status;
  String _errorcode;
  String _msg;
  List<Data> _data;

  BusinessPackagesModel(
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

  BusinessPackagesModel.fromJson(Map<String, dynamic> json) {
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
  String _name;
  String _price;
  String _duration;
  String _createdAt;
  String _updatedAt;
  String _isDelete;
  String inapppurchase_key;

  Data(
      {String id,
        String name,
        String price,
        String duration,
        String createdAt,
        String updatedAt,
        String inapppurchase_key,
        String isDelete}) {
    this._id = id;
    this._name = name;
    this._price = price;
    this._duration = duration;
    this._createdAt = createdAt;
    this._updatedAt = updatedAt;
    this._isDelete = isDelete;
    this.inapppurchase_key = inapppurchase_key;
  }

  String get id => _id;
  set id(String id) => _id = id;
  String get name => _name;
  set name(String name) => _name = name;
  String get price => _price;
  set price(String price) => _price = price;
  String get duration => _duration;
  set duration(String duration) => _duration = duration;
  String get createdAt => _createdAt;
  set createdAt(String createdAt) => _createdAt = createdAt;
  String get updatedAt => _updatedAt;
  set updatedAt(String updatedAt) => _updatedAt = updatedAt;
  String get isDelete => _isDelete;
  set isDelete(String isDelete) => _isDelete = isDelete;

  String get inapppurchaseKey => inapppurchase_key;
  set inapppurchaseKey(String isDelete) => inapppurchase_key = inapppurchase_key;

  Data.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _name = json['name'];
    _price = json['price'];
    _duration = json['duration'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _isDelete = json['is_delete'];
    inapppurchase_key = json['inapppurchase_key'];
  }
}