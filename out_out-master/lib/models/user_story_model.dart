class UserStory {
  String status;
  String errorcode;
  String msg;
  List<StoryData> data;

  UserStory({this.status, this.errorcode, this.msg, this.data});

  UserStory.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    errorcode = json['errorcode'];
    msg = json['msg'];
    if (json['data'] != null) {
      data = new List<StoryData>();
      json['data'].forEach((v) {
        data.add(new StoryData.fromJson(v));
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

class StoryData {
  String userid;
  String username;
  String profileImage;
  String id;
  String userId;
  String story;
  String caption;
  String type;
  String validHours;
  String createdAt;
  String updatedAt;
  String isDelete;

  StoryData(
      {this.userid,
      this.username,
      this.profileImage,
      this.id,
      this.userId,
      this.story,
      this.caption,
      this.type,
      this.validHours,
      this.createdAt,
      this.updatedAt,
      this.isDelete});

  StoryData.fromJson(Map<String, dynamic> json) {
    userid = json['userid'];
    username = json['username'];
    profileImage = json['profile_image'];
    id = json['id'];
    userId = json['user_id'];
    story = json['story'];
    caption = json['caption'];
    type = json['type'];
    validHours = json['valid_hours'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    isDelete = json['is_delete'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userid'] = this.userid;
    data['username'] = this.username;
    data['profile_image'] = this.profileImage;
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['story'] = this.story;
    data['caption'] = this.caption;
    data['type'] = this.type;
    data['valid_hours'] = this.validHours;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['is_delete'] = this.isDelete;
    return data;
  }
}
