import 'dart:async';
import 'dart:math' as math;

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;
import 'package:agora_rtm/agora_rtm.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:custom_timer/custom_timer.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:image_picker/image_picker.dart';
import 'package:out_out/Golive/firebaseDB/firestoreDB.dart';
import 'package:out_out/Golive/models/message.dart';
import 'package:out_out/Golive/models/user.dart' as User;
import 'package:out_out/Golive/utils/settings.dart';
import 'package:out_out/api/api_implementer.dart';
import 'package:out_out/models/friendList_model.dart' as FriendList;
import 'package:out_out/models/notifications/broadcast_message_notification.dart';
import 'package:out_out/pages/common/login_page.dart';
import 'package:out_out/providers/common_details_provider.dart' as Qser;
import 'package:out_out/utils/common_dialog_util.dart';
import 'package:out_out/utils/custom_colors.dart';
import 'package:out_out/utils/preferences_constants.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wakelock/wakelock.dart';

import '../HearAnim.dart';

class CallPage extends StatefulWidget {
  /// non-modifiable channel name of the page
  final String channelName;
  final String token;
  final String hostUserId;

  /// non-modifiable client role of the page
  final ClientRole role;
  final bool isHost;
  final String image;
  final time;

  /// Creates a call page with given channel name.
  const CallPage(
      {Key key,
      this.channelName,
      this.role,
      this.time,
      this.image,
      this.token,
      this.isHost,
      this.hostUserId})
      : super(key: key);

  @override
  _CallPageState createState() => _CallPageState();
}

class _CallPageState extends State<CallPage> {
  static final _users = <int>[];
  String channelName;
  List<User.User> userList = [];
  SharedPreferences _sharedPreferences;
  bool _isLoading = false;
  RxString _profileUrl = ''.obs;
  RxString _userName = ''.obs;
  RxString _city = ''.obs;
  RxString _birthDate = ''.obs;
  String _accessToken = '';
  String _userId = '';
  String _accountType = '';
  List<bool> checkvalue = new List();
  final picker = ImagePicker();

  // GlobalKey<NavigatorState> _key = GlobalKey();
  SharedPreferences prefs;
  FirebaseMessaging messaging;
  bool _isLogin = true;
  bool _isInChannel = true;
  int userNo = 0;
  var userMap;
  var tryingToEnd = false;
  bool personBool = false;
  bool accepted = false;

  final _channelMessageController = TextEditingController();

  final _infoStrings = <Message>[];

  AgoraRtmClient _client;
  AgoraRtmChannel _channel;
  bool heart = false;
  bool anyPerson = false;
  RtcEngine _engine;

  //Love animation
  final _random = math.Random();
  Timer _timer;
  double height = 0.0;
  int _numConfetti = 5;
  int guestID = -1;
  Qser.User user;
  bool waiting = false;
  List<FriendList.Data> _data = new List();

  @override
  void dispose() {
    // clear users
    _users.clear();
    // destroy sdk+
    _engine.leaveChannel();
    _engine.destroy();

    Provider.of<Qser.CommonDetailsProvider>(context, listen: false)
        .isEndedLive = false;
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    if (!_isLoading) {
      _sharedPreferences = Provider.of<Qser.CommonDetailsProvider>(context)
          .getPreferencesInstance;
      _profileUrl.value =
          _sharedPreferences.get(PreferenceConstants.PROFILE_IMAGE);
      _userName.value =
          '${_sharedPreferences.get(PreferenceConstants.FIRST_NAME)} ${_sharedPreferences.get(PreferenceConstants.LAST_NAME)}';
      _city.value = _sharedPreferences.get(PreferenceConstants.CITY);
      _birthDate.value = _sharedPreferences.get(PreferenceConstants.DOB);
      _accessToken = _sharedPreferences.get(PreferenceConstants.ACCESS_TOKEN);
      _userId = _sharedPreferences.get(PreferenceConstants.USER_ID);
      print("mohit");
      print(_userId);
      print(_accessToken);
      _accountType =
          _sharedPreferences.get(PreferenceConstants.ACCOUNT_TYPE) ?? '';
    }
    _isLoading = true;
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    user = Provider.of<Qser.CommonDetailsProvider>(context, listen: false).user;
    ApiImplementer.ListFriendApiImplementer(
      accessToken: user.accessToken,
      userid: user.userId,
    ).then((value) {
      _data.addAll(value);
      setState(() {
        for (int i = 0; i <= _data.length + 1; i++) {
          checkvalue.add(false);
        }
      });
    });
    // initialize agora sdk
    initialize();

    userMap = {widget.channelName: widget.image};
    _createClient();
  }

