import 'package:flutter/material.dart';
import 'package:out_out/api/api_implementer.dart';
import 'package:out_out/models/MenuModels/menumodels.dart';
import 'package:out_out/pages/common/login_page.dart';
import 'package:out_out/providers/common_details_provider.dart';
import 'package:out_out/utils/common_dialog_util.dart';
import 'package:out_out/utils/commona_utils.dart';
import 'package:out_out/utils/custom_colors.dart';
import 'package:out_out/utils/icon_utils.dart';
import 'package:out_out/widget/common_app_bar.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'addmenuitem.dart';

class MenuList extends StatefulWidget {
  @override
  MenuListState createState() => MenuListState();
}

class MenuListState extends State<MenuList> {
  List<String> _nonVipFriends = ["1", "2", "3", "5"];
  User user;
  SharedPreferences _sharedPreferences;
  bool _isLoading = false;
  MenuListModel _response;
String errorMsg="";
  @override
  void didChangeDependencies() {
    if (!_isLoading) {
      _sharedPreferences =
          Provider
              .of<CommonDetailsProvider>(context)
              .getPreferencesInstance;
    }

    _isLoading = true;
    getMenuList();

    super.didChangeDependencies();
  }

  void getMenuList() async {
    user = Provider
        .of<CommonDetailsProvider>(context, listen: false)
        .user;

    ApiImplementer.getMenuList(
      accessToken: user.accessToken,
      user_id: user.userId,
    ).then((value) {
      if (value.errorcode == ApiImplementer.SUCCESS) {
        setState(() {
          _isLoading = false;
          _response = value;
        });
      }else if (value.errorcode == ApiImplementer.FAIL) {
        setState(() {
          _isLoading = false;
          // _response = value;
          _response=null;
          errorMsg=value.msg;
        });
      } else if (value.errorcode == "2") {
        print("logout");
        _sharedPreferences.clear();
           Navigator.of(context).pushNamedAndRemoveUntil(LoginScreen.routeName, (Route<dynamic> route) => false);
        CommonDialogUtil.showErrorSnack(context: context, msg: value.msg);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black,
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Container(height: 70, child: Image.asset(out_out_actionbar)),
        actions: [
         /* IconButton(
            icon: Icon(
              Icons.add,
              color: Colors.white,
            ),
            onPressed: () async {
              var result = await Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => AddMenuItem(null),
              ));

              if (result != null) {
                getMenuList();
              }
            },
          )*/
          InkWell(
            onTap: ()async{
              var result = await Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => AddMenuItem(null),
              ));

              if (result != null) {
                getMenuList();
              }
            },
            child: Center(child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text("ADD",style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.w700),),
            )),
          )
        ],
      ),
      body: Container(
        width: MediaQuery
            .of(context)
            .size
            .width,
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
                    'Menus',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.white),
                  ),
                ),
              ),
            ),

            (_response != null && _response.data.length != 0)
                ? Expanded(
                  child: ListView.builder(
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
                            borderRadius: BorderRadius.all(Radius.circular(8))),
                        child: Column(
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
                              height: 5,
                            ),  Text(
                              item.description,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[400],

                                  fontSize: CommonUtils.FONT_SIZE_14),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(
                              height: 5,
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                InkWell(
                                  child: Container(
                                    width: 90,
                                    decoration: BoxDecoration(
                                        color: CustomColor.colorPrimary,
                                        borderRadius:
                                        BorderRadius.all(Radius.circular(5))),
                                    padding: EdgeInsets.symmetric(
                                        vertical: 8, horizontal: 15),
                                    child: Text("Edit",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: CustomColor.colorCanvas,
                                            fontWeight: FontWeight.w500,
                                            fontSize: CommonUtils.FONT_SIZE_12)),
                                  ),
                                  onTap: () async {
                                    var result = await Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (context) => AddMenuItem(item),
                                    ));

                                    if (result != null) {
                                      getMenuList();
                                    }
                                  },
                                ),
                                InkWell(
                                  child: Container(
                                    width: 90,
                                    decoration: BoxDecoration(
                                        color: Colors.redAccent,
                                        borderRadius:
                                        BorderRadius.all(Radius.circular(5))),
                                    padding: EdgeInsets.symmetric(
                                        vertical: 8, horizontal: 15),
                                    child: Text("Delete",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: CustomColor.colorCanvas,
                                            fontWeight: FontWeight.w500,
                                            fontSize: CommonUtils.FONT_SIZE_12)),
                                  ),
                                  onTap: () {
                                    deleteMenuItem(item);
                                  },
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  }),
                )
                : Expanded(
              child: Center(
                child: Text(
                  errorMsg,
                  textAlign: TextAlign.center,
                  style: Theme
                      .of(context)
                      .textTheme
                      .headline6,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void deleteMenuItem(MenuItem item) {
    CommonDialogUtil.showProgressDialog(
        context, 'Please wait...');
    ApiImplementer.deleteMenuItem(
        accessToken: user.accessToken, user_id: user.userId, id: item.id)
        .then((value) {
      Navigator.of(context).pop();
      getMenuList();
    }).onError((error, stackTrace) {
      Navigator.of(context).pop();
      print(stackTrace.toString());
      CommonDialogUtil.showErrorSnack(context: context, msg: error.toString());
    });
  }
}
