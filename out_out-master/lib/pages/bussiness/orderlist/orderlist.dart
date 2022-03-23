import 'package:flutter/material.dart';
import 'package:out_out/api/api_implementer.dart';
import 'package:out_out/models/BookiingTableOrderResponse.dart';
import 'package:out_out/models/OrderBussinessResponse.dart';
import 'package:out_out/pages/common/login_page.dart';
import 'package:out_out/providers/common_details_provider.dart';
import 'package:out_out/utils/common_dialog_util.dart';
import 'package:out_out/utils/commona_utils.dart';
import 'package:out_out/utils/custom_colors.dart';
import 'package:out_out/widget/common_app_bar.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'OrderDetailScreen.dart';

class OrderList extends StatefulWidget {
  @override
  OrderListState createState() => OrderListState();
}

class OrderListState extends State<OrderList> {
  User user;
  SharedPreferences _sharedPreferences;
  bool _isLoading = false;
  OrderBussinessResponse _response;
  String errorMessage = "";

  List<OrderBusinessUserItem> orderList = [];

  @override
  void initState() {
    user = Provider.of<CommonDetailsProvider>(context, listen: false).user;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (!_isLoading) {
      _sharedPreferences =
          Provider.of<CommonDetailsProvider>(context).getPreferencesInstance;
    }

    _isLoading = true;
    getOrderBussinessList();

    super.didChangeDependencies();
  }

