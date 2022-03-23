import 'dart:io';
import 'dart:ui';

import 'package:device_info/device_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:out_out/api/api_implementer.dart';
import 'package:out_out/models/login_with_user_name_and_otp_model.dart';
import 'package:out_out/models/send_otp_model.dart';
import 'package:out_out/models/verify_otp_model.dart';
import 'package:out_out/pages/common/register_page.dart';
import 'package:out_out/pages/common/settings_page.dart';
import 'package:out_out/pages/memory_page/memory_page.dart';
import 'package:out_out/providers/common_details_provider.dart';
import 'package:out_out/utils/common_dialog_util.dart';
import 'package:out_out/utils/commona_utils.dart';
import 'package:out_out/utils/icon_utils.dart';
import 'package:out_out/utils/preferences_constants.dart';
import 'package:out_out/widget/common_gradiant_btn.dart';
import 'package:out_out/widget/forget_userid.dart';
import 'package:out_out/widget/fotgot_password.dart';
import 'package:out_out/widget/login_with_otp.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:local_auth/local_auth.dart';

import '../membership_page.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/login-screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscureText = true;
  final _userNameTextEditingController = TextEditingController();
  final _passwordTextEditingController = TextEditingController();
  SharedPreferences _sharedPreferences;
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  String deviceId;
  String enteredOTP = '';
  String enteredMobileNo = '';
  bool _isLoaded = false;

  final LocalAuthentication _localAuth = LocalAuthentication();

  bool _isValid() {
    String userName = _userNameTextEditingController.text;
    String password = _passwordTextEditingController.text;
    bool isValid = true;
    if (userName == null || userName.isEmpty) {
      isValid = false;
      CommonDialogUtil.showErrorSnack(
          context: context, msg: 'Please enter username!');
    } else if (password == null || password.isEmpty) {
      CommonDialogUtil.showErrorSnack(
          context: context, msg: 'Please enter password!');
      isValid = false;
    }
    return isValid;
  }

  @override
  void didChangeDependencies() async {
    if (!_isLoaded) {
      _sharedPreferences =
          Provider.of<CommonDetailsProvider>(context, listen: false)
              .getPreferencesInstance;
      super.didChangeDependencies();
    }
    _isLoaded = true;
  }

  Future<void> checkAuthSetting() async {
    initializeFaceRecognition();
    if (!kReleaseMode) {
      _userNameTextEditingController.text =
          _sharedPreferences.getString(PreferenceConstants.USER_NAME);
      _passwordTextEditingController.text =
          _sharedPreferences.getString(PreferenceConstants.PASSWORD);
    }
    setState(() {
      _isChecked = true;
    });
  }

  initializeFaceRecognition() async {
    bool canCheckBiometrics = await _localAuth.canCheckBiometrics;
    if (!canCheckBiometrics) {
      // setState(() =>
      print("========>  This device does not support biometrics ");
      return;
    }
    List<BiometricType> availableBiometrics =
        await _localAuth.getAvailableBiometrics();
    if (availableBiometrics.length != 0) {
      if (availableBiometrics.contains(BiometricType.face)) {
        print("========>  Face Biometrics Found! ");

        var didAuthenticate = await _localAuth.authenticate(
            localizedReason: 'Authenticate with face recognition',
            useErrorDialogs: false);

        if (didAuthenticate) {
          _userNameTextEditingController.text =
              await _sharedPreferences.getString(PreferenceConstants.USER_NAME);
          _passwordTextEditingController.text =
              await _sharedPreferences.getString(PreferenceConstants.PASSWORD);
          loginAPiCall();
        } else {
          _userNameTextEditingController.text = "";
          _passwordTextEditingController.text = "";
          /* CommonDialogUtil.showErrorSnack(
              context: context,
              msg: "Authentication Failed with face recognition");*/
        }
        return;
      } else if (availableBiometrics.contains(BiometricType.fingerprint)) {
        print("========> Fingerprint Biometrics Found! ");
        var isAuthenticated = await _localAuth.authenticate(
          localizedReason: 'Verify your Fingerprint',
          biometricOnly: false,
        );
        print("========> $isAuthenticated ");
        if (isAuthenticated) {
          _userNameTextEditingController.text =
              await _sharedPreferences.getString(PreferenceConstants.USER_NAME);
          _passwordTextEditingController.text =
              await _sharedPreferences.getString(PreferenceConstants.PASSWORD);
          loginAPiCall();
        } else {
          _userNameTextEditingController.text = "";
          _passwordTextEditingController.text = "";
          /* CommonDialogUtil.showErrorSnack(
              context: context, msg: "Authentication Failed with Fingerprint");*/
        }
        return;
      }
    } else {
      print("========> No Biometrics Found! ");
      return;
    }
  }

  void loginAPiCall() async {
    if (_isValid()) {
      String userName = _userNameTextEditingController.text;
      String password = _passwordTextEditingController.text;

      CommonDialogUtil.showProgressDialog(context, 'Please wait...');
      ApiImplementer.loginApiImplementer(
        deviceId: await CommonUtils.getId(),
        fcmToken: 'test',
        userName: userName,
        password: password,
      ).then((value) {
        Navigator.of(context).pop();
        LoginWithUsernameAndOTPModel loginModel = value;
        if (loginModel.errorcode == '0') {
          setUserLoginDetails(loginModel: value);
          CommonDialogUtil.showSuccessSnack(
              context: context, msg: loginModel.msg);
          if ((value.data.userdetails.accountType == "1" ||
                  value.data.userdetails.accountType == "2") &&
              value.data.userdetails.payment_status == '1') {
            if (value.data.userdetails.is_trial_completed != "0") {
              Navigator.pushReplacementNamed(context, MembershipPage.routeName);
            } else {
              Navigator.pushReplacementNamed(context, MemoryPage.routeName);
            }
          } else {
            Navigator.pushReplacementNamed(context, MemoryPage.routeName);
          }
        } else {
          CommonDialogUtil.showErrorSnack(
              context: context, msg: loginModel.msg);
        }
      }).onError((error, stackTrace) {
        Navigator.of(context).pop();
        print(stackTrace.toString());
        CommonDialogUtil.showErrorSnack(
            context: context, msg: error.toString());
      });
    }
  }

  void onOTPEntered(String enteredOTP) {
    this.enteredOTP = enteredOTP;
  }

  void onResendOTP() {
    // sendedOTP = CommonUtils.getRandomOTP().toString();
    CommonDialogUtil.showProgressDialog(context, 'Please wait...');
    ApiImplementer.sendOTPApiImplementer(
      accessToken:
          _sharedPreferences.getString(PreferenceConstants.ACCESS_TOKEN),
      phone_number: enteredMobileNo,
    ).then((value) {
      Navigator.of(context).pop();
      SendOTPModel sendOTPModel = value;
      if (sendOTPModel.errorcode == '0') {
        CommonDialogUtil.showToastMsg(
            context: context, toastMsg: sendOTPModel.msg);
      } else {
        CommonDialogUtil.showToastMsg(
            context: context, toastMsg: sendOTPModel.msg);
      }
    }).onError((error, stackTrace) {
      Navigator.of(context).pop();
      CommonDialogUtil.showToastMsg(
          context: context, toastMsg: error.toString());
    });
  }

  void onVerifyOTP() {
    if (enteredOTP.length != 4) {
      CommonDialogUtil.showToastMsg(
          context: context, toastMsg: 'OTP length must be four character!');
    } else {
      //call verify OTP
      CommonDialogUtil.showProgressDialog(context, 'Please wait...');
      ApiImplementer.verifyOTPApiImplementer(
        accessToken:
            _sharedPreferences.getString(PreferenceConstants.ACCESS_TOKEN),
        otp: enteredOTP,
      ).then((value) {
        Navigator.of(context).pop();
        VerifyOTPModel verifyOTPModel = value;
        if (verifyOTPModel.errorcode == '0') {
          CommonDialogUtil.showSuccessSnack(
              context: context, msg: verifyOTPModel.msg);
          Navigator.pushReplacementNamed(context, MemoryPage.routeName);
        } else {
          CommonDialogUtil.showToastMsg(
              context: context, toastMsg: verifyOTPModel.msg);
        }
      }).catchError((error) {
        Navigator.of(context).pop();
        CommonDialogUtil.showToastMsg(
            context: context, toastMsg: error.toString());
      });
    }
  }

  void onMobileNoEntered(String mobileNo) {
    enteredMobileNo = mobileNo;
    // sendedOTP = CommonUtils.getRandomOTP().toString();
    // Navigator.of(context).pop();
    CommonDialogUtil.showProgressDialog(context, 'Please wait...');
    ApiImplementer.loginWithOTPApiImplementer(
      deviceId: deviceId,
      fcmToken: 'test',
      phone_number: mobileNo,
    ).then((value) {
      Navigator.of(context).pop();
      LoginWithUsernameAndOTPModel loginWithOTPModel = value;
      if (loginWithOTPModel.errorcode == '0') {
        setUserLoginDetails(loginModel: loginWithOTPModel);
        CommonDialogUtil.verifyOTPCommonModalBottomSheet(
          context: context,
          mobileNo: mobileNo,
          onOTPEntered: onOTPEntered,
          onResendOTP: onResendOTP,
          onVerifyOTP: onVerifyOTP,
        );
      } else {
        CommonDialogUtil.showErrorSnack(
            context: context, msg: loginWithOTPModel.msg);
      }
    }).catchError((error) {
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
      CommonDialogUtil.showErrorSnack(context: context, msg: error.toString());
    });
  }

  @override
  void initState() {
    getDeviceInfo();
    super.initState();
  }

  void getDeviceInfo() async {
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      deviceId = androidInfo.androidId;
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      deviceId = iosInfo.identifierForVendor;
    }
    var isRemember =
        await _sharedPreferences.getBool(PreferenceConstants.REMEMBER_ME) ??
            false;
    print(isRemember);
    if (isRemember) checkAuthSetting();
  }

  @override
  void dispose() {
    _userNameTextEditingController.dispose();
    _passwordTextEditingController.dispose();
    super.dispose();
  }

  void _handleRememberme(bool value) {
    _isChecked = value;

    _sharedPreferences.setBool(PreferenceConstants.REMEMBER_ME, true);
    _sharedPreferences.setString(
        PreferenceConstants.USER_NAME, _userNameTextEditingController.text);
    _sharedPreferences.setString(
        PreferenceConstants.PASSWORD, _passwordTextEditingController.text);

    setState(() {
      _isChecked = value;
    });
  }

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void setUserLoginDetails(
      {@required LoginWithUsernameAndOTPModel loginModel}) {
    _sharedPreferences.setBool(PreferenceConstants.IS_USER_LOGGED_IN, true);
    _sharedPreferences.setString(
        PreferenceConstants.ACCESS_TOKEN, loginModel.data.accessToken);

    Userdetails userDetails = loginModel.data.userdetails;

    print(userDetails);
    _sharedPreferences.setString(
        PreferenceConstants.USER_NAME, userDetails.username);
    _sharedPreferences.setString(PreferenceConstants.USER_ID, userDetails.id);
    _sharedPreferences.setString(
        PreferenceConstants.FIRST_NAME, userDetails.firstName);
    _sharedPreferences.setString(
        PreferenceConstants.LAST_NAME, userDetails.lastName);
    _sharedPreferences.setString(PreferenceConstants.DOB, userDetails.dob);
    _sharedPreferences.setString(
        PreferenceConstants.GENDER, userDetails.gender);
    _sharedPreferences.setString(
        PreferenceConstants.MOBILE_NO, userDetails.phoneNumber);
    _sharedPreferences.setString(
        PreferenceConstants.EMAIL_ID, userDetails.email);
    _sharedPreferences.setString(
        PreferenceConstants.ACCOUNT_TYPE, userDetails.accountType);
    _sharedPreferences.setString(PreferenceConstants.LAT, userDetails.latitude);
    _sharedPreferences.setString(
        PreferenceConstants.LONG, userDetails.longitude);
    _sharedPreferences.setString(PreferenceConstants.CITY, userDetails.city);
    _sharedPreferences.setString(
        PreferenceConstants.PROFILE_IMAGE, userDetails.profileImage);
    _sharedPreferences.setString(
        PreferenceConstants.payment_status, userDetails.payment_status);
    _sharedPreferences.setString(
        PreferenceConstants.packageId, userDetails.packageId ?? '0');
    // print("Payment Status:=====================>>>>>>${userDetails.payment_status}");
    _sharedPreferences.setString(
        PreferenceConstants.IS_VERIFIED, userDetails.isVerified);
    _sharedPreferences.setString(PreferenceConstants.IS_VIP, userDetails.isVIP);
    _sharedPreferences.setString(
        PreferenceConstants.WEBSITE, userDetails.website??"");
    _sharedPreferences.setString(PreferenceConstants.Bio, userDetails.bio??"");
    Provider.of<CommonDetailsProvider>(context, listen: false).initUser();
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
      } else {
        CommonDialogUtil.showErrorSnack(context: context, msg: value.msg);
      }
    }).onError((error, stackTrace) {
      Navigator.of(context).pop();
      CommonDialogUtil.showErrorSnack(context: context, msg: error.toString());
    });
  }

  void onForgotUserIdClick({@required String emailId}) {
    CommonDialogUtil.showProgressDialog(context, 'Please wait...');
    ApiImplementer.forgotUsernameApiImplementer(
            accessToken:
                _sharedPreferences.getString(PreferenceConstants.ACCESS_TOKEN),
            emailId: emailId)
        .then((value) {
      Navigator.of(context).pop();
      if (value.errorcode == '0') {
        CommonDialogUtil.showSuccessSnack(context: context, msg: value.msg);
      } else {
        CommonDialogUtil.showErrorSnack(context: context, msg: value.msg);
      }
    }).onError((error, stackTrace) {
      Navigator.of(context).pop();
      CommonDialogUtil.showErrorSnack(context: context, msg: error.toString());
    });
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

  Future showForgotuserIdDialog() {
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
            child: ForgotUserId(
              onForgotPasswordClick: onForgotUserIdClick,
            ),
          ),
        );
      },
    );
  }

  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    TargetPlatform platform = Theme.of(context).platform;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Column(
                children: [
                  Expanded(
                    flex: 3,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 40,
                        ),
                        Container(
                          height: 120,
                          width: 230,
                          child: Image.asset(
                            out_out_actionbar,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 8,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 26.0, vertical: 10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Container(
                                  margin:
                                      EdgeInsets.symmetric(horizontal: 16.0),
                                  child: Text(
                                    'User Name',
                                    style: TextStyle(
                                      fontSize: 15.0,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 4.0,
                                ),
                                Card(
                                  child: Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 16.0),
                                    alignment: Alignment.center,
                                    height: 46.0,
                                    child: new TextField(
                                      controller:
                                          _userNameTextEditingController,
                                      textInputAction: TextInputAction.next,
                                      style: TextStyle(
                                        fontSize: CommonUtils.FONT_SIZE_13,
                                      ),
                                      decoration: InputDecoration(
                                        suffixIcon: Icon(
                                          Icons.person,
                                          color: Colors.grey,
                                        ),
                                        hintText: 'Enter username',
                                        hintStyle: TextStyle(
                                          fontSize: CommonUtils.FONT_SIZE_13,
                                          color: Colors.grey.withOpacity(0.8),
                                        ),
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(30)),
                                  ),
                                  margin: EdgeInsets.zero,
                                  elevation: 0.0,
                                ),
                                SizedBox(
                                  height: 12.0,
                                ),
                                Container(
                                  margin:
                                      EdgeInsets.symmetric(horizontal: 16.0),
                                  child: Text(
                                    'Password',
                                    style: TextStyle(
                                      fontSize: 15.0,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 4.0,
                                ),
                                Card(
                                  child: Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 16.0),
                                    alignment: Alignment.center,
                                    height: 46.0,
                                    child: new TextField(
                                      controller:
                                          _passwordTextEditingController,
                                      textInputAction: TextInputAction.next,
                                      style: TextStyle(
                                        fontSize: CommonUtils.FONT_SIZE_13,
                                      ),
                                      decoration: InputDecoration(
                                        suffixIcon: InkWell(
                                          onTap: _toggle,
                                          child: Icon(
                                            _obscureText
                                                ? Icons.visibility_off
                                                : Icons.visibility,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        hintText: 'Enter password',
                                        hintStyle: TextStyle(
                                          fontSize: CommonUtils.FONT_SIZE_13,
                                          color: Colors.grey.withOpacity(0.8),
                                        ),
                                        border: InputBorder.none,
                                      ),
                                      obscureText: _obscureText,
                                    ),
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(30)),
                                  ),
                                  margin: EdgeInsets.zero,
                                  elevation: 0.0,
                                ),
                                SizedBox(
                                  height: 15.0,
                                ),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                          height: 24.0,
                                          width: 24.0,
                                          child: Theme(
                                            data: ThemeData(
                                                unselectedWidgetColor: Color(
                                                    0xff00C8E8) // Your color
                                                ),
                                            child: Checkbox(
                                                activeColor: Color(0xff00C8E8),
                                                value: _isChecked,
                                                onChanged: _handleRememberme),
                                          )),
                                      SizedBox(width: 10.0),
                                      Text("Remember Me",
                                          style: TextStyle(
                                            color: Color(0xff646464),
                                            fontSize: 12,
                                          ))
                                    ]),
                                SizedBox(
                                  height: 10.0,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        showForgotuserIdDialog();
                                      },
                                      child: Text(
                                        "Forgot Username?",
                                        style: TextStyle(
                                          color: Colors.blue,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        showForgotPasswordDialog();
                                      },
                                      child: Text(
                                        "Forgot Password?",
                                        style: TextStyle(
                                          color: Colors.blue,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 15.0,
                                ),
                                InkWell(
                                  onTap: () async {
                                    loginAPiCall();
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0, horizontal: 40),
                                    child: CommonGradiantButton(
                                      title: 'LOGIN',
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.symmetric(vertical: 8.0),
                                  alignment: Alignment.center,
                                  child: Text(
                                    'OR',
                                    style: TextStyle(
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    CommonDialogUtil
                                        .loginWithOTPCommonModalBottomSheet(
                                      context: context,
                                      onMobileNoEntered: onMobileNoEntered,
                                    );
                                    //loginWithPanelController.open();
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0, horizontal: 40),
                                    child: CommonGradiantButton(
                                      title: 'Login With OTP',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(
                              vertical: 16.0, horizontal: 12.0),
                          child: Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  Navigator.of(context).pushNamed(
                                      SettingsPage.routeName,
                                      arguments: false);
                                },
                                icon: Icon(
                                  Icons.settings,
                                  color: Colors.grey,
                                  size: 30.0,
                                ),
                              ),
                              Spacer(),
                              InkWell(
                                onTap: () {
                                  Navigator.of(context)
                                      .pushNamed(RegisterUserScreen.routeName);
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 8.0, horizontal: 8.0),
                                  child: Text(
                                    'create an account',
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              ),
                              Spacer(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              //forgotPassPanel(),
            ],
          ),
        ),
      ),
    );
  }

  PanelController loginWithPanelController = PanelController();

  forgotPassPanel() {
    return SlidingUpPanel(
      controller: loginWithPanelController,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      backdropTapClosesPanel: true,
      backdropEnabled: true,
      panel: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  icon: Icon(
                    Icons.close,
                    size: 30.0,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 18.0),
                child: Text(
                  'What\'s your mobile number ?',
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.black,
                  ),
                ),
              ),
              Text(
                'Enter your mobile number below to login in\nOutOut.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14.0),
              ),
              Container(
                child: LoginWithOTP(
                  onMobileNoEntered: onMobileNoEntered,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
