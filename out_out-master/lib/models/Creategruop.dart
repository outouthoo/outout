class CreateGruop {
  String status;
  String errorcode;
  String msg;
  List<Data> data;

  CreateGruop({this.status, this.errorcode, this.msg, this.data});

  CreateGruop.fromJson(Map<String, dynamic> json) {
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
  String name;
  String groupphoto;
  String createdAt;
  Null updatedAt;
  String isDelete;

  Data(
      {this.id,
        this.userid,
        this.name,
        this.groupphoto,
        this.createdAt,
        this.updatedAt,
        this.isDelete});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userid = json['userid'];
    name = json['name'];
    groupphoto = json['groupphoto'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    isDelete = json['is_delete'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userid'] = this.userid;
    data['name'] = this.name;
    data['groupphoto'] = this.groupphoto;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['is_delete'] = this.isDelete;
    return data;
  }
}
