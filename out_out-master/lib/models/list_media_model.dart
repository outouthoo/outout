class ListMediaModel {
  String status;
  String errorcode;
  String msg;
  List<Mediadata> mediadata;

  ListMediaModel({this.status, this.errorcode, this.msg, this.mediadata});

  ListMediaModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    errorcode = json['errorcode'];
    msg = json['msg'];
    if (json['mediadata'] != null) {
      mediadata = new List<Mediadata>();
      json['mediadata'].forEach((v) {
        mediadata.add(new Mediadata.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['errorcode'] = this.errorcode;
    data['msg'] = this.msg;
    if (this.mediadata != null) {
      data['mediadata'] = this.mediadata.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Mediadata {
  String id;
  String type;
  String mediaName;
  String mediaExtension;
  String mediaUrl;
  String mediaThumbnail;
  String caption;
  String mediaDescription;
  String link;
  String username;
  String profileImage;
  String city;
  dynamic isUserLiked;
  dynamic isUserViewed;
  String taggedUserIds;
  String taggedUserNames;
  String listType;
  dynamic likes;
  dynamic views;
  String status;

  Mediadata(
      {this.id,
        this.type,
        this.mediaName,
        this.mediaExtension,
        this.mediaUrl,
        this.mediaThumbnail,
        this.caption,
        this.mediaDescription,
        this.link,
        this.username,
        this.profileImage,
        this.city,
        this.isUserLiked,
        this.isUserViewed,
        this.taggedUserIds,
        this.taggedUserNames,
        this.listType,
        this.likes,
        this.views,
        this.status});

  Mediadata.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    mediaName = json['media_name'];
    mediaExtension = json['media_extension'];
    mediaUrl = json['media_url'];
    mediaThumbnail = json['media_thumbnail'];
    caption = json['caption'];
    mediaDescription = json['media_description'];
    link = json['link'];
    username = json['username'];
    profileImage = json['profile_image'];
    city = json['city'];
    isUserLiked = json['is_user_liked'];
    isUserViewed = json['is_user_viewed'];
    taggedUserIds = json['tagged_user_ids'];
    taggedUserNames = json['tagged_user_names'];
    listType = json['list_type'];
    likes = json['likes'];
    views = json['views'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['type'] = this.type;
    data['media_name'] = this.mediaName;
    data['media_extension'] = this.mediaExtension;
    data['media_url'] = this.mediaUrl;
    data['media_thumbnail'] = this.mediaThumbnail;
    data['caption'] = this.caption;
    data['media_description'] = this.mediaDescription;
    data['link'] = this.link;
    data['username'] = this.username;
    data['profile_image'] = this.profileImage;
    data['city'] = this.city;
    data['is_user_liked'] = this.isUserLiked;
    data['is_user_viewed'] = this.isUserViewed;
    data['tagged_user_ids'] = this.taggedUserIds;
    data['tagged_user_names'] = this.taggedUserNames;
    data['list_type'] = this.listType;
    data['likes'] = this.likes;
    data['views'] = this.views;
    data['status'] = this.status;
    return data;
  }
}