  Future<void> initialize() async {
    if (APP_ID.isEmpty) {
      setState(() {});
      return;
    }

    await _initAgoraRtcEngine();
    _addAgoraEventHandlers();
    // await _engine.enableWebSdkInteroperability(true);
    // VideoEncoderConfiguration configuration = VideoEncoderConfiguration();
    // configuration.dimensions = VideoDimensions();
    // await _engine.setVideoEncoderConfiguration(configuration);
    await _engine.joinChannel(widget.token, widget.channelName, null, 0);
  }

  /// Create agora sdk instance and initialize
  Future<void> _initAgoraRtcEngine() async {

    _engine = await RtcEngine.create(APP_ID);
    await _engine.enableVideo();
    //Split Screen
    // await _engine.enableLocalVideo(true);
    await _engine.setChannelProfile(ChannelProfile.LiveBroadcasting);
    await _engine.setClientRole(widget.role);
  }

  /// Add agora event handlers
  void _addAgoraEventHandlers() {
    _isLoading = true;

    _engine.setEventHandler(RtcEngineEventHandler(error: (code) {
      // setState(() {
      final info = 'onError: $code';
      print("CHHH :" + info);
      //   _infoStrings.add(info);
      // });
    }, joinChannelSuccess: (channel, uid, elapsed) {
      setState(() {
        _isLoading = false;
      });
      final info = 'onJoinChannel: $channel, uid: $uid';
      print("CHHH joinChannelSuccess :" + info);
      if (widget.role == ClientRole.Broadcaster) {
        ApiImplementer.GoliveImplementer(
                accessToken: user.accessToken,
                userid: user.userId,
                liveUrl: '',
                livevalue: "1")
            .then((valu) {
          if (valu.errorcode == "2") {
            print("logout");
            _sharedPreferences.clear();
               Navigator.of(context).pushNamedAndRemoveUntil(LoginScreen.routeName, (Route<dynamic> route) => false);
            CommonDialogUtil.showErrorSnack(context: context, msg: valu.msg);
          } else {
            setState(() {
              print("vikaaaaaaaaaaaaaaaaaaaaaaaaas");
              print(valu.toString());
            });
          }
        });
      }
      //  _infoStrings.add(info);
      // });
    }, leaveChannel: (stats) {
      // setState(() {
      // _infoStrings.add('onLeaveChannel');
      _users.clear();
      // });
    }, userJoined: (uid, elapsed) {
      setState(() {
        _isLoading = false;
      });
      // setState(() {
      final info = 'userJoined: $uid';
      print("CHHH userJoined :" + info);
      //    _infoStrings.add(info);
      if (_users.length < 5) _users.add(uid);
      setState(() {});
      // });
    }, userOffline: (uid, elapsed) {
      // setState(() {
      final info = 'userOffline: $uid';
      print("CHHH userOffline :" + info);
      //    _infoStrings.add(info);
      _users.remove(uid);
      setState(() {});
      // });
    }, firstRemoteVideoFrame: (uid, width, height, elapsed) {
      // setState(() {
      final info = 'firstRemoteVideo: $uid ${width}x $height';
      print("CHHH firstRemoteVideoFrame :" + info);
      //     _infoStrings.add(info);
      // });
    }));
  }

  /// Helper function to get list of native views
  List<Widget> _getRenderViews() {
    final List<StatefulWidget> list = [];
    if (widget.role == ClientRole.Broadcaster) {
      list.add(RtcLocalView.SurfaceView());
    }
    _users.forEach((int uid) => list.add(RtcRemoteView.SurfaceView(uid: uid)));
    return list;
  }

  /* Future<void> initialize() async {

    await _init_engine();
    _addAgoraEventHandlers();
    await _engine.enableWebSdkInteroperability(true);
    await _engine.setParameters(
        '''{\"che.video.lowBitRateStreamParameter\":{\"width\":320,\"height\":180,\"frameRate\":15,\"bitRate\":140}}''');
    await _engine.joinChannel(null, widget.channelName, null, 0);
  }*/

  /// Create agora sdk instance and initialize
  Future<void> _init_engine() async {
    _engine = await RtcEngine.create(APP_ID);
    await _engine.enableVideo();
    await _engine.enableLocalAudio(true);
  }

  /// Add agora event handlers
/*  void _addAgoraEventHandlers() {

    _engine.onJoinChannelSuccess = (
      String channel,
      int uid,
      int elapsed,
    ) async{

      final documentId = widget.channelName;
      channelName= documentId;
      FireStoreClass.createLiveUser(name: documentId,id: uid,time: widget.time,image:widget.image);
      // The above line create a document in the firestore with username as documentID

      await Wakelock.enable();
      // This is used for Keeping the device awake. Its now enabled

    };

    _engine.onLeaveChannel = () {
      setState(() {
        _users.clear();
      });
    };

    _engine.onUserJoined = (int uid, int elapsed) {
      setState(() {
        _users.add(uid);
      });
    };

    _engine.onUserOffline = (int uid, int reason) {
      if(uid == guestID){
        setState(() {
          accepted=false;
        });
      }
      setState(() {
        _users.remove(uid);
      });
    };
  }*/

