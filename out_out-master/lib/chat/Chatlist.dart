import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:out_out/api/api_implementer.dart';
import 'package:out_out/chat/chat.dart';
import 'package:out_out/chat/chatgruop.dart';
import 'package:out_out/chat/model/user_chat.dart';
import 'package:out_out/chat/select_friend.dart';
import 'package:out_out/chat/widget/full_photo.dart';
import 'package:out_out/chat/widget/loading.dart';
import 'package:out_out/models/ChatGruoplist.dart' as ChatGruoplist;
import 'package:out_out/outfit_story/image_preview.dart';
import 'package:out_out/outfit_story/story_page.dart';
import 'package:out_out/pages/memory_page/memory_page.dart';
import 'package:out_out/providers/common_details_provider.dart';
import 'package:out_out/utils/commona_utils.dart';
import 'package:out_out/utils/custom_colors.dart';
import 'package:out_out/utils/icon_utils.dart';
import 'package:out_out/utils/permission_util.dart';
import 'package:out_out/utils/preferences_constants.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Creategruop.dart';
import 'const.dart';

class Chat_gruop_list extends StatefulWidget {
  static const routeName = '/Chat_gruop_list-page-screen';
  @override
  State createState() => Chat_gruop_listState();
}

class Chat_gruop_listState extends State<Chat_gruop_list> {
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final ScrollController listScrollController = ScrollController();
  int _limit = 20;
  int _limitIncrement = 20;
  bool isLoading = false;
  List<ChatGruoplist.ChatData> search = new List();
  SharedPreferences _sharedPreferences;
  bool _isLoading = false;
  RxString _profileUrl = ''.obs;
  RxString _userName = ''.obs;
  RxString _city = ''.obs;
  RxString _birthDate = ''.obs;
  String _accessToken = '';
  String _userId = '';
  final picker = ImagePicker();
  User user;

