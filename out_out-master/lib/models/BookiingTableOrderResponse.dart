class BookingTableOrderResponse {
  String status;
  String errorcode;
  String msg;
  List<BookTableOrderItem> data;

  BookingTableOrderResponse(
      {this.status, this.errorcode, this.msg, this.data});

  BookingTableOrderResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    errorcode = json['errorcode'];
    msg = json['msg'];
    if (json['data'] != null) {
      data = <BookTableOrderItem>[];
      json['data'].forEach((v) {
        data.add(new BookTableOrderItem.fromJson(v));
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

class BookTableOrderItem {
  String id;
  String tableid;
  String tablename;
  String userid;
  String fullname;
  String email;
  String numberOfPerson;
  String visitTime;
  String status;

  BookTableOrderItem(
      {this.id,
        this.tableid,
        this.tablename,
        this.userid,
        this.fullname,
        this.email,
        this.numberOfPerson,
        this.visitTime,
        this.status});

  BookTableOrderItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    tableid = json['tableid'];
    tablename = json['tablename'];
    userid = json['userid'];
    fullname = json['fullname'];
    email = json['email'];
    numberOfPerson = json['number_of_person'];
    visitTime = json['visit_time'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['tableid'] = this.tableid;
    data['tablename'] = this.tablename;
    data['userid'] = this.userid;
    data['fullname'] = this.fullname;
    data['email'] = this.email;
    data['number_of_person'] = this.numberOfPerson;
    data['visit_time'] = this.visitTime;
    data['status'] = this.status;
    return data;
  }
}