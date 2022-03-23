import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CommonUtils {
  static const int NOTIFICATION_COUNT = 20;

  // static const String YOUR_EVENTS = "0";
  // static const String ALL_EVENTS = "1";
  static const  String tokenizationKey = 'sandbox_rz7fckv9_pgjg86nxzz4z4553';

  static const String ADD_FRIEND_PENDING_STATUS = '0';
  static const String ADD_FRIEND_ACCEPTED_STATUS = '1';
  static const String ADD_FRIEND_REJECTED_STATUS = '2';
  // static const int REJECT_AFTER_ACCEPT_STATUS = 3;

  static const String COMMENTS_OPERATION_ADD = "add";
  static const String COMMENTS_OPERATION_EDIT = "edit";
  static const String COMMENTS_OPERATION_DELETE = "delete";

  static const int PAGE_LIMIT = 20;
  static const int MEDIA_TYPE_IMAGE = 0;
  static const int MEDIA_TYPE_VIDEO = 1;
  static const String ACCOUNT_TYPE_NORMAL_USER = '0';
  static const String ACCOUNT_TYPE_BUSINESS_USER = '1';
  static const String ACCOUNT_TYPE_PREMIUM_USER = '2';

  static const String STORY_TYPE_NORMAL = "0";
  static const String STORY_TYPE_OUTFIT = "1";
  static const String STORY_TYPE_PLACES = "2";

  static const String CHAT_TYPE_GROUP = "Group";
  static const String CHAT_TYPE_INDIVIDUAL = "Individual";

  static const String APP_UPDATE_TYPE = "AppUpdateType";
  static const bool IS_FORCE_UPDATE = false;

  static final String API_KEY = "w3e2rosrt3y5u6iter8iug4h58mf1e0";

  static const int ROW_PER_PAGE = 25;
  static const String FOLDER_NAME = 'OutOut';

  static const int CONNECTION_TIME_OUT_IN_MILL_SEC = 180000;
  static const int RECEIVE_TIME_OUT_IN_MILL_SEC = 180000;

  static const String FONT_FAMILY_UBUNTU_REGULAR = "Ubuntu-Regular";
  static const String FONT_FAMILY_UBUNTU_MEDIUM = "Ubuntu-Medium";
  static const String FONT_FAMILY_UBUNTU_Bold = "Ubuntu-Bold";

  static const String FORCE_UPDATE = "ForceUpdate";
  static const String OPTIONAL_UPDATE = "OptionalUpdate";

  static const String NOTIFICATION_TYPE_FEED = "0";
  static const String NOTIFICATION_TYPE_BROADCAST = "1";
  static const String NOTIFICATION_TYPE_STORY = "2";
  static const String NOTIFICATION_TYPE_PLACES = "3";
  static const String NOTIFICATION_TYPE_GO_LIVE = "4";
  static const String NOTIFICATION_TYPE_REQUEST_TO_JOIN_LIVE = "5";
  static const String NOTIFICATION_TYPE_END_GO_LIVE = "6";

  static const double FONT_SIZE_8 = 8.0;
  static const double FONT_SIZE_10 = 10.0;
  static const double FONT_SIZE_11 = 11.0;
  static const double FONT_SIZE_12 = 12.0;
  static const double FONT_SIZE_13 = 13.0;
  static const double FONT_SIZE_14 = 14.0;
  static const double FONT_SIZE_16 = 16.0;
  static const double FONT_SIZE_18 = 18.0;
  static const double FONT_SIZE_20 = 20.0;
  static const double FONT_SIZE_22 = 22.0;
  static const double FONT_SIZE_24 = 24.0;
  static const double FONT_SIZE_26 = 26.0;
  static const double FONT_SIZE_28 = 28.0;
  static const double FONT_SIZE_30 = 30.0;

  static const String DATE_FORMAT_1 = "yyyy-MM-dd HH:mm:ss";
  static const String DATE_FORMAT_2 = "dd MMM, yyyy hh:mm a";

  static bool checkIsEmptyOrNullForStringAndInt(Object object) {
    if (object == null) {
      return true;
    } else if (object.toString().isEmpty) {
      return true;
    }
    return false;
  }

  // static int getRandomOTP(){
  //   int min = 10000; //min and max values act as your 6 digit range
  //   int max = 99999;
  //   var randomizer = new Random();
  //   int rNum = min + randomizer.nextInt(max - min);
  //   return rNum;
  // }
  String getStandardFormattedDateTime(DateTime dateTime) {
    if (dateTime == null) {
      return '';
    }
    var dat = DateFormat(DATE_FORMAT_1).format(dateTime);
    return dat;
  }

  String getLocalDateTimeStdFormat(DateTime dateTime) {
    if (dateTime == null) {
      return '';
    }
    // var localTime = DateTime.parse(dateTime).toLocal();
    // var dat = DateFormat("dd-MM-yyyy hh:mm").format(dateTime);
    var dat = DateFormat(DATE_FORMAT_2).format(dateTime);
    return dat;
  }

  String getFormattedDateTime(DateTime dateTime, String format) {
    if (dateTime == null) {
      return '';
    }
    // var localTime = DateTime.parse(dateTime).toLocal();
    // var dat = DateFormat("dd-MM-yyyy hh:mm").format(dateTime);
    var dat = DateFormat(format).format(dateTime);
    return dat;
  }

  static Future<String> getId() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      // import 'dart:io'
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } else {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.androidId; // unique ID on Android
    }
  }
}

class NoKeyboardEditableTextFocusNode extends FocusNode {
  @override
  bool consumeKeyboardToken() {
    // prevents keyboard from showing on first focus
    return false;
  }

  @override
  bool get hasFocus => false;
}
