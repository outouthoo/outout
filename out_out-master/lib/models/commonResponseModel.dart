class CommonResponseModel {
  String status;
  String errorcode;
  String msg;

  CommonResponseModel({this.status, this.errorcode, this.msg});

  CommonResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    errorcode = json['errorcode'];
    msg = json['msg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['errorcode'] = this.errorcode;
    data['msg'] = this.msg;
    return data;
  }
}