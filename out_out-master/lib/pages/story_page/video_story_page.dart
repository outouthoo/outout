import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:out_out/api/api_implementer.dart';
import 'package:out_out/flutter_emoji_keyboard/src/base_emoji.dart';
import 'package:out_out/models/comment_list_model.dart';
import 'package:out_out/models/list_media_model.dart' as media;
import 'package:out_out/models/post_comments_model.dart';
import 'package:out_out/pages/common/login_page.dart';
import 'package:out_out/providers/common_details_provider.dart';
import 'package:out_out/utils/common_dialog_util.dart';
import 'package:out_out/utils/commona_utils.dart';
import 'package:out_out/utils/custom_colors.dart';
import 'package:out_out/utils/preferences_constants.dart';
import 'package:out_out/widget/common_app_bar.dart';
import 'package:out_out/widget/item_comment_list.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';

class VideoStoryPage extends StatefulWidget {
  // static const routeName = '/video-story-page';

  final bool canIncreaseViewCount;
  media.Mediadata data;

  VideoStoryPage({@required this.data, this.canIncreaseViewCount});

  @override
  _VideoStoryPageState createState() => _VideoStoryPageState();
}

class _VideoStoryPageState extends State<VideoStoryPage> {
  VideoPlayerController _controller;
  Future<void> _initializeVideoPlayerFuture;
  RxBool _isPlaying = false.obs;
  bool _isLoading = false;
  String _userId;
  String _accessToken;
  SharedPreferences _sharedPreferences;
  String _operation = CommonUtils.COMMENTS_OPERATION_ADD;
  TextEditingController _commentsTextEditingController =
      TextEditingController();

  List<CommentList> _commentList;

  @override
  void initState() {
    super.initState();
    if (widget.canIncreaseViewCount) sendViewsToPost();
    getCommentList();
    _controller = VideoPlayerController.network(widget.data.mediaUrl);
    _initializeVideoPlayerFuture = _controller.initialize();
    _controller.addListener(() {
      if (!_controller.value.isPlaying &&
          _controller.value.isInitialized &&
          (_controller.value.duration == _controller.value.position)) {
        //checking the duration and position every time
        _isPlaying.value = false;
        _initializeVideoPlayerFuture = _controller.initialize();
      }
      // if (!_controller.value.isPlaying) {
      //   _isPlaying.value = false;
      // }
      //
    });
  }

  void sendViewsToPost() {
    CommonDialogUtil.showProgressDialog(context, 'Please wait...');
    ApiImplementer.sendMediaViews(
      accessToken: _accessToken,
      user_id: _userId,
      media_id: widget.data.id,
    ).then((value) {});
  }