  /// Helper function to get list of native views
  /* List<Widget> _getRenderViews() {
    final list = [
      AgoraRenderWidget(0, local: true, preview: true),
    ];
    if(accepted==true) {
      _users.forEach((int uid) {
        if(uid!=0){
          guestID = uid;
        }
        list.add(AgoraRenderWidget(uid));
      });
    }
    return list;
  }*/

  /// Video view wrapper
  Widget _videoView(view) {
    return Expanded(child: ClipRRect(child: view));
  }

  /// Video view row wrapper
  Widget _expandedVideoRow(List<Widget> views) {
    final wrappedViews = views.map<Widget>(_videoView).toList();
    return Expanded(
      child: Row(
        children: wrappedViews,
      ),
    );
  }

  /// Video view row wrapper
  Widget _expandedVideoColumn(List<Widget> views) {
    final wrappedViews = views.map<Widget>(_videoView).toList();
    return Expanded(
      child: Column(
        children: wrappedViews,
      ),
    );
  }

  /// Video layout wrapper
  Widget _viewRows() {
    final views = _getRenderViews();

    switch (views.length) {
      case 1:
        return Container(
            child: Column(
          children: <Widget>[_videoView(views[0])],
        ));
      case 2:
        return Container(
            child: Column(
          children: <Widget>[
            _expandedVideoRow([views[0]]),
            _expandedVideoRow([views[1]])
          ],
        ));
      case 3:
        return Container(
            child: Column(
          children: <Widget>[
            // _videoView(views[0]),
            _expandedVideoRow([views[0], views[1]]),
            _expandedVideoRow([views[2]])
          ],
        ));
      case 4:
        return Container(
            child: Column(
          children: <Widget>[
            _expandedVideoRow([views[0], views[1]]),
            _expandedVideoRow([views[2], views[3]])
          ],
        ));
    }
    return Container();

    /*    return Container(
        child: Column(
          children: <Widget>[_videoView(views[0])],
        ));*/
  }

  void popUp() async {
    setState(() {
      heart = true;
    });

    _timer = Timer.periodic(Duration(milliseconds: 125), (Timer t) {
      setState(() {
        height += _random.nextInt(20);
      });
    });

    Timer(
        Duration(seconds: 4),
        () => {
              _timer.cancel(),
              setState(() {
                heart = false;
              })
            });
  }

