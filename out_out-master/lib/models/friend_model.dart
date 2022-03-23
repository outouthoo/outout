class FriendsListModel {
  String status;
  String errorcode;
  String msg;
  List<FriendsListData> data;

  FriendsListModel({this.status, this.errorcode, this.msg, this.data});

  FriendsListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    errorcode = json['errorcode'];
    msg = json['msg'];
    if (json['data'] != null) {
      data = <FriendsListData>[];
      json['data'].forEach((v) {
        data.add(new FriendsListData.fromJson(v));
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

class FriendsListData {
  String id;
  String firstName;
  String status;
  String isFollow;

  FriendsListData({this.id, this.firstName, this.status, this.isFollow});

  FriendsListData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['full_name'];
    status = json['status'];
    isFollow = json['is_follow'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['full_name'] = this.firstName;
    data['status'] = this.status;
    data['is_follow'] = this.isFollow;
    return data;
  }
}