import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:out_out/api/api_implementer.dart';
import 'package:out_out/flutter_emoji_keyboard/src/base_emoji.dart';
import 'package:out_out/models/comment_list_model.dart';
import 'package:out_out/models/list_media_model.dart';
import 'package:out_out/models/post_comments_model.dart';
import 'package:out_out/pages/common/login_page.dart';
import 'package:out_out/providers/common_details_provider.dart';
import 'package:out_out/utils/common_dialog_util.dart';
import 'package:out_out/utils/commona_utils.dart';
import 'package:out_out/utils/custom_colors.dart';
import 'package:out_out/utils/icon_utils.dart';
import 'package:out_out/utils/preferences_constants.dart';
import 'package:out_out/widget/common_app_bar.dart';
import 'package:out_out/widget/item_comment_list.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ImageStoryPage extends StatefulWidget {
  final Mediadata media;
  final bool canIncreaseViewCount;
  static const routeName = '/image-story-page';

  const ImageStoryPage({Key key, this.media, this.canIncreaseViewCount})
      : super(key: key);

  @override
  _ImageStoryPageState createState() => _ImageStoryPageState();
}

class _ImageStoryPageState extends State<ImageStoryPage> {
  SharedPreferences _sharedPreferences;
  bool _isLoading = false;
  String _userId;
  String _accessToken;
  String _operation = CommonUtils.COMMENTS_OPERATION_ADD;
  TextEditingController _commentsTextEditingController =
      TextEditingController();

  User user;

  List<CommentList> _commentList;

  @override
  void initState() {
    super.initState();
    getCommentList();
    if (widget.canIncreaseViewCount) sendViewsToPost();
  }

  void getCommentList() async {
    user = Provider.of<CommonDetailsProvider>(context, listen: false).user;
    ApiImplementer.getCommentsList(
      accessToken: user.accessToken,
      user_id: user.userId,
      offset: 1,
      limit: CommonUtils.NOTIFICATION_COUNT,
      media_id: widget.media.id,
    ).then((value) {
      if (value.errorcode == ApiImplementer.SUCCESS) {
        setState(() {
          _commentList = value.data.list;
        });
      } else if (value.errorcode == "2") {
        print("logout");
        _sharedPreferences.clear();
        Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
        CommonDialogUtil.showErrorSnack(context: context, msg: value.msg);
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
      media_id: widget.media.id,
      comments: comment,
    ).then((value) {
      Navigator.of(context).pop();
      PostCommentsModel postCommentsModel = value;
      if (postCommentsModel.errorcode == '0') {
        getCommentList();
        CommonDialogUtil.showSuccessSnack(
            context: context, msg: postCommentsModel.msg);
      } else if (value.errorcode == "2") {
        print("logout");
        _sharedPreferences.clear();
        Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
        CommonDialogUtil.showErrorSnack(context: context, msg: value.msg);
      } else {
        CommonDialogUtil.showErrorSnack(
            context: context, msg: postCommentsModel.msg);
      }
    }).onError((error, stackTrace) {
      Navigator.of(context).pop();
      CommonDialogUtil.showErrorSnack(context: context, msg: error.toString());
    });
  }

  void sendViewsToPost() {
    // CommonDialogUtil.showProgressDialog(context, 'Please wait...');
    ApiImplementer.sendMediaViews(
      accessToken: _accessToken,
      user_id: _userId,
      media_id: widget.media.id,
    ).then((value) {});
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(56.0),
            child: CommonAppBar(),
          ),
          body: IntrinsicHeight(
            child: Container(
              height: MediaQuery.of(context).size.height - 56.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    flex: 7,
                    child: Stack(
                      children: [
                        Container(
                          child: Hero(
                            tag: widget.media.id,
                            child: Container(
                              child: CachedNetworkImage(
                                fit: BoxFit.fill,
                                errorWidget: (context, _, te) =>
                                    Image.asset(out_out_actionbar),
                                placeholder: (context, _) =>
                                    Image.asset(splash_logo),
                                imageUrl: widget.media.mediaUrl,
                                fadeInCurve: Curves.easeInOut,
                              ),
                              // decoration: BoxDecoration(
                              //   border: Border.all(
                              //     width: 6,
                              //     color: CustomColor.colorAccent,
                              //   ),
                              // ),
                            ),
                          ),
                          width: MediaQuery.of(context).size.width,
                        ),
                        Positioned(
                            bottom: 10,
                            right: 10,
                            child: InkWell(
                                onTap: () {
                                  if(widget.media.taggedUserNames!=null&&widget.media.taggedUserNames.isNotEmpty){
                                    openBottomSheetTaggedUser(widget.media.taggedUserNames,widget.media.taggedUserIds);
                                  }
                                },
                                child: Icon(FlutterIcons.user_circle_o_faw)))
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Container(
                      padding: EdgeInsets.all(16.0),
                      color: Colors.grey,
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
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
                                  widget.media.city,
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                Spacer(),
                                Text(
                                  (widget.media.likes == null
                                      ? '0'
                                      : '${widget.media.likes}'),
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
                                //   '${widget.media.views} Viewss',
                                //   style: TextStyle(
                                //     color: Colors.white,
                                //   ),
                                // ),
                              ],
                            ),
                            Text(
                              widget.media.caption,
                              style: TextStyle(
                                color: Colors.white,
                              ),
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
                                        borderRadius:
                                            BorderRadius.circular(30.0),
                                        color: Colors.white,
                                      ),
                                      child: TextFormField(
                                        controller:
                                            _commentsTextEditingController,
                                        readOnly: true,
                                        maxLines: 1,
                                        onTap: () {
                                          CommonDialogUtil
                                              .emojiKeyboardBottomSheet(
                                                  context: context,
                                                  onEmojiSelected:
                                                      onEmojiSelected);
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
                                    itemBuilder: (context, index) =>
                                        ItemCommentList(
                                      commentData:
                                          _commentList.elementAt(index),
                                    ),
                                  )
                                : SizedBox()
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        onWillPop: _willPopCallback);
  }

  void openBottomSheetTaggedUser(String taggedUserNames, String taggedUserIds) {
    showModalBottomSheet(
        context: context,
        builder: (builder){
          var nameArray=taggedUserNames.split(",");
          var idArray=taggedUserIds.split(",");
          return new Container(
            color: Colors.transparent, //could change this to Color(0xFF737373),
            //so you don't have to change MaterialApp canvasColor
            child: Column(
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Tags',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: CommonUtils.FONT_SIZE_20),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                ListView.separated(
                    separatorBuilder: (context, index) {
                      return Divider();
                    },
                    shrinkWrap: true,
                    itemCount: nameArray.length,
                    itemBuilder: (BuildContext context, int index) {
                      var item = nameArray.elementAt(index);
                      return InkWell(
                          onTap: () {
                            Navigator.pop(context, item);
                          },
                          child: Padding(
                            padding:  EdgeInsets.symmetric(vertical: 15.0,horizontal: 12),
                            child: Text(
                              '${item}',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: CommonUtils.FONT_SIZE_14),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          )
                      );
                    }),
              ],
            )/* new Container(
                decoration: new BoxDecoration(
                    color: Colors.white,
                    borderRadius: new BorderRadius.only(
                        topLeft: const Radius.circular(10.0),
                        topRight: const Radius.circular(10.0))),
                child: new Center(
                  child: new Text("This is a modal sheet"),
                )),*/
          );
        }
    );
  }
  Future<bool> _willPopCallback() async {
    Navigator.of(context).pop(true);
    return false; // return true if the route to be popped
  }
}

