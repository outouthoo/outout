import 'dart:io';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:camera/camera.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:image_picker/image_picker.dart';
import 'package:out_out/Golive/agora/host.dart';
import 'package:out_out/api/api_implementer.dart';
import 'package:out_out/models/notification_list_model.dart';
import 'package:out_out/models/upload_media_model.dart';
import 'package:out_out/pages/common/image_view_page.dart';
import 'package:out_out/pages/common/login_page.dart';
import 'package:out_out/pages/common/video_upload_page.dart';
import 'package:out_out/pages/common/video_view_page.dart';
import 'package:out_out/pages/memory_page/memory_page.dart';
import 'package:out_out/providers/common_details_provider.dart';
import 'package:out_out/utils/common_dialog_util.dart';
import 'package:out_out/utils/commona_utils.dart';
import 'package:out_out/utils/preferences_constants.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class CameraPage extends StatefulWidget {
  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  List<CameraDescription> _cameras;
  CameraController _controller;
  bool _isReady = false;
  File _image;
  SharedPreferences _sharedPreferences;
  bool _isLoading = false;
  RxString _profileUrl = ''.obs;
  RxString _userName = ''.obs;
  RxString _city = ''.obs;
  RxString _birthDate = ''.obs;
  String _accessToken = '';
  String _userId = '';
  String _accountType = '';
  final picker = ImagePicker();
  FirebaseMessaging messaging;
  // User user;
  GetNotificationResponse _response;
  SharedPreferences prefs;
  bool flag = false;
  bool flagcamera = false;
  User _user;
  @override
  void initState() {
    // To display the current output from the Camera,
    // create a CameraController.
    // TODO: implement initState
    super.initState();

    _user = Provider.of<CommonDetailsProvider>(context, listen: false).user;
    _setUpCamera();
  }

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
      _accountType =
          _sharedPreferences.get(PreferenceConstants.ACCOUNT_TYPE) ?? '';
      //  firbaseuser();
    }
    _isLoading = true;
    super.didChangeDependencies();
  }

  void onImageSelected(File selectedImageFile) {
    _image = File(selectedImageFile.path);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (builder) => ImageViewPage(
          _image,
        ),
      ),
    ).then((value) {
      if (value != null && value) {
        Navigator.of(context).pop(true);
      }
    });
   /* print("1111111111");
    CommonDialogUtil.showProgressDialog(context, 'Uploading...');
    ApiImplementer.uploadMediaApiImplementer(
      accessToken: _accessToken,
      user_id: _userId,
      media_type: CommonUtils.MEDIA_TYPE_IMAGE,
      file: selectedImageFile,
      caption: '',
      thumbFile: null,
    ).then((value) {
      Navigator.of(context).pop();
      UploadMediaModel uploadMediaModel = value;
      if (uploadMediaModel.errorcode == '0') {
        Navigator.of(context).pushNamed(MemoryPage.routeName);
        CommonDialogUtil.showSuccessSnack(
            context: context, msg: uploadMediaModel.msg);
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
      Navigator.of(context).pop();
      //  CommonDialogUtil.showErrorSnack(context: context, msg: error.toString());
    });*/
  }

  void onCameraTap() {
    Navigator.of(context).pushNamed(VideoUploadPage.routeName).then(
      (value) {
        if (value != null && value) {}
      },
    );
  }

  void onVideoSelected(File selectedVideoFile) async {
    CommonDialogUtil.showProgressDialog(context, 'Uploading...');
    String thumb = await VideoThumbnail.thumbnailFile(
      thumbnailPath: (await getTemporaryDirectory()).path,
      video: '${selectedVideoFile.path}',
      //  imageFormat: ImageFormat.PNG,
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
        Navigator.of(context).pushNamed(MemoryPage.routeName);
        CommonDialogUtil.showSuccessSnack(
            context: context, msg: uploadMediaModel.msg);
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
      Navigator.of(context).pop();
      CommonDialogUtil.showErrorSnack(context: context, msg: error.toString());
    });
  }

  Future<void> _initializeControllerFuture;
  void _setUpCamera() async {
    try {
      // initialize cameras.
      _cameras = await availableCameras();

      _controller = CameraController(
        _cameras[0],
        ResolutionPreset.medium,
      );

      await _controller.initialize();
    } on CameraException catch (_) {
      // do something on error.
    }
    if (!mounted) return;
    setState(() {
      _isReady = true;
    });
  }

  final ImagePicker _picker = ImagePicker();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      floatingActionButton: getFooter(),
      body: getBody(),
    );
  }

  Widget cameraPreview() {
    return AspectRatio(
        aspectRatio: _controller.value.aspectRatio,
        child: CameraPreview(_controller));
  }

  Widget getBody() {
    var size = MediaQuery.of(context).size;
    if (_isReady == false ||
        _controller == null ||
        !_controller.value.isInitialized) {
      return Container(
        decoration: BoxDecoration(color: Colors.white),
        width: size.width,
        height: size.height,
        child: Center(
            child: SizedBox(
                width: 25,
                height: 25,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                ))),
      );
    }

    return Container(
      width: size.width,
      height: size.height,
      child: ClipRRect(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10)),
          child: cameraPreview()),
    );
  }

  Widget getBodyBK() {
    var size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      height: size.height,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20)),
          color: Colors.white),
      child: Image(
        image: NetworkImage(
          "https://images.unsplash.com/photo-1582152629442-4a864303fb96?ixid=MXwxMjA3fDB8MHxzZWFyY2h8MXx8c2VsZmllfGVufDB8fDB8&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60",
        ),
        fit: BoxFit.cover,
      ),
    );
  }

  Future<void> onJoin(
      {channelName, channelId, username, hostImage, userImage}) async {
    // update input validation
    if (channelName.isNotEmpty) {
      // push video page with given channel name
      /*await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => JoinPage(
            channelName: channelName,
            channelId: channelId,
            username: username,
            hostImage: hostImage,
            userImage: userImage,
          ),
        ),
      );*/
    }
  }

  Widget getFooter() {
    return Padding(
      padding: const EdgeInsets.only(left: 30, top: 60),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black.withOpacity(0.3)),
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Icon(
                        Icons.arrow_back_ios_outlined,
                        color: Colors.white,
                        size: 23,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.black.withOpacity(0.3)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          IconButton(
                              onPressed: () async {
                                final cameras = await availableCameras();
                                final firstCamera =
                                    flagcamera ? cameras[1] : cameras.first;
                                setState(() async {
                                  flagcamera = !flagcamera;
                                  _controller = CameraController(
                                    firstCamera,
                                    ResolutionPreset.medium,
                                  );
                                  await _controller.initialize();
                                  //  _initializeControllerFuture = _controller.initialize();
                                });
                              },
                              icon: Icon(
                                SimpleLineIcons.refresh,
                                color: Colors.white,
                                size: 25,
                              )),
                          SizedBox(
                            height: 18,
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                flag = !flag;
                              });
                              flag
                                  ? _controller.setFlashMode(FlashMode.torch)
                                  : _controller.setFlashMode(FlashMode.off);
                            },
                            child: Icon(
                              flag ? Icons.flash_off : Icons.flash_on_outlined,
                              color: Colors.white,
                              size: 25,
                            ),
                          ),
                          SizedBox(
                            height: 18,
                          ),
                          InkWell(
                            onTap: () async {
                              PickedFile image = await _picker.getVideo(
                                source: ImageSource.gallery,
                              );

                              setState(() {
                                _image = File(image.path);
                                Navigator.of(context)
                                    .push(
                                  MaterialPageRoute(
                                    builder: (context) => VideoViewPage(_image),
                                  ),
                                )
                                    .then((value) {
                                  if (value != null && value) {
                                    Navigator.of(context).pop(true);
                                  }
                                });
                              });
                            },
                            child: Icon(
                              Entypo.video,
                              color: Colors.white,
                              size: 25,
                            ),
                          ),
                          SizedBox(
                            height: 18,
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.image,
                              color: Colors.white,
                              size: 25,
                            ),
                            onPressed: () async {
                              PickedFile image = await _picker.getImage(
                                  source: ImageSource.gallery,
                                  imageQuality: 50);

                              setState(() {
                                _image = File(image.path);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (builder) => ImageViewPage(
                                      _image,
                                    ),
                                  ),
                                ).then((value) {
                                  if (value != null && value) {
                                    Navigator.of(context).pop(true);
                                  }
                                });
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                  onPressed: startGoLive,
                  child: Text(
                    "GO LIVE",
                    style: TextStyle(color: Colors.white),
                  )),
              SizedBox(
                width: 15,
              ),
              InkWell(
                onTap: () async {
                  PickedFile image = await _picker.getImage(
                      source: ImageSource.camera, imageQuality: 50);

                  setState(() {
                    _image = File(image.path);
                    onImageSelected(_image);
                  });
                },
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(width: 2, color: Colors.white)),
                ),
              ),
              SizedBox(
                width: 15,
              ),
              IconButton(
                onPressed: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => FaceFilter(
                  //
                  //
                  //     ),
                  //   ),
                  // );
                },
                icon: Icon(
                  Entypo.emoji_happy,
                  color: Colors.white,
                  size: 28,
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  void startGoLive() {
    ApiImplementer.getAgoraToken(
            accessToken: _user.accessToken, userid: _user.userId)
        .then((value) {
      if (value.errorcode == ApiImplementer.SUCCESS) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                CallPage(
                    isHost: true,
                    role: ClientRole.Broadcaster,
                    channelName: value.data.channelName,
                    token: value.data.agoraToken),
            // channelName: 'outout',
            // token:
            //     '00692841c5e791c4ebc8e34eb16a13ca5f3IAAPZbPEsc/2cG9QoMfc4Ce0bNR1I5Z6SLkQbvs7GMZ8btPwpNsAAAAAEABr21wCc66PYQEAAQB0ro9h'),
          ),
        );
      }else if (value.errorcode == "2") {
        print("logout");
        _sharedPreferences.clear();
        Navigator.of(context)
            .pushReplacementNamed(LoginScreen.routeName);
        CommonDialogUtil.showErrorSnack(
            context: context, msg: value.msg);
      }
      else {
        Navigator.pop(context);
        showToast(value.msg, context: context);
      }
    });
  }
}
