import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:out_out/api/api_implementer.dart';
import 'package:out_out/chat/const.dart';
import 'package:out_out/models/list_my_friends_modal.dart';
import 'package:out_out/pages/common/login_page.dart';
import 'package:out_out/providers/common_details_provider.dart';
import 'package:out_out/utils/common_dialog_util.dart';
import 'package:out_out/utils/commona_utils.dart';
import 'package:out_out/utils/custom_colors.dart';
import 'package:out_out/utils/icon_utils.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyFriendPageList extends StatefulWidget {
  @override
  MyFriendPageListState createState() => MyFriendPageListState();
}

class MyFriendPageListState extends State<MyFriendPageList> {
  User user;
  SharedPreferences _sharedPreferences;
  bool _isLoading = false;
  String errorMsg = "";
  String searchString = "";

  GetMyFriendsResponse _response;

  @override
  void didChangeDependencies() {
    if (!_isLoading) {
      _sharedPreferences =
          Provider.of<CommonDetailsProvider>(context).getPreferencesInstance;
    }
    _isLoading = true;
    getMyFriendList();
    super.didChangeDependencies();
  }

  void getMyFriendList() async {
    user = Provider.of<CommonDetailsProvider>(context, listen: false).user;

    ApiImplementer.getMyFriendsList(
            accessToken: user.accessToken,
            search_query: searchString,
            user_id: user.userId)
        .then((value) {
      if (value.errorcode == ApiImplementer.SUCCESS) {
        setState(() {
          _isLoading = false;
          _response = value;
        });
      } else if (value.errorcode == ApiImplementer.FAIL) {
        setState(() {
          _isLoading = false;
          // _response = value;
          _response = null;
          errorMsg = value.msg;
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
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: (_response != null &&_response.data != null && _response.data.length != 0)
            ? ListView.separated(
                shrinkWrap: true,
                separatorBuilder: (context, index) {
                  return Divider();
                },
                itemCount: _response.data.length,
                itemBuilder: (BuildContext context, int index) {
                  Friend item = _response.data[index];
                  return InkWell(
                    onTap: () {
                      // Navigator.pop(context, item);
                    },
                    child: Container(
                      margin: EdgeInsets.all(5),
                      padding: EdgeInsets.all(8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            //BoxDecoration Widget
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 3,
                                color: CustomColor.colorPrimaryDark,
                              ), //Border.all
                              borderRadius: BorderRadius.circular(15),
                            ), //BoxDecoration
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: CachedNetworkImage(
                                errorWidget: (context, _, error) =>
                                    Image.asset(person_placeholder),
                                placeholder: (context, _) =>
                                    Image.asset(person_placeholder),
                                imageUrl: item.profileImage,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Expanded(
                            flex: 1,
                              child: Padding(
                            padding: EdgeInsets.all(5),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.fullName,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: CommonUtils.FONT_SIZE_16),
                                ),
                                SizedBox(
                                  height: 3,
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.location_on,
                                      color: CustomColor.colorPrimary,
                                      size: 20,
                                    ),
                                    Text(item.city)
                                  ],
                                )
                              ],
                            ),
                          )),
                          InkWell(
                            onTap: () {
                              callAddFriendApi(
                                user.userId,
                                item.userId,
                                '0',
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: CustomColor.colorPrimary,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50))),

                              padding: EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 15),
                              child: Text("UnFriend",
                                  style: TextStyle(
                                      color:Colors.white,
                                      fontWeight: FontWeight.w500,
                                      fontSize: CommonUtils.FONT_SIZE_12)),
                            ),
                          ),
                          /* item.story.compareTo("1") == 0
                              ? IconButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          StoryViewPage(
                                            userId: item.userid,
                                            title: item.fullname,
                                            image: item.profileImage,
                                          ),
                                    ));
                              },
                              icon: Icon(Icons.place))
                              : Container()*/
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
      ),
    );
  }

  void callAddFriendApi(String userId, String id, String status) {
    ApiImplementer.addFriendsApiImplementer(
      accessToken: user.accessToken,
      from_user_id: userId,
      to_user_id: id,
      status: status,
    ).then((value) {
      if (value.errorcode == ApiImplementer.SUCCESS && value.data != null) {
        _isLoading = false;
        setState(() {
          // _nonVipFriends = value.data;
          getMyFriendList();
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
