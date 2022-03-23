import 'package:flutter/material.dart';
import 'package:out_out/api/api_implementer.dart';
import 'package:out_out/models/BookiingTableOrderResponse.dart';
import 'package:out_out/models/ListAccountResponseModel.dart';
import 'package:out_out/models/ListBusinessTableBookingResponse.dart';
import 'package:out_out/pages/common/login_page.dart';
import 'package:out_out/providers/common_details_provider.dart';
import 'package:out_out/utils/common_dialog_util.dart';
import 'package:out_out/utils/commona_utils.dart';
import 'package:out_out/utils/custom_colors.dart';
import 'package:out_out/widget/common_app_bar.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookingList extends StatefulWidget {
  @override
  BookingListState createState() => BookingListState();
}

class BookingListState extends State<BookingList> {
  User user;
  SharedPreferences _sharedPreferences;
  bool _isLoading = false;
  ListBusinessTableBookingResponse _response;
  String errorMessage = "";

  List<BookingTableItem> orderList = [];

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
    getBookingForBusinessList();

    super.didChangeDependencies();
  }

  void getBookingForBusinessList() async {
    user = Provider.of<CommonDetailsProvider>(context, listen: false).user;

    ApiImplementer.getBookingForBusinessList(
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
                    'Table Bookings',
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
                        BookingTableItem item = orderList.elementAt(index);
                        return InkWell(
                          onTap: () {
                            // Navigator.pop(context, item);
                          },
                          child: Container(
                            margin: EdgeInsets.all(5),
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(Radius.circular(8))),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.fromName??"",
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
                                          'No. of Person:- ${item.numberOfPerson}',
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
                                          "Table Name:- ${item.tablename}",
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
                                          "Booking Time:- ${item.visitTime}",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              color: Colors.grey[400],
                                              fontSize: CommonUtils.FONT_SIZE_12),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                    Text(
                                      getItemStatus(item.status),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: CommonUtils.FONT_SIZE_14),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                user.accountType != "0" && item.status == "0"
                                    ? Row(
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
                                                      color: CustomColor.colorCanvas,
                                                      fontWeight: FontWeight.w500,
                                                      fontSize:
                                                          CommonUtils.FONT_SIZE_12)),
                                            ),
                                            onTap: () {
                                              changeTableStatusAPICall(1, item.id);
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
                                                      color: CustomColor.colorCanvas,
                                                      fontWeight: FontWeight.w500,
                                                      fontSize:
                                                          CommonUtils.FONT_SIZE_12)),
                                            ),
                                            onTap: () {
                                              changeTableStatusAPICall(2, item.id);
                                            },
                                          ),
                                        ],
                                      )
                                    : Container()
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
    ApiImplementer.changeTableStatus(
            accessToken: user.accessToken, id: id, status: status.toString())
        .then((value) {
      if (value.errorcode == ApiImplementer.SUCCESS) {
        getBookingForBusinessList();
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
        return "cancelled";
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
