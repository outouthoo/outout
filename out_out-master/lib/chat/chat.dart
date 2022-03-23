import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:out_out/api/api_implementer.dart';
import 'package:out_out/chat/widget/full_photo.dart';
import 'package:out_out/chat/widget/loading.dart';
import 'package:out_out/pages/common/login_page.dart';
import 'package:out_out/providers/common_details_provider.dart';
import 'package:out_out/utils/common_dialog_util.dart';
import 'package:out_out/utils/commona_utils.dart';
import 'package:out_out/utils/custom_colors.dart';
import 'package:out_out/utils/icon_utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import 'SoundPlayer/SoundPlayerPro.dart';
import 'VideoPreview.dart';
import 'audioRecorder.dart';
import 'const.dart';

class Chat extends StatelessWidget {
  final bool isNewChat;
  final String peerId;
  final String peerName;
  final String peerAvatar;

  Chat({Key key, this.peerId, this.peerAvatar, this.isNewChat, this.peerName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black12,
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
            Navigator.of(context).pop();
          },
        ),
        title: Container(height: 70, child: Image.asset(out_out_actionbar)),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60.0), // here the desired height
          child: Container(
            decoration: new BoxDecoration(
                gradient: new LinearGradient(colors: [
                  Color(0xFFD6D6D6),
                  Color(0xFFD6D6D6),
                ]),
                boxShadow: [
                  new BoxShadow(
                      // color: Colors.grey[500],
                      // blurRadius: 20.0,
                      // spreadRadius: 1.0,
                      )
                ]),
            child: Column(
              children: [
                SizedBox(
                  height: 5,
                ),
                ListTile(
                    leading: Image.network(
                      peerAvatar,
                      fit: BoxFit.fill,
                      width: 50.0,
                      height: 60.0,
                      loadingBuilder: (BuildContext context, Widget child,
                          ImageChunkEvent loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          width: 50,
                          height: 50,
                          child: Center(
                            child: CircularProgressIndicator(
                              color: primaryColor,
                              value: loadingProgress.expectedTotalBytes !=
                                          null &&
                                      loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes
                                  : null,
                            ),
                          ),
                        );
                      },
                      errorBuilder: (context, object, stackTrace) {
                        return Container(
                          width: 65,
                          height: 64,
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
                                  Image.asset(test_image),
                              placeholder: (context, _) =>
                                  Image.asset(test_image),
                              imageUrl: peerAvatar,
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                    ),
                    title: Text(
                      peerName,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          foreground: Paint()
                            ..shader = LinearGradient(
                              colors: <Color>[
                                CustomColor.colorAccent,
                                CustomColor.colorPrimaryDark,
                              ],
                            ).createShader(
                                Rect.fromLTWH(0.0, 0.0, 200.0, 70.0))),
                    )
                    // backgroundColor: Colors.grey,
                    ),
                SizedBox(
                  height: 5,
                )
              ],
            ),
          ),
        ),
      ),
      body: ChatScreen(
        isNewChat: isNewChat,
        peerId: peerId,
        peerAvatar: peerAvatar,
      ),
    );
  }
}

class ChatScreen extends StatefulWidget {
  final bool isNewChat;
  final String peerId;
  final String peerAvatar;

  ChatScreen({Key key, this.peerId, this.peerAvatar, this.isNewChat})
      : super(key: key);

  @override
  State createState() =>
      ChatScreenState(peerId: peerId, peerAvatar: peerAvatar);
}

class ChatScreenState extends State<ChatScreen> {
  User _user;

  ChatScreenState({Key key, this.peerId, this.peerAvatar});

  String peerId;
  String peerAvatar;
  String id;

  List<QueryDocumentSnapshot> listMessage = new List.from([]);
  int _limit = 20;
  int _limitIncrement = 20;
  String groupChatId = "";
  SharedPreferences prefs;

  File imageFile;
  bool isMsgSentOnce = false;
  bool isLoading = false;
  bool isShowSticker = false;
  String imageUrl = "";
  SharedPreferences _sharedPreferences;

  final TextEditingController textEditingController = TextEditingController();
  final ScrollController listScrollController = ScrollController();
  final FocusNode focusNode = FocusNode();
  String nickname = '';
  String aboutMe = '';
  String photoUrl = '';

