
class LogOutModel {
  String _status;
  String _errorcode;
  String _msg;

  LogOutModel({String status, String errorcode, String msg}) {
    this._status = status;
    this._errorcode = errorcode;
    this._msg = msg;
  }

  String get status => _status;
  set status(String status) => _status = status;
  String get errorcode => _errorcode;
  set errorcode(String errorcode) => _errorcode = errorcode;
  String get msg => _msg;
  set msg(String msg) => _msg = msg;

  LogOutModel.fromJson(Map<String, dynamic> json) {
    _status = json['status'];
    _errorcode = json['errorcode'];
    _msg = json['msg'];
  }
}
