import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:out_out/api/api_implementer.dart';
import 'package:out_out/camera/CameraPage.dart';
import 'package:out_out/models/friend_model.dart';
import 'package:out_out/models/get_friends_list.dart';
import 'package:out_out/outfit_story/story_page.dart';
import 'package:out_out/pages/common/login_page.dart';
import 'package:out_out/providers/common_details_provider.dart';
import 'package:out_out/utils/common_dialog_util.dart';
import 'package:out_out/utils/commona_utils.dart';
import 'package:out_out/utils/custom_colors.dart';
import 'package:out_out/utils/icon_utils.dart';
import 'package:out_out/utils/permission_util.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:out_out/models/search_friends_list_model.dart' as friendModel;

class FriendsRequestsPage extends StatefulWidget {
  static const routeName = "/Friend-Requests-Page";

  @override
  _FriendsRequestsPageState createState() => _FriendsRequestsPageState();
}

class _FriendsRequestsPageState extends State<FriendsRequestsPage> {
  User _user;
  List<friendModel.Data> _nonVipFriends = [];
  bool _isLoading;
  SharedPreferences _sharedPreferences;

  String errorMessage = "The friends list is currently empty.";

  @override
  void initState() {
    _isLoading = true;
    super.initState();
    _user = Provider.of<CommonDetailsProvider>(context, listen: false).user;
    getFriendData();
  }

  Future<void> getFriendData() async {
    try {
      await ApiImplementer.GetRequestedFriendList(
              accessToken: _user.accessToken, userid: _user.userId)
          .then((value) {
        if (value.errorcode == ApiImplementer.SUCCESS && value.data != null) {
          _isLoading = false;
          setState(() {
            _nonVipFriends = value.data;
          });
        }
        if (value.errorcode == ApiImplementer.FAIL) {
          _isLoading = false;
          setState(() {
            errorMessage = value.msg;
          });
        } else if (value.errorcode == "2") {
          print("logout");
          _sharedPreferences.clear();
             Navigator.of(context).pushNamedAndRemoveUntil(LoginScreen.routeName, (Route<dynamic> route) => false);
          CommonDialogUtil.showErrorSnack(context: context, msg: value.msg);
        }
      });
    } catch (error) {}
  }

  @override
  Widget build(BuildContext context) {
    TargetPlatform platform = Theme.of(context).platform;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black,
        elevation: 0.0,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Container(height: 70, child: Image.asset(out_out_actionbar)),
      ),
      body: Column(
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
              child: Text(
                'Friends Requests',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.white),
              ),
            ),
          ),

          _nonVipFriends.length != 0
              ? Expanded(
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: _nonVipFriends.length,
                      itemBuilder: (BuildContext context, int index) {
                        friendModel.Data item = _nonVipFriends.elementAt(index);
                        return Container(
                          margin: EdgeInsets.all(5),
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8))),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                                    imageUrl: '${item.profileImage ?? ''}',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Expanded(
                                  child: Padding(
                                padding: EdgeInsets.all(5),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${item.fullName}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: CommonUtils.FONT_SIZE_16),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        // users API there is parameter named status  = 0 means request is pending, 1 means accepted and 2 means rejected
                                        InkWell(
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: CustomColor.colorPrimary,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(50))),
                                            padding: EdgeInsets.symmetric(
                                                vertical: 8, horizontal: 15),
                                            child: Text("Accept",
                                                style: TextStyle(
                                                    color:
                                                        CustomColor.colorCanvas,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: CommonUtils
                                                        .FONT_SIZE_12)),
                                          ),
                                          onTap: () {
                                            callAddFriendApi(
                                                _user.userId,
                                                item.userId,
                                                '1',);
                                          },
                                        ),

                                        InkWell(
                                          onTap: (){
                                            callAddFriendApi(
                                              _user.userId,
                                              item.userId,
                                              '3',);
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: Colors.redAccent,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(50))),
                                            padding: EdgeInsets.symmetric(
                                                vertical: 8, horizontal: 15),
                                            child: Text("Reject",
                                                style: TextStyle(
                                                    color:
                                                        CustomColor.colorCanvas,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: CommonUtils
                                                        .FONT_SIZE_12)),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              )),
                            ],
                          ),
                        );
                      }),
                )
              : Expanded(
                  child: Center(
                    child: Text(
                      errorMessage,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ),
                )
        ],
      ),
      // drawer: AppDrawer(),
    );
  }

  void callAddFriendApi(
      String userId, String id, String status) {
    ApiImplementer.addFriendsApiImplementer(
            accessToken: _user.accessToken,
            from_user_id: userId,
            to_user_id: id,
            status: status,)
        .then((value) {
      if (value.errorcode == ApiImplementer.SUCCESS && value.data != null) {
        _isLoading = false;
        setState(() {
          // _nonVipFriends = value.data;
          getFriendData();
        });
      } else if (value.errorcode == "2") {
        print("logout");
        _sharedPreferences.clear();
           Navigator.of(context).pushNamedAndRemoveUntil(LoginScreen.routeName, (Route<dynamic> route) => false);
        CommonDialogUtil.showErrorSnack(context: context, msg: value.msg);
      }
    });
  }
}
