class ChatGruoplist {
  String status;
  String errorcode;
  String msg;
  Data data;

  ChatGruoplist({this.status, this.errorcode, this.msg, this.data});

  ChatGruoplist.fromJson(Map<String, dynamic> json) {
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
  List<ChatData> chatData;

  Data({this.chatData});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['chatData'] != null) {
      chatData = new List<ChatData>();
      json['chatData'].forEach((v) {
        chatData.add(new ChatData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.chatData != null) {
      data['chatData'] = this.chatData.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ChatData {
  String chatid;
  String chatname;
  String chatImage;
  String chatType;
  String story;
  int members;
  List<Memberlist> memberlist;

  ChatData(
      {this.chatid,
      this.chatname,
      this.chatImage,
      this.chatType,
      this.story,
      this.members,
      this.memberlist});

  ChatData.fromJson(Map<String, dynamic> json) {
    chatid = json['chatid'];
    chatname = json['chatname'];
    chatImage = json['chatImage'];
    chatType = json['chatType'];
    story = json['story'];
    members = json['members'];
    if (json['memberlist'] != null) {
      memberlist = new List<Memberlist>();
      json['memberlist'].forEach((v) {
        memberlist.add(new Memberlist.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['chatid'] = this.chatid;
    data['chatname'] = this.chatname;
    data['chatImage'] = this.chatImage;
    data['chatType'] = this.chatType;
    data['story'] = this.story;
    data['members'] = this.members;
    if (this.memberlist != null) {
      data['memberlist'] = this.memberlist.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Memberlist {
  String id;
  String username;
  String firstName;
  String lastName;
  String profileImage;
  String email;

  Memberlist(
      {this.id,
      this.username,
      this.firstName,
      this.lastName,
      this.profileImage,
      this.email});

  Memberlist.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    profileImage = json['profile_image'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['username'] = this.username;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['profile_image'] = this.profileImage;
    data['email'] = this.email;
    return data;
  }
}
