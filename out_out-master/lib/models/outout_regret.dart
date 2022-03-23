class OutOutRegretModel {
  String status;
  String errorcode;
  String msg;
  List<Data> data;

  OutOutRegretModel({this.status, this.errorcode, this.msg, this.data});

  OutOutRegretModel.fromJson(Map<String, dynamic> json) {
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
  String storyid;
  String story;

  Data({this.id, this.storyid, this.story});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    storyid = json['storyid'];
    story = json['story'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['storyid'] = this.storyid;
    data['story'] = this.story;
    return data;
  }
}