  void getCommentList() async {
    var user = Provider.of<CommonDetailsProvider>(context, listen: false).user;
    ApiImplementer.getCommentsList(
      accessToken: user.accessToken,
      user_id: user.userId,
      offset: 1,
      limit: CommonUtils.NOTIFICATION_COUNT,
      media_id: widget.data.id,
    ).then((value) {
      if (value.errorcode == ApiImplementer.SUCCESS) {
        setState(() {
          _commentList = value.data.list;
        });
      } else if (value.errorcode == "2") {
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
  void didChangeDependencies() {
    if (!_isLoading) {
      _sharedPreferences =
          Provider.of<CommonDetailsProvider>(context).getPreferencesInstance;
      _userId = _sharedPreferences.getString(PreferenceConstants.USER_ID);
      _accessToken =
          _sharedPreferences.getString(PreferenceConstants.ACCESS_TOKEN);
    }
    _isLoading = true;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _commentsTextEditingController.dispose();
    _controller.dispose();
    super.dispose();
  }

  void onEmojiSelected(Emoji emoji) {
    _commentsTextEditingController.text =
        _commentsTextEditingController.text + emoji.toString();
    Navigator.of(context).pop();
  }

  void postCommentsApiCall(String comment) {
    CommonDialogUtil.showProgressDialog(context, 'Please wait...');
    ApiImplementer.postCommentsApiImplementer(
      accessToken: _accessToken,
      operation: _operation,
      comment_id: 0,
      user_id: _userId,
      media_id: widget.data.id,
      comments: comment,
    ).then((value) {
      Navigator.of(context).pop();
      PostCommentsModel postCommentsModel = value;
      if (postCommentsModel.errorcode == '0') {
        getCommentList();
        CommonDialogUtil.showSuccessSnack(
            context: context, msg: postCommentsModel.msg);
      }  else if (value.errorcode == "2") {
        print("logout");
        _sharedPreferences.clear();
        Navigator.of(context)
            .pushReplacementNamed(LoginScreen.routeName);
        CommonDialogUtil.showErrorSnack(
            context: context, msg: value.msg);
      }else {
        CommonDialogUtil.showErrorSnack(
            context: context, msg: postCommentsModel.msg);
      }
    }).onError((error, stackTrace) {
      Navigator.of(context).pop();
      CommonDialogUtil.showErrorSnack(context: context, msg: error.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56.0),
        child: CommonAppBar(),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 7,
                child: Container(
                  child: Stack(
                    children: [
                      Container(
                        child: FutureBuilder(
                          future: _initializeVideoPlayerFuture,
                          builder: (context, snapShot) {
                            if (snapShot.connectionState ==
                                ConnectionState.done) {
                              return VideoPlayer(_controller);
                            }
                            return AspectRatio(
                              aspectRatio: _controller.value.aspectRatio,
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            );
                          },
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              // If the video is playing, pause it.
                              if (_controller.value.isPlaying) {
                                _controller.pause();
                                _isPlaying.value = false;
                              } else {
                                // If the video is paused, play it.
                                _controller.play();
                                _isPlaying.value = true;
                              }
                            });
                            // _isPlaying.value
                            //     ? _controller.pause()
                            //     : _controller.play();
                            // _isPlaying.value = !_isPlaying.value;
                          },
                          child: CircleAvatar(
                            radius: 33,
                            backgroundColor: Colors.black38,
                            child: Obx(
                              () => Icon(
                                _isPlaying.value
                                    ? Icons.pause
                                    : Icons.play_arrow,
                                color: Colors.white,
                                size: 50,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                child: Container(
                  padding: EdgeInsets.all(16.0),
                  color: Colors.grey,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            '#OutOut',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(
                            width: 8.0,
                          ),
                          Icon(
                            Icons.location_on,
                            color: CustomColor.colorPrimary,
                            size: 20,
                          ),
                          SizedBox(
                            width: 2.0,
                          ),
                          Text(
                            widget.data.city,
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          Spacer(),
                          Text(
                            '${widget.data.likes}',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.favorite,
                              color: CustomColor.colorPrimary,
                            ),
                            onPressed: () {},
                          ),
                          // Text(
                          //   '${widget.data.views} Views',
                          //   style: TextStyle(
                          //     color: Colors.white,
                          //   ),
                          // ),
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 6.0),
                        child: Row(
                          children: [
                            Icon(
                              Icons.chat,
                              size: 40,
                              color: CustomColor.colorCanvas,
                            ),
                            SizedBox(
                              width: 4.0,
                            ),
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  vertical: 0.0,
                                  horizontal: 16.0,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 0.8, color: Colors.grey),
                                  borderRadius: BorderRadius.circular(30.0),
                                  color: Colors.white,
                                ),
                                child: TextFormField(
                                  controller: _commentsTextEditingController,
                                  readOnly: true,
                                  maxLines: 1,
                                  onTap: () {
                                    CommonDialogUtil.emojiKeyboardBottomSheet(
                                        context: context,
                                        onEmojiSelected: onEmojiSelected);
                                  },
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'Comments...'),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 4.0,
                            ),
                            InkWell(
                              onTap: () {
                                postCommentsApiCall(
                                    _commentsTextEditingController.text);
                              },
                              child: CircleAvatar(
                                radius: 20,
                                child: Icon(
                                  Icons.send_rounded,
                                  color: Colors.white,
                                  size: 27,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      _commentList != null && _commentList.length > 0
                          ? ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: _commentList.length,
                              itemBuilder: (context, index) => ItemCommentList(
                                commentData: _commentList.elementAt(index),
                              ),
                            )
                          : SizedBox()
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
