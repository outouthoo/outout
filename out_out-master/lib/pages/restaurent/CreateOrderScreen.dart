import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:out_out/api/api_implementer.dart';
import 'package:out_out/models/ListAccountResponseModel.dart';
import 'package:out_out/models/MenuModels/menumodels.dart';
import 'package:out_out/models/createOrderModel.dart';
import 'package:out_out/pages/common/login_page.dart';
import 'package:out_out/pages/wallet/walletpage.dart';
import 'package:out_out/providers/common_details_provider.dart';
import 'package:out_out/utils/common_dialog_util.dart';
import 'package:out_out/utils/commona_utils.dart';
import 'package:out_out/utils/custom_colors.dart';
import 'package:out_out/widget/common_app_bar.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateOrderScreen extends StatefulWidget {
  CreateOrderScreen(this.item);

  ListAccountItem item;

  @override
  CreateOrderScreenState createState() => CreateOrderScreenState();
}

class CreateOrderScreenState extends State<CreateOrderScreen> {
  User user;
  bool _isLoading = false;
  SharedPreferences _sharedPreferences;

  MenuListModel _response;

  List<MenuItem> menuList = [];

  String errorMsg = "";
  var amount = 0.0;

  int noOfItems = 0;

  @override
  void initState() {
    print("Restaurant Name" + widget.item.fullName);
    getTableList();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (!_isLoading) {
      _sharedPreferences =
          Provider.of<CommonDetailsProvider>(context).getPreferencesInstance;
    }

    _isLoading = true;
    super.didChangeDependencies();
  }

