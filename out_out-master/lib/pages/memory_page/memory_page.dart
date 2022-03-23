import 'dart:io';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_floating_menu/floating_menu.dart';
import 'package:flutter_floating_menu/floating_menu_callback.dart';
import 'package:flutter_floating_menu/floating_menu_item.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:out_out/Golive/agora/host.dart';
import 'package:out_out/api/api_implementer.dart';
import 'package:out_out/camera/CameraPage.dart';
import 'package:out_out/chat/Chatlist.dart';
import 'package:out_out/chat/const.dart';
import 'package:out_out/chat/model/user_chat.dart';
import 'package:out_out/main.dart';
import 'package:out_out/models/home_response.dart';
import 'package:out_out/models/notification_list_model.dart';
import 'package:out_out/models/notifications/broadcast_message_notification.dart';
import 'package:out_out/models/upload_media_model.dart';
import 'package:out_out/outfit_story/story_page.dart';
import 'package:out_out/pages/broadcast/create_message.dart';
import 'package:out_out/pages/broadcast/show_message.dart';
import 'package:out_out/pages/bussiness/menu/menuscreen.dart';
import 'package:out_out/pages/bussiness/orderlist/bookingorderscreen.dart';
import 'package:out_out/pages/bussiness/orderlist/bookinguserorderscreen.dart';
import 'package:out_out/pages/bussiness/orderlist/orderUserlist.dart';
import 'package:out_out/pages/bussiness/orderlist/orderlist.dart';
import 'package:out_out/pages/bussiness/tablesview/tablelist.dart';
import 'package:out_out/pages/common/edit_profile_page.dart';
import 'package:out_out/pages/common/login_page.dart';
import 'package:out_out/pages/common/settings_page.dart';
import 'package:out_out/pages/common/video_upload_page.dart';
import 'package:out_out/pages/events_modul/view_events/upcoming_event.dart';
import 'package:out_out/pages/friend_feed_new/friend_feed_page.dart';
import 'package:out_out/pages/friendspage/friend_page.dart';
import 'package:out_out/pages/home_page.dart';
import 'package:out_out/pages/memory_page/memory_page_emog.dart';
import 'package:out_out/pages/memory_page/memory_page_image.dart';
import 'package:out_out/pages/memory_page/memory_page_video.dart';
import 'package:out_out/pages/memory_page/notification_list_page.dart';
import 'package:out_out/pages/restaurent/restaurent_list.dart';
import 'package:out_out/pages/shout_out_page/shout_out_page.dart';
import 'package:out_out/providers/common_details_provider.dart';
import 'package:out_out/utils/common_dialog_util.dart';
import 'package:out_out/utils/commona_utils.dart';
import 'package:out_out/utils/constant.dart';
import 'package:out_out/utils/custom_colors.dart';
import 'package:out_out/utils/icon_utils.dart';
import 'package:out_out/utils/navigation_service.dart';
import 'package:out_out/utils/permission_util.dart';
import 'package:out_out/utils/preferences_constants.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import 'MyFollowerPage.dart';
import 'MyFriendPage.dart';

class MemoryPage extends StatefulWidget {
  static const routeName = '/memory-page-screen';

  @override
  _MemoryPageState createState() => _MemoryPageState();
}

