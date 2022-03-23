import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_browser/flutter_web_browser.dart';
import 'package:out_out/api/api_implementer.dart';
import 'package:out_out/models/change_password_model.dart';
import 'package:out_out/models/logout_model.dart';
import 'package:out_out/pages/common/login_page.dart';
import 'package:out_out/pages/wallet/walletpage.dart';
import 'package:out_out/providers/common_details_provider.dart';
import 'package:out_out/utils/common_dialog_util.dart';
import 'package:out_out/utils/custom_colors.dart';
import 'package:out_out/utils/preferences_constants.dart';
import 'package:out_out/widget/change_password.dart';
import 'package:out_out/widget/common_app_bar.dart';
import 'package:out_out/widget/fotgot_password.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../advertisement.dart';
import '../../datevalidation.dart';
import '../renew_membership.dart';

class SettingsPage extends StatefulWidget {
  static const routeName = '/settings-page';

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  SharedPreferences _sharedPreferences;
  bool _isLoaded = false;
  bool _isUserLoggedIn = false;
  bool _isGotoLoginPage = false;

  Future showLogoutDialog() {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding:
              EdgeInsets.only(top: 20.0, bottom: 12.0, left: 24.0, right: 24.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(20.0),
            ),
          ),
          content: Container(
            width: 260.0,
            height: 140.0,
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  'Logout',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18.0,
                  ),
                ),
                Spacer(),
                Container(
                  child: Text(
                    'Are you sure,do you want to logout ?',
                    style: TextStyle(
                      fontSize: 14.0,
                    ),
                  ),
                ),
                Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'No',
                        style: TextStyle(
                          color: CustomColor.colorAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        logoutUser();
                      },
                      child: Text(
                        'Yes',
                        style: TextStyle(
                          color: CustomColor.colorAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void onPasswordChangedClick({
    @required String newPass,
    @required String confirmPass,
  }) {
    print('called');
    CommonDialogUtil.showProgressDialog(context, 'Please wait...');
    ApiImplementer.changePasswordApiImplementer(
      accessToken:
          _sharedPreferences.getString(PreferenceConstants.ACCESS_TOKEN),
      userid: _sharedPreferences.getString(PreferenceConstants.USER_ID),
      newPass: newPass,
      confirmPass: confirmPass,
    ).then((value) {
      Navigator.of(context).pop();
      ChangePasswordModel changePasswordModel = value;
      if (changePasswordModel.errorcode == '0') {
        CommonDialogUtil.showSuccessSnack(
            context: context, msg: changePasswordModel.msg);
      } else if (changePasswordModel.errorcode == '2') {
        print("logout");
        _sharedPreferences.clear();
           Navigator.of(context).pushNamedAndRemoveUntil(LoginScreen.routeName, (Route<dynamic> route) => false);
        CommonDialogUtil.showErrorSnack(
            context: context, msg: changePasswordModel.msg);
      } else {
        CommonDialogUtil.showErrorSnack(
            context: context, msg: changePasswordModel.msg);
      }
    }).onError((error, stackTrace) {
      Navigator.of(context).pop();
      CommonDialogUtil.showErrorSnack(context: context, msg: error.toString());
    });
  }

  void onForgotPasswordClick({@required String emailId}) {
    CommonDialogUtil.showProgressDialog(context, 'Please wait...');
    ApiImplementer.forgotPasswordApiImplementer(
            accessToken:
                _sharedPreferences.getString(PreferenceConstants.ACCESS_TOKEN),
            emailId: emailId)
        .then((value) {
      Navigator.of(context).pop();
      if (value.errorcode == '0') {
        CommonDialogUtil.showSuccessSnack(context: context, msg: value.msg);
      } else if (value.errorcode == '2') {
        print("logout");
        _sharedPreferences.clear();
           Navigator.of(context).pushNamedAndRemoveUntil(LoginScreen.routeName, (Route<dynamic> route) => false);
        CommonDialogUtil.showErrorSnack(context: context, msg: value.msg);
      } else {
        CommonDialogUtil.showErrorSnack(context: context, msg: value.msg);
      }
    }).onError((error, stackTrace) {
      Navigator.of(context).pop();
      CommonDialogUtil.showErrorSnack(context: context, msg: error.toString());
    });
  }

  Future showChanePasswordDialog() {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding:
              EdgeInsets.only(top: 0.0, bottom: 0.0, left: 0.0, right: 0.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(20.0),
            ),
          ),
          content: Container(
            child: ChangePassword(
              onPasswordChangedClick: onPasswordChangedClick,
            ),
          ),
        );
      },
    );
  }

  Future showForgotPasswordDialog() {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding:
              EdgeInsets.only(top: 0.0, bottom: 0.0, left: 0.0, right: 0.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(20.0),
            ),
          ),
          content: Container(
            child: ForgotPassword(
              onForgotPasswordClick: onForgotPasswordClick,
            ),
          ),
        );
      },
    );
  }

  void logoutUser() {
    CommonDialogUtil.showProgressDialog(context, 'Please wait...');
    ApiImplementer.logoutApiImplementer(
            accessToken:
                _sharedPreferences.getString(PreferenceConstants.ACCESS_TOKEN),
            userid: _sharedPreferences.getString(PreferenceConstants.USER_ID))
        .then((value) {
      LogOutModel logOutModel = value;
      if (logOutModel.errorcode == '0') {
        CommonDialogUtil.showSuccessSnack(
            context: context, msg: logOutModel.msg);
        _sharedPreferences.clear();
        // Navigator.of(context).pop();
        // if (_isGotoLoginPage != null && _isGotoLoginPage) {
             Navigator.of(context).pushNamedAndRemoveUntil(LoginScreen.routeName, (Route<dynamic> route) => false);
        // }
      } else {
        //CommonDialogUtil.showErrorSnack(context: context, msg: logOutModel.msg);
        _sharedPreferences.clear();
        Navigator.of(context).pop();
        // if (_isGotoLoginPage != null && _isGotoLoginPage) {
             Navigator.of(context).pushNamedAndRemoveUntil(LoginScreen.routeName, (Route<dynamic> route) => false);
        // }
      }
    }).onError((error, stackTrace) {
      _sharedPreferences.clear();
      Navigator.of(context).pop();
      // if (_isGotoLoginPage != null && _isGotoLoginPage) {
           Navigator.of(context).pushNamedAndRemoveUntil(LoginScreen.routeName, (Route<dynamic> route) => false);
      // }
      // Navigator.of(context).pop();
      // CommonDialogUtil.showErrorSnack(context: context, msg: error.toString());
    });
  }

  @override
  void didChangeDependencies() {
    if (!_isLoaded) {
      _sharedPreferences =
          Provider.of<CommonDetailsProvider>(context, listen: false)
              .getPreferencesInstance;
      _isUserLoggedIn =
          _sharedPreferences.getBool(PreferenceConstants.IS_USER_LOGGED_IN) ??
              false;
      setState(() {});
    }
    _isLoaded = true;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    _isGotoLoginPage = ModalRoute.of(context).settings.arguments as bool;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56.0),
        child: CommonAppBar(),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              if (!_isUserLoggedIn)
                ListTile(
                  contentPadding: EdgeInsets.all(16.0),
                  onTap: () {
                    showForgotPasswordDialog();
                  },
                  leading: Icon(
                    Icons.face_sharp,
                    size: 30.0,
                  ),
                  title: Text('Forgot Password'),
                  trailing: Icon(Icons.arrow_forward_ios_sharp),
                ),
              Divider(
                height: 0.0,
              ),
             /* if (_isUserLoggedIn)
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [

                  ],
                ),*/
            ListTile(
                contentPadding: EdgeInsets.all(16.0),
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => RenewMembershipPage()),
                  );
                },
                leading: Icon(
                  Icons.card_membership_rounded,
                  size: 30.0,
                ),
                title: Text('Membership'),
                trailing: Icon(Icons.arrow_forward_ios_sharp),
              ),
              Divider(
                height: 0.0,
              ),
              checkDateIsToday()?ListTile(
                contentPadding: EdgeInsets.all(16.0),
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => WalletPage()),
                  );
                },
                leading: Icon(
                  Icons.account_balance_wallet_rounded,
                  size: 30.0,
                ),
                title: Text('Wallet'),
                trailing: Icon(Icons.arrow_forward_ios_sharp),
              ):Container(),
              Divider(
                height: 0.0,
              ),
              ListTile(
                contentPadding: EdgeInsets.all(16.0),
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => advertisement()),
                  );
                },
                leading: Icon(
                  Icons.add_business_outlined,
                  size: 30.0,
                ),
                title: Text('Advertisement'),
                trailing: Icon(Icons.arrow_forward_ios_sharp),
              ),
              Divider(
                height: 0.0,
              ),
              ListTile(
                contentPadding: EdgeInsets.all(16.0),
                onTap: () {
                  showChanePasswordDialog();
                },
                leading: Icon(
                  Icons.lock_clock,
                  size: 30.0,
                ),
                title: Text('Change Password'),
                trailing: Icon(Icons.arrow_forward_ios_sharp),
              ),
              Divider(
                height: 0.0,
              ),
              ListTile(
                contentPadding: EdgeInsets.all(16.0),
                onTap: () {
                  CommonDialogUtil.showAboutUsDialog(context: context);
                },
                leading: Icon(
                  Icons.info,
                  size: 30.0,
                ),
                title: Text('About OutOut'),
                trailing: Icon(Icons.arrow_forward_ios_sharp),
              ),
              Divider(
                height: 0.0,
              ),
              ListTile(
                contentPadding: EdgeInsets.all(16.0),
                onTap: () {
                  FlutterWebBrowser.openWebPage(
                    url: 'https://outout.app',
                    safariVCOptions: SafariViewControllerOptions(
                      barCollapsingEnabled: true,
                      dismissButtonStyle:
                          SafariViewControllerDismissButtonStyle.close,
                      modalPresentationCapturesStatusBarAppearance: true,
                    ),
                  );
                },
                leading: Icon(
                  Icons.privacy_tip,
                  size: 30.0,
                ),
                title: Text('Privacy Policy'),
                trailing: Icon(Icons.arrow_forward_ios_sharp),
              ),
              Divider(
                height: 0.0,
              ),
              ListTile(
                contentPadding: EdgeInsets.all(16.0),
                onTap: () {
                  FlutterWebBrowser.openWebPage(
                    url: 'https://outout.app/company',
                    safariVCOptions: SafariViewControllerOptions(
                      barCollapsingEnabled: true,
                      preferredBarTintColor: Colors.blueGrey[900],
                      preferredControlTintColor: Colors.blueGrey[900],
                      dismissButtonStyle:
                          SafariViewControllerDismissButtonStyle.close,
                      modalPresentationCapturesStatusBarAppearance: true,
                    ),
                    customTabsOptions: CustomTabsOptions(
                      toolbarColor: Colors.blueGrey[900],
                      secondaryToolbarColor: Colors.blueGrey[900],
                      navigationBarColor: Colors.blueGrey[900],
                    ),
                  );
                },
                leading: Icon(
                  Icons.rule,
                  size: 30.0,
                ),
                title: Text('Terms & Conditions'),
                trailing: Icon(Icons.arrow_forward_ios_sharp),
              ),
              Divider(
                height: 0.0,
              ),
              ListTile(
                contentPadding: EdgeInsets.all(16.0),
                onTap: () {
                  showLogoutDialog();
                },
                leading: Icon(
                  Icons.logout,
                  size: 30.0,
                ),
                title: Text('Logout'),
                trailing: Icon(Icons.arrow_forward_ios_sharp),
              ),
              Divider(
                height: 0.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
