import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:out_out/api/api_implementer.dart';
import 'package:out_out/models/upload_media_model.dart';
import 'package:out_out/pages/common/searchFriendforTag.dart';
import 'package:out_out/pages/memory_page/memory_page.dart';
import 'package:out_out/providers/common_details_provider.dart';
import 'package:out_out/utils/common_dialog_util.dart';
import 'package:out_out/utils/commona_utils.dart';
import 'package:out_out/utils/custom_colors.dart';
import 'package:out_out/utils/preferences_constants.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login_page.dart';
import 'package:out_out/models/search_friends_list_model.dart' as friendModel;

class ImageViewPage extends StatefulWidget {
  File imagePath;

  ImageViewPage([this.imagePath]);

  // static const routeName = '/image-view-page';

  @override
  _ImageViewPageState createState() => _ImageViewPageState();
}

class _ImageViewPageState extends State<ImageViewPage> {
  SharedPreferences _sharedPreferences;
  bool _isLoading = false;
  String _accessToken = '';
  String _userId = '';
  int _mediaType = CommonUtils.MEDIA_TYPE_IMAGE;
  String _caption = '';
  File imageFile;
  List<friendModel.Data> _tagsList = [];
  List<String> _tagsName = [];
  final descriptionController = TextEditingController();
  final locationController = TextEditingController();
  bool isAddLocation=false;

  void imageVideoApiCall() {
    print("1112222222");
    CommonDialogUtil.showProgressDialog(context, 'Uploading...');

    // _tagsList
    // for (friendModel.Data data:_tagsList){
    //
    // }
    var tagid="";
    for(friendModel.Data item in _tagsList){
      tagid=tagid+item.userId+",";
    }
    if (tagid != null && tagid.length > 0) {
      tagid = tagid.substring(0, tagid.length - 1);
    }
    // tagid.las
    print("TAGS=========>"+tagid);
    ApiImplementer.uploadMediaApiImplementer(
      accessToken: _accessToken,
      user_id: _userId,
      media_type: _mediaType,
      file: imageFile,
      caption: descriptionController.text,
      lat: "0.0",
      long: "0.0",
      address: locationController.text,
      thumbFile: null,
      taggedUser: tagid
    ).then((value) {
      Navigator.of(context).pushNamed(MemoryPage.routeName);
      UploadMediaModel uploadMediaModel = value;
      if (uploadMediaModel.errorcode == '0') {
        Navigator.of(context).pushNamed(MemoryPage.routeName);
        CommonDialogUtil.showSuccessSnack(
            context: context, msg: uploadMediaModel.msg);
      } else if (value.errorcode == "2") {
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
  void didChangeDependencies() {
    if (!_isLoading) {
      imageFile = widget.imagePath;
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Expanded(
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Image.file(
                  imageFile,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              color: Colors.black38,
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: TextFormField(
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                      ),
                      controller: descriptionController,
                      maxLines: 6,
                      minLines: 1,
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Add Caption....",
                        contentPadding: EdgeInsets.only(
                            left: 10.0, top: 24.0, right: 12.0, bottom: 16.0),
                        hintStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      imageVideoApiCall();
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
            Container(height: 1,color: Colors.grey,),
            InkWell(
              onTap: () {
                // showSearchFriendDialog();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (builder) => SearchTagFriend(),
                  ),
                ).then((value) {
                  if (value != null) {
                    // Navigator.of(context).pop(true);
                    // print(value.fullname);
                    _tagsList.add(value);
                    _tagsName.add(value.fullName);
                    setState(() {});
                  }
                });
              },
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                child: Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Add People",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                    ),
                  ),
                ),
              ),
            ),
            _tagsList.length != 0
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Tags(
                      alignment: WrapAlignment.start,
                      itemCount: _tagsList.length,
                      itemBuilder: (index) {
                        print("${index}");
                        return ItemTags(
                            index: index,
                            key: Key(index.toString()),
                            title: _tagsList[index].fullName,
                            removeButton: ItemTagsRemoveButton(
                              onRemoved: () {
                                setState(() {
                                  _tagsList.removeAt(index);
                                });
                                return true;
                              },
                            ));
                      },
                    ),
                  )
                : Container(),
            Container(height: 1,color: Colors.grey,),

            !isAddLocation?   InkWell(
              onTap: (){
                isAddLocation=true;
                setState(() {
                });
              },
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                child: Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Add Location",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                    ),
                  ),
                ),
              ),
            )
            :TextFormField(
              style: TextStyle(
                color: Colors.white,
                fontSize: 17,
              ),
              maxLines: 6,
              minLines: 1,
              controller: locationController,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Enter Location....",
                contentPadding: EdgeInsets.only(
                    left: 10.0, top: 24.0, right: 12.0, bottom: 16.0),
                hintStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                ),
              ),
            ),
            Container(height: 1,color: Colors.grey,),

          ],
        ),
      ),
    );
  }
}
