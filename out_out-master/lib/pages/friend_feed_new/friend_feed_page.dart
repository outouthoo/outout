import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:out_out/api/api_implementer.dart';
import 'package:out_out/camera/CameraPage.dart';
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

class FriendFeedPage extends StatefulWidget {
  static const routeName = "/Friend-Feed-Page";

  @override
  _FriendFeedPageState createState() => _FriendFeedPageState();
}

class _FriendFeedPageState extends State<FriendFeedPage> {
  User _user;
  List<Feeddata> _vipFriends = [];
  List<Feeddata> _nonVipFriends = [];
  bool _isLoading;
  SharedPreferences _sharedPreferences;

  @override
  void initState() {
    _isLoading = true;
    // TODO: implement initState
    super.initState();

    _user = Provider.of<CommonDetailsProvider>(context, listen: false).user;

    ApiImplementer.GetFriendFeed(
            accessToken: _user.accessToken, userid: _user.userId, isVip: 1)
        .then((value) {
      if (value.errorcode == ApiImplementer.SUCCESS && value.data != null) {
        _isLoading = false;
        setState(() {
          _vipFriends = value.data.feeddata;
        });
      }else if (value.errorcode == "2") {
        _sharedPreferences =
        Provider.of<CommonDetailsProvider>(context).getPreferencesInstance;
        print("logout");
        _sharedPreferences.clear();
        Navigator.of(context)
            .pushReplacementNamed(LoginScreen.routeName);
        CommonDialogUtil.showErrorSnack(
            context: context, msg: value.msg);
      }
    });
    ApiImplementer.GetFriendFeed(
            accessToken: _user.accessToken, userid: _user.userId, isVip: 0)
        .then((value) {
      if (value.errorcode == ApiImplementer.SUCCESS && value.data != null) {
        _isLoading = false;
        setState(() {
          _nonVipFriends = value.data.feeddata;
        });
      }else if (value.errorcode == "2") {
        print("logout");
        _sharedPreferences.clear();
        Navigator.of(context)
            .pushReplacementNamed(LoginScreen.routeName);
        CommonDialogUtil.showErrorSnack(
            context: context, msg: value.msg);
      }
    });
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
        /*actions: [
          IconButton(
            icon: Icon(
              Icons.arrow_forward_ios,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ],*/
        title: Container(height: 70, child: Image.asset(out_out_actionbar)),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _vipFriends.length == 0
              ? Container()
              : Expanded(
                  child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Row(
                        children: [
                          Text(
                            "VIP's",
                            style: TextStyle(
                                color: CustomColor.colorAccent,
                                fontWeight: FontWeight.bold,
                                fontSize: CommonUtils.FONT_SIZE_22),
                          )
                        ],
                      ),
                    ),
                    ListView.builder(
                        shrinkWrap: true,
                        itemCount: _vipFriends.length,
                        itemBuilder: (BuildContext context, int index) {
                          Feeddata item = _vipFriends.elementAt(index);
                          return Container(
                            margin: EdgeInsets.all(5),
                            padding: EdgeInsets.all(8),
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
                                      imageUrl: item.profileImage,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.fullname,
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
                                item.story.compareTo("1") == 0
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
                                    : Container()
                              ],
                            ),
                          );
                        })
                  ],
                )),
          _nonVipFriends.length == 0
              ? Container()
              : Expanded(
                  child: Container(
                  color: Colors.black87,
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: _nonVipFriends.length,
                      itemBuilder: (BuildContext context, int index) {
                        Feeddata item = _nonVipFriends.elementAt(index);
                        return Container(
                          margin: EdgeInsets.all(5),
                          padding: EdgeInsets.all(8),
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
                                    color: CustomColor.colorAccent,
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
                              Padding(
                                padding: EdgeInsets.all(5),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.fullname,
                                      style: TextStyle(
                                          color: Colors.white70,
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
                                          color: CustomColor.colorAccent,
                                          size: 20,
                                        ),
                                        Text(
                                          item.city,
                                          style: TextStyle(
                                            color: Colors.grey,
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        );
                      }),
                )),
          (_vipFriends.length == 0 && _nonVipFriends.length == 0) ? Container(child: Text('The friends list is currently empty.',textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headline6,),) : Container()

        ],
      ),
      // drawer: AppDrawer(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: Container(
          width: 60,
          height: 60,
          child: Icon(
            Icons.add,
            size: 35,
            color: Colors.white70,
          ),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [CustomColor.colorAccent, CustomColor.colorPrimaryDark],
            ),
          ),
        ),
        onPressed: () {
          PermissionUtil.checkPermission(platform).then(
            (hasGranted) {
              if (hasGranted != null && hasGranted) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => CameraPage()),
                );
                /*  CommonDialogUtil.uploadImageAndVideoFromCameraOrGalleryCommonModalBottomSheet(
                  context: context,
                  picker: picker,
                  onImageSelected: onImageSelected,
                  onVideoSelected: onVideoSelected,
                  onCameraTap: onCameraTap,
                );*/
              }
            },
          );
        },
        elevation: 10.0,
      ),
    );
  }
}
