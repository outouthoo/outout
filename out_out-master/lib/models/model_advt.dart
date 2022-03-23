class model_advt {
  String status;
  String errorcode;
  String msg;
  List<Data> data;

  model_advt({this.status, this.errorcode, this.msg, this.data});

  model_advt.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    errorcode = json['errorcode'];
    msg = json['msg'];
    if (json['data'] != null) {
      data = new List<Data>();
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
  String title;
  String description;
  Null media;
  String type;
  String link;
  String status;
  String createdAt;
  Null updatedAt;
  String isDelete;

  Data(
      {this.id,
        this.userid,
        this.title,
        this.description,
        this.media,
        this.type,
        this.link,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.isDelete});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userid = json['userid'];
    title = json['title'];
    description = json['description'];
    media = json['media'];
    type = json['type'];
    link = json['link'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    isDelete = json['is_delete'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userid'] = this.userid;
    data['title'] = this.title;
    data['description'] = this.description;
    data['media'] = this.media;
    data['type'] = this.type;
    data['link'] = this.link;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['is_delete'] = this.isDelete;
    return data;
  }
}