  void getTableList() async {
    user = Provider.of<CommonDetailsProvider>(context, listen: false).user;

    ApiImplementer.getMenuList(
      accessToken: user.accessToken,
      user_id: widget.item.userId,
    ).then((value) {
      if (value.errorcode == ApiImplementer.SUCCESS) {
        setState(() {
          _isLoading = false;
          _response = value;

          if (_response.data != null && _response.data.isNotEmpty) {
            menuList = _response.data;
            errorMsg = _response.msg;
          } else {
            CommonDialogUtil.showErrorSnack(
                context: context, msg: "No Tables Available!!");
          }
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

  void calculateTotal() {
    amount = 0.0;
    noOfItems = 0;
    for (int i = 0; i < menuList.length; i++) {
      if (menuList[i].qty != 0) {
        amount = amount + (menuList[i].qty * double.parse(menuList[i].price));
        noOfItems = noOfItems + 1;
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56.0),
        child: CommonAppBar(),
      ),
      body: Container(
        padding: EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(
              height: 15.0,
            ),
            Center(
              child: Text(
                "Create Order",
                style: TextStyle(fontSize: 24.0),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              "Name: " + widget.item.fullName,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: CommonUtils.FONT_SIZE_16),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(
              height: 2,
            ),
            Text(
              "City: " + widget.item.city,
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[400],
                  fontSize: CommonUtils.FONT_SIZE_12),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(
              height: 2,
            ),
            Text(
              "Phone No: " + widget.item.phoneNumber,
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[400],
                  fontSize: CommonUtils.FONT_SIZE_12),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(
              height: 2,
            ),
            Text(
              "Email: " + widget.item.email,
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[400],
                  fontSize: CommonUtils.FONT_SIZE_12),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(
              height: 15.0,
            ),
            (_response != null && _response.data.length != 0)
                ? ListView.builder(
                    shrinkWrap: true,
                    itemCount: _response.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      MenuItem item = _response.data[index];
                      return InkWell(
                        onTap: () {
                          // Navigator.pop(context, item);
                        },
                        child: Container(
                          margin: EdgeInsets.all(5),
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8))),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    item.name,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: CommonUtils.FONT_SIZE_16),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    '€ 10',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey[400],
                                        fontSize: CommonUtils.FONT_SIZE_14),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                ],
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 10),
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    border: Border.all(color: Colors.grey)),
                                child: Row(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        item.qty = item.qty + 1;
                                        calculateTotal();
                                      },
                                      child: Icon(
                                        Icons.add,
                                        size: 20,
                                      ),
                                    ),
                                    Text(
                                      "${item.qty ?? 0}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: CommonUtils.FONT_SIZE_16),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        if (item.qty != 0) {
                                          item.qty = item.qty - 1;
                                        }
                                        calculateTotal();
                                      },
                                      child: Icon(
                                        Icons.remove,
                                        size: 20,
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    })
                : Expanded(
                    child: Center(
                      child: Text(
                        errorMsg,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    ),
                  ),
            Expanded(child: Container()),
            amount == 0.0
                ? InkWell(
                    onTap: () {
                      CommonDialogUtil.showErrorSnack(
                          context: context, msg: "Please add menu item!!");
                    },
                    child: Container(
                      height: 40,
                      margin: EdgeInsets.all(10.0),
                      padding: EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        color: CustomColor.colorPrimary,
                        borderRadius: BorderRadius.all(Radius.circular(12.0)),
                      ),
                      child: Text(
                        "Place Order",
                        style: TextStyle(color: Colors.white, fontSize: 14),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                : InkWell(
                    onTap: () {
                      crateOrderAPICall();
                      /*();*/
                    },
                    child: Container(
                      margin: EdgeInsets.all(10.0),
                      padding: EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        color: CustomColor.colorPrimary,
                        borderRadius: BorderRadius.all(Radius.circular(12.0)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Place Order",
                            style: TextStyle(color: Colors.white, fontSize: 14),
                            textAlign: TextAlign.center,
                          ),
                          Column(
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "Items: ",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 14),
                                    textAlign: TextAlign.center,
                                  ),
                                  Text(
                                    "${noOfItems}",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 14),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    "Amount: ",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 14),
                                    textAlign: TextAlign.center,
                                  ),
                                  Text(
                                    "${amount}",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 14),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
            SizedBox(
              height: 5.0,
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> checkWalletBalance() async {
    try {
      await ApiImplementer.FetchWalletData(
              accessToken: user.accessToken, userid: user.userId)
          .then((value) {
        if (value.errorcode == ApiImplementer.SUCCESS && value.data != null) {
          _isLoading = false;
          // walletAmount= value.data.wallet;

          if (amount > double.parse(value.data.wallet)) {
            print('less');
            CommonDialogUtil.showErrorSnack(
                context: context, msg: "Please add amount in wallet!!");
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => WalletPage(),
            ));
            // showDialogForPayment(businessPackagesList, false);
          } else {
            crateOrderAPICall();
            // showDialogForPayment(businessPackagesList, true);
          }
        }
        if (value.errorcode == ApiImplementer.FAIL) {
          _isLoading = false;
          CommonDialogUtil.showErrorSnack(context: context, msg: value.msg);
        } else if (value.errorcode == "2") {
          print("logout");
          _sharedPreferences.clear();
          Navigator.of(context).pushNamedAndRemoveUntil(
              LoginScreen.routeName, (Route<dynamic> route) => false);
          CommonDialogUtil.showErrorSnack(context: context, msg: value.msg);
        }
      });
    } catch (error) {
      print(error);
    }
  }

  void crateOrderAPICall() {
    List<CreateOrder> orderItemList = [];
    for (int i = 0; i < menuList.length; i++) {
      if (menuList[i].qty != 0) {
        orderItemList.add(CreateOrder(menuList[i].id, menuList[i].qty));
      }
    }
    var orderData = jsonEncode(orderItemList);

    ApiImplementer.createOrderApiCall(
      accessToken: user.accessToken,
      user_id: user.userId,
      to_user_id: widget.item.userId,
      item_details: orderData,
    ).then((value) {
      if (value.errorcode == ApiImplementer.SUCCESS) {
        setState(() {
          _isLoading = false;
          CommonDialogUtil.showSuccessSnack(
              context: context, msg: _response.msg);
          Navigator.pop(context);
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
}
