import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:out_out/api/api_implementer.dart';
import 'package:out_out/camera/CameraPage.dart';
import 'package:out_out/models/upload_media_model.dart';
import 'package:out_out/pages/common/login_page.dart';
import 'package:out_out/pages/common/video_upload_page.dart';
import 'package:out_out/pages/friends_feed/business_friends.dart';
import 'package:out_out/pages/friends_feed/normal_friends.dart';
import 'package:out_out/pages/friends_feed/vip_friends.dart';
import 'package:out_out/providers/common_details_provider.dart';
import 'package:out_out/utils/common_dialog_util.dart';
import 'package:out_out/utils/commona_utils.dart';
import 'package:out_out/utils/custom_colors.dart';
import 'package:out_out/utils/icon_utils.dart';
import 'package:out_out/utils/permission_util.dart';
import 'package:out_out/utils/preferences_constants.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class FriendsFeedPage extends StatefulWidget {
  static const routeName = "/Friends-Feed-Page";

  @override
  _FriendsFeedPageState createState() => _FriendsFeedPageState();
}

class _FriendsFeedPageState extends State<FriendsFeedPage> {
  SharedPreferences _sharedPreferences;
  bool _isLoading = false;
  RxString _profileUrl = ''.obs;
  RxString _userName = ''.obs;
  RxString _city = ''.obs;
  RxString _birthDate = ''.obs;
  String _accessToken = '';
  String _userId = '';
  final picker = ImagePicker();

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
      _accessToken = _sharedPreferences.get(PreferenceConstants.ACCESS_TOKEN);
      _userId = _sharedPreferences.get(PreferenceConstants.USER_ID);
    }
    _isLoading = true;
    super.didChangeDependencies();
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
  //     CommonDialogUtil.showErrorSnack(context: context, msg: error.toString());
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
      }else if (value.errorcode == "2") {
        print("logout");
        _sharedPreferences.clear();
           Navigator.of(context).pushNamedAndRemoveUntil(LoginScreen.routeName, (Route<dynamic> route) => false);
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
            Navigator.of(context).pop();
          },
        ),
        title: Container(height: 70, child: Image.asset(out_out_actionbar)),
      ),
      body: Column(
        children: [
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
                      gradient: LinearGradient(
                        colors: [
                          CustomColor.colorAccent,
                          CustomColor.colorPrimaryDark,
                        ],
                      ),
                    ),
                    tabs: [
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12.0, vertical: 12.0),
                          child: Text('VIP'),
                        ),
                      ),
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12.0, vertical: 12.0),
                          child: Text('Business'),
                        ),
                      ),
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12.0, vertical: 12.0),
                          child: Text('Normal'),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        VipFriends(),
                        BusinessFriends(),
                        NormalFriends(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      // drawer: AppDrawer(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: Container(
          width: 60,
          height: 60,
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
