class WalletModel {
  String status;
  String errorcode;
  String msg;
  Data data;

  WalletModel({this.status, this.errorcode, this.msg, this.data});

  WalletModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    errorcode = json['errorcode'];
    msg = json['msg'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['errorcode'] = this.errorcode;
    data['msg'] = this.msg;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  String userId;
  String fullName;
  String wallet;

  Data({this.userId, this.fullName, this.wallet});

  Data.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    fullName = json['full_name'];
    wallet = json['wallet'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['full_name'] = this.fullName;
    data['wallet'] = this.wallet;
    return data;
  }
}