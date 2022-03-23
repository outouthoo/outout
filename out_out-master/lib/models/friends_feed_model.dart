class GetFriendsFeedListResponse {
  String status;
  String errorcode;
  String msg;
  List<Data> data;

  GetFriendsFeedListResponse(
      {this.status, this.errorcode, this.msg, this.data});

  GetFriendsFeedListResponse.fromJson(Map<String, dynamic> json) {
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
  String userId;
  String mediaType;
  String mediaName;
  String mediaExtension;
  String mediaUrl;
  String mediaThumbnail;
  String caption;
  String likes;
  String views;
  String createdAt;
  String updatedAt;
  String isDelete;
  String username;
  String profileImage;
  String city;
  String isUserLiked;
  String isUserViewed;
  String taggedUserIds;
  String taggedUserNames;

  Data(
      {this.id,
      this.userId,
      this.mediaType,
      this.mediaName,
      this.mediaExtension,
      this.mediaUrl,
      this.mediaThumbnail,
      this.caption,
      this.likes,
      this.views,
      this.createdAt,
      this.updatedAt,
      this.isDelete,
      this.username,
      this.profileImage,
      this.city,
      this.isUserLiked,
      this.isUserViewed,
      this.taggedUserIds,
      this.taggedUserNames});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    mediaType = json['media_type'];
    mediaName = json['media_name'];
    mediaExtension = json['media_extension'];
    mediaUrl = json['media_url'];
    mediaThumbnail = json['media_thumbnail'];
    caption = json['caption'];
    likes = json['likes'];
    views = json['views'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    isDelete = json['is_delete'];
    username = json['username'];
    profileImage = json['profile_image'];
    city = json['city'];
    isUserLiked = json['is_user_liked'];
    isUserViewed = json['is_user_viewed'];
    taggedUserIds = json['tagged_user_ids'];
    taggedUserNames = json['tagged_user_names'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['media_type'] = this.mediaType;
    data['media_name'] = this.mediaName;
    data['media_extension'] = this.mediaExtension;
    data['media_url'] = this.mediaUrl;
    data['media_thumbnail'] = this.mediaThumbnail;
    data['caption'] = this.caption;
    data['likes'] = this.likes;
    data['views'] = this.views;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['is_delete'] = this.isDelete;
    data['username'] = this.username;
    data['profile_image'] = this.profileImage;
    data['city'] = this.city;
    data['is_user_liked'] = this.isUserLiked;
    data['is_user_viewed'] = this.isUserViewed;
    data['tagged_user_ids'] = this.taggedUserIds;
    data['tagged_user_names'] = this.taggedUserNames;
    return data;
  }
}
