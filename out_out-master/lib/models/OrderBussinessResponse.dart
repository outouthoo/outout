class OrderBussinessResponse {
  String status;
  String errorcode;
  String msg;
  List<OrderBusinessUserItem> data;

  OrderBussinessResponse({this.status, this.errorcode, this.msg, this.data});

  OrderBussinessResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    errorcode = json['errorcode'];
    msg = json['msg'];
    if (json['data'] != null) {
      data = <OrderBusinessUserItem>[];
      json['data'].forEach((v) {
        data.add(new OrderBusinessUserItem.fromJson(v));
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

class OrderBusinessUserItem {
  String id;
  String fromUserId;
  String fromName;
  List<ItemsDetails> itemsDetails;
  String orderStatus;
  String orderDate;
  String orderAmount;

  OrderBusinessUserItem(
      {this.id,
        this.fromUserId,
        this.fromName,
        this.itemsDetails,
        this.orderStatus,
        this.orderDate,
        this.orderAmount});

  OrderBusinessUserItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fromUserId = json['from_user_id'];
    fromName = json['from_name'];
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
    data['from_user_id'] = this.fromUserId;
    data['from_name'] = this.fromName;
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

class ItemsDetails {
  String name;
  String price;
  int qty;

  ItemsDetails({this.name, this.price, this.qty});

  ItemsDetails.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    price = json['price'];
    qty = json['qty'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['price'] = this.price;
    data['qty'] = this.qty;
    return data;
  }
}