class _MemoryPageState extends State<MemoryPage>
    implements FloatingMenuCallback {
  SharedPreferences _sharedPreferences;
  bool _isLoading = false;
  RxString _profileUrl = ''.obs;
  RxString _userName = ''.obs;
  RxString _city = ''.obs;
  RxString _birthDate = ''.obs;
  RxString _WEBSITE = ''.obs;
  RxString _Bio = ''.obs;
  RxDouble ratting = 0.0.obs;
  String _accessToken = '';
  String _userId = '';
  String _accountType = '';
  final picker = ImagePicker();
  FirebaseMessaging messaging;
  User user;

  HomeResponse _response;
  SharedPreferences prefs;

  @override
  void initState() {
    CommonUtils.getId().then((value) => print("DEVICE ID:" + value));
    messaging = FirebaseMessaging.instance;
    messaging.getToken().then((value) {
      print('vikaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa');
      print(value);
      ApiImplementer.FCMTOKENImplementer(
              accessToken: _accessToken,
              userid: _userId,
              FCMToken: value.toString())
          .then((valu) {
        setState(() {
          //    leadboard =Leaderboard.fromJson(value);
          //  print(leadboard.errorcode.toString());
          print("FCM TOKEN" + valu.toString());
        });
      });
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
      if (notification != null && android != null) {
        print("44444444444");
        print(message.data);
        bool showNotification = true;
        try {
          if (message.data['notification_type'] ==
              CommonUtils.NOTIFICATION_TYPE_GO_LIVE) {
            showNotification = false;
            print(message.data);

            confirmAlert(
                    NavigationService.instance.navigationKey.currentContext,
                    notification.title + " Do you want to join?")
                .then((value) {
              if (value) {
                GoLiveNotification goLiveNotification =
                    GoLiveNotification.fromJson(message.data);
                PermissionUtil.checkPermission(Theme.of(NavigationService
                            .instance.navigationKey.currentContext)
                        .platform)
                    .then(
                  (hasGranted) {
                    if (hasGranted != null && hasGranted) {
                      Route route = MaterialPageRoute(
                        builder: (context) => CallPage(
                          isHost: false,
                          hostUserId: goLiveNotification.hostUserId,
                          role: goLiveNotification.isBroadCaster
                                      .compareTo("true") ==
                                  0
                              ? ClientRole.Broadcaster
                              : ClientRole.Audience,
                          channelName: goLiveNotification.channelName,
                          token: goLiveNotification.subscribertoken,
                        ),
                      );
                      print("CHECKKKKKKKK:" + route.isCurrent.toString());
                      Navigator.push(
                        NavigationService.instance.navigationKey.currentContext,
                        route,
                      );
                    }
                  },
                );
              }
            });
          } else if (message.data['notification_type'] ==
              CommonUtils.NOTIFICATION_TYPE_REQUEST_TO_JOIN_LIVE) {
            showNotification = false;
            RequestToGoLiveNotification requestToGoLiveNotification =
                RequestToGoLiveNotification.fromJson(message.data);
            Provider.of<CommonDetailsProvider>(context, listen: false)
                .addReqList(requestToGoLiveNotification);
          } else if (message.data['notification_type'] ==
              CommonUtils.NOTIFICATION_TYPE_END_GO_LIVE) {
            showNotification = false;
            Provider.of<CommonDetailsProvider>(context, listen: false)
                .isEndedLive = true;
          }
        } catch (e) {}
        // if (message.data != null) handleNotification(message);
        if (showNotification) {
          print("ttttttttttttttttttttttttttttttttttttt");
          flutterLocalNotificationsPlugin.show(
              notification.hashCode,
              notification.title,
              notification.body,
              NotificationDetails(
                android: AndroidNotificationDetails(
                  channel.id,
                  channel.name,
                  channel.description,
                  color: Colors.blue,
                  playSound: true,
                  icon: '@mipmap/ic_launcher',
                ),
              ));
        }
      }
    });

    messaging.getInitialMessage().then((value) {
      print('FCM :::::: InitialMessage');
      if (value != null) {
        print("111111111");
        handleNotification(value);
      }
    });
    // If the message also contains a data property with a "type" of "chat",
    // navigate to a chat screen

    Future<void> _messageHandler(RemoteMessage message) async {
      print('FCM :::::: background message ${message.notification.body}');
      print("2222222222");
      if (message.data != null) handleNotification(message);
    }

    FirebaseMessaging.onBackgroundMessage(_messageHandler);

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('FCM :::::: A new onMessageOpenedApp event was published!');
      RemoteNotification notification = message.notification;
      print(notification);
      AndroidNotification android = message.notification?.android;
      print(message.data.toString());

      if (notification != null && android != null) {
        if (message.data != null) {
          print("33333333333");
          handleNotification(message);
        } else {
          showDialog(
              context: context,
              builder: (_) {
                return AlertDialog(
                  title: Text(notification.title),
                  content: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [Text(notification.body)],
                    ),
                  ),
                );
              });
        }
      }
    });
    messaging.getToken().then((firbasetokenvalue) {
      setState(() {
        // fcmtoken= firbasetokenvalue;
        print(firbasetokenvalue);

        /*  AppPreferences.getString(AppConstants.Token).then((authkey) =>

           ApiClient().firbaseupdatetoken(authkey, fcmtoken).then((value) =>print(value.data.toString())));
*/
      });
    });
    getNotificationList();
    super.initState();
  }

  void handleNotification(RemoteMessage message) {
    print(message.data);
    if (message.data['notification_type'] ==
        CommonUtils.NOTIFICATION_TYPE_BROADCAST) {
      BroadcastMessageNotification notification =
          BroadcastMessageNotification.fromJson(message.data);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  ShowBroadcastMessagePage(notification: notification)));
    } else if (message.data['notification_type'] ==
        CommonUtils.NOTIFICATION_TYPE_GO_LIVE) {
      print(message.data);
      GoLiveNotification notification =
          GoLiveNotification.fromJson(message.data);
      PermissionUtil.checkPermission(
              Theme.of(NavigationService.instance.navigationKey.currentContext)
                  .platform)
          .then(
        (hasGranted) {
          if (hasGranted != null && hasGranted) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CallPage(
                  isHost: false,
                  hostUserId: notification.hostUserId,
                  role: notification.isBroadCaster.compareTo("true") == 0
                      ? ClientRole.Broadcaster
                      : ClientRole.Audience,
                  channelName: notification.channelName,
                  token: notification.subscribertoken,
                ),
              ),
            );
          }
        },
      );
    } else if (message.data['notification_type'] ==
        CommonUtils.NOTIFICATION_TYPE_REQUEST_TO_JOIN_LIVE) {
      RequestToGoLiveNotification requestToGoLiveNotification =
          RequestToGoLiveNotification.fromJson(message.data);
      Provider.of<CommonDetailsProvider>(context, listen: false)
          .addReqList(requestToGoLiveNotification);
    } else if (message.data['notification_type'] ==
        CommonUtils.NOTIFICATION_TYPE_END_GO_LIVE) {
      // Provider.of<CommonDetailsProvider>(context, listen: false).isEndedLive =
      //     true;
    }
  }

  void getNotificationList() async {
    user = Provider.of<CommonDetailsProvider>(context, listen: false).user;
    print("userid===========>+$_userId");

    ApiImplementer.getHomeScreen(
      accessToken: user.accessToken,
      user_id: user.userId,
    ).then((value) {
      if (value.errorcode == ApiImplementer.SUCCESS) {
        setState(() {
          _response = value;
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

  // GlobalKey<NavigatorState> _key = GlobalKey();

  @override
  void didChangeDependencies() {
    if (!_isLoading) {
      _sharedPreferences =
          Provider.of<CommonDetailsProvider>(context).getPreferencesInstance;
      _profileUrl.value =
          _sharedPreferences.get(PreferenceConstants.PROFILE_IMAGE);
      _userName.value =
          '${_sharedPreferences.get(PreferenceConstants.FIRST_NAME)} ${_sharedPreferences.get(PreferenceConstants.LAST_NAME)}';
      _city.value = _sharedPreferences.get(PreferenceConstants.CITY);
      _birthDate.value = _sharedPreferences.get(PreferenceConstants.DOB);
      _WEBSITE.value = _sharedPreferences.get(PreferenceConstants.WEBSITE);
      _Bio.value = _sharedPreferences.get(PreferenceConstants.Bio);
      // ratting.value = _sharedPreferences.get(PreferenceConstants.ratings);
      _accessToken = _sharedPreferences.get(PreferenceConstants.ACCESS_TOKEN);
      _userId = _sharedPreferences.get(PreferenceConstants.USER_ID);
      _accountType =
          _sharedPreferences.get(PreferenceConstants.ACCOUNT_TYPE) ?? '';
      firbaseuser();
    }
    _isLoading = true;

    super.didChangeDependencies();
  }

  Future<void> firbaseuser() async {
    // Check is already sign up
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('users')
        .where('id', isEqualTo: _userId.toString())
        .get();
    final List<DocumentSnapshot> documents = result.docs;
    //print("mohit");
    //   print(_userId);
    //   print(documents);
    //  print("mohit");
    prefs = await SharedPreferences.getInstance();
    if (documents.length == 0) {
      // Update data to server if new user
      FirebaseFirestore.instance.collection('users').doc(_userId).set({
        'nickname': _userName,
        'photoUrl': _profileUrl,
        'id': _userId,
        'createdAt': DateTime.now().millisecondsSinceEpoch.toString(),
        'chattingWith': null
      }, SetOptions(merge: true)).catchError((err) {
        // Fluttertoast.showToast(msg: err.message.toString());
      });

      // Write data to local
      //currentUser = firebaseUser;
      await prefs?.setString('id', _userId);
      await prefs?.setString('nickname', _userName.toString() ?? "");
      await prefs?.setString('photoUrl', _profileUrl.toString() ?? "");
    } else {
      DocumentSnapshot documentSnapshot = documents[0];
      UserChat userChat = UserChat.fromDocument(documentSnapshot);
      // Write data to local
      await prefs?.setString('id', userChat.id);

      await prefs?.setString('nickname', userChat.nickname);
      await prefs?.setString('photoUrl', userChat.photoUrl);
      await prefs?.setString('aboutMe', userChat.aboutMe);
    }

    // Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen(currentUserId: _userId)));
  }

  // void onImageSelected(File selectedImageFile) {
  //   CommonDialogUtil.showProgressDialog(context, 'Uploading...');
  //   ApiImplementer.uploadMediaApiImplementer(
  //     accessToken: _accessToken,
  //     user_id: _userId,
  //     media_type: CommonUtils.MEDIA_TYPE_IMAGE,
  //     file: selectedImageFile,
  //     caption: '',
  //     thumbFile: null,
  //   ).then((value) {
  //     Navigator.of(context).pop();
  //     UploadMediaModel uploadMediaModel = value;
  //     if (uploadMediaModel.errorcode == '0') {
  //       CommonDialogUtil.showSuccessSnack(
  //           context: context, msg: uploadMediaModel.msg);
  //     } else {
  //       CommonDialogUtil.showErrorSnack(
  //           context: context, msg: uploadMediaModel.msg);
  //     }
  //   }).onError((error, stackTrace) {
  //     Navigator.of(context).pop();
  //     //  CommonDialogUtil.showErrorSnack(context: context, msg: error.toString());
  //   });
  // }

  void onVideoSelected(File selectedVideoFile) async {
    CommonDialogUtil.showProgressDialog(context, 'Uploading...');
    String thumb = await VideoThumbnail.thumbnailFile(
      thumbnailPath: (await getTemporaryDirectory()).path,
      video: '${selectedVideoFile.path}',
      imageFormat: ImageFormat.PNG,
      quality: 100,
    );
    File thumbFile = File(thumb);

    ApiImplementer.uploadMediaApiImplementer(
      accessToken: _accessToken,
      user_id: _userId,
      media_type: CommonUtils.MEDIA_TYPE_VIDEO,
      file: selectedVideoFile,
      caption: '',
      thumbFile: thumbFile,
    ).then((value) {
      Navigator.of(context).pop();
      UploadMediaModel uploadMediaModel = value;
      if (uploadMediaModel.errorcode == '0') {
        CommonDialogUtil.showSuccessSnack(
            context: context, msg: uploadMediaModel.msg);
      } else if (value.errorcode == "2") {
        print("logout");
        _sharedPreferences.clear();
        Navigator.of(context).pushNamedAndRemoveUntil(
            LoginScreen.routeName, (Route<dynamic> route) => false);
        CommonDialogUtil.showErrorSnack(context: context, msg: value.msg);
      } else {
        CommonDialogUtil.showErrorSnack(
            context: context, msg: uploadMediaModel.msg);
      }
    }).onError((error, stackTrace) {
      Navigator.of(context).pop();
      CommonDialogUtil.showErrorSnack(context: context, msg: error.toString());
    });
  }

  void onCameraTap() {
    Navigator.of(context).pushNamed(VideoUploadPage.routeName).then(
      (value) {
        if (value != null && value) {}
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    TargetPlatform platform = Theme.of(context).platform;
    final List<FloatingMenuItem> floatMenuList = [
      FloatingMenuItem(
          id: 1,
          icon: Icons.add_photo_alternate,
          backgroundColor: Colors.white),
      FloatingMenuItem(
          id: 2, icon: Icons.list_alt, backgroundColor: Colors.white),
      FloatingMenuItem(
          id: 3,
          icon: FlutterIcons.add_user_ent,
          backgroundColor: Colors.white),
      FloatingMenuItem(
          id: 4,
          icon: Icons.shopping_bag_outlined,
          backgroundColor: Colors.white)
    ];

    if (user.accountType == "1" || user.accountType == "2") {
      /*  floatMenuList.add(FloatingMenuItem(
          id: 4,
          icon: Icons.shopping_bag_outlined,
          backgroundColor: Colors.white));*/
      floatMenuList.add(FloatingMenuItem(
          id: 5, icon: Icons.border_color, backgroundColor: Colors.white));
      floatMenuList.add(FloatingMenuItem(
          id: 7, icon: Icons.chair, backgroundColor: Colors.white));
    }
    if (user.accountType == "0" || user.accountType == "2") {
      /*  floatMenuList.add(FloatingMenuItem(
          id: 4,
          icon: Icons.shopping_bag_outlined,
          backgroundColor: Colors.white));*/
      floatMenuList.add(FloatingMenuItem(
          id: 6,
          icon: Icons.add_shopping_cart_sharp,
          backgroundColor: Colors.white));
    }
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black,
        elevation: 0.0,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onPressed: () {
            print('home');
            Navigator.of(context).pushNamed(HomePage.routeName);
          },
        ),
        title: Container(height: 70, child: Image.asset(out_out_actionbar)),
        actions: [
          IconButton(
            icon: Icon(
              Icons.arrow_forward_ios,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.of(context).pushNamed(ShoutOutPage.routeName);
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 5),
                decoration: BoxDecoration(
                    border: Border(top: BorderSide()),
                    gradient: _accountType == AccountType.BUSINESS
                        ? LinearGradient(colors: [
                            CustomColor.colorAccent,
                            CustomColor.colorAccent,
                          ])
                        : _accountType == AccountType.PREMIUM
                            ? LinearGradient(
                                colors: [
                                  Colors.orange,
                                  Colors.deepOrange,
                                ],
                              )
                            : LinearGradient(
                                colors: [
                                  Colors.white,
                                  Colors.white,
                                ],
                              )),
                child: Container(
                  color: Colors.white,
                  padding: EdgeInsets.symmetric(
                    vertical: 5.0,
                    horizontal: 16.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: () {
                              // if()
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => StoryViewPage(
                                      userId: _userId,
                                      title: '${_userName.value}',
                                    ),
                                  ));
                            },
                            child: Container(
                              width: 70,
                              height: 70,
                              //BoxDecoration Widget
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 3,
                                  color: CustomColor.colorPrimaryDark,
                                ), //Border.all
                                borderRadius: BorderRadius.circular(15),
                              ), //BoxDecoration
                              child: Obx(
                                () => ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: CachedNetworkImage(
                                    errorWidget: (context, _, error) =>
                                        Image.asset(person_placeholder),
                                    placeholder: (context, _) =>
                                        Image.asset(person_placeholder),
                                    imageUrl: _profileUrl.value,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 10.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      if (_response != null &&
                                          _response.data.is_verified != "1")
                                        Padding(
                                          padding: EdgeInsets.fromLTRB(
                                            0.0,
                                            5.0,
                                            5.0,
                                            5.0,
                                          ),
                                          child: Image.asset(
                                            verify,
                                            height: 15,
                                            width: 15,
                                          ),
                                        ),
                                      Obx(
                                        () => Text(
                                          _userName.value,
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 14.0,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Obx(
                                    () => Text(
                                      _birthDate.value,
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        color: Colors.grey.shade600,
                                        fontSize: 12.0,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Column(
                                        children: [
                                          Text(
                                            _response != null
                                                ? _response.data.points ?? "100"
                                                : "0",
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          SizedBox(
                                            width: 15.0,
                                          ),
                                          Text(
                                            "Points",
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ],
                                      ),
                                      InkWell(
                                        onTap: () {
                                          Navigator.of(context)
                                              .push(MaterialPageRoute(
                                            builder: (context) =>
                                                MyFriendPageList(),
                                          ))
                                              .then((value) {
                                            print(
                                                '-------------------*************---------------------');
                                            getNotificationList();
                                          });
                                        },
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Text(
                                              _response != null
                                                  ? _response.data.friends
                                                  : "0",
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 16.0,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            SizedBox(
                                              width: 15.0,
                                            ),
                                            Text(
                                              "Friends",
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ],
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          Navigator.of(context)
                                              .push(MaterialPageRoute(
                                            builder: (context) =>
                                                MyFollowerPageList(),
                                          ))
                                              .then((value) {
                                            print(
                                                '-------------------*************---------------------');
                                            getNotificationList();
                                          });
                                        },
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Text(
                                              _response != null
                                                  ? _response.data.followers
                                                  : "0",
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 16.0,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            SizedBox(
                                              width: 15.0,
                                            ),
                                            Text(
                                              "Followers",
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            color: CustomColor.colorAccent,
                            size: 20,
                          ),
                          Obx(
                            () => Text(
                              _city.value,
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 12.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Obx(
                        () => InkWell(
                          onTap: () {
                            if (_WEBSITE.value.isNotEmpty)
                              launch(_WEBSITE.value);
                          },
                          child: Text(
                            _WEBSITE.value,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              color: Colors.blue,
                              decoration: TextDecoration.underline,
                              fontSize: 12.0,
                            ),
                          ),
                        ),
                      ),
                      Obx(
                        () => Text(
                          _Bio.value ?? "",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 12.0,
                          ),
                        ),
                      ),
                      user.accountType==0&&_response!=null
                          ? RatingBar.builder(
                        initialRating: _response.data.overallrating ?? 0.0,
                        minRating: 0,
                        tapOnlyMode: true,
                        direction: Axis.horizontal,
                        itemSize: 15,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemBuilder: (context, _) => Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                      )
                          : Container(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.of(context)
                                  .push(MaterialPageRoute(
                                builder: (context) => NotificationListPage(),
                              ))
                                  .then((value) {
                                print(
                                    '-------------------*************---------------------');
                                getNotificationList();
                              });
                            },
                            icon: Badge(
                              badgeContent: Text(
                                  _response != null
                                      ? _response.data.unreadNotifications
                                          .toString()
                                      : "0",
                                  style: Theme.of(context)
                                      .primaryTextTheme
                                      .caption
                                      .copyWith(color: Colors.white)),
                              badgeColor: CustomColor.colorAccent,
                              child: Icon(
                                Icons.notifications_active,
                                color: CustomColor.colorPrimaryDark,
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () async {
                              prefs = await SharedPreferences.getInstance();
                              print("vikkkkkkkkkkkkkkkkkkkkkk");
                              print('${prefs.getString('id')}');
                              showItemSelectionDialog(context);
                            },
                            child: Icon(
                              Icons.chat,
                              color: CustomColor.colorPrimaryDark,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.of(context)
                                  .pushNamed(UpcomingEvents.routeName)
                                  .then((value) {
                                if (value) {
                                  setState(() {});
                                }
                              });
                            },
                            child: Icon(
                              Icons.event,
                              color: CustomColor.colorPrimaryDark,
                            ),
                            // child: Text(
                            //   'Upcoming Events',
                            //   style: TextStyle(
                            //     color: Colors.grey,
                            //     fontSize: 14.0,
                            //     fontWeight: FontWeight.bold,
                            //   ),
                            // ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.of(context)
                                  .pushNamed(EditProfilePage.routeName)
                                  .then((value) {
                                if (value) {
                                  setState(() {});
                                  getNotificationList();
                                }
                              });
                            },
                            child: Icon(
                              Icons.edit,
                              color: CustomColor.colorPrimaryDark,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              /*   Navigator.of(context).pushNamed(
                                  SettingsPage.routeName,
                                  arguments: true); .then((value) {
                              print(
                              '-------------------*************---------------------');
                              getNotificationList();
                              });*/
                              Navigator.of(context)
                                  .push(MaterialPageRoute(
                                builder: (context) => SettingsPage(),
                              ))
                                  .then((value) {
                                print(
                                    '-------------------*************---------------------');
                                getNotificationList();
                              });
                            },
                            child: Icon(
                              Icons.settings,
                              color: CustomColor.colorPrimaryDark,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: DefaultTabController(
                  length: 3,
                  initialIndex: 0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TabBar(
                        indicatorWeight: 0.0,
                        indicatorColor: Colors.transparent,
                        isScrollable: false,
                        unselectedLabelColor: Colors.grey,
                        indicator: ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              0.0,
                            ),
                          ),
                          gradient: _accountType == AccountType.BUSINESS
                              ? LinearGradient(colors: [
                                  CustomColor.colorAccent,
                                  CustomColor.colorAccent,
                                ])
                              : _accountType == AccountType.PREMIUM
                                  ? LinearGradient(
                                      colors: [
                                        Colors.orange,
                                        Colors.deepOrange,
                                      ],
                                    )
                                  : LinearGradient(
                                      colors: [
                                        CustomColor.colorAccent,
                                        CustomColor.colorPrimary,
                                      ],
                                    ),
                        ),
                        tabs: [
                          Container(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12.0, vertical: 6.0),
                              child: Icon(
                                Icons.camera_alt,
                                size: 35.0,
                                color: Colors.grey.shade400,
                              ),
                            ),
                          ),
                          Container(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12.0, vertical: 6.0),
                              child: Icon(
                                Icons.videocam_outlined,
                                size: 35.0,
                                color: Colors.grey.shade400,
                              ),
                            ),
                          ),
                          if (_accountType == "1" || _accountType == "2")
                            Container(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0, vertical: 6.0),
                                child: Image.asset(
                                  homeTag,
                                  height: 35,
                                  width: 35,
                                  color: Colors.grey.shade400,
                                ),
                              ),
                            ),
                          if (_accountType == "0")
                            Container(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0, vertical: 6.0),
                                child: Image.asset(
                                  sml_glass,
                                  height: 35,
                                  width: 35,
                                ),
                              ),
                            ),
                        ],
                      ),
                      Expanded(
                        child: TabBarView(
                          children: [
                            MemoryPageImage(),
                            MemoryPageVideo(),
                            if (_accountType == "1" || _accountType == "2")
                              Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      CustomColor.colorAccent.withOpacity(0.4),
                                      CustomColor.colorPrimaryDark
                                          .withOpacity(0.4),
                                    ],
                                  ),
                                ),
                                child: Center(
                                    child: Text(
                                  "No data Found!",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black),
                                )),
                              ),
                            if (_accountType == "0") MemoryPageEmoG(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          FloatingMenu(
            menuList: floatMenuList,
            callback: this,
            btnBackgroundColor: CustomColor.colorPrimary,
            preMenuIcon: Icons.menu,
            postMenuIcon: Icons.close,
          ),
        ],
      ),
    );
  }

  Future showItemSelectionDialog(BuildContext context) async {
    return await showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: const Text('Select type '),
            children: [
              SimpleDialogOption(
                padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 24.0),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Chat_gruop_list()),
                  );
                },
                child: const Text('Chat'),
              ),
              SimpleDialogOption(
                padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 24.0),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CreateBroadcastMessage()),
                  );
                },
                child: const Text('Broadcast Message'),
              )
            ],
          );
        });
  }

  @override
  void onMenuClick(FloatingMenuItem floatingMenuItem) {
    print("onMenuClicked : " + floatingMenuItem.id.toString());
    switch (floatingMenuItem.id) {
      case 1:
        {
          PermissionUtil.checkPermission(Theme.of(context).platform).then(
            (hasGranted) {
              if (hasGranted != null && hasGranted) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CameraPage()),
                );
                // CommonDialogUtil
                //     .uploadImageAndVideoFromCameraOrGalleryCommonModalBottomSheet(
                //   context: context,
                //   picker: picker,
                //   onImageSelected: onImageSelected,
                //   onVideoSelected: onVideoSelected,
                //   onCameraTap: onCameraTap,
                // );
              }
            },
          );
        }
        break;
      case 2:
        {
          Navigator.of(context).pushNamed(FriendFeedPage.routeName);

          // centerText = "Map";
        }
        break;
      case 3:
        {
          Navigator.of(context).pushNamed(FriendsPage.routeName);

          // centerText = "Map";
        }
        break;
      case 4:
        {
          openOrderDialog();

          // centerText = "Map";
        }
        break;
      case 5:
        {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => MenuList(),
          ));

          // centerText = "Map";
        }
        break;
      case 6:
        {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => RestaurantList(),
          ));
          // centerText = "Map";
        }
        break;
      case 7:
        {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => TableList(),
          ));

          // centerText = "Map";
        }
        break;
    }

    setState(() {});
  }

  openOrderDialog() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            contentPadding: EdgeInsets.only(top: 10.0),
            content: Container(
              width: 400.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        "Order Options",
                        style: TextStyle(fontSize: 24.0),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => user.accountType == "0"
                            ? OrderUserList()
                            : OrderList(),
                      ));
                    },
                    child: Container(
                      margin: EdgeInsets.all(10.0),
                      height: 40,
                      padding: EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.all(Radius.circular(32.0)),
                      ),
                      child: Text(
                        user.accountType == "0" ? "My Orders" : "Orders",
                        style: TextStyle(color: Colors.white, fontSize: 14),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => user.accountType == "0"
                            ? BookingUserList()
                            : BookingList(),
                      ));
                    },
                    child: Container(
                      height: 40,
                      margin: EdgeInsets.all(10.0),
                      padding: EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.all(Radius.circular(32.0)),
                      ),
                      child: Text(
                        user.accountType == "0" ? "My Bookings" : "Bookings",
                        style: TextStyle(color: Colors.white, fontSize: 14),
                        textAlign: TextAlign.center,
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
        });
  }
}
