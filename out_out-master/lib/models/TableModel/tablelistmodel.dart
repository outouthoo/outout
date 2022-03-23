class TableListModel {
  String status;
  String errorcode;
  String msg;
  List<TablesItem> data;

  TableListModel({this.status, this.errorcode, this.msg, this.data});

  TableListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    errorcode = json['errorcode'];
    msg = json['msg'];
    if (json['data'] != null) {
      data = <TablesItem>[];
      json['data'].forEach((v) {
        data.add(new TablesItem.fromJson(v));
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

class TablesItem {
  String id;
  String userid;
  String name;
  String capacity;
  String createdAt;
  String updatedAt;
  String isDelete;

  TablesItem(
      {this.id,
        this.userid,
        this.name,
        this.capacity,
        this.createdAt,
        this.updatedAt,
        this.isDelete});

  TablesItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userid = json['userid'];
    name = json['name'];
    capacity = json['capacity'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    isDelete = json['is_delete'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userid'] = this.userid;
    data['name'] = this.name;
    data['capacity'] = this.capacity;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['is_delete'] = this.isDelete;
    return data;
  }
}