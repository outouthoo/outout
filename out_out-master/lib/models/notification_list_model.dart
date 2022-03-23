class GetNotificationResponse {
  String status;
  String errorcode;
  String msg;
  Data data;

  GetNotificationResponse({this.status, this.errorcode, this.msg, this.data});

  GetNotificationResponse.fromJson(Map<String, dynamic> json) {
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
  List<Notifications> notifications;
  int totalnotifications;

  Data({this.notifications, this.totalnotifications});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['notifications'] != null) {
      notifications = new List<Notifications>();
      json['notifications'].forEach((v) {
        notifications.add(new Notifications.fromJson(v));
      });
    }
    totalnotifications = json['totalnotifications'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.notifications != null) {
      data['notifications'] =
          this.notifications.map((v) => v.toJson()).toList();
    }
    data['totalnotifications'] = this.totalnotifications;
    return data;
  }
}

class Notifications {
  String id;
  String userId;
  String profile_image;
  String mediaId;
  String description;
  String isRead;
  String createdAt;
  String updatedAt;
  String isDelete;

  Notifications(
      {this.id,
      this.userId,
      this.mediaId,
      this.profile_image,
      this.description,
      this.isRead,
      this.createdAt,
      this.updatedAt,
      this.isDelete});

  Notifications.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    profile_image = json['profile_image'];
    mediaId = json['media_id'];
    description = json['description'];
    isRead = json['is_read'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    isDelete = json['is_delete'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['profile_image'] = this.profile_image;
    data['media_id'] = this.mediaId;
    data['description'] = this.description;
    data['is_read'] = this.isRead;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['is_delete'] = this.isDelete;
    return data;
  }
}
