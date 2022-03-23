class WalletTransactionModel {
  String status;
  String errorcode;
  String msg;
  List<Data> data;

  WalletTransactionModel({this.status, this.errorcode, this.msg, this.data});

  WalletTransactionModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    errorcode = json['errorcode'];
    msg = json['msg'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['errorcode'] = this.errorcode;
    data['msg'] = this.msg;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String id;
  String userid;
  String packageid;
  String amount;
  String paymentRefId;
  String paymentDate;
  String payment_type;
  String trans_type;
  String notes;
  String createdAt;

  Data(
      {this.id,
      this.userid,
      this.packageid,
      this.amount,
      this.paymentRefId,
      this.paymentDate,
      this.payment_type,
      this.trans_type,
      this.notes,
      this.createdAt});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userid = json['userid'];
    packageid = json['packageid'];
    amount = json['amount'];
    paymentRefId = json['payment_ref_id'];
    paymentDate = json['payment_date'];
    notes = json['notes'];
    payment_type = json['payment_type'];
    trans_type = json['trans_type'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userid'] = this.userid;
    data['packageid'] = this.packageid;
    data['amount'] = this.amount;
    data['payment_ref_id'] = this.paymentRefId;
    data['payment_date'] = this.paymentDate;
    data['notes'] = this.notes;
    data['created_at'] = this.createdAt;
    data['payment_type'] = this.payment_type;
    data['trans_type'] = this.trans_type;
    return data;
  }
}
