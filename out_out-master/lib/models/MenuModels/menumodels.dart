class MenuListModel {
  String status;
  String errorcode;
  String msg;
  List<MenuItem> data;

  MenuListModel({this.status, this.errorcode, this.msg, this.data});

  MenuListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    errorcode = json['errorcode'];
    msg = json['msg'];
    if (json['data'] != null) {
      data = <MenuItem>[];
      json['data'].forEach((v) {
        data.add(new MenuItem.fromJson(v));
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

class MenuItem {
  String id;
  String userid;
  String name;
  String price;
  String description;
  String createdAt;
  String updatedAt;
  String isDelete;
  int qty=0;

  MenuItem(
      {this.id,
        this.userid,
        this.name,
        this.price,
        this.description,
        this.createdAt,
        this.updatedAt,
        this.qty,
        this.isDelete});

  MenuItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userid = json['userid'];
    name = json['name'];
    price = json['price'];
    description = json['description'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    isDelete = json['is_delete'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userid'] = this.userid;
    data['name'] = this.name;
    data['price'] = this.price;
    data['description'] = this.description;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['is_delete'] = this.isDelete;
    return data;
  }
}