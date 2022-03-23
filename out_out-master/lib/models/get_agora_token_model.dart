class GetAgoraToken {
  String status;
  String errorcode;
  String msg;
  Data data;

  GetAgoraToken({this.status, this.errorcode, this.msg, this.data});

  GetAgoraToken.fromJson(Map<String, dynamic> json) {
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
  String channelName;
  String agoraToken;

  Data({this.channelName, this.agoraToken});

  Data.fromJson(Map<String, dynamic> json) {
    channelName = json['channelName'];
    agoraToken = json['agoraToken'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['channelName'] = this.channelName;
    data['agoraToken'] = this.agoraToken;
    return data;
  }
}
