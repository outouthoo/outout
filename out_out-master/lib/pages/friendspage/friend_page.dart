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
import 'package:out_out/pages/friendspage/requestedFriendspage.dart';
import 'package:out_out/providers/common_details_provider.dart';
import 'package:out_out/utils/common_dialog_util.dart';
import 'package:out_out/utils/commona_utils.dart';
import 'package:out_out/utils/custom_colors.dart';
import 'package:out_out/utils/icon_utils.dart';
import 'package:out_out/utils/permission_util.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:out_out/models/search_friends_list_model.dart' as friendModel;

class FriendsPage extends StatefulWidget {
  static const routeName = "/Friend-Page";

  @override
  _FriendsPageState createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  User _user;
  List<friendModel.Data> _nonVipFriends = [];
  bool _isLoading;
  SharedPreferences _sharedPreferences;
  bool _IsSearching;
  final TextEditingController _searchQuery = new TextEditingController();
  Widget appBarTitle = new Container(height: 70, child: Image.asset(out_out_actionbar));
  Icon actionIcon = new Icon(Icons.search, color: Colors.white,);

  String searchKeyWord='';

  @override
  void initState() {
    _isLoading = true;
    _IsSearching = false;
    super.initState();
    _user = Provider.of<CommonDetailsProvider>(context, listen: false).user;
    getFriendData();
  }

  Future<void> getFriendData() async {
    try {
      List<friendModel.Data> newItems = await ApiImplementer.GetFriendList(
          accessToken: _user.accessToken, userid: _user.userId,search: searchKeyWord);
      if (newItems == null || newItems.length <= 0) {
        newItems = [];
      }
      setState(() {
        _nonVipFriends = newItems;
      });
    } catch (error) {}
  }

  Widget buildBar(BuildContext context) {
    return AppBar(
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
      title:appBarTitle ,
      actions: [
         IconButton(icon: actionIcon, onPressed: () {
           searchKeyWord='';
          setState(() {
            if (this.actionIcon.icon == Icons.search) {
              this.actionIcon = new Icon(Icons.close, color: Colors.white,);
              this.appBarTitle = new TextField(
                controller: _searchQuery,
                style: new TextStyle(
                  color: Colors.white,
                ),
                textInputAction: TextInputAction.send,
                onEditingComplete: (){
                  print('onEditingComplete');
                  getFriendData();
                },
                onChanged: (value){
                  print('onChanged$value');
                  setState(() {
                    searchKeyWord=value;
                  });
                },
                decoration: new InputDecoration(
                    prefixIcon: new Icon(Icons.search, color: Colors.white),
                    hintText: "Search By Name",
                    hintStyle: new TextStyle(color: Colors.white)
                ),
              );
              _handleSearchStart();
            }
            else {
              _handleSearchEnd();
            }
          });
        },),
        IconButton(
          icon: Image.asset(
            addFriend,
            height: 15,
            width: 15,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pushNamed(FriendsRequestsPage.routeName);
            // Navigator.pop(context);
          },
        ),

      ],
    );/*new AppBar(
        centerTitle: true,
        title: appBarTitle,
        actions: <Widget>[

        ]
    );*/
  }

  void _handleSearchStart() {
    setState(() {
      _IsSearching = true;
    });
  }

  void _handleSearchEnd() {
    setState(() {
      this.actionIcon = new Icon(Icons.search, color: Colors.white,);
      this.appBarTitle = new Container(height: 70, child: Image.asset(out_out_actionbar));
      _IsSearching = false;
      _searchQuery.clear();
      searchKeyWord='';
      getFriendData();
    });
  }