  _scrollListener() {
    if (listScrollController.offset >=
            listScrollController.position.maxScrollExtent &&
        !listScrollController.position.outOfRange) {
      setState(() {
        _limit += _limitIncrement;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _user = Provider.of<CommonDetailsProvider>(context, listen: false).user;
    focusNode.addListener(onFocusChange);
    listScrollController.addListener(_scrollListener);
    readLocal();
  }

  void onFocusChange() {
    if (focusNode.hasFocus) {
      // Hide sticker when keyboard appear
      setState(() {
        isShowSticker = false;
      });
    }
  }

  readLocal() async {
    prefs = await SharedPreferences.getInstance();
    id = prefs?.getString('id') ?? '';
    nickname = prefs?.getString('nickname') ?? '';
    aboutMe = prefs?.getString('aboutMe') ?? '';
    photoUrl = prefs?.getString('photoUrl') ?? '';
    prefs = await SharedPreferences.getInstance();
    id = prefs?.getString('id') ?? '';
    if (id.hashCode <= peerId.hashCode) {
      groupChatId = '$id-$peerId';
    } else {
      groupChatId = '$peerId-$id';
    }

    try {
      FirebaseFirestore.instance
          .collection('users')
          .doc(id)
          .update({'chattingWith': peerId});
    } catch (e) {}

    setState(() {});
  }

  Future getImage() async {
    ImagePicker imagePicker = ImagePicker();
    PickedFile pickedFile;

    pickedFile = await imagePicker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      imageFile = File(pickedFile.path);
      if (imageFile != null) {
        setState(() {
          isLoading = true;
        });
        showOneTimeDialog(context, 1);
      }
    }
  }

  showOneTimeDialog(BuildContext context, int type) {
    // set up the button
    Widget okButton = TextButton(
      child: Text("Yes"),
      onPressed: () {
        uploadFile(type, true);
        Navigator.pop(context);
      },
    ); // set up the button
    Widget cancelButton = TextButton(
      child: Text("No"),
      onPressed: () {
        uploadFile(type, false);
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("One Time Message"),
      content: Text(
          "Are you sure recipient will able to open this message one time?"),
      actions: [okButton, cancelButton],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Future getCamera() async {
    ImagePicker imagePicker = ImagePicker();
    PickedFile pickedFile;

    pickedFile = await imagePicker.getImage(source: ImageSource.camera);
    if (pickedFile != null) {
      imageFile = File(pickedFile.path);
      if (imageFile != null) {
        setState(() {
          isLoading = true;
        });
        // uploadFile(1);
        showOneTimeDialog(context, 1);
      }
    }
  }

  getFileData(File image, {int timestamp, int totalFiles}) async {
    print("+++++++++++++++++++${image.path}");
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference reference = FirebaseStorage.instance.ref().child(fileName);
    UploadTask uploadTask = reference.putFile(image);

    try {
      TaskSnapshot snapshot = await uploadTask;
      imageUrl = await snapshot.ref.getDownloadURL();
      setState(() {
        isLoading = false;
        onSendMessage(imageUrl, 4, false);
      });
    } on FirebaseException catch (e) {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: e.message ?? e.toString());
    }
  }

  uploadAudio(url) async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference reference = FirebaseStorage.instance.ref().child(fileName);
    UploadTask uploadTask = reference.putFile(File(url));

    try {
      TaskSnapshot snapshot = await uploadTask;
      imageUrl = await snapshot.ref.getDownloadURL();
      setState(() {
        isLoading = false;
        onSendMessage(imageUrl, 4, false);
      });
    } on FirebaseException catch (e) {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: e.message ?? e.toString());
    }
  }

  Future getvideo() async {
    ImagePicker imagePicker = ImagePicker();
    PickedFile pickedFile;

    pickedFile = await imagePicker.getVideo(source: ImageSource.gallery);
    if (pickedFile != null) {
      imageFile = File(pickedFile.path);
      if (imageFile != null) {
        setState(() {
          isLoading = true;
        });
        // uploadFile(5);
        showOneTimeDialog(context, 5);
      }
    }
  }

  void getSticker() {
    // Hide keyboard when sticker appear
    focusNode.unfocus();
    setState(() {
      isShowSticker = !isShowSticker;
    });
  }

  Future uploadFile(int type, bool isOpenOnce) async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference reference = FirebaseStorage.instance.ref().child(fileName);
    UploadTask uploadTask = reference.putFile(imageFile);

    try {
      TaskSnapshot snapshot = await uploadTask;
      imageUrl = await snapshot.ref.getDownloadURL();
      setState(() {
        isLoading = false;
        onSendMessage(imageUrl, type, isOpenOnce);
      });
    } on FirebaseException catch (e) {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: e.message ?? e.toString());
    }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      CommonDialogUtil.showToastMsg(
          context: context,
          toastMsg:
              'Location permissions are pdenied. Please go to settings & allow location tracking permission.');
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        // Permissions are denied forever, handle appropriately.
        CommonDialogUtil.showToastMsg(
            context: context,
            toastMsg:
                'Location permissions are pdenied. Please go to settings & allow location tracking permission.');
        return Future.error(
            'Location permissions are permanently denied, we cannot request permissions.');
      }

      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        CommonDialogUtil.showToastMsg(
            context: context,
            toastMsg:
                'Location permissions are pdenied. Please go to settings & allow location tracking permission.');
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      CommonDialogUtil.showToastMsg(
          context: context, toastMsg: "Detecting Location");
    }
    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    var location = await Geolocator.getCurrentPosition();
    return location;
  }

  void onSendMessage(String content, int type, bool isOpenOnce) {
    // type: 0 = text, 1 = image, 2 = sticker, 3 = location, 4= Audio, 5= video
    if (widget.isNewChat) {
      ApiImplementer.AddFrndsingruopApiImplementer(
              accessToken: _user.accessToken,
              gruopid: 0,
              addusers: peerId,
              userid: _user.userId)
          .then((value) {
        if (value.errorcode == ApiImplementer.SUCCESS) {
          setState(() {
            isMsgSentOnce = true;
          });
        } else if (value.errorcode == "2") {
          print("logout");
          _sharedPreferences = Provider.of<CommonDetailsProvider>(context)
              .getPreferencesInstance;
          _sharedPreferences.clear();
             Navigator.of(context).pushNamedAndRemoveUntil(LoginScreen.routeName, (Route<dynamic> route) => false);
          CommonDialogUtil.showErrorSnack(context: context, msg: value.msg);
        }
      });
    }

    if (content.trim() != '') {
      textEditingController.clear();

      var documentReference = FirebaseFirestore.instance
          .collection('messages')
          .doc(groupChatId)
          .collection(groupChatId)
          .doc(DateTime.now().millisecondsSinceEpoch.toString());

      FirebaseFirestore.instance.runTransaction((transaction) async {
        transaction.set(
          documentReference,
          {
            'idFrom': id,
            'idTo': peerId,
            'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
            'content': content,
            'isOpenOnce': isOpenOnce,
            'isOpened': false,
            'type': type
          },
        );
      });
      listScrollController.animateTo(0.0,
          duration: Duration(milliseconds: 300), curve: Curves.easeOut);
    } else {
      Fluttertoast.showToast(
          msg: 'Nothing to send',
          backgroundColor: Colors.black,
          textColor: Colors.red);
    }
  }

  Widget buildItem(int index, DocumentSnapshot document) {
    if (document != null) {
      if (document.get('idFrom') == id) {
        // Right (my message)
        return Row(
          children: <Widget>[
            document.get('type') == 0
                // Text
                ? Container(
                    constraints: BoxConstraints(maxWidth: 200),
                    child: Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            document.get('content'),
                            style: TextStyle(color: primaryColor),
                          ),
                        ],
                      ),
                    ),
                    padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.0)),
                    margin: EdgeInsets.only(
                        bottom: isLastMessageRight(index) ? 10.0 : 10.0,
                        right: 10.0),
                  )
                : document.get('type') == 1
                    // Image
                    ? (document.get('isOpenOnce') == true
                        ? Container(
                            child: singleSendWidget(index),
                          )
                        : sendImageView(document, index))
                    // Sticker
                    : document.get('type') == 3
                        ? Container(
                            child: InkWell(
                              onTap: () {
                                print(document.get('content'));
                                launch(document.get('content'));
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: greyColor2,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8.0),
                                  ),
                                ),
                                child: Image.asset(
                                  'assets/images/mapview.jpg',
                                  height: 100,
                                  width: 130,
                                ),
                              ),
                            ),
                            margin: EdgeInsets.only(
                                bottom: isLastMessageRight(index) ? 20.0 : 10.0,
                                right: 10.0),
                          )
                        : document.get('type') == 4
                            ? Container(
                                child: SizedBox(
                                  width: 200,
                                  height: 80,
                                  child: MultiPlayback(
                                      url: document.get('content'),
                                      isMe: true,
                                      onTapDownloadFn: () {}),
                                ),
                                margin: EdgeInsets.only(
                                    bottom:
                                        isLastMessageRight(index) ? 20.0 : 10.0,
                                    right: 10.0),
                              )
                            : document.get('type') == 5
                                ? (document.get('isOpenOnce') == true
                ? Container(
              child: singleSendWidget(index),
            )
                : sendVideoView(document, index))
                                : Container(
                                    child: Image.asset(
                                      'images/${document.get('content')}.gif',
                                      width: 100.0,
                                      height: 100.0,
                                      fit: BoxFit.cover,
                                    ),
                                    margin: EdgeInsets.only(
                                        bottom: isLastMessageRight(index)
                                            ? 20.0
                                            : 10.0,
                                        right: 10.0),
                                  ),
            isLastMessageLeft(index)
                ? Material(
                    child: Image.network(
                      photoUrl,
                      loadingBuilder: (BuildContext context, Widget child,
                          ImageChunkEvent loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            color: primaryColor,
                            value: loadingProgress.expectedTotalBytes != null &&
                                    loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes
                                : null,
                          ),
                        );
                      },
                      errorBuilder: (context, object, stackTrace) {
                        return Icon(
                          Icons.account_circle,
                          size: 35,
                          color: greyColor,
                        );
                      },
                      width: 35,
                      height: 35,
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                    clipBehavior: Clip.hardEdge,
                  )
                : Container(width: 35.0),
          ],
          mainAxisAlignment: MainAxisAlignment.end,
        );
      } else {
        // Left (peer message)
        return Container(
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  isLastMessageLeft(index)
                      ? Material(
                          child: Image.network(
                            peerAvatar,
                            loadingBuilder: (BuildContext context, Widget child,
                                ImageChunkEvent loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
                                  color: primaryColor,
                                  value: loadingProgress.expectedTotalBytes !=
                                              null &&
                                          loadingProgress.expectedTotalBytes !=
                                              null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes
                                      : null,
                                ),
                              );
                            },
                            errorBuilder: (context, object, stackTrace) {
                              return Icon(
                                Icons.account_circle,
                                size: 35,
                                color: greyColor,
                              );
                            },
                            width: 35,
                            height: 35,
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(18.0),
                          ),
                          clipBehavior: Clip.hardEdge,
                        )
                      : Container(width: 35.0),
                  document.get('type') == 0
                      ? Container(
                          child: Text(
                            document.get('content'),
                            style: TextStyle(color: Colors.white),
                          ),
                          padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                          // width: 200.0,
                          constraints: BoxConstraints(maxWidth: 200),
                          decoration: BoxDecoration(
                              color: primaryColor,
                              borderRadius: BorderRadius.circular(8.0)),
                          margin: EdgeInsets.only(left: 10.0),
                        )
                      : document.get('type') == 1
                          ? (document.get('isOpenOnce') == true &&
                                  document.get('isOpened') == true
                              ? Container(
                                  child: singleOpenWidget(),
                                )
                              : receipientImageView(document))
                          : document.get('type') == 3
                              ? Container(
                                  child: InkWell(
                                    onTap: () {
                                      launch(document.get('content'));
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: primaryColor,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(8.0),
                                        ),
                                      ),
                                      child: Image.asset(
                                        'assets/images/mapview.jpg',
                                        height: 100,
                                        width: 130,
                                      ),
                                    ),
                                  ),
                                  margin: EdgeInsets.only(
                                      bottom: isLastMessageRight(index)
                                          ? 20.0
                                          : 10.0,
                                      right: 10.0),
                                )
                              : document.get('type') == 4
                                  ? Container(
                                      child: SizedBox(
                                        width: 200,
                                        height: 80,
                                        child: MultiPlayback(
                                            url: document.get('content'),
                                            isMe: false,
                                            onTapDownloadFn: () {}),
                                      ),
                                      margin: EdgeInsets.only(
                                          bottom: isLastMessageRight(index)
                                              ? 20.0
                                              : 10.0,
                                          right: 10.0),
                                    )
                                  : document.get('type') == 5
                                      ? (document.get('isOpenOnce') == true &&
                                              document.get('isOpened') == true
                                          ? Container(
                                              child: singleOpenWidget(),
                                            )
                                          : receipientVideoView(
                                              document, index))
                                      : Container(
                                          child: Image.asset(
                                            'images/${document.get('content')}.gif',
                                            width: 100.0,
                                            height: 100.0,
                                            fit: BoxFit.cover,
                                          ),
                                          margin: EdgeInsets.only(
                                              bottom: isLastMessageRight(index)
                                                  ? 20.0
                                                  : 10.0,
                                              right: 10.0),
                                        ),
                ],
              ),

              // Time
              isLastMessageLeft(index)
                  ? Container(
                      child: Text(
                        DateFormat('dd MMM kk:mm').format(
                            DateTime.fromMillisecondsSinceEpoch(
                                int.parse(document.get('timestamp')))),
                        style: TextStyle(
                            color: greyColor,
                            fontSize: 12.0,
                            fontStyle: FontStyle.italic),
                      ),
                      margin:
                          EdgeInsets.only(left: 50.0, top: 5.0, bottom: 5.0),
                    )
                  : Container()
            ],
            crossAxisAlignment: CrossAxisAlignment.start,
          ),
          margin: EdgeInsets.only(bottom: 10.0),
        );
      }
    } else {
      return SizedBox.shrink();
    }
  }

  Future<String> createThumbNil(param0) async {
    String thumb = await VideoThumbnail.thumbnailFile(
      thumbnailPath: (await getTemporaryDirectory()).path,
      video: '${param0}',
      imageFormat: ImageFormat.PNG,
      quality: 100,
    );
    // thumbFile = File(thumb);
    setState(() {});
    return thumb;
  }

  bool isLastMessageLeft(int index) {
    if ((index > 0 && listMessage[index - 1].get('idFrom') == id) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

  bool isLastMessageRight(int index) {
    if ((index > 0 && listMessage[index - 1].get('idFrom') != id) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> onBackPress() {
    if (isShowSticker) {
      setState(() {
        isShowSticker = false;
      });
    } else {
      FirebaseFirestore.instance
          .collection('users')
          .doc(id)
          .update({'chattingWith': null});
      Navigator.pop(context);
    }

    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              // List of messages
              buildListMessage(),

              // Sticker
              isShowSticker ? buildSticker() : Container(),

              // Input content
              buildInput(context),
            ],
          ),

          // Loading
          buildLoading()
        ],
      ),
      onWillPop: onBackPress,
    );
  }

  Widget buildSticker() {
    return Expanded(
      child: Container(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                TextButton(
                  onPressed: () => onSendMessage('mimi1', 2, false),
                  child: Image.asset(
                    'images/mimi1.gif',
                    width: 50.0,
                    height: 50.0,
                    fit: BoxFit.cover,
                  ),
                ),
                TextButton(
                  onPressed: () => onSendMessage('mimi2', 2, false),
                  child: Image.asset(
                    'images/mimi2.gif',
                    width: 50.0,
                    height: 50.0,
                    fit: BoxFit.cover,
                  ),
                ),
                TextButton(
                  onPressed: () => onSendMessage('mimi3', 2, false),
                  child: Image.asset(
                    'images/mimi3.gif',
                    width: 50.0,
                    height: 50.0,
                    fit: BoxFit.cover,
                  ),
                )
              ],
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            ),
            Row(
              children: <Widget>[
                TextButton(
                  onPressed: () => onSendMessage('mimi4', 2, false),
                  child: Image.asset(
                    'images/mimi4.gif',
                    width: 50.0,
                    height: 50.0,
                    fit: BoxFit.cover,
                  ),
                ),
                TextButton(
                  onPressed: () => onSendMessage('mimi5', 2, false),
                  child: Image.asset(
                    'images/mimi5.gif',
                    width: 50.0,
                    height: 50.0,
                    fit: BoxFit.cover,
                  ),
                ),
                TextButton(
                  onPressed: () => onSendMessage('mimi6', 2, false),
                  child: Image.asset(
                    'images/mimi6.gif',
                    width: 50.0,
                    height: 50.0,
                    fit: BoxFit.cover,
                  ),
                )
              ],
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            ),
            Row(
              children: <Widget>[
                TextButton(
                  onPressed: () => onSendMessage('mimi7', 2, false),
                  child: Image.asset(
                    'images/mimi7.gif',
                    width: 50.0,
                    height: 50.0,
                    fit: BoxFit.cover,
                  ),
                ),
                TextButton(
                  onPressed: () => onSendMessage('mimi8', 2, false),
                  child: Image.asset(
                    'images/mimi8.gif',
                    width: 50.0,
                    height: 50.0,
                    fit: BoxFit.cover,
                  ),
                ),
                TextButton(
                  onPressed: () => onSendMessage('mimi9', 2, false),
                  child: Image.asset(
                    'images/mimi9.gif',
                    width: 50.0,
                    height: 50.0,
                    fit: BoxFit.cover,
                  ),
                )
              ],
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            )
          ],
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        ),
        decoration: BoxDecoration(
            border: Border(top: BorderSide(color: greyColor2, width: 0.5)),
            color: Colors.white),
        padding: EdgeInsets.all(5.0),
        height: 180.0,
      ),
    );
  }

  Widget buildLoading() {
    return Positioned(
      child: isLoading ? const Loading() : Container(),
    );
  }

  Widget buildInput(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              // Button send image
              IconButton(
                icon: Icon(
                  Icons.camera_alt,
                  color: Colors.white,
                ),
                onPressed: getCamera,
                color: primaryColor,
              ),
              IconButton(
                icon: Icon(
                  Icons.video_call_outlined,
                  color: Colors.white,
                ),
                onPressed: getvideo,
                color: primaryColor,
              ),
              IconButton(
                icon: Icon(
                  Icons.image,
                  color: Colors.white,
                ),
                onPressed: getImage,
                color: primaryColor,
              ),
              IconButton(
                icon: Icon(
                  Icons.mic,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AudioRecord(
                                title: "Record",
                                callback: getFileData,
                              ))).then((url) {
                    if (url != null) {
                      if (url != null) {
                        // recordFilePath = url;
                        uploadAudio(url);
                      } else {}

                      /*    onSendMessage(
                          context,
                          url +
                              '-BREAK-' +
                              uploadTimestamp.toString(),
                          MessageType.audio,
                          uploadTimestamp);*/
                    } else {}
                  });
                } /*getSticker*/,
                color: primaryColor,
              ),
              IconButton(
                icon: Icon(
                  Icons.location_on,
                  color: Colors.white,
                ),
                onPressed: () async {
                  /*onSendMessage(textEditingController.text, 0)*/
                  await _determinePosition().then(
                    (location) async {
                      var locationstring =
                          'https://www.google.com/maps/search/?api=1&query=${location.latitude},${location.longitude}';
                      print(locationstring);
                      onSendMessage(locationstring, 3, false);
                    },
                  );
                },
                color: primaryColor,
              )
            ],
          ),
          Row(
            children: [
              Flexible(
                child: Container(
                  height: 44,
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20)),
                  child: Center(
                    child: TextField(
                      onSubmitted: (value) {
                        onSendMessage(textEditingController.text, 0, false);
                      },
                      style: TextStyle(color: primaryColor, fontSize: 15.0),
                      controller: textEditingController,
                      decoration: InputDecoration.collapsed(
                        hintText: 'Type your message...',
                        hintStyle: TextStyle(color: greyColor),
                      ),
                      focusNode: focusNode,
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.send,
                  color: Colors.white,
                ),
                onPressed: () =>
                    onSendMessage(textEditingController.text, 0, false),
                color: primaryColor,
              ),
            ],
          ),
        ],
      ),
      width: double.infinity,
      height: 100.0,
      decoration: new BoxDecoration(
          gradient:
              new LinearGradient(colors: [Colors.blue, Colors.deepPurple]),
          boxShadow: [
            new BoxShadow(
              // color: Colors.grey[500],
              blurRadius: 20.0,
              spreadRadius: 1.0,
            )
          ]),
    );
  }

  Widget buildListMessage() {
    print("BUILD MESSAGE:" + groupChatId);
    return Flexible(
      child: groupChatId.isNotEmpty
          ? StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('messages')
                  .doc(groupChatId)
                  .collection(groupChatId)
                  .orderBy('timestamp', descending: true)
                  .limit(_limit)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  listMessage.addAll(snapshot.data.docs);
                  return ListView.builder(
                    padding: EdgeInsets.all(10.0),
                    itemBuilder: (context, index) =>
                        buildItem(index, snapshot.data?.docs[index]),
                    itemCount: snapshot.data?.docs.length,
                    reverse: true,
                    controller: listScrollController,
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                    ),
                  );
                }
              },
            )
          : Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
              ),
            ),
    );
  }

  singleOpenWidget() {
    return Container(
      child: Row(
        children: [
          Image.asset(
            once,
            height: 20,
            width: 20,
            color: Colors.white,
          ),
          SizedBox(
            width: 10,
          ),
          Text(
            'Opened',
            style: TextStyle(color: Colors.white),
          )
        ],
      ),
      padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
      // width: 200.0,
      constraints: BoxConstraints(maxWidth: 130),
      decoration: BoxDecoration(
          color: primaryColor, borderRadius: BorderRadius.circular(8.0)),
      margin: EdgeInsets.only(left: 10.0),
    );
  }

  singleSendWidget(int index) {
    return Container(
      child: Row(
        children: [
          Image.asset(
            once,
            height: 20,
            width: 20,
            color: primaryColor,
          ),
          SizedBox(
            width: 10,
          ),
          Text(
            'Sended',
            style: TextStyle(color: primaryColor),
          )
        ],
      ),
      padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(8.0)),
      margin: EdgeInsets.only(
          bottom: isLastMessageRight(index) ? 10.0 : 10.0, right: 10.0),
    );
  }

  receipientImageView(DocumentSnapshot document) {
    var sigmaX = 0.0, sigmaY = 0.0;
    if (document.get('isOpenOnce')) {
      sigmaX = 8.0;
      sigmaY = 8.0;
    }

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FullPhoto(
              url: document.get('content'),
            ),
          ),
        );
        readViewCall(document);
      },
      child: Container(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),

          child: ImageFiltered(
            imageFilter: ImageFilter.blur(sigmaX: sigmaX, sigmaY: sigmaY),
            child: Image.network(
              document.get('content'),
              loadingBuilder: (BuildContext context, Widget child,
                  ImageChunkEvent loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  decoration: BoxDecoration(
                    color: greyColor2,
                  ),
                  width: 200.0,
                  height: 200.0,
                  child: Center(
                    child: CircularProgressIndicator(
                      color: primaryColor,
                      value: loadingProgress.expectedTotalBytes != null &&
                              loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes
                          : null,
                    ),
                  ),
                );
              },
              errorBuilder: (context, object, stackTrace) => Material(
                child: Image.asset(
                  'images/img_not_available.jpeg',
                  width: 200.0,
                  height: 200.0,
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(8.0),
                ),
                clipBehavior: Clip.hardEdge,
              ),
              width: 200.0,
              height: 200.0,
              fit: BoxFit.cover,
            ),
          ),
        ),
        margin: EdgeInsets.only(left: 10.0),
      ),
    );
  }

  receipientVideoView(DocumentSnapshot document, int index) {
    var sigmaX = 0.0, sigmaY = 0.0;
    if (document.get('isOpenOnce')) {
      sigmaX = 8.0;
      sigmaY = 8.0;
    }

    return Container(
      child: InkWell(
        onTap: () {
          Navigator.push(
              this.context,
              new MaterialPageRoute(
                  builder: (context) => new PreviewVideo(
                        videourl: document.get('content'),
                      )));
          readViewCall(document);

        },
        child: Container(
          height: 250,
          width: 230,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Stack(
              children: [
                CachedNetworkImage(
                  placeholder: (context, url) => Container(
                    child: CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Colors.blueGrey[400]),
                    ),
                    padding: EdgeInsets.all(80.0),
                    decoration: BoxDecoration(
                      color: Colors.blueGrey,
                      borderRadius: BorderRadius.all(
                        Radius.circular(0.0),
                      ),
                    ),
                  ),
                  errorWidget: (context, str, error) => Material(
                    child: Container(
                      width: 230,
                      height: 250,
                      child: Image.asset(
                        'assets/images/img_not_available.jpeg',
                        fit: BoxFit.cover,
                      ),
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(0.0),
                    ),
                    clipBehavior: Clip.hardEdge,
                  ),
                  imageUrl: document.get('content'),
                  fit: BoxFit.cover,
                ),
                // Image.file(File(await createThumbNil(document.get('content')),)),

                Container(
                  color: Colors.black.withOpacity(0.4),
                ),
                Center(
                  child: Icon(Icons.play_circle_fill_outlined,
                      color: Colors.white70, size: 65),
                ),
              ],
            ),
          ),
        ),
      ),
      margin: EdgeInsets.only(
          bottom: isLastMessageRight(index) ? 20.0 : 10.0, right: 10.0),
    );
  }

  sendImageView(DocumentSnapshot document, int index) {
    return Container(
      child: OutlinedButton(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.network(
            document.get("content"),
            loadingBuilder: (BuildContext context, Widget child,
                ImageChunkEvent loadingProgress) {
              if (loadingProgress == null) return child;
              return Container(
                decoration: BoxDecoration(
                  color: greyColor2,
                  borderRadius: BorderRadius.all(
                    Radius.circular(8.0),
                  ),
                ),
                width: 150.0,
                height: 150.0,
                child: Center(
                  child: CircularProgressIndicator(
                    color: primaryColor,
                    value: loadingProgress.expectedTotalBytes != null &&
                            loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes
                        : null,
                  ),
                ),
              );
            },
            errorBuilder: (context, object, stackTrace) {
              return Material(
                child: Image.asset(
                  'images/img_not_available.jpeg',
                  width: 200.0,
                  height: 200.0,
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(8.0),
                ),
                clipBehavior: Clip.hardEdge,
              );
            },
            width: 150.0,
            height: 150.0,
            fit: BoxFit.cover,
          ),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FullPhoto(
                url: document.get('content'),
              ),
            ),
          );
        },
        style: ButtonStyle(
            padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(0))),
      ),
      margin: EdgeInsets.only(
          bottom: isLastMessageRight(index) ? 20.0 : 10.0, right: 10.0),
    );
  }

  sendVideoView(DocumentSnapshot document, int index) {
    return Container(
      child: InkWell(
        onTap: () {
          Navigator.push(
              this.context,
              new MaterialPageRoute(
                  builder: (context) =>
                  new PreviewVideo(
                    videourl: document
                        .get('content'),
                  )));
        },
        child: Container(
          height: 250,
          width: 230,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Stack(
              children: [
                // Image.file(File()),

                CachedNetworkImage(
                  placeholder: (context, url) =>
                      Container(
                        height: 250,
                        width: 230,
                        child:
                        CircularProgressIndicator(
                          valueColor:
                          AlwaysStoppedAnimation<
                              Color>(
                              Colors.blueGrey[400]),
                        ),
                        padding: EdgeInsets.all(80.0),
                        decoration: BoxDecoration(
                          color: Colors.blueGrey,
                          borderRadius:
                          BorderRadius.all(
                            Radius.circular(0.0),
                          ),
                        ),
                      ),
                  errorWidget:
                      (context, str, error) =>
                      Material(
                        child: Container(
                          width: 230,
                          height: 250,
                          child: Image.asset(
                            'assets/images/img_not_available.jpeg',
                            fit: BoxFit.cover,
                          ),
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(0.0),
                        ),
                        clipBehavior: Clip.hardEdge,
                      ),
                  imageUrl: document.get('content'),
                  fit: BoxFit.cover,
                ),
                // Image.file(File(await createThumbNil(document.get('content')),)),

                Container(
                  color:
                  Colors.black.withOpacity(0.4),
                ),
                Center(
                  child: Icon(
                      Icons
                          .play_circle_fill_outlined,
                      color: Colors.white70,
                      size: 65),
                ),
              ],
            ),
          ),
        ),
      ),
      margin: EdgeInsets.only(
          bottom: isLastMessageRight(index)
              ? 20.0
              : 10.0,
          right: 10.0),
    );
  }

  void readViewCall(DocumentSnapshot document) {
    try {
      document.reference.update({
        'isOpened': true,
      });
    } catch (e) {
      print(e);
    }
  }
}
