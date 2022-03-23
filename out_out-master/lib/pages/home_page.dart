import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:out_out/api/api_implementer.dart';
import 'package:out_out/models/friends_feed_model.dart';
import 'package:out_out/models/list_media_model.dart';
import 'package:out_out/pages/story_page/image_story_page.dart';
import 'package:out_out/pages/story_page/video_story_page.dart';
import 'package:out_out/providers/common_details_provider.dart';
import 'package:out_out/utils/common_dialog_util.dart';
import 'package:out_out/utils/commona_utils.dart';
import 'package:out_out/utils/custom_colors.dart';
import 'package:out_out/utils/icon_utils.dart';
import 'package:out_out/widget/app_error.dart';
import 'package:out_out/widget/app_loader.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'common/login_page.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/home-page';

  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  User user;
  String error;

  GetFriendsFeedListResponse _response;
  SharedPreferences _sharedPreferences;

  @override
  void initState() {
    super.initState();

    initData();
  }

  @override
  void didChangeDependencies() {
    _sharedPreferences =
        Provider.of<CommonDetailsProvider>(context).getPreferencesInstance;
    super.didChangeDependencies();
  }

  void initData() async {
    user = Provider.of<CommonDetailsProvider>(context, listen: false).user;
    ApiImplementer.getFriendsFeedList(
            accessToken: user.accessToken,
            user_id: user.userId,
            offset: 1,
            limit: CommonUtils.NOTIFICATION_COUNT,
            media_id: "",
            media_type: "")
        .then((value) {
      _response = value;
      if (value.errorcode == "1") {
        // setState(() {
        error = value.msg;
        // });
      } else if (value.errorcode == "2") {
        print("logout");
        _sharedPreferences.clear();
           Navigator.of(context).pushNamedAndRemoveUntil(LoginScreen.routeName, (Route<dynamic> route) => false);
        CommonDialogUtil.showErrorSnack(context: context, msg: value.msg);
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            centerTitle: true,
            backgroundColor: Colors.black,
            elevation: 0.0,
            automaticallyImplyLeading: false,
           /* leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios_rounded,
                color: Colors.white38,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),*/
            title: Container(height: 70, child: Image.asset(out_out_actionbar)),
            actions: [
              IconButton(
                icon: Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white,
                ),
                onPressed: () {
                  // Navigator.of(context).pushNamed(ShoutOutPage.routeName);
                  Navigator.pop(context);
                },
              ),
            ]),
        body: _response == null
            ? AppLoader()
            : (_response != null && _response.errorcode == "1") ||
                    _response.data == null
                ? AppError(
                    error: _response.msg,
                  )
                : Container(
                    height: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          CustomColor.colorAccent.withOpacity(0.4),
                          CustomColor.colorPrimaryDark.withOpacity(0.4),
                        ],
                      ),
                    ),
                    child: ListView.builder(
                      padding: EdgeInsets.all(8),
                      itemCount: _response.data.length,
                      itemBuilder: (context, index) {
                        return _buildItemWidget(
                            _response.data.elementAt(index));
                      },
                    ),
                  ));
  }

  Widget _buildItemWidget(Data item) {
    log("BUILD ITEM:" + item.id + "--" + item.profileImage);
    return Padding(
        padding: EdgeInsets.all(0),
        child: Card(
            elevation: 4.0,
            margin: EdgeInsets.all(5.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              //to expand to device width
              children: [
                ListTile(
                  contentPadding: EdgeInsets.only(
                      left: 8.0, right: 0.0, bottom: 0.0, top: 0.0),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(30.0),
                    child: CachedNetworkImage(
                      fit: BoxFit.cover,
                      height: 48.0,
                      width: 48.0,
                      errorWidget: (context, _, te) =>
                          Image.asset(out_out_actionbar),
                      placeholder: (context, _) => Image.asset(splash_logo),
                      imageUrl: item.profileImage,
                      fadeInCurve: Curves.easeInOut,
                    ),
                  ),
                  title: Text(item.username),
                  subtitle: Text(item.createdAt),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 8.0,
                    bottom: 6.0,
                  ),
                  child: Text(
                    item.caption,
                    style: Theme.of(context).accentTextTheme.subtitle2,
                  ),
                ),
                InkWell(
                  onTap: () {
                    item.mediaExtension.compareTo("mp4") == 0
                        ? Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => VideoStoryPage(
                                canIncreaseViewCount: true,
                                data: Mediadata(
                                    id: item.id,
                                    mediaUrl: item.mediaUrl,
                                    likes: int.parse(item.likes),
                                    views: int.parse(item.views),
                                    city: item.city),
                              ),
                            ),
                          )
                        : Navigator.of(context)
                            .push(MaterialPageRoute(
                            builder: (context) => ImageStoryPage(
                                canIncreaseViewCount: true,
                                media: Mediadata(
                                    id: item.id,
                                    mediaUrl: item.mediaUrl,
                                    likes: int.parse(item.likes),
                                    views: int.parse(item.views),
                                    city: item.city)),
                          ))
                            .then((value) {
                            if (value == null) initData();
                          });
                  },
                  child: Stack(
                    fit: StackFit.passthrough,
                    children: [
                      CachedNetworkImage(
                        fit: BoxFit.cover,
                        height: 180.0,
                        errorWidget: (context, _, te) =>
                            Image.asset(splash_logo),
                        placeholder: (context, _) => Image.asset(splash_logo),
                        imageUrl: item.mediaThumbnail,
                        fadeInCurve: Curves.easeInOut,
                      ),
                      item.mediaExtension.compareTo("mp4") == 0
                          ? Positioned(
                              bottom: 0.0,
                              right: 0.0,
                              left: 0.0,
                              top: 0.0,
                              child: Icon(
                                Icons.play_arrow,
                                color: Colors.white,
                                size: 50,
                              ),
                            )
                          : SizedBox()
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text(item.likes),
                      IconButton(
                        icon: Icon(
                          Icons.thumb_up_alt_outlined,
                          color: item.isUserLiked.compareTo("0") == 0
                              ? Colors.grey.withOpacity(0.9)
                              : CustomColor.colorPrimary,
                          size: 20.0,
                        ),
                        onPressed: () => likePost(item),
                      ),
                      // SizedBox(
                      //   width: 3.0,
                      // ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Text('${item.views}  views'),
                    ],
                  ),
                ),
              ],
            )
            // ListTile(
            //   onTap: () {},
            //   tileColor: CustomColor.colorPrimary.withOpacity(0.2),
            //   title: Text(
            //     item.caption,
            //     style: Theme.of(context).accentTextTheme.subtitle1,
            //   ),
            //   trailing: Text(CommonUtils()
            //       .getLocalDateTimeStdFormat(DateTime.parse(item.createdAt))),
            // ),
            ));
  }

  likePost(Data item) {
    ApiImplementer.likePost(
      accessToken: user.accessToken,
      user_id: user.userId,
      is_liked: item.isUserLiked.compareTo("0") == 0 ? "1" : "0",
      media_id: item.id,
    ).then((value) {
      if (value.errorcode == ApiImplementer.SUCCESS) {
        // setState(() {
        //   _response = null;
        // });
        initData();
      } else if (value.errorcode == "2") {
        print("logout");
        _sharedPreferences.clear();
           Navigator.of(context).pushNamedAndRemoveUntil(LoginScreen.routeName, (Route<dynamic> route) => false);
        CommonDialogUtil.showErrorSnack(context: context, msg: value.msg);
      }
    });
  }
}
