import 'package:flutter/material.dart';
import 'package:out_out/api/api_implementer.dart';
import 'package:out_out/models/search_friends_list_model.dart';
import 'package:out_out/pages/common/login_page.dart';
import 'package:out_out/providers/common_details_provider.dart';
import 'package:out_out/utils/common_dialog_util.dart';
import 'package:out_out/utils/custom_colors.dart';
import 'package:out_out/utils/icon_utils.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SendMoneyPage extends StatefulWidget {
  SendMoneyPage(this.item);

  Data item;

  @override
  SendMoneyPageState createState() => SendMoneyPageState();
}

class SendMoneyPageState extends State<SendMoneyPage> {
  final amountTEC = TextEditingController();
  User _user;
  bool _isLoading = false;
  SharedPreferences _sharedPreferences;

  @override
  void initState() {
    _user = Provider.of<CommonDetailsProvider>(context, listen: false).user;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (!_isLoading) {
      _sharedPreferences =
          Provider.of<CommonDetailsProvider>(context).getPreferencesInstance;
    }
    _isLoading = true;
    super.didChangeDependencies();
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
            Icons.close,
            color: Colors.white,
          ),
          onPressed: () {
            // Navigator.of(context).pushNamed(HomePage.routeName);
            Navigator.pop(context);
          },
        ),
        title: Container(height: 70, child: Image.asset(out_out_actionbar)),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            decoration: ShapeDecoration(
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
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 12.0,
                vertical: 15.0,
              ),
              child: Text(
                'Send Money to ${widget.item.fullName}',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.white),
              ),
            ),
          ),
          Container(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 100,
                    ),
                    Text(
                      "Amount to be send",
                      style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.w600,
                          fontSize: 14),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: TextFormField(
                        decoration: new InputDecoration(
                          border: InputBorder.none,
                        ),
                        keyboardType: TextInputType.phone,
                        controller: amountTEC,
                        validator: validateEmpty,
                      ),
                      decoration: BoxDecoration(
                          color: Color(0xFFF3F6FA),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: InkWell(
                        onTap: () {
                          sendMoneyApiCall(amountTEC.text.toString());
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.9,
                          height: 45,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50))),
                          child: Text(
                            "Send Money to ${widget.item.fullName}",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontSize: 16),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static String validateEmpty(String value, {String errorTitle}) {
    if (value.isEmpty || value.trim().isEmpty || value.length < 6) {
      return '$errorTitle is empty';
    }
    return null;
  }

  void sendMoneyApiCall(String amount) async {
    try {
      await ApiImplementer.sendMoneyToUser(
              accessToken: _user.accessToken,
              userid: _user.userId,
              toUserId: widget.item.userId,
              amount: amount)
          .then((value) {
        if (value.errorcode == ApiImplementer.SUCCESS) {
          _isLoading = false;
          CommonDialogUtil.showSuccessSnack(context: context, msg: value.msg);
          Navigator.pop(context, true);
        }
        if (value.errorcode == ApiImplementer.FAIL) {
          _isLoading = false;
          CommonDialogUtil.showErrorSnack(context: context, msg: value.msg);
        } else if (value.errorcode == "2") {
          print("logout");
          _sharedPreferences.clear();
          Navigator.of(context).pushNamedAndRemoveUntil(
              LoginScreen.routeName, (Route<dynamic> route) => false);
          CommonDialogUtil.showErrorSnack(context: context, msg: value.msg);
        }
      });
    } catch (error) {}
  }
}
