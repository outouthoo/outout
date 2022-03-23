import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:out_out/api/api_implementer.dart';
import 'package:out_out/models/notifications/broadcast_message_notification.dart';
import 'package:out_out/pages/common/login_page.dart';
import 'package:out_out/providers/common_details_provider.dart';
import 'package:out_out/utils/common_dialog_util.dart';
import 'package:out_out/utils/commona_utils.dart';
import 'package:out_out/utils/custom_colors.dart';
import 'package:out_out/utils/icon_utils.dart';
import 'package:out_out/widget/app_button.dart';
import 'package:out_out/widget/common_app_bar.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShowBroadcastMessagePage extends StatefulWidget {
  final BroadcastMessageNotification notification;

  const ShowBroadcastMessagePage({Key key, this.notification})
      : super(key: key);

  @override
  _ShowBroadcastMessagePageState createState() =>
      _ShowBroadcastMessagePageState();
}

class _ShowBroadcastMessagePageState extends State<ShowBroadcastMessagePage> {
  User _user;
  SharedPreferences _sharedPreferences;

  bool isLiked = false;

  @override
  void initState() {
    _user = Provider.of<CommonDetailsProvider>(context, listen: false).user;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _sharedPreferences =
        Provider.of<CommonDetailsProvider>(context).getPreferencesInstance;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56.0),
        child: CommonAppBar(),
      ),
      body: Container(
        margin: EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 5, right: 10, left: 10),
                    child: Row(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          //BoxDecoration Widget
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 3,
                              color: CustomColor.colorPrimaryDark,
                            ), //Border.all
                            borderRadius: BorderRadius.circular(25),
                          ), //BoxDecoration
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(25),
                            child: CachedNetworkImage(
                              errorWidget: (context, _, error) =>
                                  Image.asset(person_placeholder),
                              placeholder: (context, _) =>
                                  Image.asset(person_placeholder),
                              imageUrl: widget.notification.profileImage,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Expanded(
                            child: Container(
                          margin: EdgeInsets.all(5),
                          child: Text(
                            widget.notification.fromusername +
                                ' has a New Broadcast Message',
                            style: TextStyle(
                                fontSize: CommonUtils.FONT_SIZE_20,
                                color: CustomColor.colorPrimary),
                          ),
                        ))
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(15),
                    height: 200,
                    child: SingleChildScrollView(
                      controller: ScrollController(),
                      child: Text(
                        widget.notification.message,
                        style: TextStyle(
                          fontSize: CommonUtils.FONT_SIZE_18,
                        ),
                      ),
                    ),
                  )
                ],
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              margin: EdgeInsets.zero,
              elevation: 0.0,
            ),
            SizedBox(
              height: 25.0,
            ),
            Row(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                    child: AppButton(
                  text: isLiked ? "LIKED" : "LIKE",
                  onPressed: () {
                    ApiImplementer.likeBroadcastMessage(
                            accessToken: _user.accessToken,
                            userid: _user.userId,
                            messageId: widget.notification.messageId,
                            isLiked: isLiked ? "0" : "1")
                        .then((value) {
                      Fluttertoast.showToast(msg: value.msg);
                      if (value.errorcode == ApiImplementer.SUCCESS) {
                        setState(() {
                          isLiked = !isLiked;
                        });
                        // Navigator.pop(context);
                      } else if (value.errorcode == "2") {
                        print("logout");
                        _sharedPreferences.clear();
                        Navigator.of(context)
                            .pushReplacementNamed(LoginScreen.routeName);
                        CommonDialogUtil.showErrorSnack(
                            context: context, msg: value.msg);
                      }
                    });
                  },
                )),
                SizedBox(
                  width: 5,
                ),
                Expanded(
                    child: AppButton(
                  text: "REPOST",
                  onPressed: () {
                    ApiImplementer.repostBroadcastMessage(
                      accessToken: _user.accessToken,
                      userid: _user.userId,
                      messageId: widget.notification.messageId,
                    ).then((value) {
                      Fluttertoast.showToast(msg: value.msg);
                      if (value.errorcode == ApiImplementer.SUCCESS) {
                        // Navigator.pop(context);
                      } else if (value.errorcode == "2") {
                        print("logout");
                        _sharedPreferences.clear();
                        Navigator.of(context)
                            .pushReplacementNamed(LoginScreen.routeName);
                        CommonDialogUtil.showErrorSnack(
                            context: context, msg: value.msg);
                      }
                    });
                  },
                )),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