  void getOrderBussinessList() async {
    user = Provider.of<CommonDetailsProvider>(context, listen: false).user;

    ApiImplementer.getOrderBussinessList(
      accessToken: user.accessToken,
      user_id: user.userId,
    ).then((value) {
      if (value.errorcode == ApiImplementer.SUCCESS) {
        setState(() {
          _isLoading = false;
          _response = value;

          orderList.clear();
          if (_response.data != null && _response.data.length != 0) {
            orderList = _response.data;
          }

          errorMessage = value.msg;
        });
      } else if (value.errorcode == "2") {
        print("logout");
        _sharedPreferences.clear();
        Navigator.of(context).pushNamedAndRemoveUntil(
            LoginScreen.routeName, (Route<dynamic> route) => false);
        CommonDialogUtil.showErrorSnack(context: context, msg: value.msg);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56.0),
        child: CommonAppBar(),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
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
                    'Orders',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.white),
                  ),
                ),
              ),
            ),
            orderList.length != 0
                ? Expanded(
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: orderList.length,
                        itemBuilder: (BuildContext context, int index) {
                          OrderBusinessUserItem item =
                              orderList.elementAt(index);
                          String selectedValue =
                              getItemStatus(item.orderStatus);
                          var menuitem = "";
                          for (int i = 0; i < item.itemsDetails.length; i++) {
                            menuitem = menuitem +
                                '${item.itemsDetails[i].name}(${item.itemsDetails[i].qty})';
                            if (i != item.itemsDetails.length - 1) {
                              menuitem = menuitem + ", ";
                            }
                          }

                          return InkWell(
                            onTap: () async {
                              var data = await Navigator.of(context)
                                  .push(MaterialPageRoute(
                                builder: (context) => OrderDetailScreen(item),
                              ));
                              getOrderBussinessList();
                              // Navigator.pop(context, item);
                            },
                            child: Container(
                              margin: EdgeInsets.all(5),
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8))),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Column(
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Name: ${item.fromName}',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize:
                                                    CommonUtils.FONT_SIZE_16),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          SizedBox(
                                            height: 2,
                                          ),
                                          Text(
                                            'Order No: #${item.id}',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                color: Colors.grey[400],
                                                fontSize:
                                                    CommonUtils.FONT_SIZE_12),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          SizedBox(
                                            height: 2,
                                          ),
                                          Text(
                                            'Date: #${item.orderDate}',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                color: Colors.grey[400],
                                                fontSize:
                                                    CommonUtils.FONT_SIZE_12),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                      Column(
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Amount:  ',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w700,
                                                fontSize:
                                                    CommonUtils.FONT_SIZE_14),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          SizedBox(
                                            height: 2,
                                          ),
                                          Text(
                                            '€${item.orderAmount}',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                color: Colors.grey[400],
                                                fontSize:
                                                    CommonUtils.FONT_SIZE_16),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 5.0),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text("Order Items:",
                                            style: TextStyle(
                                                color: Colors.grey[400],
                                                fontWeight: FontWeight.w700,
                                                fontSize:
                                                    CommonUtils.FONT_SIZE_14)),
                                        Expanded(
                                          child: Text(
                                            menuitem,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w700,
                                                fontSize:
                                                    CommonUtils.FONT_SIZE_14),
                                            maxLines: 3,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  if (user.accountType != "0" &&
                                      item.orderStatus == "0")
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        InkWell(
                                          child: Container(
                                            width: 90,
                                            decoration: BoxDecoration(
                                                color: CustomColor.colorPrimary,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(5))),
                                            padding: EdgeInsets.symmetric(
                                                vertical: 8, horizontal: 15),
                                            child: Text("Accept",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color:
                                                        CustomColor.colorCanvas,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: CommonUtils
                                                        .FONT_SIZE_12)),
                                          ),
                                          onTap: () {
                                            changeTableStatusAPICall(
                                                1, item.id);
                                          },
                                        ),
                                        InkWell(
                                          child: Container(
                                            width: 90,
                                            decoration: BoxDecoration(
                                                color: Colors.redAccent,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(5))),
                                            padding: EdgeInsets.symmetric(
                                                vertical: 8, horizontal: 15),
                                            child: Text("Reject",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color:
                                                        CustomColor.colorCanvas,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: CommonUtils
                                                        .FONT_SIZE_12)),
                                          ),
                                          onTap: () {
                                            changeTableStatusAPICall(
                                                3, item.id);
                                          },
                                        ),
                                      ],
                                    )
                                  else
                                    Container(
                                        child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        item.orderStatus != "4" &&
                                                item.orderStatus != "3"
                                            ? Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 10),
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: Colors.grey,
                                                        width: 1),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5)),
                                                child: DropdownButton<String>(
                                                  items: <String>[
                                                    'Accepted',
                                                    'Prepared',
                                                    'Paid',
                                                    'cancelled'
                                                  ].map((String value) {
                                                    return DropdownMenuItem<
                                                        String>(
                                                      value: value,
                                                      child: Text(value),
                                                    );
                                                  }).toList(),
                                                  value: selectedValue,
                                                  onChanged: (value) {
                                                    if (value == "Prepared") {
                                                      changeTableStatusAPICall(
                                                          2, item.id);
                                                    } else if (value ==
                                                        "cancelled") {
                                                      changeTableStatusAPICall(
                                                          3, item.id);
                                                    } else if (value ==
                                                        "Paid") {
                                                      changeTableStatusAPICall(
                                                          4, item.id);
                                                    }
                                                    selectedValue = value;
                                                    setState(() {});
                                                  },
                                                  underline: Container(),
                                                ),
                                              )
                                            : Container(),
                                        Text(
                                          getItemStatus(item.orderStatus),
                                          textAlign: TextAlign.right,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText2,
                                        ),
                                      ],
                                    ))
                                ],
                              ),
                            ),
                          );
                        }),
                  )
                : Center(
                    child: Text(
                      errorMessage,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  void changeTableStatusAPICall(int status, String id) {
    ApiImplementer.changeBookingStatus(
            accessToken: user.accessToken, id: id, status: status.toString())
        .then((value) {
      if (value.errorcode == ApiImplementer.SUCCESS) {
        getOrderBussinessList();
      } else if (value.errorcode == "2") {
        print("logout");
        _sharedPreferences.clear();
        Navigator.of(context).pushNamedAndRemoveUntil(
            LoginScreen.routeName, (Route<dynamic> route) => false);
        CommonDialogUtil.showErrorSnack(context: context, msg: value.msg);
      }
    });
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
