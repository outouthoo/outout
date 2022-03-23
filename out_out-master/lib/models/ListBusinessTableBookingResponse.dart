class ListBusinessTableBookingResponse {
  String status;
  String errorcode;
  String msg;
  List<BookingTableItem> data;

  ListBusinessTableBookingResponse(
      {this.status, this.errorcode, this.msg, this.data});

  ListBusinessTableBookingResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    errorcode = json['errorcode'];
    msg = json['msg'];
    if (json['data'] != null) {
      data = <BookingTableItem>[];
      json['data'].forEach((v) {
        data.add(new BookingTableItem.fromJson(v));
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

class BookingTableItem {
  String id;
  String fromUserId;
  String fromName;
  String tableid;
  String tablename;
  String numberOfPerson;
  String visitTime;
  String status;

  BookingTableItem(
      {this.id,
        this.fromUserId,
        this.fromName,
        this.tableid,
        this.tablename,
        this.numberOfPerson,
        this.visitTime,
        this.status});

  BookingTableItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fromUserId = json['from_user_id'];
    fromName = json['from_name'];
    tableid = json['tableid'];
    tablename = json['tablename'];
    numberOfPerson = json['number_of_person'];
    visitTime = json['visit_time'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['from_user_id'] = this.fromUserId;
    data['from_name'] = this.fromName;
    data['tableid'] = this.tableid;
    data['tablename'] = this.tablename;
    data['number_of_person'] = this.numberOfPerson;
    data['visit_time'] = this.visitTime;
    data['status'] = this.status;
    return data;
  }
}