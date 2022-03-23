import 'dart:io';

import 'package:flutter/material.dart';
import 'package:out_out/api/api_implementer.dart';
import 'package:out_out/chat/const.dart';
import 'package:out_out/pages/common/login_page.dart';
import 'package:out_out/providers/common_details_provider.dart';
import 'package:out_out/utils/common_dialog_util.dart';
import 'package:out_out/utils/commona_utils.dart';
import 'package:out_out/utils/custom_colors.dart';
import 'package:out_out/utils/icon_utils.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ImagePreviewPage extends StatefulWidget {
  final ImageProvider provider;
  final File path;
  const ImagePreviewPage({Key key, this.provider, this.path}) : super(key: key);

  @override
  _ImagePreviewPageState createState() => _ImagePreviewPageState();
}

class _ImagePreviewPageState extends State<ImagePreviewPage> {
  TextEditingController _captionController;

  User _user;
  SharedPreferences _sharedPreferences;
@override
  void didChangeDependencies() {
  _sharedPreferences =
      Provider.of<CommonDetailsProvider>(context).getPreferencesInstance;
    super.didChangeDependencies();
  }
  @override
  void initState() {

    _captionController = TextEditingController();
    _user = Provider.of<CommonDetailsProvider>(context, listen: false).user;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
      body: Stack(
        children: [
          Container(
              alignment: Alignment.topCenter,
              margin: EdgeInsets.only(bottom: 20),
              child: PhotoView(imageProvider: widget.provider)),
          Align(
            alignment: Alignment.bottomLeft,
            child: buildBottomInputRow(),
          )
        ],
      ),
    );
  }

  Widget buildBottomInputRow() {
    return Container(
      padding: EdgeInsets.all(10),
      alignment: Alignment.center,
      width: double.infinity,
      height: 70.0,
      decoration: new BoxDecoration(
          gradient: new LinearGradient(colors: [
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
      child: Row(
        children: [
          Flexible(
            child: Container(
              height: 44,
              padding: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(20)),
              child: Center(
                child: TextField(
                  controller: _captionController,
                  style: TextStyle(color: primaryColor, fontSize: 15.0),
                  decoration: InputDecoration(
                    hintText: 'Something about outfit..',
                    hintStyle: TextStyle(color: greyColor),
                  ),
                  // focusNode: focusNode,
                ),
              ),
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.upload,
              color: Colors.white,
            ),
            onPressed: () => uploadOutfitStory(),
            color: primaryColor,
          ),
        ],
      ),
    );
  }

  void uploadOutfitStory() {
    CommonDialogUtil.showProgressDialog(context, 'Uploading...');
    ApiImplementer.addStory(
            accessToken: _user.accessToken,
            user_id: _user.userId,
            type: CommonUtils.STORY_TYPE_OUTFIT,
            file: widget.path,
            caption: _captionController.text.trim())
        .then((value) {
      Navigator.of(context).pop();
      if (value.errorcode == ApiImplementer.SUCCESS) {
        CommonDialogUtil.showSuccessSnack(context: context, msg: value.msg);
        Navigator.of(context).pop();
      } else if (value.errorcode == "2") {
        print("logout");
        _sharedPreferences.clear();
        Navigator.of(context)
            .pushReplacementNamed(LoginScreen.routeName);
        CommonDialogUtil.showErrorSnack(
            context: context, msg: value.msg);
      } else {
        CommonDialogUtil.showErrorSnack(context: context, msg: value.msg);
      }
    }).onError((error, stackTrace) {
      CommonDialogUtil.showErrorSnack(context: context, msg: error.toString());
    });
  }
}