  Widget heartPop() {
    final size = MediaQuery.of(context).size;
    final confetti = <Widget>[];
    for (var i = 0; i < _numConfetti; i++) {
      final height = _random.nextInt(size.height.floor());
      final width = 20;
      confetti.add(HeartAnim(
        height % 200.0,
        width.toDouble(),
        0.5,
      ));
    }

    return Container(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Align(
          alignment: Alignment.bottomRight,
          child: Container(
            height: 400,
            width: 200,
            child: Stack(
              children: confetti,
            ),
          ),
        ),
      ),
    );
  }

  /// Info panel to show logs
  Widget _requestList() {
    return Center(
      child: Container(
        padding: const EdgeInsets.fromLTRB(0, 0, 100, 10),
        alignment: Alignment.bottomRight,
        child: FractionallySizedBox(
          heightFactor: 0.5,
          child: Container(
            padding: const EdgeInsets.only(bottom: 65),
            child: ListView.builder(
              reverse: true,
              itemCount: Provider.of<Qser.CommonDetailsProvider>(context,
                      listen: false)
                  .reqList
                  .length,
              itemBuilder: (BuildContext context, int index) {
                List<RequestToGoLiveNotification> _list =
                    Provider.of<Qser.CommonDetailsProvider>(context,
                            listen: false)
                        .reqList;
                if (Provider.of<Qser.CommonDetailsProvider>(context,
                        listen: false)
                    .reqList
                    .isEmpty) {
                  return null;
                }
                return Container(
                    color: Colors.black12,
                    margin: EdgeInsets.all(2),
                    padding: const EdgeInsets.symmetric(
                      vertical: 0,
                      horizontal: 10,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                              child: Text(
                            '${_list[index].friendName} has request to join',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          )),
                          TextButton(
                              onPressed: _list[index].isAccepted
                                  ? () {}
                                  : () {
                                      ApiImplementer.sendRequestToJoinGoLive(
                                              accessToken: _accessToken,
                                              userId: _userId,
                                              friendId: _list[index].friendid)
                                          .then((value) {
                                        _list[index].isAccepted = true;
                                        setState(() {});
                                        // showToast("msg");
                                      });
                                    },
                              child: Text(
                                _list[index].isAccepted ? "ACCEPTED" : "ACCEPT",
                                style: TextStyle(
                                    color: CustomColor.colorPrimary,
                                    fontWeight: FontWeight.bold),
                              ))
                        ],
                      ),
                    ));
              },
            ),
          ),
        ),
      ),
    );
  }

  /// Info panel to show logs
  Widget messageList() {
    return Center(
      child: Container(
        padding: const EdgeInsets.fromLTRB(0, 0, 100, 10),
        alignment: Alignment.bottomRight,
        child: FractionallySizedBox(
          heightFactor: 0.5,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 48),
            child: ListView.builder(
              reverse: true,
              itemCount: _infoStrings.length,
              itemBuilder: (BuildContext context, int index) {
                if (_infoStrings.isEmpty) {
                  return null;
                }
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 3,
                    horizontal: 10,
                  ),
                  child: (_infoStrings[index].type == 'join')
                      ? Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              CachedNetworkImage(
                                imageUrl: _infoStrings[index].image,
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                  width: 32.0,
                                  height: 32.0,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.cover),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                ),
                                child: Text(
                                  '${_infoStrings[index].user} joined',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : (_infoStrings[index].type == 'message')
                          ? Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Text(_infoStrings[index].image.toString()),
                                  /*    CachedNetworkImage(
                          imageUrl: _infoStrings[index].image,
                          imageBuilder: (context, imageProvider) => Container(
                            width: 12.0,
                            height: 12.0,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  image: imageProvider, fit: BoxFit.cover),
                            ),
                          ),
                        ),*/
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                        ),
                                        child: Text(
                                          _infoStrings[index].user,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                        ),
                                        child: Text(
                                          _infoStrings[index].message,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            )
                          : null,
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  void _onSwitchCamera() {
    _engine.switchCamera();
  }

  Future<bool> _willPopCallback() async {
    if (personBool == true) {
      setState(() {
        personBool = false;
      });
    } else {
      setState(() {
        tryingToEnd = !tryingToEnd;
      });
    }
    return false; // return true if the route to be popped
  }

  Widget _endCall() {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
            child: GestureDetector(
              onTap: () {
                _onEndButtonCLick();
              },
              child: Text(
                'END',
                style: TextStyle(
                    color: Colors.red,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _liveText() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        // mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: <Color>[Colors.red, Colors.redAccent],
                ),
                borderRadius: BorderRadius.all(Radius.circular(4.0))),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 5.0, horizontal: 8.0),
              child: Text(
                'LIVE',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Padding(
              padding: const EdgeInsets.only(left: 5, right: 10),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.black.withOpacity(.6),
                    borderRadius: BorderRadius.all(Radius.circular(4.0))),
                height: 28,
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Center(
                    child: CustomTimer(
                      from: Duration(hours: 0),
                      to: Duration(hours: 1),
                      onBuildAction: CustomTimerAction.auto_start,
                      builder: (CustomTimerRemainingTime remaining) {
                        return Text(
                          "${remaining.hours}:${remaining.minutes}:${remaining.seconds}",
                          style: TextStyle(fontSize: 15.0, color: Colors.white),
                        );
                      },
                    ),
                  ),
                ),
              )),
          // Expanded(
          //   child: Padding(
          //     padding:
          //         const EdgeInsets.symmetric(vertical: 5.0, horizontal: 8.0),
          //     child: Text(
          //       'END',
          //       style: TextStyle(
          //           color: Colors.white,
          //           fontSize: 15,
          //           fontWeight: FontWeight.bold),
          //     ),
          //   ),
          // )
        ],
      ),
    );
  }

  Widget endLive() {
    return Container(
      color: Colors.black.withOpacity(0.5),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: Text(
              'Are you sure you want to end your live video?',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 8.0, right: 4.0, top: 8.0, bottom: 8.0),
                  child: RaisedButton(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      child: Text(
                        'End Video',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    elevation: 2.0,
                    color: Colors.red,
                    onPressed: () async {
                      await Wakelock.disable();
                      _logout();
                      _leaveChannel();
                      _engine.leaveChannel();
                      _engine.destroy();

                      if (widget.isHost) {
                        ApiImplementer.GoliveImplementer(
                                accessToken: user.accessToken,
                                userid: user.userId,
                                liveUrl: '',
                                livevalue: "0")
                            .then((valu) {
                          if (valu.errorcode == "2") {
                            print("logout");
                            _sharedPreferences.clear();
                            Navigator.of(context)
                                .pushReplacementNamed(LoginScreen.routeName);
                            CommonDialogUtil.showErrorSnack(
                                context: context, msg: valu.msg);
                          } else {
                            Provider.of<Qser.CommonDetailsProvider>(context,
                                    listen: false)
                                .clearReqList();
                            setState(() {
                              print("vikaaaaaaaaas");
                              print(valu.toString());
                            });
                          }
                        });
                      }
                      Navigator.pop(context);
                    },
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 4.0, right: 8.0, top: 8.0, bottom: 8.0),
                  child: RaisedButton(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      child: Text(
                        'Cancel',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    elevation: 2.0,
                    color: Colors.grey,
                    onPressed: () {
                      setState(() {
                        tryingToEnd = false;
                      });
                    },
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget endedVideo() {
    return Container(
      color: Colors.black.withOpacity(0.5),
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(0.0),
            child: Text(
              'Live video is ended!',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: 8.0, right: 4.0, top: 15.0, bottom: 8.0),
            child: RaisedButton(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Text(
                  'Ok',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              elevation: 2.0,
              color: Colors.red,
              onPressed: () {
                Provider.of<Qser.CommonDetailsProvider>(context, listen: false)
                    .isEndedLive = false;
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget personList() {
    return Container(
      alignment: Alignment.bottomRight,
      child: Container(
        height: 2 * MediaQuery.of(context).size.height / 3,
        width: MediaQuery.of(context).size.height,
        decoration: new BoxDecoration(
          color: Colors.grey[850],
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25), topRight: Radius.circular(25)),
        ),
        child: Stack(
          children: <Widget>[
            Container(
              height: 2 * MediaQuery.of(context).size.height / 3 - 50,
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    width: MediaQuery.of(context).size.width,
                    alignment: Alignment.center,
                    child: Text(
                      'Go Live with',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Divider(
                    color: Colors.grey[800],
                    thickness: 0.5,
                    height: 0,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                    width: double.infinity,
                    color: Colors.grey[900],
                    child: Text(
                      'When you go live with someone, anyone who can watch their live videos will be able to watch it too.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[400],
                      ),
                    ),
                  ),
                  anyPerson == true
                      ? Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 15),
                          width: double.maxFinite,
                          child: Text(
                            'INVITE',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.start,
                          ))
                      : Expanded(
                          child: ListView.builder(
                          shrinkWrap: true,
                          padding: EdgeInsets.all(10.0),
                          itemBuilder: (context, index) => Container(
                            child: Column(
                              children: [
                                TextButton(
                                  child: Row(
                                    children: <Widget>[
                                      Material(
                                        child: _data.length != 0
                                            ? Image.network(
                                                _data[index].profileImage,
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
                                                        color: CustomColor
                                                            .colorAccent,
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
                                                errorBuilder: (context, object,
                                                    stackTrace) {
                                                  return Icon(
                                                    Icons.account_circle,
                                                    size: 50.0,
                                                    color:
                                                        CustomColor.color_gray,
                                                  );
                                                },
                                              )
                                            : Icon(
                                                Icons.account_circle,
                                                size: 50.0,
                                                color: CustomColor.color_gray,
                                              ),
                                        //  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                        clipBehavior: Clip.hardEdge,
                                      ),
                                      Expanded(
                                          child: Container(
                                        child: Text(
                                          '${_data[index].fullName}',
                                          maxLines: 1,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        alignment: Alignment.centerLeft,
                                        margin: EdgeInsets.fromLTRB(
                                            10.0, 0.0, 0.0, 5.0),
                                      )),
                                      Padding(
                                        padding: EdgeInsets.all(5),
                                        child: Text(
                                          checkvalue.elementAt(index)
                                              ? "Sent"
                                              : "",
                                          style: TextStyle(
                                              color: CustomColor.colorPrimary,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      )
                                    ],
                                  ),
                                  onPressed: checkvalue.elementAt(index)
                                      ? () {}
                                      : () {
                                          final snackBar = SnackBar(
                                            backgroundColor:
                                                Colors.deepPurpleAccent,
                                            content:
                                                const Text('Request Sent '),
                                            action: SnackBarAction(
                                              label: '',
                                              onPressed: () {
                                                // Some code to undo the change.
                                              },
                                            ),
                                          );

                                          // Find the ScaffoldMessenger in the widget tree
                                          // and use it to show a SnackBar.
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(snackBar);
                                          ApiImplementer
                                                  .sendRequestToJoinGoLive(
                                                      accessToken: _accessToken,
                                                      userId: _userId,
                                                      friendId:
                                                          _data[index].userId)
                                              .then((valu) {
                                            if (valu.errorcode ==
                                                ApiImplementer.SUCCESS)
                                              setState(() {
                                                checkvalue.insert(index, true);
                                                //    leadboard =Leaderboard.fromJson(value);
                                                // print(leadboard.errorcode.toString());
                                                print(valu.toString());
                                              });
                                            else if (valu.errorcode == "2") {
                                              print("logout");
                                              _sharedPreferences.clear();
                                              Navigator.of(context)
                                                  .pushReplacementNamed(LoginScreen.routeName);
                                              CommonDialogUtil.showErrorSnack(
                                                  context: context, msg: valu.msg);
                                            }
                                            else
                                              showToast(valu.msg,
                                                  context: context);
                                          });
                                        },
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            CustomColor.color_gray),
                                    shape: MaterialStateProperty.all<
                                        OutlinedBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                      ),
                                    ),
                                  ),
                                ),
                                Divider()
                              ],
                            ),
                            margin: EdgeInsets.only(
                                bottom: 10.0, left: 5.0, right: 5.0),
                          ),
                          itemCount: _data.length,
                        )),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    personBool = !personBool;
                  });
                },
                child: Container(
                  color: Colors.grey[850],
                  alignment: Alignment.bottomCenter,
                  height: 50,
                  child: Stack(
                    children: <Widget>[
                      Container(
                          height: double.maxFinite,
                          alignment: Alignment.center,
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          )),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> getUserStories() {
    List<Widget> stories = [];
    for (User.User users in userList) {
      stories.add(getStory(users));
    }
    return stories;
  }

  Widget getStory(User.User users) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 7.5),
      child: Column(
        children: <Widget>[
          GestureDetector(
            onTap: () async {
              setState(() {
                waiting = true;
              });
              await _channel.sendMessage(
                  AgoraRtmMessage.fromText('d1a2v3i4s5h6 ${users.username}'));
            },
            child: Container(
                padding: EdgeInsets.only(left: 15),
                color: Colors.grey[850],
                child: Row(
                  children: <Widget>[
                    CachedNetworkImage(
                      imageUrl: users.image,
                      imageBuilder: (context, imageProvider) => Container(
                        width: 40.0,
                        height: 40.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: imageProvider, fit: BoxFit.cover),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Column(
                        children: <Widget>[
                          Text(
                            users.username,
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                          SizedBox(
                            height: 2,
                          ),
                          Text(
                            users.name,
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    )
                  ],
                )),
          ),
        ],
      ),
    );
  }

  Widget stopSharing() {
    return Container(
      height: MediaQuery.of(context).size.height / 2 + 40,
      alignment: Alignment.bottomRight,
      child: Padding(
        padding: const EdgeInsets.only(right: 10),
        child: MaterialButton(
          minWidth: 0,
          onPressed: () async {
            stopFunction();
            await _channel
                .sendMessage(AgoraRtmMessage.fromText('E1m2I3l4i5E6 stoping'));
          },
          child: Icon(
            Icons.clear,
            color: Colors.white,
            size: 15.0,
          ),
          shape: CircleBorder(),
          elevation: 2.0,
          color: Colors.red,
          padding: const EdgeInsets.all(5.0),
        ),
      ),
    );
  }

  Widget guestWaiting() {
    return Container(
      alignment: Alignment.bottomRight,
      child: Container(
          height: 100,
          width: double.maxFinite,
          alignment: Alignment.center,
          color: Colors.black,
          child: Wrap(
            children: <Widget>[
              Text(
                'Waiting for the user to accept...',
                style: TextStyle(color: Colors.white, fontSize: 20),
              )
            ],
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: SafeArea(
          child: Scaffold(
            body: Container(
              color: Colors.black,
              child: Center(
                child: Stack(
                  children: <Widget>[
                    _viewRows(), // Video Widget
                    if(_isLoading)Center(child: CircularProgressIndicator()),
                    // if (tryingToEnd == false) _endCall(),
                    if (tryingToEnd == false) _liveText(),
                    if (heart == true && tryingToEnd == false) heartPop(),
                    if (tryingToEnd == false) bottomBar(), // send message
                    if (tryingToEnd == false) _requestList(),
                    if (tryingToEnd == true) endLive(), // view message
                    if (personBool == true && waiting == false) personList(),
                    if (accepted == true) stopSharing(),
                    if (waiting == true) guestWaiting(),
                    if (Provider.of<Qser.CommonDetailsProvider>(context,
                            listen: false)
                        .isEndedLive)
                      endedVideo()
                  ],
                ),
              ),
            ),
          ),
        ),
        onWillPop: _willPopCallback);
  }

// Agora RTM

  Widget bottomBar() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: 70,
        color: Colors.black,
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
                child: widget.role == ClientRole.Broadcaster
                    ? Padding(
                        padding: const EdgeInsets.fromLTRB(4.0, 0, 0, 0),
                        child: MaterialButton(
                          height: 50,
                          minWidth: 0,
                          onPressed: _onSwitchCamera,
                          child: Icon(
                            Icons.switch_camera,
                            color: Colors.white,
                            size: 22.0,
                          ),
                          shape: CircleBorder(),
                          elevation: 2.0,
                          color: CustomColor.colorPrimary,
                          padding: const EdgeInsets.all(12.0),
                        ),
                      )
                    : Container()),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(4.0, 0, 0, 0),
                child: MaterialButton(
                  height: 60,
                  minWidth: 0,
                  onPressed: _onEndButtonCLick,
                  child: Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 28.0,
                  ),
                  shape: CircleBorder(),
                  elevation: 2.0,
                  color: Colors.red,
                  padding: const EdgeInsets.all(12.0),
                ),
              ),
            ),
            Expanded(
                child: // if (accepted == false)
                    widget.isHost
                        ? Padding(
                            padding: const EdgeInsets.fromLTRB(4.0, 0, 0, 0),
                            child: MaterialButton(
                              height: 50,
                              minWidth: 0,
                              onPressed: _addPerson,
                              child: Icon(
                                Icons.person_add,
                                color: Colors.white,
                                size: 22.0,
                              ),
                              shape: CircleBorder(),
                              elevation: 2.0,
                              color: CustomColor.colorPrimary,
                              padding: const EdgeInsets.all(12.0),
                            ),
                          )
                        : widget.role == ClientRole.Audience
                            ? Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(4.0, 0, 0, 0),
                                child: MaterialButton(
                                  height: 50,
                                  minWidth: 0,
                                  onPressed: _sendRequestToJoin,
                                  child: Text(
                                    "+JOIN",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  shape: CircleBorder(),
                                  elevation: 2.0,
                                  color: CustomColor.colorPrimary,
                                  padding: const EdgeInsets.all(12.0),
                                ),
                              )
                            : Container()),
          ],
        ),
      ),
    );
  }

  Widget _bottomBar() {
    if (!_isLogin || !_isInChannel) {
      return Container();
    }
    return Container(
      alignment: Alignment.bottomRight,
      child: Container(
        color: Colors.black,
        child: Padding(
          padding: const EdgeInsets.only(left: 8, top: 5, right: 8, bottom: 5),
          child: Row(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // new Expanded(
                //     child: Padding(
                //   padding: const EdgeInsets.fromLTRB(0.0, 0, 0, 0),
                //   child: new TextField(
                //       cursorColor: CustomColor.colorAccent,
                //       textInputAction: TextInputAction.send,
                //       onSubmitted: _sendMessage,
                //       style: TextStyle(color: Colors.white),
                //       controller: _channelMessageController,
                //       textCapitalization: TextCapitalization.sentences,
                //       decoration: InputDecoration(
                //         isDense: true,
                //         hintText: 'Comment',
                //         hintStyle: TextStyle(color: Colors.white),
                //         enabledBorder: OutlineInputBorder(
                //             borderRadius: BorderRadius.circular(50.0),
                //             borderSide: BorderSide(color: Colors.white)),
                //         focusedBorder: OutlineInputBorder(
                //             borderRadius: BorderRadius.circular(50.0),
                //             borderSide: BorderSide(color: Colors.white)),
                //       )),
                // )),
                // Padding(
                //   padding: const EdgeInsets.fromLTRB(4.0, 0, 0, 0),
                //   child: MaterialButton(
                //     minWidth: 0,
                //     onPressed: _toggleSendChannelMessage,
                //     child: Icon(
                //       Icons.send,
                //       color: Colors.white,
                //       size: 20.0,
                //     ),
                //     shape: CircleBorder(),
                //     elevation: 2.0,
                //     color: CustomColor.colorPrimary,
                //     padding: const EdgeInsets.all(12.0),
                //   ),
                // ),
                // if (accepted == false)
                //   Padding(
                //     padding: const EdgeInsets.fromLTRB(4.0, 0, 0, 0),
                //     child: MaterialButton(
                //       minWidth: 0,
                //       onPressed: _addPerson,
                //       child: Icon(
                //         Icons.person_add,
                //         color: Colors.white,
                //         size: 20.0,
                //       ),
                //       shape: CircleBorder(),
                //       elevation: 2.0,
                //       color: CustomColor.colorPrimary,
                //       padding: const EdgeInsets.all(12.0),
                //     ),
                //   ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(4.0, 0, 0, 0),
                  child: MaterialButton(
                    minWidth: 0,
                    onPressed: _onSwitchCamera,
                    child: Icon(
                      Icons.switch_camera,
                      color: CustomColor.colorPrimary,
                      size: 20.0,
                    ),
                    shape: CircleBorder(),
                    elevation: 2.0,
                    color: Colors.white,
                    padding: const EdgeInsets.all(12.0),
                  ),
                )
              ]),
        ),
      ),
    );
  }

  void _addPerson() {
    setState(() {
      // tryingToEnd = true;
      personBool = !personBool;
    });
  }

  void stopFunction() {
    setState(() {
      accepted = false;
    });
  }

  void _logout() async {
    try {
      await _client.logout();
      //_log(info:'Logout success.',type: 'logout');
    } catch (errorCode) {
      //_log(info: 'Logout error: ' + errorCode.toString(), type: 'error');
    }
  }

  void _leaveChannel() async {
    try {
      await _channel.leave();
      //_log(info: 'Leave channel success.',type: 'leave');
      _client.releaseChannel(_channel.channelId);
      _channelMessageController.text = null;
    } catch (errorCode) {
      // _log(info: 'Leave channel error: ' + errorCode.toString(),type: 'error');
    }
  }

  void _toggleSendChannelMessage() async {
    String text = _channelMessageController.text;
    if (text.isEmpty) {
      return;
    }
    try {
      _channelMessageController.clear();
      await _channel.sendMessage(AgoraRtmMessage.fromText(text));
      _log(user: widget.channelName, info: text, type: 'message');
    } catch (errorCode) {
      //_log(info: 'Send channel message error: ' + errorCode.toString(), type: 'error');
    }
  }

  void _sendMessage(text) async {
    if (text.isEmpty) {
      return;
    }
    try {
      _channelMessageController.clear();
      await _channel.sendMessage(AgoraRtmMessage.fromText(text));
      _log(user: widget.channelName, info: text, type: 'message');
    } catch (errorCode) {
      // _log('Send channel message error: ' + errorCode.toString());
    }
  }

  void _createClient() async {
    _client = await AgoraRtmClient.createInstance(APP_ID);
    _client.onMessageReceived = (AgoraRtmMessage message, String peerId) {
      _log(user: peerId, info: message.text, type: 'message');
    };
    _client.onConnectionStateChanged = (int state, int reason) {
      if (state == 5) {
        _client.logout();
        //_log('Logout.');
        setState(() {
          _isLogin = false;
        });
      }
    };
    await _client.login(null, widget.channelName);
    _channel = await _createChannel(widget.channelName);
    await _channel.join();
  }

  Future<AgoraRtmChannel> _createChannel(String name) async {
    AgoraRtmChannel channel = await _client.createChannel(name);
    channel.onMemberJoined = (AgoraRtmMember member) async {
      var img = await FireStoreClass.getImage(username: member.userId);
      var nm = await FireStoreClass.getName(username: member.userId);
      setState(() {
        userList
            .add(new User.User(username: member.userId, name: nm, image: img));
        if (userList.length > 0) anyPerson = true;
      });
      userMap.putIfAbsent(member.userId, () => img);
      var len;
      _channel.getMembers().then((value) {
        len = value.length;
        setState(() {
          userNo = len - 1;
        });
      });

      _log(info: 'Member joined: ', user: member.userId, type: 'join');
    };
    channel.onMemberLeft = (AgoraRtmMember member) {
      var len;
      setState(() {
        userList.removeWhere((element) => element.username == member.userId);
        if (userList.length == 0) anyPerson = false;
      });

      _channel.getMembers().then((value) {
        len = value.length;
        setState(() {
          userNo = len - 1;
        });
      });
    };
    channel.onMessageReceived =
        (AgoraRtmMessage message, AgoraRtmMember member) {
      _log(user: member.userId, info: message.text, type: 'message');
    };
    return channel;
  }

  void _log({String info, String type, String user}) {
    if (type == 'message' && info.contains('m1x2y3z4p5t6l7k8')) {
      popUp();
    } else if (type == 'message' && info.contains('k1r2i3s4t5i6e7')) {
      setState(() {
        accepted = true;
        personBool = false;
        personBool = false;
        waiting = false;
      });
    } else if (type == 'message' && info.contains('E1m2I3l4i5E6')) {
      stopFunction();
    } else if (type == 'message' && info.contains('R1e2j3e4c5t6i7o8n9e0d')) {
      setState(() {
        waiting = false;
      });
      /*FlutterToast.showToast(
          msg: "Guest Declined",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0
      );*/

    } else {
      var image = userMap[user];
      Message m =
          new Message(message: info, type: type, user: user, image: image);
      setState(() {
        _infoStrings.insert(0, m);
      });
    }
  }

  void _onEndButtonCLick() {
    if (personBool == true) {
      setState(() {
        personBool = false;
      });
    }
    setState(() {
      if (waiting == true) {
        waiting = false;
      }
      tryingToEnd = true;
    });
  }

  void _sendRequestToJoin() {
    ApiImplementer.requestToJoinGoLive(
            accessToken: _accessToken,
            userId: _userId,
            friendId: widget.hostUserId)
        .then((value) {
      if (value.errorcode == ApiImplementer.SUCCESS)
        showToast("Request sent", context: context);
      else if (value.errorcode == "2") {
        print("logout");
        _sharedPreferences.clear();
        Navigator.of(context)
            .pushReplacementNamed(LoginScreen.routeName);
        CommonDialogUtil.showErrorSnack(
            context: context, msg: value.msg);
      }
    });
  }
}
