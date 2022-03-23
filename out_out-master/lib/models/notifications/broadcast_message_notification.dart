class BroadcastMessageNotification {
  String notificationType;
  String fromuserid;
  String profileImage;
  String fromusername;
  String messageId;
  String message;

  BroadcastMessageNotification(
      {this.notificationType,
      this.fromuserid,
      this.profileImage,
      this.fromusername,
      this.messageId,
      this.message});

  BroadcastMessageNotification.fromJson(Map<String, dynamic> json) {
    notificationType = json['notification_type'];
    fromuserid = json['fromuserid'];
    profileImage = json['profile_image'];
    fromusername = json['fromusername'];
    messageId = json['messageId'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['notification_type'] = this.notificationType;
    data['fromuserid'] = this.fromuserid;
    data['profile_image'] = this.profileImage;
    data['fromusername'] = this.fromusername;
    data['messageId'] = this.messageId;
    data['message'] = this.message;
    return data;
  }
}

class GoLiveNotification {
  String notificationType;
  String channelName;
  String agoraToken;
  String subscribertoken;
  String isBroadCaster;
  String hostUserId;

  GoLiveNotification({this.notificationType, this.channelName});

  GoLiveNotification.fromJson(Map<String, dynamic> json) {
    notificationType = json['notification_type'];
    channelName = json['channelName'];
    agoraToken = json['agoraToken'];
    subscribertoken = json['subscribertoken'];
    isBroadCaster = json['isBroadCaster'];
    hostUserId = json['hostUserId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['notification_type'] = this.notificationType;
    data['channelName'] = this.channelName;
    data['agoraToken'] = this.agoraToken;
    data['subscribertoken'] = this.subscribertoken;
    data['isBroadCaster'] = this.isBroadCaster;
    data['hostUserId'] = this.hostUserId;
    return data;
  }
}

class RequestToGoLiveNotification {
  String notificationType;
  String isBroadCaster;
  String hostUserId;
  String friendid;
  String friendName;
  bool isAccepted;

  RequestToGoLiveNotification(
      {this.notificationType,
      this.isBroadCaster,
      this.hostUserId,
      this.friendid,
      this.friendName,
      this.isAccepted});

  RequestToGoLiveNotification.fromJson(Map<String, dynamic> json) {
    notificationType = json['notification_type'];
    isBroadCaster = json['isBroadCaster'];
    hostUserId = json['hostUserId'];
    friendid = json['friendid'];
    friendName = json['friendName'];
    isAccepted = false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['notification_type'] = this.notificationType;
    data['isBroadCaster'] = this.isBroadCaster;
    data['hostUserId'] = this.hostUserId;
    data['friendid'] = this.friendid;
    data['friendName'] = this.friendName;
    data['isAccepted'] = this.isAccepted;
    return data;
  }
}
