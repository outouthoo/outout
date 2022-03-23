import 'OrderBussinessResponse.dart';

class OrderUserResponse {
  String status;
  String errorcode;
  String msg;
  List<OrderUserItem> data;

  OrderUserResponse({this.status, this.errorcode, this.msg, this.data});

  OrderUserResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    errorcode = json['errorcode'];
    msg = json['msg'];
    if (json['data'] != null) {
      data = <OrderUserItem>[];
      json['data'].forEach((v) {
        data.add(new OrderUserItem.fromJson(v));
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

class OrderUserItem {
  String id;
  String toUserId;
  String toName;
  List<ItemsDetails> itemsDetails;
  String orderStatus;
  String orderDate;
  String orderAmount;

  OrderUserItem(
      {this.id,
        this.toUserId,
        this.toName,
        this.itemsDetails,
        this.orderStatus,
        this.orderDate,
        this.orderAmount});

  OrderUserItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    toUserId = json['to_user_id'];
    toName = json['to_name'];
    if (json['items_details'] != null) {
      itemsDetails = <ItemsDetails>[];
      json['items_details'].forEach((v) {
        itemsDetails.add(new ItemsDetails.fromJson(v));
      });
    }
    orderStatus = json['order_status'];
    orderDate = json['order_date'];
    orderAmount = json['order_amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['to_user_id'] = this.toUserId;
    data['to_name'] = this.toName;
    if (this.itemsDetails != null) {
      data['items_details'] =
          this.itemsDetails.map((v) => v.toJson()).toList();
    }
    data['order_status'] = this.orderStatus;
    data['order_date'] = this.orderDate;
    data['order_amount'] = this.orderAmount;
    return data;
  }
}
