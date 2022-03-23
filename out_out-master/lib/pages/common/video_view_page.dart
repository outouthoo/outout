import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:out_out/api/api_implementer.dart';
import 'package:out_out/models/upload_media_model.dart';
import 'package:out_out/pages/memory_page/memory_page.dart';
import 'package:out_out/providers/common_details_provider.dart';
import 'package:out_out/utils/common_dialog_util.dart';
import 'package:out_out/utils/commona_utils.dart';
import 'package:out_out/utils/custom_colors.dart';
import 'package:out_out/utils/preferences_constants.dart';
import 'package:out_out/widget/common_app_bar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import 'login_page.dart';

class VideoViewPage extends StatefulWidget {
  File videoPath;

  VideoViewPage([this.videoPath]);

  // static const routeName = '/video-view-page';

  @override
  _VideoViewPageState createState() => _VideoViewPageState();
}

class _VideoViewPageState extends State<VideoViewPage> {
  VideoPlayerController _controller;
  Future<void> _initializeVideoPlayerFuture;
  RxBool _isPlaying = false.obs;
  SharedPreferences _sharedPreferences;
  bool _isLoading = false;
  String _accessToken = '';
  String _userId = '';
  int _mediaType = CommonUtils.MEDIA_TYPE_VIDEO;
  String _caption = '';
  File videoFile;
  File thumbFile;

  void uploadVideoApiCall() {
    CommonDialogUtil.showProgressDialog(context, 'Uploading...');
    ApiImplementer.uploadMediaApiImplementer(
      accessToken: _accessToken,
      user_id: _userId,
      media_type: _mediaType,
      file: videoFile,
      caption: _caption,
      thumbFile: thumbFile,
    ).then((value) {
      Navigator.of(context).pushNamed(MemoryPage.routeName);
      UploadMediaModel uploadMediaModel = value;
      if (uploadMediaModel.errorcode == '0') {
        CommonDialogUtil.showSuccessSnack(
            context: context, msg: uploadMediaModel.msg);
        Navigator.of(context).pushNamed(MemoryPage.routeName);
      }else if (value.errorcode == "2") {
        print("logout");
        _sharedPreferences.clear();
           Navigator.of(context).pushNamedAndRemoveUntil(LoginScreen.routeName, (Route<dynamic> route) => false);
        CommonDialogUtil.showErrorSnack(context: context, msg: value.msg);
      } else {
        Navigator.of(context).pushNamed(MemoryPage.routeName);
        CommonDialogUtil.showErrorSnack(
            context: context, msg: uploadMediaModel.msg);
      }
    }).onError((error, stackTrace) {
      Navigator.of(context).pushNamed(MemoryPage.routeName);
    //  CommonDialogUtil.showErrorSnack(context: context, msg: error.toString());
    });
  }

  @override
  void initState() {
    super.initState();
    createThumbNil();
    videoFile = widget.videoPath;
    _controller = VideoPlayerController.file(videoFile);
    _initializeVideoPlayerFuture = _controller.initialize();
    _controller.addListener(() {
        if (!_controller.value.isPlaying &&_controller.value.isInitialized &&
            (_controller.value.duration ==_controller.value.position)) { //checking the duration and position every time
          _isPlaying.value = false;
          _initializeVideoPlayerFuture = _controller.initialize();
        }
      // if (!_controller.value.isPlaying) {
      //   _isPlaying.value = false;
      // }
      //
    });
  }

  Future<String> createThumbNil() async {
    String thumb = await VideoThumbnail.thumbnailFile(
      thumbnailPath: (await getTemporaryDirectory()).path,
      video: '${widget.videoPath}',
      imageFormat: ImageFormat.PNG,
      quality: 100,
    );
    thumbFile = File(thumb);
    setState(() {});
  }

  @override
  void didChangeDependencies() {
    if (!_isLoading) {
      _sharedPreferences =
          Provider.of<CommonDetailsProvider>(context).getPreferencesInstance;
      _accessToken =
          _sharedPreferences.getString(PreferenceConstants.ACCESS_TOKEN);
      _userId = _sharedPreferences.getString(PreferenceConstants.USER_ID);
    }
    _isLoading = true;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height - 150,
              child: FutureBuilder(
                future: _initializeVideoPlayerFuture,
                builder: (context, snapShot) {
                  if (snapShot.connectionState == ConnectionState.done) {
                    return AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller),
                    );
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
            Positioned(
              bottom: 0,
              child: Container(
                color: Colors.black38,
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        onChanged: (value) {
                          _caption = value;
                        },
                        textInputAction: TextInputAction.done,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                        ),
                        maxLines: 6,
                        minLines: 1,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Add Caption....",
                          contentPadding: EdgeInsets.only(
                              left: 22.0, top: 24.0, right: 12.0, bottom: 16.0),
                          hintStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        uploadVideoApiCall();
                      },
                      child: CircleAvatar(
                        radius: 27,
                        backgroundColor: CustomColor.colorPrimary,
                        child: Transform.rotate(
                          angle: 75.0,
                          child: Icon(
                            Icons.send_rounded,
                            color: Colors.white,
                            size: 27,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
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
                  // _isPlaying.value ? _controller.pause() : _controller.play();
                  // _isPlaying.value = !_isPlaying.value;
                },
                child: CircleAvatar(
                  radius: 33,
                  backgroundColor: Colors.black38,
                  child: Obx(
                    () => Icon(
                      _isPlaying.value ? Icons.pause : Icons.play_arrow,
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
    );
  }
}
