
class PaymentSuccessModel {
  String status;
  String errorcode;
  String msg;
  Data data;

  PaymentSuccessModel({this.status, this.errorcode, this.msg, this.data});

  PaymentSuccessModel.fromJson(Map<String, dynamic> json) {
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
  String transactionId;
  bool success;

  Data({this.transactionId, this.success});

  Data.fromJson(Map<String, dynamic> json) {
    transactionId = json['transaction_id'];
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['transaction_id'] = this.transactionId;
    data['success'] = this.success;
    return data;
  }
}