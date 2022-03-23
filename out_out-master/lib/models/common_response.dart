class CommonResponse {
  String status;
  String errorcode;
  String msg;

  CommonResponse({this.status, this.errorcode, this.msg});

  CommonResponse.fromJson(Map<String, dynamic> json) {
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