  @override
  Widget build(BuildContext context) {
    TargetPlatform platform = Theme.of(context).platform;

    return Scaffold(
      appBar: buildBar(context),
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Friends',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.white),
                  ),
                  InkWell(
                    onTap: (){
                      Navigator.of(context).pushNamed(FriendsRequestsPage.routeName);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                          BorderRadius.all(
                              Radius.circular(50))),
                      padding: EdgeInsets.symmetric(
                          vertical: 8, horizontal: 15),
                      child: Text("Friends Requests",
                          style: TextStyle(color: CustomColor.colorPrimary,
                              fontWeight:
                              FontWeight.w700,
                              fontSize: CommonUtils
                                  .FONT_SIZE_12)),
                    ),
                  )

                ],
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
                                          fontWeight: FontWeight.w700,
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
                                        if (item.status == "0")
                                          InkWell(
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  color:
                                                      CustomColor.colorPrimary,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(50))),
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 8, horizontal: 15),
                                              child: Text("Add Friend",
                                                  style: TextStyle(
                                                      color: CustomColor
                                                          .colorCanvas,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontSize: CommonUtils
                                                          .FONT_SIZE_12)),
                                            ),
                                            onTap: () {
                                              callAddFriendApi(
                                                  _user.userId,
                                                  item.userId,
                                                  '3',
                                                  item.isFollow);
                                            },
                                          ),
                                        if (item.status == "1")
                                          InkWell(
                                            onTap: () {
                                              callAddFriendApi(
                                                  _user.userId,
                                                  item.userId,
                                                  '0',
                                                  item.isFollow);
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  color:
                                                      CustomColor.colorPrimary,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(50))),
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 8, horizontal: 15),
                                              child: Text("Remove Friend",
                                                  style: TextStyle(
                                                      color: CustomColor
                                                          .colorCanvas,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontSize: CommonUtils
                                                          .FONT_SIZE_12)),
                                            ),
                                          ),
                                        if (item.status == "2")
                                          Container(
                                            decoration: BoxDecoration(
                                                color: Colors.redAccent,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(50))),
                                            padding: EdgeInsets.symmetric(
                                                vertical: 8, horizontal: 15),
                                            child: Text("Rejected",
                                                style: TextStyle(
                                                    color:
                                                        CustomColor.colorCanvas,
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: CommonUtils
                                                        .FONT_SIZE_12)),
                                          ),
                                        if (item.status == "3")
                                          InkWell(
                                            onTap: () {
                                              callAddFriendApi(
                                                  _user.userId,
                                                  item.userId,
                                                  '0',
                                                  item.isFollow);
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  color: Colors.redAccent,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(50))),
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 8, horizontal: 15),
                                              child: Text("Cancel Request",
                                                  style: TextStyle(
                                                      color: CustomColor
                                                          .colorCanvas,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontSize: CommonUtils
                                                          .FONT_SIZE_12)),
                                            ),
                                          ),
                                        if (item.isFollow == "0")
                                          InkWell(
                                            onTap: () {
                                              callFollowApi(
                                                  _user.userId,
                                                  item.userId,
                                                  '1');
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  color:
                                                      CustomColor.colorAccent,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(50))),
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 8, horizontal: 15),
                                              child: Text("Follow",
                                                  style: TextStyle(
                                                      color: CustomColor
                                                          .colorCanvas,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontSize: CommonUtils
                                                          .FONT_SIZE_12)),
                                            ),
                                          ),
                                        if (item.isFollow == "1")
                                          InkWell(
                                            onTap: () {
                                              callFollowApi(
                                                  _user.userId,
                                                  item.userId,
                                                  '0');
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  color:
                                                      CustomColor.colorAccent,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(50))),
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 8, horizontal: 15),
                                              child: Text("Followed",
                                                  style: TextStyle(
                                                      color: CustomColor
                                                          .colorCanvas,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: CommonUtils
                                                          .FONT_SIZE_12)),
                                            ),
                                          )
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
                      'The friends list is currently empty.',
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
      String userId, String id, String status, String isFollow) {
    ApiImplementer.addFriendsApiImplementer(
            accessToken: _user.accessToken,
            from_user_id: userId,
            to_user_id: id,
            status: status,
            is_follow: isFollow)
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
  void callFollowApi(
      String userId, String id,  String isFollow) {
    ApiImplementer.followUnfollowApiImplementer(
            accessToken: _user.accessToken,
            from_user_id: userId,
            to_user_id: id,
            is_follow: isFollow)
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