  File imageFile;
  String imageUrl = "";
  // static   List<ChatGruoplist.ChatData> _chatGruoplist =  new List();
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
      _accessToken = _sharedPreferences.get(PreferenceConstants.ACCESS_TOKEN);
      _userId = _sharedPreferences.get(PreferenceConstants.USER_ID);
    }
    _isLoading = true;
    super.didChangeDependencies();
  }

  void Function_getData(String userid) {
    user = Provider.of<CommonDetailsProvider>(context, listen: false).user;
    print(_accessToken);
    ApiImplementer.ListChatGroupsApiImplementer(
            accessToken: user.accessToken, userid: user.userId)
        .then((value) {
      if (value != null) {
        setState(() {
          print(value.toString());
          //   ChatGruoplist.Data _value =value;
          print(value.chatData.toString());
          var setdata =
              Provider.of<CommonDetailsProvider>(context, listen: false);
          setdata.getchatdatalist.clear();
          value.chatData.map((e) {
            setState(() {
              setdata.Fun_chatdata(e);
            });
          }).toList();
          search.addAll(value.chatData);
          //  _chatGruoplist.addAll(value.chatData);
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    registerNotification();
    configLocalNotification();

    Function_getData(_userId.toString());
    //  Navigator.of(context).pop();
  }

  void registerNotification() {
    firebaseMessaging.requestPermission();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('onMessage: $message');
      if (message.notification != null) {
        showNotification(message.notification);
      }
      return;
    });

    firebaseMessaging.getToken().then((token) {
      print('token: $token');
      print('_userId: $_userId');
      FirebaseFirestore.instance
          .collection('users')
          .doc(_userId)
          .update({'pushToken': token});
    }).catchError((err) {
      Fluttertoast.showToast(msg: err.message.toString());
    });
  }

  void configLocalNotification() {
    AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings();
    InitializationSettings initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void scrollListener() {
    if (listScrollController.offset >=
            listScrollController.position.maxScrollExtent &&
        !listScrollController.position.outOfRange) {
      setState(() {
        _limit += _limitIncrement;
      });
    }
  }

  void showNotification(RemoteNotification remoteNotification) async {
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      Platform.isAndroid ? 'ccom.outout.outout' : 'com.duytq.flutterchatdemo',
      'Flutter chat demo',
      'your channel description',
      playSound: true,
      enableVibration: true,
      importance: Importance.max,
      priority: Priority.high,
    );
    IOSNotificationDetails iOSPlatformChannelSpecifics =
        IOSNotificationDetails();
    NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);

    print(remoteNotification);

    // await flutterLocalNotificationsPlugin.show(
    //   0,
    //   remoteNotification.title,
    //   remoteNotification.body,
    //   platformChannelSpecifics,
    //   payload: null,
    // );
  }

  Future<bool> onBackPress() {
    Navigator.of(context).pushNamed(MemoryPage.routeName);
    // openDialog();
    return Future.value(false);
  }

  onChanged(String value) {
    var setdata = Provider.of<CommonDetailsProvider>(context, listen: false);
    setdata.getchatdatalist.clear();
    search.forEach((item) {
      String q1 = item.chatname;

      setState(() {
        if (q1.toLowerCase().contains(value.toLowerCase())) {
          print('search item name ${item.chatname} == ${value} ');
          setdata.getchatdatalist.add(item);
        }
      });
    });
  }

  TextEditingController _groupcontroller = new TextEditingController();

  Future getCamera() async {
    ImagePicker imagePicker = ImagePicker();
    PickedFile pickedFile;

    pickedFile = await imagePicker.getImage(source: ImageSource.camera);
    if (pickedFile != null) {
      imageFile = File(pickedFile.path);
      if (imageFile != null) {
        // setState(() {
        //   isLoading = true;
        // });
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ImagePreviewPage(
                  provider: FileImage(imageFile), path: imageFile),
            ));
        // uploadFile();
      }
    }
  }

  Future uploadFile() async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference reference = FirebaseStorage.instance.ref().child(fileName);
    UploadTask uploadTask = reference.putFile(imageFile);

    try {
      TaskSnapshot snapshot = await uploadTask;
      imageUrl = await snapshot.ref.getDownloadURL();
      setState(() {
        isLoading = false;
        // onSendMessage(imageUrl, 1);
      });
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FullPhotoScreen(),
          ));
    } on FirebaseException catch (e) {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: e.message ?? e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CommonDetailsProvider>(
        builder: (BuildContext context, value, Widget child) {
      return Scaffold(
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
            // Navigator.push(context, MaterialPageRoute(builder: (context) => Chat(),));

            PermissionUtil.checkPermission(Theme.of(context).platform).then(
              (hasGranted) {
                if (hasGranted != null && hasGranted) {
                  getCamera();
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
          },
          elevation: 10.0,
        ),
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
              Navigator.of(context).pushNamed(MemoryPage.routeName);
            },
          ),
          title: Container(height: 70, child: Image.asset(out_out_actionbar)),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(60.0), // here the desired height
            child: Container(
              decoration: new BoxDecoration(
                  gradient: LinearGradient(colors: [
                    CustomColor.colorAccent,
                    CustomColor.colorPrimaryDark,
                  ]),
                  boxShadow: [
                    new BoxShadow(
                      // color: Colors.grey[500],
                      blurRadius: 20.0,
                      spreadRadius: 1.0,
                    )
                  ]),
              child: Column(
                children: [
                  ListTile(
                      // backgroundColor: Colors.grey,
                      leading: IconButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SelectFriendPage(),
                                )).then((value) {
                              if (value != null) {
                                // Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder: (context) => Chat(
                                //             isNewChat: true,
                                //             peerId: value.userId,
                                //             peerAvatar: value.profileImage)));
                              }
                            });
                          },
                          icon: Icon(
                            Icons.message,
                            size: 30,
                            color: Colors.white,
                          )),
                      title: Container(
                        height: 40,
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20)),
                        child: TextField(
                          onChanged: onChanged,
                          showCursor: false,
                          decoration: new InputDecoration(
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              alignLabelWithHint: true,
                              contentPadding: EdgeInsets.only(
                                  left: 15, bottom: 11, right: 15),
                              hintText: "Search here"),
                        ),
                      ),
                      //centerTitle: true,

                      trailing: IconButton(
                          onPressed: () {
                            showModalBottomSheet(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                backgroundColor: Colors.white,
                                context: context,
                                builder: (context) {
                                  return Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.45,
                                    child: Column(
                                      children: [
                                        Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.30,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 28.0),
                                            child: TextFormField(
                                              controller: _groupcontroller,
                                              decoration: InputDecoration(
                                                  labelText:
                                                      'Enter Group Name ',
                                                  labelStyle: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 14)),
                                            ),
                                          ),
                                        ),
                                        FlatButton(
                                            onPressed: () {
                                              setState(() {
                                                ApiImplementer
                                                        .CreateGroupApiImplementer(
                                                            accessToken:
                                                                _accessToken,
                                                            userid: _userId,
                                                            name:
                                                                _groupcontroller
                                                                    .text)
                                                    .then((value) =>
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  add_Frnds_gruop(
                                                                    gruopId:
                                                                        value[0]
                                                                            .id,
                                                                  )),
                                                        ));
                                                _groupcontroller.clear();
                                              });
                                            },
                                            child: Container(
                                                color: Colors.black,
                                                height: 50,
                                                width: 120,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Center(
                                                      child: Text(
                                                    "Save",
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  )),
                                                )))
                                      ],
                                    ),
                                  );
                                });

                            //  CreateGruopAlertDialog(context);
                          },
                          icon: Icon(
                            Icons.group_add,
                            size: 35,
                            color: Colors.white,
                          ))),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 20,
                    color: Colors.black,
                    child: Center(
                        child: Text(
                      'Current Chats',
                      style: TextStyle(color: Colors.white),
                    )),
                  )
                ],
              ),
            ),
          ),
        ),
        body: value.getchatdatalist == null
            ? Loading()
            : value.getchatdatalist.isEmpty
                ? Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: Center(
                      heightFactor: MediaQuery.of(context).size.height - 0,
                      widthFactor: MediaQuery.of(context).size.width - 0,
                      child: Text(
                          "Create Group or Message a New friend to see chat here"),
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: value.getchatdatalist.length,
                    itemBuilder: (context, index) {
                      ChatGruoplist.ChatData item =
                          value.getchatdatalist.elementAt(index);
                      return Container(
                        child: Column(
                          children: [
                            TextButton(
                              child: Row(
                                children: <Widget>[
                                  Material(
                                    child: value.getchatdatalist.length != 0
                                        ? Image.network(
                                            value.getchatdatalist[index]
                                                .chatImage,
                                            fit: BoxFit.fill,
                                            width: 60.0,
                                            height: 60.0,
                                            loadingBuilder:
                                                (BuildContext context,
                                                    Widget child,
                                                    ImageChunkEvent
                                                        loadingProgress) {
                                              if (loadingProgress == null)
                                                return child;
                                              return Container(
                                                width: 50,
                                                height: 50,
                                                child: Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                    color: primaryColor,
                                                    value: loadingProgress
                                                                    .expectedTotalBytes !=
                                                                null &&
                                                            loadingProgress
                                                                    .expectedTotalBytes !=
                                                                null
                                                        ? loadingProgress
                                                                .cumulativeBytesLoaded /
                                                            loadingProgress
                                                                .expectedTotalBytes
                                                        : null,
                                                  ),
                                                ),
                                              );
                                            },
                                            errorBuilder:
                                                (context, object, stackTrace) {
                                              return Container(
                                                width: 70,
                                                height: 64,
                                                //BoxDecoration Widget
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    width: 3,
                                                    color: CustomColor
                                                        .colorPrimaryDark,
                                                  ), //Border.all
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                ), //BoxDecoration
                                                child: Obx(
                                                  () => ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                    child: CachedNetworkImage(
                                                      errorWidget:
                                                          (context, _, error) =>
                                                              Image.asset(
                                                                  test_image),
                                                      placeholder:
                                                          (context, _) =>
                                                              Image.asset(
                                                                  test_image),
                                                      imageUrl:
                                                          _profileUrl.value,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                          )
                                        : Icon(
                                            Icons.account_circle,
                                            size: 50.0,
                                            color: greyColor,
                                          ),
                                    //  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                    clipBehavior: Clip.hardEdge,
                                  ),
                                  Flexible(
                                    child: Container(
                                      child: Column(
                                        children: <Widget>[
                                          Container(
                                            child: Text(
                                              '${value.getchatdatalist[index].chatname}',
                                              maxLines: 1,
                                              style: TextStyle(
                                                  color: primaryColor,
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            alignment: Alignment.centerLeft,
                                            margin: EdgeInsets.fromLTRB(
                                                0.0, 0.0, 0.0, 5.0),
                                          ),
                                          Container(
                                            child: Text(
                                              'sent 3 hours ago',
                                              maxLines: 1,
                                              style: TextStyle(
                                                  color: primaryColor),
                                            ),
                                            alignment: Alignment.centerLeft,
                                            margin: EdgeInsets.fromLTRB(
                                                0.0, 0.0, 0.0, 0.0),
                                          )
                                        ],
                                      ),
                                      margin: EdgeInsets.only(left: 20.0),
                                    ),
                                  ),
                                  item.chatType ==
                                              CommonUtils
                                                  .CHAT_TYPE_INDIVIDUAL &&
                                          item.story != null &&
                                          item.story == "1"
                                      ? IconButton(
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      StoryViewPage(
                                                    userId: value
                                                        .getchatdatalist[index]
                                                        .chatid,
                                                    title:
                                                        '${value.getchatdatalist[index].chatname}',
                                                  ),
                                                ));
                                          },
                                          icon: Image.asset(hanger_icon))
                                      : Container()
                                ],
                              ),
                              onPressed: () {
                                if (value.getchatdatalist[index].chatType ==
                                    CommonUtils.CHAT_TYPE_INDIVIDUAL) {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Chat(
                                          isNewChat: false,
                                          peerId: value
                                              .getchatdatalist[index].chatid,
                                          peerName: value
                                              .getchatdatalist[index].chatname,
                                          peerAvatar: value
                                              .getchatdatalist[index].chatImage,
                                        ),
                                      ));
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Chatgruop(
                                        chatData: value
                                            .getchatdatalist[index].memberlist,
                                        chatName: value
                                            .getchatdatalist[index].chatname,
                                        chatTotalM: value
                                            .getchatdatalist[index].members
                                            .toString(),
                                        chatId:
                                            value.getchatdatalist[index].chatid,
                                        chatAvatar: value
                                            .getchatdatalist[index].chatImage,
                                      ),
                                    ),
                                  );
                                }
                              },
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        greyColor2),
                                shape:
                                    MaterialStateProperty.all<OutlinedBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                  ),
                                ),
                              ),
                            ),
                            Divider()
                          ],
                        ),
                        margin: EdgeInsets.only(
                            bottom: 10.0, left: 5.0, right: 5.0),
                      );
                    }),
      );
    });
  }

  Widget buildItem(BuildContext context, DocumentSnapshot document) {
    if (document != null) {
      UserChat userChat = UserChat.fromDocument(document);
      if (userChat.id == _userId) {
        return SizedBox.shrink();
      } else {
        return Container(
          child: Column(
            children: [
              TextButton(
                child: Row(
                  children: <Widget>[
                    Material(
                      child: userChat.photoUrl.isNotEmpty
                          ? Image.network(
                              userChat.photoUrl,
                              fit: BoxFit.fill,
                              width: 60.0,
                              height: 60.0,
                              loadingBuilder: (BuildContext context,
                                  Widget child,
                                  ImageChunkEvent loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Container(
                                  width: 50,
                                  height: 50,
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      color: primaryColor,
                                      value: loadingProgress
                                                      .expectedTotalBytes !=
                                                  null &&
                                              loadingProgress
                                                      .expectedTotalBytes !=
                                                  null
                                          ? loadingProgress
                                                  .cumulativeBytesLoaded /
                                              loadingProgress.expectedTotalBytes
                                          : null,
                                    ),
                                  ),
                                );
                              },
                              errorBuilder: (context, object, stackTrace) {
                                return Icon(
                                  Icons.account_circle,
                                  size: 50.0,
                                  color: greyColor,
                                );
                              },
                            )
                          : Icon(
                              Icons.account_circle,
                              size: 50.0,
                              color: greyColor,
                            ),
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      clipBehavior: Clip.hardEdge,
                    ),
                    Flexible(
                      child: Container(
                        child: Column(
                          children: <Widget>[
                            Container(
                              child: Text(
                                '${userChat.nickname}',
                                maxLines: 1,
                                style: TextStyle(
                                    color: primaryColor,
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold),
                              ),
                              alignment: Alignment.centerLeft,
                              margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 5.0),
                            ),
                            Container(
                              child: Text(
                                'sent 3 hours ago',
                                maxLines: 1,
                                style: TextStyle(color: primaryColor),
                              ),
                              alignment: Alignment.centerLeft,
                              margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                            )
                          ],
                        ),
                        margin: EdgeInsets.only(left: 20.0),
                      ),
                    ),
                  ],
                ),
                onPressed: () {},
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(greyColor2),
                  shape: MaterialStateProperty.all<OutlinedBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                ),
              ),
              Divider()
            ],
          ),
          margin: EdgeInsets.only(bottom: 10.0, left: 5.0, right: 5.0),
        );
      }
    } else {
      return SizedBox.shrink();
    }
  }

  bool isSelected = false;
  Widget buildIteml(BuildContext context, DocumentSnapshot document) {
    if (document != null) {
      UserChat userChat = UserChat.fromDocument(document);
      if (userChat.id == _userId) {
        return SizedBox.shrink();
      } else {
        return Ink(
          color: isSelected ? Colors.blue : Colors.transparent,
          child: Container(
            child: Column(
              children: [
                TextButton(
                  child: Row(
                    children: <Widget>[
                      Material(
                        child: userChat.photoUrl.isNotEmpty
                            ? Image.network(
                                userChat.photoUrl,
                                fit: BoxFit.fill,
                                width: 60.0,
                                height: 60.0,
                                loadingBuilder: (BuildContext context,
                                    Widget child,
                                    ImageChunkEvent loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return Container(
                                    width: 50,
                                    height: 50,
                                    child: Center(
                                      child: CircularProgressIndicator(
                                        color: primaryColor,
                                        value: loadingProgress
                                                        .expectedTotalBytes !=
                                                    null &&
                                                loadingProgress
                                                        .expectedTotalBytes !=
                                                    null
                                            ? loadingProgress
                                                    .cumulativeBytesLoaded /
                                                loadingProgress
                                                    .expectedTotalBytes
                                            : null,
                                      ),
                                    ),
                                  );
                                },
                                errorBuilder: (context, object, stackTrace) {
                                  return Icon(
                                    Icons.account_circle,
                                    size: 50.0,
                                    color: greyColor,
                                  );
                                },
                              )
                            : Icon(
                                Icons.account_circle,
                                size: 50.0,
                                color: greyColor,
                              ),
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        clipBehavior: Clip.hardEdge,
                      ),
                      Flexible(
                        child: Container(
                          child: Column(
                            children: <Widget>[
                              Container(
                                child: Text(
                                  '${userChat.nickname}',
                                  maxLines: 1,
                                  style: TextStyle(
                                      color: primaryColor,
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold),
                                ),
                                alignment: Alignment.centerLeft,
                                margin:
                                    EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 5.0),
                              ),
                              Container(
                                child: Text(
                                  ' ${userChat.aboutMe}',
                                  maxLines: 1,
                                  style: TextStyle(color: primaryColor),
                                ),
                                alignment: Alignment.centerLeft,
                                margin:
                                    EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                              )
                            ],
                          ),
                          margin: EdgeInsets.only(left: 20.0),
                        ),
                      ),
                    ],
                  ),
                  onPressed: () {
                    /*  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Chat(

                          peerId: userChat.id,
                          peerAvatar: userChat.photoUrl,
                        ),
                      ),
                    );*/
                  },
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(greyColor2),
                    shape: MaterialStateProperty.all<OutlinedBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                    ),
                  ),
                ),
                Divider()
              ],
            ),
            margin: EdgeInsets.only(bottom: 10.0, left: 5.0, right: 5.0),
          ),
        );
      }
    } else {
      return SizedBox.shrink();
    }
  }
}

class Choice {
  const Choice({this.title, this.icon});
  final String title;
  final IconData icon;
}
