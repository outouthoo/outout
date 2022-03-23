import 'package:flutter/material.dart';
import 'package:out_out/models/OrderBussinessResponse.dart';
import 'package:out_out/utils/custom_colors.dart';
import 'package:out_out/widget/common_app_bar.dart';

class OrderDetailScreen extends StatefulWidget {
  OrderDetailScreen(this.item);

  OrderBusinessUserItem item;

  @override
  OrderDetailScreenState createState() => OrderDetailScreenState();
}

class OrderDetailScreenState extends State<OrderDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(56.0),
          child: CommonAppBar(),
        ),
        body: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      0.0,
                    ),
                  ),
                  gradient: LinearGradient(
                    colors: [
                      CustomColor.colorAccent,
                      CustomColor.colorPrimaryDark,
                    ],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12.0,
                    vertical: 15.0,
                  ),
                  child: Center(
                    child: Text(
                      'Order Summary',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.white),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Customer Details',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      widget.item.fromName,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: Colors.grey[500]),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "Order Date: ${widget.item.orderDate}",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: Colors.grey[500]),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Order Details',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Order Number :-  #${widget.item.id}',
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                          color: Colors.grey[500]),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      'Order Status :- ${getItemStatus(widget.item.orderStatus)}',
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                          color: Colors.grey[500]),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ListView.separated(
                        shrinkWrap: true,
                        separatorBuilder: (context, index) {
                          return Divider();
                        },
                        itemCount: widget.item.itemsDetails.length,
                        itemBuilder: (BuildContext context, int index) {
                          var dataItem = widget.item.itemsDetails[index];
                          return Container(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                dataItem.name,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: Colors.grey[800]),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "${dataItem.qty} x €${dataItem.price}",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        color: Colors.grey[500]),
                                  ),
                                  Text(
                                    '€ ${dataItem.qty * double.parse(dataItem.price)}',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        color: Colors.grey[500]),
                                  ),
                                ],
                              )
                            ],
                          ));
                        }),
                    SizedBox(
                      height: 10,
                    ),
                    Divider(
                      height: 2,
                      color: Colors.black,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Grand Total",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.black),
                        ),
                        Text(
                          '€ ${widget.item.orderAmount}',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.black),
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ));
  }
  String getItemStatus(String status) {
    switch (status) {
      case "0":
        return "Received";
        break;
      case "1":
        return "Accepted";
        break;
      case "2":
        return "Prepared";
        break;
      case "3":
        return "cancelled";
        break;
      case "4":
        return "Paid";
        break;
    }
  }
}
