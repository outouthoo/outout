import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:out_out/api/api_implementer.dart';
import 'package:out_out/pages/common/login_page.dart';
import 'package:out_out/providers/common_details_provider.dart';
import 'package:out_out/utils/common_dialog_util.dart';
import 'package:out_out/utils/commona_utils.dart';
import 'package:out_out/utils/custom_colors.dart';
import 'package:out_out/widget/common_app_bar.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateBroadcastMessage extends StatefulWidget {
  const CreateBroadcastMessage({Key key}) : super(key: key);

  @override
  _CreateBroadcastMessageState createState() => _CreateBroadcastMessageState();
}

class _CreateBroadcastMessageState extends State<CreateBroadcastMessage> {
  TextEditingController _msgController;
  User _user;
  SharedPreferences _sharedPreferences;

  @override
  void initState() {

    _msgController = TextEditingController();
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
            Container(
              // margin: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Broadcast Message',
                style: TextStyle(
                    fontSize: CommonUtils.FONT_SIZE_18,
                    color: CustomColor.colorPrimary),
              ),
            ),
            SizedBox(
              height: 15.0,
            ),
            Card(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                alignment: Alignment.center,
                child: new TextField(
                  controller: _msgController,
                  textInputAction: TextInputAction.newline,
                  maxLines: 5,
                  style: TextStyle(
                    fontSize: CommonUtils.FONT_SIZE_18,
                  ),
                  decoration: InputDecoration(
                    hintText: 'What would you like to share?',
                    border: InputBorder.none,
                  ),
                ),
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
            Container(
              alignment: Alignment.center,
              child: ElevatedButton.icon(
                icon: Icon(
                  Icons.send,
                  color: Colors.white,
                ),
                onPressed: () {
                  if (_msgController.text.trim().length > 0) {
                    ApiImplementer.sendBroadcastMessage(
                            accessToken: _user.accessToken,
                            userid: _user.userId,
                            message: _msgController.text)
                        .then((value) {
                      Fluttertoast.showToast(msg: value.msg);
                      if (value.errorcode == ApiImplementer.SUCCESS) {
                        Navigator.pop(context);
                      }else if (value.errorcode == "2") {
                        print("logout");
                        _sharedPreferences.clear();
                        Navigator.of(context)
                            .pushReplacementNamed(LoginScreen.routeName);
                        CommonDialogUtil.showErrorSnack(
                            context: context, msg: value.msg);
                      }
                    });
                  } else {
                    showToast("Oops! Invalid Broadcast Message");
                  }
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                      if (states.contains(MaterialState.pressed))
                        return Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.5);
                      return null; // Use the component's default.
                    },
                  ),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                ),
                label: Text('SEND'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
