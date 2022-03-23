import 'package:flutter/material.dart';
import 'package:out_out/api/api_implementer.dart';
import 'package:out_out/models/notification_list_model.dart';
import 'package:out_out/pages/common/login_page.dart';
import 'package:out_out/pages/home_page.dart';
import 'package:out_out/providers/common_details_provider.dart';
import 'package:out_out/utils/common_dialog_util.dart';
import 'package:out_out/utils/commona_utils.dart';
import 'package:out_out/utils/custom_colors.dart';
import 'package:out_out/widget/app_error.dart';
import 'package:out_out/widget/app_loader.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationPage extends StatefulWidget {
  final String type;

  const NotificationPage({Key key, this.type}) : super(key: key);

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  User user;
  String error;
  SharedPreferences _sharedPreferences;

  GetNotificationResponse _response;

  @override
  void initState() {
    super.initState();

    getNotificationList();
  }

  @override
  void didChangeDependencies() {
    _sharedPreferences =
        Provider.of<CommonDetailsProvider>(context).getPreferencesInstance;
    super.didChangeDependencies();
  }

  void getNotificationList() async {
    user = Provider.of<CommonDetailsProvider>(context, listen: false).user;
    ApiImplementer.getNotificationList(
      accessToken: user.accessToken,
      user_id: user.userId,
      offset: 1,
      limit: CommonUtils.NOTIFICATION_COUNT,
      type: widget.type,
    ).then((value) {
      if (value.errorcode == "2") {
        print("logout");
        _sharedPreferences.clear();
           Navigator.of(context).pushNamedAndRemoveUntil(LoginScreen.routeName, (Route<dynamic> route) => false);
        CommonDialogUtil.showErrorSnack(context: context, msg: value.msg);
      } else {
        setState(() {
          _response = value;
        });
      }
    });
  }

  void readNotificationList(Notifications item) async {
    user = Provider.of<CommonDetailsProvider>(context, listen: false).user;
    ApiImplementer.readNotificationList(
      accessToken: user.accessToken,
      id: item.id,
      messageId: item.mediaId,
    ).then((value) {
      if (value.errorcode == "2") {
        print("logout");
        _sharedPreferences.clear();
           Navigator.of(context).pushNamedAndRemoveUntil(LoginScreen.routeName, (Route<dynamic> route) => false);
        CommonDialogUtil.showErrorSnack(context: context, msg: value.msg);
      } else {
        setState(() {
          // _response = value;
          item.isRead="1";
        });
        Navigator.of(context).pushNamed(HomePage.routeName);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   centerTitle: true,
      //   backgroundColor: Colors.grey,
      //   elevation: 0.0,
      //   automaticallyImplyLeading: false,
      //   leading: IconButton(
      //     icon: Icon(
      //       Icons.arrow_back_ios,
      //       color: Colors.white38,
      //     ),
      //     onPressed: () {
      //       Navigator.of(context).pop();
      //     },
      //   ),
      //   title:  Container(height: 70,
      //       child: Image.asset(out_out_actionbar)),
      // ),
      body: _response == null
          ? AppLoader()
          : (_response != null && _response.errorcode == "1")
              ? AppError(
                  error: _response.msg,
                )
              : ListView.builder(
                  padding: EdgeInsets.all(8),
                  itemCount: _response.data.notifications.length,
                  itemBuilder: (context, index) {
                    return _buildItemNotification(
                        _response.data.notifications.elementAt(index));
                  },
                ),
    );
  }

  Widget _buildItemNotification(Notifications item) {
    return GestureDetector(
      onTap: (){

        readNotificationList(item);
      },
      child: Container(
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.all(5),
          decoration: BoxDecoration(
              color: item.isRead == "0"
                  ? CustomColor.colorAccent.withOpacity(0.5)
                  : CustomColor.colorPrimary.withOpacity(0.5),
              borderRadius: BorderRadius.circular(5)),
          child: Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(item.profile_image),
              ),
              SizedBox(
                width: 5,
              ),
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.description,
                    style: Theme.of(context).primaryTextTheme.subtitle1,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      CommonUtils().getLocalDateTimeStdFormat(
                          DateTime.parse(item.createdAt)),
                      style: Theme.of(context).primaryTextTheme.caption,
                    ),
                  )
                ],
              ))
            ],
          )),
    );
  }
}
