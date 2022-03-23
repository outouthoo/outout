class CreateOrderResposne {
  String status;
  String errorcode;
  String msg;
  List<OrderCItem> data;

  CreateOrderResposne({this.status, this.errorcode, this.msg, this.data});

  CreateOrderResposne.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    errorcode = json['errorcode'];
    msg = json['msg'];
    if (json['data'] != null) {
      data = <OrderCItem>[];
      json['data'].forEach((v) {
        data.add(new OrderCItem.fromJson(v));
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

class OrderCItem {
  String id;
  String fromUserId;
  String toUserId;
  String itemsDetails;
  String orderDate;
  String orderStatus;
  String orderAmount;
  String createdAt;
  String updatedAt;
  String isDelete;

  OrderCItem(
      {this.id,
        this.fromUserId,
        this.toUserId,
        this.itemsDetails,
        this.orderDate,
        this.orderStatus,
        this.orderAmount,
        this.createdAt,
        this.updatedAt,
        this.isDelete});

  OrderCItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fromUserId = json['from_user_id'];
    toUserId = json['to_user_id'];
    itemsDetails = json['items_details'];
    orderDate = json['order_date'];
    orderStatus = json['order_status'];
    orderAmount = json['order_amount'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    isDelete = json['is_delete'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['from_user_id'] = this.fromUserId;
    data['to_user_id'] = this.toUserId;
    data['items_details'] = this.itemsDetails;
    data['order_date'] = this.orderDate;
    data['order_status'] = this.orderStatus;
    data['order_amount'] = this.orderAmount;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['is_delete'] = this.isDelete;
    return data;
  }
}