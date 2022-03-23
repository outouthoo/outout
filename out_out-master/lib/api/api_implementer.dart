import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:out_out/api/dio_client.dart';
import 'package:out_out/models/BookiingTableOrderResponse.dart';
import 'package:out_out/models/ChatGruoplist.dart' as ChatGruoplist;
import 'package:out_out/models/CreateOrderResposne.dart';
import 'package:out_out/models/Creategruop.dart' as CreateGruop;
import 'package:out_out/models/ListAccountResponseModel.dart';
import 'package:out_out/models/ListBusinessTableBookingResponse.dart';
import 'package:out_out/models/MenuModels/menumodels.dart';
import 'package:out_out/models/OrderBussinessResponse.dart';
import 'package:out_out/models/OrderUserResponse.dart';
import 'package:out_out/models/Payment_list.dart';
import 'package:out_out/models/TableModel/tablelistmodel.dart';
import 'package:out_out/models/add_friend_model.dart';
import 'package:out_out/models/addmoneytowallet.dart';
import 'package:out_out/models/business_category_model.dart';
import 'package:out_out/models/business_frnds.dart';
import 'package:out_out/models/business_packages_model.dart';
import 'package:out_out/models/change_password_model.dart';
import 'package:out_out/models/comment_list_model.dart';
import 'package:out_out/models/commonResponseModel.dart';
import 'package:out_out/models/common_response.dart';
import 'package:out_out/models/create_event_model.dart';
import 'package:out_out/models/delete_event_model.dart';
import 'package:out_out/models/forgot_password_model.dart';
import 'package:out_out/models/friendList_model.dart' as FriendList;
import 'package:out_out/models/friend_model.dart';
import 'package:out_out/models/friends_feed_model.dart';
import 'package:out_out/models/get_agora_token_model.dart';
import 'package:out_out/models/get_friends_list.dart';
import 'package:out_out/models/home_response.dart';
import 'package:out_out/models/invite_friends_model.dart' as inviteFriend;
import 'package:out_out/models/join_event_model.dart' as joinEvent;
import 'package:out_out/models/list_business_account_modal.dart';
import 'package:out_out/models/list_currency_modal.dart';
import 'package:out_out/models/list_events_model.dart' as eventList;
import 'package:out_out/models/list_media_model.dart' as media;
import 'package:out_out/models/list_my_friends_modal.dart';
import 'package:out_out/models/list_notification_model.dart'
    as notificationModel;
import 'package:out_out/models/list_shoutout_model.dart' as shoutout;
import 'package:out_out/models/login_with_user_name_and_otp_model.dart';
import 'package:out_out/models/logout_model.dart';
import 'package:out_out/models/model_advt.dart';
import 'package:out_out/models/notification_list_model.dart';
import 'package:out_out/models/payment_success_model.dart';
import 'package:out_out/models/post_comments_model.dart';
import 'package:out_out/models/register_model.dart';
import 'package:out_out/models/search_friends_list_model.dart' as friendModel;
import 'package:out_out/models/search_friends_list_model.dart';
import 'package:out_out/models/send_otp_model.dart';
import 'package:out_out/models/update_profile_model.dart';
import 'package:out_out/models/upload_media_model.dart';
import 'package:out_out/models/user_story_model.dart';
import 'package:out_out/models/verify_otp_model.dart';
import 'package:out_out/models/vip_frnds.dart' as vip;
import 'package:out_out/models/walletmodel.dart';
import 'package:out_out/models/wallettransactionmodel.dart';
import 'package:out_out/utils/commona_utils.dart';
import 'package:out_out/utils/custom_http_exception.dart';

class ApiImplementer {
  static const String SUCCESS = "0";
  static const String FAIL = "1";

  static Future<LoginWithUsernameAndOTPModel> loginApiImplementer({
    @required String deviceId,
    @required String fcmToken,
    @required String userName,
    @required String password,
  }) async {
    FormData formData = new FormData.fromMap({
      'deviceId': '${deviceId}',
      'fcmToken': '${fcmToken}',
      'username': '${userName}',
      'password': '${password}',
      'apiKey': '${CommonUtils.API_KEY}'
    });
    log("REQUEST Login:" + formData.fields.join(","));
    final response =
        await DioClient.getInstance().post('Login', data: formData);

    log("RESPONSE Login:" + response.toString());
    if (response.statusCode == 200) {
      return LoginWithUsernameAndOTPModel.fromJson(response.data);
    } else {
      throw CustomHttpException(
          exceptionMsg: response.statusMessage.toString());
    }
  }

  static Future<LoginWithUsernameAndOTPModel> loginWithOTPApiImplementer({
    @required String deviceId,
    @required String fcmToken,
    @required String phone_number,
  }) async {
    FormData formData = new FormData.fromMap({
      'deviceId': '${deviceId}',
      'fcmToken': '${fcmToken}',
      'phone_number': '${phone_number}',
      'apiKey': '${CommonUtils.API_KEY}'
    });
    log("REQUEST loginWithOTPApiImplementer:" + formData.fields.join(","));
    final response =
        await DioClient.getInstance().post('LoginWithOTP', data: formData);
    log("RESPONSE loginWithOTPApiImplementer:" + response.toString());
    if (response.statusCode == 200) {
      return LoginWithUsernameAndOTPModel.fromJson(response.data);
    } else {
      throw CustomHttpException(
          exceptionMsg: response.statusMessage.toString());
    }
  }

  static Future<RegisterModel> registerApiImplementer(
      {@required String first_name,
      @required String last_name,
      @required int gender,
      @required String phone_number,
      @required String dob,
      @required String email,
      @required String username,
      @required String password,
      @required double latitude,
      @required double longitude,
      @required String city,
      @required int account_type,
      @required int terms_and_conditions,
      @required String catId,
      @required String profile_image}) async {
    FormData formData = new FormData.fromMap({
      'first_name': '${first_name}',
      'last_name': '${last_name}',
      'gender': '${gender}',
      'phone_number': '${phone_number}',
      'dob': '${dob}',
      'email': '${email}',
      'username': '${username}',
      'password': '${password}',
      'apiKey': '${CommonUtils.API_KEY}',
      'latitude': '${latitude}',
      'longitude': '${longitude}',
      'city': '${city}',
      'catid': '${catId}',
      'account_type': '${account_type}',
      'terms_and_conditions': '${terms_and_conditions}',
      'profile_image': '${profile_image}'
    });
    log("REQUEST registerApiImplementer:" + formData.fields.join(","));
    final response =
        await DioClient.getInstance().post('Register', data: formData);
    log("RESPONSE registerApiImplementer:" + response.toString());
    if (response.statusCode == 200) {
      return RegisterModel.fromJson(response.data);
    } else {
      throw CustomHttpException(
          exceptionMsg: response.statusMessage.toString());
    }
  }

  static Future<SendOTPModel> sendOTPApiImplementer({
    @required String accessToken,
    @required String phone_number,
  }) async {
    FormData formData = new FormData.fromMap({
      'accessToken': '${accessToken}',
      'phone_number': '${phone_number}',
      'apiKey': '${CommonUtils.API_KEY}'
    });
    log("REQUEST sendOTPApiImplementer:" + formData.fields.join(","));
    final response =
        await DioClient.getInstance().post('SendOTP', data: formData);
    log("RESPONSE sendOTPApiImplementer:" + response.toString());
    if (response.statusCode == 200) {
      return SendOTPModel.fromJson(response.data);
    } else {
      throw CustomHttpException(
          exceptionMsg: response.statusMessage.toString());
    }
  }

  static Future<VerifyOTPModel> verifyOTPApiImplementer({
    @required String accessToken,
    @required String otp,
  }) async {
    FormData formData = new FormData.fromMap({
      'accessToken': '${accessToken}',
      'otp': '${otp}',
      'apiKey': '${CommonUtils.API_KEY}'
    });
    log("REQUEST verifyOTPApiImplementer:" + formData.fields.join(","));
    final response =
        await DioClient.getInstance().post('VerifyOTP', data: formData);
    log("RESPONSE verifyOTPApiImplementer:" + response.toString());
    if (response.statusCode == 200) {
      return VerifyOTPModel.fromJson(response.data);
    } else {
      throw CustomHttpException(
          exceptionMsg: response.statusMessage.toString());
    }
  }

  static Future<LogOutModel> logoutApiImplementer({
    @required String accessToken,
    @required String userid,
  }) async {
    FormData formData = new FormData.fromMap({
      'accessToken': '${accessToken}',
      'userid': '${userid}',
      'apiKey': '${CommonUtils.API_KEY}'
    });
    log("REQUEST logoutApiImplementer:" + formData.fields.join(","));
    final response =
        await DioClient.getInstance().post('LogOut', data: formData);
    log("RESPONSE logoutApiImplementer:" + response.toString());
    if (response.statusCode == 200) {
      return LogOutModel.fromJson(response.data);
    } else {
      throw CustomHttpException(
          exceptionMsg: response.statusMessage.toString());
    }
  }

  static Future<UpdateProfileModel> updateProfileApiImplementer(
      {@required String accessToken,
      @required String userid,
      @required String username,
      @required String first_name,
      @required String last_name,
      @required int gender,
      @required String phone_number,
      @required String dob,
      @required String email,
      @required double latitude,
      @required double longitude,
      @required String city,
      @required String account_no,
      @required String account_holder,
      @required String bank_code,
      @required String swift_code,
      @required String bank_name,
      @required String website,
      @required String bio,
      @required int account_type,
      @required int terms_and_conditions,
      @required String profile_image}) async {
    FormData formData = new FormData.fromMap({
      'accessToken': '${accessToken}',
      'userid': '${userid}',
      'username': '${username}',
      'first_name': '${first_name}',
      'last_name': '${last_name}',
      'gender': '${gender}',
      'phone_number': '${phone_number}',
      'website': website,
      'biography': bio,
      'dob': '${dob}',
      'email': '${email}',
      'apiKey': '${CommonUtils.API_KEY}',
      'latitude': '${latitude}',
      'longitude': '${longitude}',
      'city': '${city}',
      'account_number': '$account_no',
      'bank_name': '${bank_name}',
      'account_holder': '$account_holder',
      'bank_code': '$bank_code',
      'swift_code': '$swift_code',
      'account_type': '${account_type}',
      'terms_and_conditions': '${terms_and_conditions}',
      'profile_image': '${profile_image}'
    });
    log("REQUEST updateProfileApiImplementer:" + formData.fields.join(","));
    final response =
        await DioClient.getInstance().post('Profile', data: formData);
    log("RESPONSE updateProfileApiImplementer:" + response.toString());
    if (response.statusCode == 200) {
      return UpdateProfileModel.fromJson(response.data);
    } else {
      throw CustomHttpException(
          exceptionMsg: response.statusMessage.toString());
    }
  }

  static Future<ChangePasswordModel> changePasswordApiImplementer({
    @required String accessToken,
    @required String userid,
    @required String newPass,
    @required String confirmPass,
  }) async {
    FormData formData = new FormData.fromMap({
      'accessToken': '${accessToken}',
      'userid': '${userid}',
      'newpassword': '${newPass}',
      'confirmnewpassword': '${confirmPass}',
      'apiKey': '${CommonUtils.API_KEY}'
    });

    log("REQUEST ChangePassword:" + formData.fields.join(","));
    final response =
        await DioClient.getInstance().post('ChangePassword', data: formData);
    log("RESPONSE ChangePassword:" + response.toString());
    if (response.statusCode == 200) {
      return ChangePasswordModel.fromJson(response.data);
    } else {
      throw CustomHttpException(
          exceptionMsg: response.statusMessage.toString());
    }
  }

  static Future<ForgotPasswordModel> forgotPasswordApiImplementer({
    @required String accessToken,
    @required String emailId,
  }) async {
    FormData formData = new FormData.fromMap({
      'accessToken': '${accessToken}',
      'email': '${emailId}',
      'apiKey': '${CommonUtils.API_KEY}'
    });

    log("REQUEST ForgetPassword:" + formData.fields.join(","));
    final response =
        await DioClient.getInstance().post('ForgetPassword', data: formData);
    log("RESPONSE ForgetPassword:" + response.toString());
    if (response.statusCode == 200) {
      return ForgotPasswordModel.fromJson(response.data);
    } else {
      throw CustomHttpException(
          exceptionMsg: response.statusMessage.toString());
    }
  }

  static Future<ForgotPasswordModel> forgotUsernameApiImplementer({
    @required String accessToken,
    @required String emailId,
  }) async {
    FormData formData = new FormData.fromMap({
      'accessToken': '${accessToken}',
      'email': '${emailId}',
      'apiKey': '${CommonUtils.API_KEY}'
    });

    log("REQUEST ForgetPassword:" + formData.fields.join(","));
    final response =
        await DioClient.getInstance().post('ForgetUserID', data: formData);
    log("RESPONSE ForgetPassword:" + response.toString());
    if (response.statusCode == 200) {
      return ForgotPasswordModel.fromJson(response.data);
    } else {
      throw CustomHttpException(
          exceptionMsg: response.statusMessage.toString());
    }
  }

  static Future<BusinessCategoryModel> businessCategoryApiImplementer() async {
    FormData formData =
        new FormData.fromMap({'apiKey': '${CommonUtils.API_KEY}'});
    log("REQUEST businessCategory:" + formData.fields.join(","));
    final response =
        await DioClient.getInstance().post('BusinessCategory', data: formData);
    log("RESPONSE businessCategory:" + response.toString());
    if (response.statusCode == 200) {
      return BusinessCategoryModel.fromJson(response.data);
    } else {
      throw CustomHttpException(
          exceptionMsg: response.statusMessage.toString());
    }
  }

  static Future<BusinessPackagesModel> businessPackagesApiImplementer() async {
    FormData formData =
        new FormData.fromMap({'apiKey': '${CommonUtils.API_KEY}'});
    log("REQUEST businessPackages:" + formData.fields.join(","));
    final response =
        await DioClient.getInstance().post('Packages', data: formData);
    log("RESPONSE businessPackages:" + response.toString());
    if (response.statusCode == 200) {
      return BusinessPackagesModel.fromJson(response.data);
    } else {
      throw CustomHttpException(
          exceptionMsg: response.statusMessage.toString());
    }
  }

  static Future<UploadMediaModel> uploadMediaApiImplementer({
    @required String accessToken,
    @required String user_id,
    @required int media_type,
    @required File file,
    @required String caption,
    @required String taggedUser,
    @required String lat,
    @required String long,
    @required String address,

    @required File thumbFile,
  }) async {
    String fileName = file.path.split('/').last;
    FormData formData = new FormData.fromMap({
      'apiKey': '${CommonUtils.API_KEY}',
      'accessToken': '${accessToken}',
      'user_id': '${user_id}',
      'media_type': '${media_type}',
      'type': '1',
      'file': await MultipartFile.fromFile(file.path, filename: fileName),
      'caption': '${caption}',
      'tagged_users': taggedUser,
      'lat': '51.52',
      'long': '0.38',
      'address': 'London, UK',
      'description': caption,
      'thumb_file': thumbFile == null
          ? ''
          : await MultipartFile.fromFile(thumbFile.path,
              filename: thumbFile.path.split('/').last),
    });
    log("REQUEST uploadMedia:" + formData.fields.join(","));
    final response =
        await DioClient.getInstance().post('UploadMedia', data: formData);
    log("RESPONSE uploadMedia:" + response.toString());
    if (response.statusCode == 200) {
      return UploadMediaModel.fromJson(response.data);
    } else {
      throw CustomHttpException(
          exceptionMsg: response.statusMessage.toString());
    }
  }

  static Future<List<media.Mediadata>> getListOfMediaApiImplementer(
      {@required String accessToken,
      @required String user_id,
      @required int media_type,
      @required int offset,
      @required int limit}) async {
    FormData formData = new FormData.fromMap({
      'apiKey': '${CommonUtils.API_KEY}',
      'accessToken': '${accessToken}',
      'user_id': '${user_id}',
      'media_type': '${media_type}',
      'offset': '${offset}',
      'limit': '${limit}'
    });
    log("REQUEST getListOfMedia:" + formData.fields.join(","));
    final response =
        await DioClient.getInstance().post('ListMedia', data: formData);
    log("RESPONSE getListOfMedia:" + response.toString());
    if (response.statusCode == 200) {
      print(response.data.toString());
      return media.ListMediaModel.fromJson(response.data).mediadata;
    } else {
      throw CustomHttpException(
          exceptionMsg: response.statusMessage.toString());
    }
  }

  static Future<PostCommentsModel> postCommentsApiImplementer({
    @required String accessToken,
    @required String operation,
    @required int comment_id,
    @required String user_id,
    @required String media_id,
    @required String comments,
  }) async {
    FormData formData = new FormData.fromMap({
      'apiKey': '${CommonUtils.API_KEY}',
      'accessToken': '${accessToken}',
      'operation': '${operation}',
      'comment_id': '${comment_id}',
      'user_id': '${user_id}',
      'media_id': '${media_id}',
      'comment': '${comments}',
      'type': '2'
    });

    log("REQUEST PostComment:" + formData.fields.join(","));
    final response =
        await DioClient.getInstance().post('PostComment', data: formData);

    log("RESPONSE PostComment:" + response.toString());
    if (response.statusCode == 200) {
      return PostCommentsModel.fromJson(response.data);
    } else {
      throw CustomHttpException(
          exceptionMsg: response.statusMessage.toString());
    }
  }

  static Future<List<friendModel.Data>> searchFriendsListApiImplementer({
    @required String accessToken,
    @required String account_type,
    @required int offset,
    @required int limit,
    @required String search_query,
    @required String is_vip,
  }) async {
    FormData formData = new FormData.fromMap({
      'apiKey': '${CommonUtils.API_KEY}',
      'accessToken': '${accessToken}',
      'account_type': '${account_type}',
      'offset': '${offset}',
      'limit': '${limit}',
      'search_query': '${search_query}',
      'is_vip': '${is_vip}'
    });
    log("REQUEST searchFriends:" + formData.fields.join(","));
    final response =
        await DioClient.getInstance().post('SearchFriends', data: formData);
    log("RESPONSE searchFriends:" + response.toString());
    if (response.statusCode == 200) {
      var data =
          friendModel.SearchFriendsListModel.fromJson(response.data).data;
      return data == null
          ? []
          : friendModel.SearchFriendsListModel.fromJson(response.data).data;
    } else {
      throw CustomHttpException(
          exceptionMsg: response.statusMessage.toString());
    }
  }

  static Future<AddFriendModel> addFriendsApiImplementer({
    @required String accessToken,
    @required String from_user_id,
    @required String to_user_id,
    @required String status,
    @required String is_follow,
  }) async {
    FormData formData = new FormData.fromMap({
      'apiKey': '${CommonUtils.API_KEY}',
      'accessToken': '${accessToken}',
      'from_user_id': '${from_user_id}',
      'to_user_id': '${to_user_id}',
      'status': '${status}',
      'is_follow': '${is_follow}'
    });
    log("REQUEST addFriends:" + formData.fields.join(","));
    final response =
        await DioClient.getInstance().post('AddFriend', data: formData);
    log("RESPONSE addFriends:" + response.toString());
    if (response.statusCode == 200) {
      return AddFriendModel.fromJson(response.data);
    } else {
      throw CustomHttpException(
          exceptionMsg: response.statusMessage.toString());
    }
  }

  static Future<AddFriendModel> followUnfollowApiImplementer({
    @required String accessToken,
    @required String from_user_id,
    @required String to_user_id,
    @required String is_follow,
  }) async {
    FormData formData = new FormData.fromMap({
      'apiKey': '${CommonUtils.API_KEY}',
      'accessToken': '${accessToken}',
      'from_user_id': '${from_user_id}',
      'to_user_id': '${to_user_id}',
      'is_follow': '${is_follow}'
    });
    log("REQUEST addFriends:" + formData.fields.join(","));
    final response =
        await DioClient.getInstance().post('FollowFriend', data: formData);
    log("RESPONSE addFriends:" + response.toString());
    if (response.statusCode == 200) {
      return AddFriendModel.fromJson(response.data);
    } else {
      throw CustomHttpException(
          exceptionMsg: response.statusMessage.toString());
    }
  }

  static Future<vip.vip_frnds> ListVIPAccountsApiImplementer({
    @required String accessToken,
    @required String user_id,
  }) async {
    FormData formData = new FormData.fromMap({
      'apiKey': '${CommonUtils.API_KEY}',
      'accessToken': '${accessToken}',
      'userid': '${user_id}',
    });
    log("REQUEST ListVIPAccounts:" + formData.fields.join(","));
    final response =
        await DioClient.getInstance().post('ListVIPAccounts', data: formData);
    log("RESPONSE ListVIPAccounts:" + response.data.toString());
    if (response.statusCode == 200) {
      var data = vip.vip_frnds.fromJson(response.data);
      print(data.data.toString());
      return data == null ? [] : data;
    } else {
      throw CustomHttpException(
          exceptionMsg: response.statusMessage.toString());
    }
  }

  static Future<business_frnds> ListbusinessAccountsApiImplementer({
    @required String accessToken,
    @required String user_id,
    @required int type,
  }) async {
    FormData formData = new FormData.fromMap({
      'apiKey': '${CommonUtils.API_KEY}',
      'accessToken': '${accessToken}',
      'userid': '${user_id}',
      'type': type
    });
    log("REQUEST ListbusinessAccounts:" + formData.fields.join(","));
    final response =
        await DioClient.getInstance().post('ListAccounts', data: formData);
    log("RESPONSE ListbusinessAccounts:" + response.data.toString());
    if (response.statusCode == 200) {
      var data = business_frnds.fromJson(response.data);
      print(data.data.toString());
      return data == null ? [] : data;
    } else {
      throw CustomHttpException(
          exceptionMsg: response.statusMessage.toString());
    }
  }

  static Future<List<shoutout.Data>> shoutoutListApiImplementer({
    @required String accessToken,
    @required String search_query,
    @required int offset,
    @required int limit,
  }) async {
    FormData formData = new FormData.fromMap({
      'apiKey': '${CommonUtils.API_KEY}',
      'accessToken': '${accessToken}',
      'search_query': '${search_query}',
      'offset': '${offset}',
      'limit': '${limit}'
    });
    log("REQUEST ListShoutout REQ:" + formData.toString());
    final response =
        await DioClient.getInstance().post('ListShoutout', data: formData);
    log("RESPONSE ListShoutout REQ:" + response.data.toString());
    if (response.statusCode == 200) {
      var data = shoutout.ListShoutoutModel.fromJson(response.data).data;
      return data == null
          ? []
          : shoutout.ListShoutoutModel.fromJson(response.data).data;
    } else {
      throw CustomHttpException(
          exceptionMsg: response.statusMessage.toString());
    }
  }

  static Future<List<eventList.Data>> eventListApiImplementer({
    @required String accessToken,
    @required String userid,
    @required String event_type,
    @required String search_query,
    @required String offset,
    @required String limit,
  }) async {
    FormData formData = new FormData.fromMap({
      'apiKey': '${CommonUtils.API_KEY}',
      'accessToken': '${accessToken}',
      'userid': '${userid}',
      'event_type': '${event_type}',
      'search_query': '${search_query}',
      'offset': '${offset}',
      'limit': '${limit}'
    });
    log("REQUEST ListEvents:" + formData.fields.join(","));
    final response =
        await DioClient.getInstance().post('ListEvents', data: formData);
    log("RESPONSE ListEvents " + response.toString());
    if (response.statusCode == 200) {
      var data = eventList.ListEventsModel.fromJson(response.data).data;
      return data == null
          ? []
          : eventList.ListEventsModel.fromJson(response.data).data;
    } else {
      throw CustomHttpException(
          exceptionMsg: response.statusMessage.toString());
    }
  }

  static Future<List<eventList.Data>> upcommingEventListApiImplementer({
    @required String accessToken,
    @required String userid,
    @required String offset,
    @required String limit,
  }) async {
    FormData formData = new FormData.fromMap({
      'apiKey': '${CommonUtils.API_KEY}',
      'accessToken': '${accessToken}',
      'userid': '${userid}',
      'offset': '${offset}',
      'limit': '${limit}'
    });
    log("REQUEST ListEvents:" + formData.fields.join(","));
    final response =
        await DioClient.getInstance().post('UpcomingEvents', data: formData);
    log("RESPONSE ListEvents " + response.toString());
    if (response.statusCode == 200) {
      var data = eventList.ListEventsModel.fromJson(response.data).data;
      return data == null
          ? []
          : eventList.ListEventsModel.fromJson(response.data).data;
    } else {
      throw CustomHttpException(
          exceptionMsg: response.statusMessage.toString());
    }
  }

  static Future<DeleteEventModel> deleteEventApiImplementer({
    @required String accessToken,
    @required String userid,
    @required String eventid,
  }) async {
    FormData formData = new FormData.fromMap({
      'apiKey': '${CommonUtils.API_KEY}',
      'accessToken': '${accessToken}',
      'userid': '${userid}',
      'eventid': '${eventid}'
    });
    log("REQUEST deleteEvent:" + formData.fields.join(","));
    final response =
        await DioClient.getInstance().post('DeleteEvents', data: formData);
    log("RESPONSE deleteEvent " + response.toString());
    if (response.statusCode == 200) {
      return DeleteEventModel.fromJson(response.data);
    } else {
      throw CustomHttpException(
          exceptionMsg: response.statusMessage.toString());
    }
  }

  static Future<joinEvent.JoinEventModel> joinEventApiImplementer({
    @required String accessToken,
    @required String userid,
    @required String eventid,
  }) async {
    FormData formData = new FormData.fromMap({
      'apiKey': '${CommonUtils.API_KEY}',
      'accessToken': '${accessToken}',
      'user_id': '${userid}',
      'event_id': '${eventid}'
    });
    log("REQUEST joinEvent:" + formData.fields.join(","));
    final response =
        await DioClient.getInstance().post('JoinEvent', data: formData);
    log("RESPONSE JoinEvent " + response.toString());
    if (response.statusCode == 200) {
      return joinEvent.JoinEventModel.fromJson(response.data);
    } else {
      throw CustomHttpException(
          exceptionMsg: response.statusMessage.toString());
    }
  }

  static Future<List<inviteFriend.Data>> inviteFriendApiImplementer(
      {@required String accessToken,
      @required String userid,
      @required String search_query,
      @required int offset,
      @required int limit}) async {
    FormData formData = new FormData.fromMap({
      'apiKey': '${CommonUtils.API_KEY}',
      'accessToken': '${accessToken}',
      'user_id': '${userid}',
      'search_query': '${search_query}',
      'offset': '${offset}',
      'limit': '${limit}'
    });
    log("REQUEST InviteFriends:" + formData.fields.join(","));
    final response =
        await DioClient.getInstance().post('InviteFriends', data: formData);
    log("RESPONSE InviteFriends " + response.toString());
    if (response.statusCode == 200) {
      var data = inviteFriend.InviteFriendsModel.fromJson(response.data).data;
      return data == null
          ? []
          : inviteFriend.InviteFriendsModel.fromJson(response.data).data;
    } else {
      throw CustomHttpException(
          exceptionMsg: response.statusMessage.toString());
    }
  }

  static Future<GetNotificationResponse> getNotificationList({
    @required String accessToken,
    @required String user_id,
    @required int offset,
    @required int limit,
    @required String type,
  }) async {
    FormData formData = new FormData.fromMap({
      'apiKey': '${CommonUtils.API_KEY}',
      'accessToken': '${accessToken}',
      'user_id': '${user_id}',
      'offset': '${offset}',
      'limit': '${limit}',
      'type': '${type}'
    });
    log("Notification Request:" + formData.fields.join(","));
    final response =
        await DioClient.getInstance().post('ListNotifications', data: formData);
    log("RESPONSE ListNotifications:" + response.toString());
    if (response.statusCode == 200) {
      return GetNotificationResponse.fromJson(response.data);
    } else {
      throw CustomHttpException(
          exceptionMsg: response.statusMessage.toString());
    }
  }

  static Future<HomeResponse> getHomeScreen({
    @required String accessToken,
    @required String user_id,
  }) async {
    FormData formData = new FormData.fromMap({
      'apiKey': '${CommonUtils.API_KEY}',
      'accessToken': '${accessToken}',
      'userid': '${user_id}',
    });
    log("Home Request:" + formData.fields.join(","));
    final response =
        await DioClient.getInstance().post('UserDetails', data: formData);
    log("RESPONSE getHomeScreen:" + response.toString());
    if (response.statusCode == 200) {
      return HomeResponse.fromJson(response.data);
    } else {
      throw CustomHttpException(
          exceptionMsg: response.statusMessage.toString());
    }
  }

  static Future<MenuListModel> getMenuList({
    @required String accessToken,
    @required String user_id,
  }) async {
    FormData formData = new FormData.fromMap({
      'apiKey': '${CommonUtils.API_KEY}',
      'accessToken': '${accessToken}',
      'userid': '${user_id}',
    });
    log("Menu List Request:" + formData.fields.join(","));
    final response =
        await DioClient.getInstance().post('ListMenuItems', data: formData);
    log("RESPONSE ListMenuItems:" + response.toString());
    if (response.statusCode == 200) {
      return MenuListModel.fromJson(response.data);
    } else {
      throw CustomHttpException(
          exceptionMsg: response.statusMessage.toString());
    }
  }

  static Future<CreateOrderResposne> createOrderApiCall({
    @required String accessToken,
    @required String user_id,
    @required String to_user_id,
    @required String item_details,
  }) async {
    FormData formData = new FormData.fromMap({
      'apiKey': '${CommonUtils.API_KEY}',
      'accessToken': '${accessToken}',
      'from_user_id': '${user_id}',
      'to_user_id': '${to_user_id}',
      'item_details': '${item_details}',
    });
    log("AddOrder Request:" + formData.fields.join(","));
    final response =
        await DioClient.getInstance().post('AddOrder', data: formData);
    log("RESPONSE AddOrder:" + response.toString());
    if (response.statusCode == 200) {
      return CreateOrderResposne.fromJson(response.data);
    } else {
      throw CustomHttpException(
          exceptionMsg: response.statusMessage.toString());
    }
  }

  static Future<MenuListModel> addMenuItem({
    @required String accessToken,
    @required String user_id,
    String name,
    String price,
    String desc,
  }) async {
    FormData formData = new FormData.fromMap({
      'apiKey': '${CommonUtils.API_KEY}',
      'accessToken': '${accessToken}',
      'userid': '${user_id}',
      'name': '${name}',
      'description': '${desc}',
      'price': '${price}',
    });
    log("addMenu Request:" + formData.fields.join(","));
    final response =
        await DioClient.getInstance().post('AddMenuItem', data: formData);
    log("RESPONSE AddMenuItem:" + response.toString());
    if (response.statusCode == 200) {
      return MenuListModel.fromJson(response.data);
    } else {
      throw CustomHttpException(
          exceptionMsg: response.statusMessage.toString());
    }
  }
  static Future<MenuListModel> editMenuItem({
    @required String accessToken,
    @required String user_id,
    String id,
    String name,
    String price,
    String desc,
  }) async {
    FormData formData = new FormData.fromMap({
      'apiKey': '${CommonUtils.API_KEY}',
      'accessToken': '${accessToken}',
      'userid': '${user_id}',
      'id': '${id}',
      'name': '${name}',
      'description': '${desc}',
      'price': '${price}',
    });
    log("editMenu Request:" + formData.fields.join(","));
    final response =
        await DioClient.getInstance().post('EditMenuItem', data: formData);
    log("RESPONSE EditMenuItem:" + response.toString());
    if (response.statusCode == 200) {
      return MenuListModel.fromJson(response.data);
    } else {
      throw CustomHttpException(
          exceptionMsg: response.statusMessage.toString());
    }
  }
  static Future<MenuListModel> deleteMenuItem({
    @required String accessToken,
    @required String user_id,
    String id,
  }) async {
    FormData formData = new FormData.fromMap({
      'apiKey': '${CommonUtils.API_KEY}',
      'accessToken': '${accessToken}',
      'userid': '${user_id}',
      'id': '${id}',
    });
    log("deleteMenu Request:" + formData.fields.join(","));
    final response =
        await DioClient.getInstance().post('DeleteMenuItem', data: formData);
    log("RESPONSE DeleteMenuItem:" + response.toString());
    if (response.statusCode == 200) {
      return MenuListModel.fromJson(response.data);
    } else {
      throw CustomHttpException(
          exceptionMsg: response.statusMessage.toString());
    }
  }


  static Future<TableListModel> getTableList({
    @required String accessToken,
    @required String user_id,
  }) async {
    FormData formData = new FormData.fromMap({
      'apiKey': '${CommonUtils.API_KEY}',
      'accessToken': '${accessToken}',
      'userid': '${user_id}',
    });
    log("getTable Request:" + formData.fields.join(","));
    final response =
    await DioClient.getInstance().post('ListTableDetails', data: formData);
    log("RESPONSE ListTableDetails:" + response.toString());
    if (response.statusCode == 200) {
      return TableListModel.fromJson(response.data);
    } else {
      throw CustomHttpException(
          exceptionMsg: response.statusMessage.toString());
    }
  }
static Future<TableListModel> addBookingTable({
    @required String accessToken,
    @required String user_id,
    @required String to_user_id,
    @required String tableId,
    @required String persons,
    @required String time,
  }) async {
    FormData formData = new FormData.fromMap({
      'apiKey': '${CommonUtils.API_KEY}',
      'accessToken': '${accessToken}',
      'from_user_id': '${user_id}',
      'to_user_id': '${to_user_id}',
      'tableid': '${tableId}',
      'number_of_person': '${persons}',
      'visit_time': '${time}',
    });
    log("addBookingTable Request:" + formData.fields.join(","));
    final response =
    await DioClient.getInstance().post('AddBookingTable', data: formData);
    log("RESPONSE addBookingTable:" + response.toString());
    if (response.statusCode == 200) {
      return TableListModel.fromJson(response.data);
    } else {
      throw CustomHttpException(
          exceptionMsg: response.statusMessage.toString());
    }
  }

  static Future<TableListModel> addTableItem({
    @required String accessToken,
    @required String user_id,
    String name,
    String capacity,
  }) async {
    FormData formData = new FormData.fromMap({
      'apiKey': '${CommonUtils.API_KEY}',
      'accessToken': '${accessToken}',
      'userid': '${user_id}',
      'name': '${name}',
      'capacity': '${capacity}',
    });
    log("addTable Request:" + formData.fields.join(","));
    final response =
    await DioClient.getInstance().post('AddTableDetails', data: formData);
    log("RESPONSE AddTableDetails:" + response.toString());
    if (response.statusCode == 200) {
      return TableListModel.fromJson(response.data);
    } else {
      throw CustomHttpException(
          exceptionMsg: response.statusMessage.toString());
    }
  }

  static Future<TableListModel> editTableItem({
    @required String accessToken,
    @required String user_id,
    String id,
    String name,
    String price,
  }) async {
    FormData formData = new FormData.fromMap({
      'apiKey': '${CommonUtils.API_KEY}',
      'accessToken': '${accessToken}',
      'userid': '${user_id}',
      'id': '${id}',
      'name': '${name}',
      'capacity': '${price}',
    });
    log("editTable Request:" + formData.fields.join(","));
    final response =
    await DioClient.getInstance().post('EditTableDetails', data: formData);
    log("RESPONSE EditTableDetails:" + response.toString());
    if (response.statusCode == 200) {
      return TableListModel.fromJson(response.data);
    } else {
      throw CustomHttpException(
          exceptionMsg: response.statusMessage.toString());
    }
  }
  static Future<TableListModel> deleteTableItem({
    @required String accessToken,
    @required String user_id,
    String id,
  }) async {
    FormData formData = new FormData.fromMap({
      'apiKey': '${CommonUtils.API_KEY}',
      'accessToken': '${accessToken}',
      'userid': '${user_id}',
      'id': '${id}',
    });
    log("deleteTable Request:" + formData.fields.join(","));
    final response =
    await DioClient.getInstance().post('DeleteTableDetails', data: formData);
    log("RESPONSE DeleteTableDetails:" + response.toString());
    if (response.statusCode == 200) {
      return TableListModel.fromJson(response.data);
    } else {
      throw CustomHttpException(
          exceptionMsg: response.statusMessage.toString());
    }
  }

  static Future<ListBusinessTableBookingResponse> getBookingForBusinessList({
    @required String accessToken,
    @required String user_id,
  }) async {
    FormData formData = new FormData.fromMap({
      'apiKey': '${CommonUtils.API_KEY}',
      'accessToken': '${accessToken}',
      'userid': '${user_id}',
    });
    log("ListBusinessTableBooking Request:" + formData.fields.join(","));
    final response =
    await DioClient.getInstance().post('ListBusinessTableBooking', data: formData);
    log("RESPONSE ListBusinessTableBooking:" + response.toString());
    if (response.statusCode == 200) {
      return ListBusinessTableBookingResponse.fromJson(response.data);
    } else {
      throw CustomHttpException(
          exceptionMsg: response.statusMessage.toString());
    }
  }
  static Future<BookingTableOrderResponse> getBookingForUserList({
    @required String accessToken,
    @required String user_id,
  }) async {
    FormData formData = new FormData.fromMap({
      'apiKey': '${CommonUtils.API_KEY}',
      'accessToken': '${accessToken}',
      'userid': '${user_id}',
    });
    log("ListBookingUser Request:" + formData.fields.join(","));
    final response =
    await DioClient.getInstance().post('ListBooking', data: formData);
    log("RESPONSE ListBookingUser:" + response.toString());
    if (response.statusCode == 200) {
      return BookingTableOrderResponse.fromJson(response.data);
    } else {
      throw CustomHttpException(
          exceptionMsg: response.statusMessage.toString());
    }
  }
  static Future<OrderUserResponse> getOrderUserList({
    @required String accessToken,
    @required String user_id,
  }) async {
    FormData formData = new FormData.fromMap({
      'apiKey': '${CommonUtils.API_KEY}',
      'accessToken': '${accessToken}',
      'userid': '${user_id}',
    });
    log("ListUserOrderBooking Request:" + formData.fields.join(","));
    final response =
    await DioClient.getInstance().post('ListUserOrderBooking', data: formData);
    log("RESPONSE ListUserOrderBooking:" + response.toString());
    if (response.statusCode == 200) {
      return OrderUserResponse.fromJson(response.data);
    } else {
      throw CustomHttpException(
          exceptionMsg: response.statusMessage.toString());
    }
  }
  static Future<OrderBussinessResponse> getOrderBussinessList({
    @required String accessToken,
    @required String user_id,
  }) async {
    FormData formData = new FormData.fromMap({
      'apiKey': '${CommonUtils.API_KEY}',
      'accessToken': '${accessToken}',
      'userid': '${user_id}',
    });
    log("ListBusinessOrderBooking Request:" + formData.fields.join(","));
    final response =
    await DioClient.getInstance().post('ListBusinessOrderBooking', data: formData);
    log("RESPONSE ListBusinessOrderBooking:" + response.toString());
    if (response.statusCode == 200) {
      return OrderBussinessResponse.fromJson(response.data);
    } else {
      throw CustomHttpException(
          exceptionMsg: response.statusMessage.toString());
    }
  }

  static Future<BookingTableOrderResponse> changeTableStatus({
    @required String accessToken,
    @required String id,
    @required String status,
  }) async {
    FormData formData = new FormData.fromMap({
      'apiKey': '${CommonUtils.API_KEY}',
      'accessToken': '${accessToken}',
      'id': '${id}',
      'table_status': '${status}',
    });
    log("TableStatus Request:" + formData.fields.join(","));
    final response =
    await DioClient.getInstance().post('TableStatus', data: formData);
    log("RESPONSE TableStatus:" + response.toString());
    if (response.statusCode == 200) {
      return BookingTableOrderResponse.fromJson(response.data);
    } else {
      throw CustomHttpException(
          exceptionMsg: response.statusMessage.toString());
    }
  }
  static Future<BookingTableOrderResponse> changeBookingStatus({
    @required String accessToken,
    @required String id,
    @required String status,
  }) async {
    FormData formData = new FormData.fromMap({
      'apiKey': '${CommonUtils.API_KEY}',
      'accessToken': '${accessToken}',
      'id': '${id}',
      'order_status': '${status}',
    });
    log("OrderStatus Request:" + formData.fields.join(","));
    final response =
    await DioClient.getInstance().post('OrderStatus', data: formData);
    log("RESPONSE OrderStatus:" + response.toString());
    if (response.statusCode == 200) {
      return BookingTableOrderResponse.fromJson(response.data);
    } else {
      throw CustomHttpException(
          exceptionMsg: response.statusMessage.toString());
    }
  }
  static Future<BookingTableOrderResponse> payOrder({
    @required String accessToken,
    @required String id,
    @required String status,
  }) async {
    FormData formData = new FormData.fromMap({
      'apiKey': '${CommonUtils.API_KEY}',
      'accessToken': '${accessToken}',
      'id': '${id}'
    });
    log("OrderPayment Request:" + formData.fields.join(","));
    final response =
    await DioClient.getInstance().post('OrderPayment', data: formData);
    log("RESPONSE OrderPayment:" + response.toString());
    if (response.statusCode == 200) {
      return BookingTableOrderResponse.fromJson(response.data);
    } else {
      throw CustomHttpException(
          exceptionMsg: response.statusMessage.toString());
    }
  }
static Future<BookingTableOrderResponse> addRating({
    @required String accessToken,
    @required String fromUserId,
    @required String toUserId,
    @required String rating,
    @required String comments,
  }) async {
    FormData formData = new FormData.fromMap({
      'apiKey': '${CommonUtils.API_KEY}',
      'accessToken': '${accessToken}',
      'from_user_id': '${fromUserId}',
      'to_user_id': '${toUserId}',
      'rating': '${rating}',
      'comments': '${comments}'
    });
    log("AddRating Request:" + formData.fields.join(","));
    final response =
    await DioClient.getInstance().post('AddRating', data: formData);
    log("RESPONSE AddRating:" + response.toString());
    if (response.statusCode == 200) {
      return BookingTableOrderResponse.fromJson(response.data);
    } else {
      throw CustomHttpException(
          exceptionMsg: response.statusMessage.toString());
    }
  }


  static Future<ListAccountResponseModel> getRestaurantList({
    @required String accessToken,
    @required String user_id,
    @required String type,
  }) async {
    FormData formData = new FormData.fromMap({
      'apiKey': '${CommonUtils.API_KEY}',
      'accessToken': '${accessToken}',
      'userid': '${user_id}',
      'type': '${type}',
    });
    log("ListAccounts Request:" + formData.fields.join(","));
    final response =
    await DioClient.getInstance().post('ListAccounts', data: formData);
    log("RESPONSE ListAccounts:" + response.toString());
    if (response.statusCode == 200) {
      return ListAccountResponseModel.fromJson(response.data);
    } else {
      throw CustomHttpException(
          exceptionMsg: response.statusMessage.toString());
    }
  }


  static Future<CommonResponseModel> readNotificationList({
    @required String accessToken,
    @required String id,
    @required String messageId,
  }) async {
    FormData formData = new FormData.fromMap({
      'apiKey': '${CommonUtils.API_KEY}',
      'accessToken': '${accessToken}',
      'id': '${id}',
      'media_id': '${messageId}',
      'is_read': '1',
    });
    log("Notification Request:" + formData.fields.join(","));
    final response =
        await DioClient.getInstance().post('ReadNotification', data: formData);
    log("RESPONSE ListNotifications:" + response.toString());
    if (response.statusCode == 200) {
      return CommonResponseModel.fromJson(jsonDecode(response.toString()));
    } else {
      throw CustomHttpException(
          exceptionMsg: response.statusMessage.toString());
    }
  }

  static Future<GetFriendsFeedListResponse> getFriendsFeedList({
    @required String accessToken,
    @required String user_id,
    @required int offset,
    @required int limit,
    String media_id,
    String media_type,
  }) async {
    FormData formData = new FormData.fromMap({
      'apiKey': '${CommonUtils.API_KEY}',
      'accessToken': '${accessToken}',
      'user_id': '${user_id}',
      'media_id': '${media_id}',
      'media_type': '${media_type}',
      'offset': '${offset}',
      'limit': '${limit}',
    });
    log("REQUEST getFriendsFeedList:" + formData.fields.join(","));
    final response =
        await DioClient.getInstance().post('FriendsFeed', data: formData);
    log("RESPONSE getFriendsFeedList:" + response.toString());
    if (response.statusCode == 200) {
      return GetFriendsFeedListResponse.fromJson(response.data);
    } else {
      throw CustomHttpException(
          exceptionMsg: response.statusMessage.toString());
    }
  }

  static Future<CommonResponse> likePost({
    @required String accessToken,
    @required String user_id,
    @required String media_id,
    @required String is_liked,
  }) async {
    FormData formData = new FormData.fromMap({
      'apiKey': '${CommonUtils.API_KEY}',
      'accessToken': '${accessToken}',
      'user_id': '${user_id}',
      'media_id': '${media_id}',
      'is_liked': '${is_liked}',
      'type': '3'
    });
    log("REQUEST LikePost:" + formData.fields.join(","));
    final response =
        await DioClient.getInstance().post('LikePost', data: formData);
    log("RESPONSE LikePost:" + response.toString());
    if (response.statusCode == 200) {
      return CommonResponse.fromJson(response.data);
    } else {
      throw CustomHttpException(
          exceptionMsg: response.statusMessage.toString());
    }
  }

  static Future<GetCommentListResponse> getCommentsList({
    @required String accessToken,
    @required String user_id,
    @required int offset,
    @required int limit,
    String media_id,
  }) async {
    FormData formData = new FormData.fromMap({
      'apiKey': '${CommonUtils.API_KEY}',
      'accessToken': '${accessToken}',
      'user_id': '${user_id}',
      'media_id': '${media_id}',
      'offset': '${offset}',
      'limit': '${limit}',
    });
    log("REQUEST ListComments:" + formData.fields.join(","));
    final response =
        await DioClient.getInstance().post('ListComments', data: formData);
    log("RESPONSE ListComments:" + response.toString());
    if (response.statusCode == 200) {
      return GetCommentListResponse.fromJson(response.data);
    } else {
      throw CustomHttpException(
          exceptionMsg: response.statusMessage.toString());
    }
  }

  static Future<GetBusinessListResponse> getBusinessAccountListByLocation(
      {@required String accessToken, @required String place}) async {
    FormData formData = new FormData.fromMap({
      'apiKey': '${CommonUtils.API_KEY}',
      'accessToken': '${accessToken}',
      'place': '${place}'
    });
    log("REQUEST Location:" + formData.fields.join(","));
    final response =
        await DioClient.getInstance().post('Location', data: formData);
    log("RESPONSE Location:" + response.data.toString());
    if (response.statusCode == 200) {
      return GetBusinessListResponse.fromJson(response.data);
    } else {
      throw CustomHttpException(
          exceptionMsg: response.statusMessage.toString());
    }
  }

  static Future<GetMyFriendsResponse> getMyFriendsList({
    @required String accessToken,
    @required String user_id,
    @required String search_query,
    @required int offset,
    @required int limit,
  }) async {
    FormData formData = new FormData.fromMap({
      'apiKey': '${CommonUtils.API_KEY}',
      'accessToken': '${accessToken}',
      'user_id': '${user_id}',
      'search_query': '${search_query}',
      'offset': '${offset}',
      'limit': '${limit}'
    });
    log("REQUEST MyFriends:" + formData.fields.join(","));
    final response =
        await DioClient.getInstance().post('MyFriends', data: formData);
    log("RESPONSE MyFriends:" + response.toString());
    if (response.statusCode == 200) {
      return GetMyFriendsResponse.fromJson(response.data);
    } else {
      throw CustomHttpException(
          exceptionMsg: response.statusMessage.toString());
    }
  }static Future<GetMyFriendsResponse> getMyFollowerList({
    @required String accessToken,
    @required String user_id,
    @required String search_query,
    @required int offset,
    @required int limit,
  }) async {
    FormData formData = new FormData.fromMap({
      'apiKey': '${CommonUtils.API_KEY}',
      'accessToken': '${accessToken}',
      'userid': '${user_id}',
      /*'search_query': '${search_query}',
      'offset': '${offset}',
      'limit': '${limit}'*/
    });
    log("REQUEST FriendsFollowers:" + formData.fields.join(","));
    final response =
        await DioClient.getInstance().post('FriendsFollowers', data: formData);
    log("RESPONSE FriendsFollowers:" + response.toString());
    if (response.statusCode == 200) {
      return GetMyFriendsResponse.fromJson(response.data);
    } else {
      throw CustomHttpException(
          exceptionMsg: response.statusMessage.toString());
    }
  }

  static Future<GetCurrencyResponse> getCurrencyListApi() async {
    FormData formData =
        new FormData.fromMap({'apiKey': '${CommonUtils.API_KEY}'});
    log("REQUEST ListCurrency:" + formData.fields.join(","));
    final response =
        await DioClient.getInstance().post('ListCurrency', data: formData);
    log("RESPONSE ListCurrency:" + response.toString());
    if (response.statusCode == 200) {
      return GetCurrencyResponse.fromJson(response.data);
    } else {
      throw CustomHttpException(
          exceptionMsg: response.statusMessage.toString());
    }
  }

  static Future<CommonResponse> sendMediaViews({
    @required String accessToken,
    @required String user_id,
    @required int offset,
    @required int limit,
    String media_id,
  }) async {
    FormData formData = new FormData.fromMap({
      'apiKey': '${CommonUtils.API_KEY}',
      'accessToken': '${accessToken}',
      'user_id': '${user_id}',
      'media_id': '${media_id}'
    });
    log("REQUEST SendViews:" + formData.fields.join(","));
    final response =
        await DioClient.getInstance().post('SendViews', data: formData);
    log("RESPONSE SendViews:" + response.toString());
    if (response.statusCode == 200) {
      return CommonResponse.fromJson(response.data);
    } else {
      throw CustomHttpException(
          exceptionMsg: response.statusMessage.toString());
    }
  }

  static Future<CreateEventModel> createEvent(
      {@required String accessToken,
      @required String userid,
      @required String event_name,
      @required String event_date,
      @required String event_lat,
      @required String event_long,
      @required String event_city,
      @required String event_invitees,
      @required String event_type,
      @required String price,
      @required String additional_info,
      @required String currency_id}) async {
    FormData formData = new FormData.fromMap({
      'apiKey': '${CommonUtils.API_KEY}',
      'accessToken': '${accessToken}',
      'userid': '${userid}',
      'event_name': '${event_name}',
      'event_date': '${event_date}',
      'event_lat': '${event_lat}',
      'event_long': '${event_long}',
      'event_city': '${event_city}',
      'event_invitees': '${event_invitees}',
      'event_type': '${event_type}',
      'price': '${price}',
      'additional_info': '${additional_info}',
      'currency_id': '${currency_id}'
    });

    log("REQUEST CreateEvent:" + formData.fields.join(","));
    final response =
        await DioClient.getInstance().post('CreateEvent', data: formData);

    log("RESPONSE CreateEvent:" + response.toString());
    if (response.statusCode == 200) {
      return CreateEventModel.fromJson(response.data);
    } else {
      throw CustomHttpException(
          exceptionMsg: response.statusMessage.toString());
    }
  }

  static Future<CreateEventModel> updateEvent(
      {@required String accessToken,
      @required String userid,
      @required String event_name,
      @required String event_id,
      @required String event_date,
      @required String event_lat,
      @required String event_long,
      @required String event_city,
      @required String event_invitees,
      @required String event_type,
      @required String price,
      @required String additional_info,
      @required String currency_id}) async {
    FormData formData = new FormData.fromMap({
      'apiKey': '${CommonUtils.API_KEY}',
      'accessToken': '${accessToken}',
      'userid': '${userid}',
      'eventid': '${event_id}',
      'event_name': '${event_name}',
      'event_date': '${event_date}',
      'event_lat': '${event_lat}',
      'event_long': '${event_long}',
      'event_city': '${event_city}',
      'event_invitees': '${event_invitees}',
      'event_type': '${event_type}',
      'price': '${price}',
      'additional_info': '${additional_info}',
      'currency_id': '${currency_id}'
    });

    log("REQUEST UpdateEvents:" + formData.fields.join(","));
    final response =
        await DioClient.getInstance().post('UpdateEvents', data: formData);

    log("RESPONSE UpdateEvents:" + response.toString());
    if (response.statusCode == 200) {
      return CreateEventModel.fromJson(response.data);
    } else {
      throw CustomHttpException(
          exceptionMsg: response.statusMessage.toString());
    }
  }

  static Future<List<FriendList.Data>> ListFriendApiImplementer(
      {@required String accessToken,
      @required String userid,
      int offset,
      int limit}) async {
    FormData formData = new FormData.fromMap({
      'apiKey': '${CommonUtils.API_KEY}',
      'accessToken': '$accessToken',
      'user_id': '$userid',
      'offset': '$offset',
      'limit': '$limit'
    });

    log("REQUEST MyFriends:" + formData.fields.join(","));

    final response =
        await DioClient.getInstance().post('MyFriends', data: formData);
    log("RESPONSE MyFriends " + response.toString());
    if (response.statusCode == 200) {
      var data = FriendList.FriendList.fromJson(response.data).data;
      print(data);
      return data == null
          ? []
          : FriendList.FriendList.fromJson(response.data).data;
    } else {
      throw CustomHttpException(
          exceptionMsg: response.statusMessage.toString());
    }
  }

  static Future<List<CreateGruop.Data>> CreateGroupApiImplementer(
      {@required String accessToken,
      @required String userid,
      @required String name}) async {
    FormData formData = new FormData.fromMap({
      'apiKey': '${CommonUtils.API_KEY}',
      'accessToken': '$accessToken',
      'userid': userid,
      'name': '$name'
    });
    log("REQUEST AddGroup:" + formData.fields.join(","));

    final response =
        await DioClient.getInstance().post('AddGroup', data: formData);
    log("RESPONSE AddGroup " + response.toString());
    if (response.statusCode == 200) {
      var data = CreateGruop.CreateGruop.fromJson(response.data).data;

      return data == null
          ? []
          : CreateGruop.CreateGruop.fromJson(response.data).data;
    } else {
      throw CustomHttpException(
          exceptionMsg: response.statusMessage.toString());
    }
  }

  static Future<CommonResponse> AddFrndsingruopApiImplementer(
      {@required String accessToken,
      @required int gruopid,
      @required String userid,
      @required String addusers}) async {
    FormData formData = new FormData.fromMap({
      'apiKey': '${CommonUtils.API_KEY}',
      'accessToken': '$accessToken',
      'userid': '$userid',
      'groupid': '$gruopid',
      'addusers': '$addusers'
    });
    log("REQUEST AddUsersInGroup:" + formData.fields.join(","));
    final response =
        await DioClient.getInstance().post('AddUsersInGroup', data: formData);
    print("AddUsersInGroup :" + response.toString());
    print(response);
    if (response.statusCode == 200) {
      return CommonResponse.fromJson(response.data);
    } else {
      throw CustomHttpException(
          exceptionMsg: response.statusMessage.toString());
    }
  }

  static Future<ChatGruoplist.Data> ListChatGroupsApiImplementer({
    @required String accessToken,
    @required String userid,
  }) async {
    FormData formData = new FormData.fromMap({
      'apiKey': '${CommonUtils.API_KEY}',
      'accessToken': '$accessToken',
      'userid': '$userid',
    });
    log("REQUEST ListChatGroups:" + formData.fields.join(","));
    final response =
        await DioClient.getInstance().post('ListChatGroups', data: formData);
    print("Response ListChatGroups:" + jsonEncode(response.data));

    if (response.statusCode == 200) {
      ChatGruoplist.Data data =
          ChatGruoplist.ChatGruoplist.fromJson(response.data).data;
      //print(data.chatData.length);
      print(data);
      return data;
    } else {
      throw CustomHttpException(
          exceptionMsg: response.statusMessage.toString());
    }
  }

  static Future<dynamic> DeleteuserfromgruopImplementer({
    @required String accessToken,
    @required String userid,
    @required String gruopid,
    @required String addusers,
  }) async {
    FormData formData = new FormData.fromMap({
      'apiKey': '${CommonUtils.API_KEY}',
      'accessToken': '$accessToken',
      'userid': '$userid',
      'addusers': '$addusers',
      'groupid': '$gruopid'
    });
    log("REQUEST DeleteuserfromgruopImplementer:" + formData.fields.join(","));
    final response = await DioClient.getInstance()
        .post('DeleteUsersInGroup', data: formData);
    log("RESPONSE DeleteuserfromgruopImplementer " + response.toString());
    if (response.statusCode == 200) {
      var data = response.data;
      print(data.toString());
      return data != null ? data : [];
    } else {
      throw CustomHttpException(
          exceptionMsg: response.statusMessage.toString());
    }
  }

  static Future<dynamic> EditgruopImplementer({
    @required String accessToken,
    @required String userid,
    @required String gruopid,
    String groupphoto,
    String name,
  }) async {
    FormData formData = new FormData.fromMap({
      'apiKey': '${CommonUtils.API_KEY}',
      'accessToken': '$accessToken',
      'userid': '$userid',
      'id': '$gruopid',
      'name': '$name',
      'groupphoto': '$groupphoto',
    });
    log("REQUEST EditgruopImplementer:" + formData.fields.join(","));
    final response =
        await DioClient.getInstance().post('EditGroup', data: formData);
    log("RESPONSE EditgruopImplementer " + response.toString());
    if (response.statusCode == 200) {
      var data = response.data;
      print(data.toString());
      return data != null ? data : [];
    } else {
      throw CustomHttpException(
          exceptionMsg: response.statusMessage.toString());
    }
  }

  static Future<dynamic> EditgruopnameImplementer({
    @required String accessToken,
    @required String userid,
    @required String gruopid,
    String name,
  }) async {
    FormData formData = new FormData.fromMap({
      'apiKey': '${CommonUtils.API_KEY}',
      'accessToken': '$accessToken',
      'userid': '$userid',
      'id': '$gruopid',
      'name': '$name',
    });
    log("REQUEST EditgruopnameImplementer:" + formData.fields.join(","));
    final response =
        await DioClient.getInstance().post('EditGroup', data: formData);
    log("RESPONSE EditgruopnameImplementer " + response.toString());
    if (response.statusCode == 200) {
      var data = response.data;
      print(data.toString());
      return data != null ? data : [];
    } else {
      throw CustomHttpException(
          exceptionMsg: response.statusMessage.toString());
    }
  }

  //Leaderboard
  static Future<dynamic> LeaderboardImplementer({
    @required String accessToken,
    String userid,
  }) async {
    FormData formData = new FormData.fromMap({
      'apiKey': '${CommonUtils.API_KEY}',
      'accessToken': '$accessToken',
      'userid': '$userid'
    });
    log("REQUEST LeaderboardImplementer:" + formData.fields.join(","));
    final response =
        await DioClient.getInstance().post('Leaderboard', data: formData);
    log("RESPONSE LeaderboardImplementer " + response.toString());
    if (response.statusCode == 200) {
      var data = response.data;
      print(data['errorcode']);
      /*   if (data['errorcode'] == "2") {

      } else {*/
      print(data.toString());
      return data != null ? data : [];
      // }
    } else {
      throw CustomHttpException(
          exceptionMsg: response.statusMessage.toString());
    }
  } //Leaderboard

  static Future<dynamic> getOutOutRegret({
    @required String accessToken,
    String userid,
  }) async {
    FormData formData = new FormData.fromMap({
      'apiKey': '${CommonUtils.API_KEY}',
      'accessToken': '$accessToken',
      'userid': '$userid'
    });
    log("REQUEST LeaderboardImplementer:" + formData.fields.join(","));
    final response =
        await DioClient.getInstance().post('ListOutOutRegret', data: formData);
    log("RESPONSE LeaderboardImplementer " + response.toString());
    if (response.statusCode == 200) {
      var data = response.data;
      print(data['errorcode']);
      /*   if (data['errorcode'] == "2") {

      } else {*/
      print(data.toString());
      return data != null ? data : [];
      // }
    } else {
      throw CustomHttpException(
          exceptionMsg: response.statusMessage.toString());
    }
  }

  //fcmtoken
  static Future<dynamic> FCMTOKENImplementer(
      {@required String accessToken, String userid, String FCMToken}) async {
    FormData formData = new FormData.fromMap({
      'apiKey': '${CommonUtils.API_KEY}',
      'accessToken': '$accessToken',
      'userid': '$userid',
      'fcmtoken': '$FCMToken',
    });
    print("REQUEST FCM: accessToken:" + accessToken);
    print("REQUEST FCM: FCMToken:" + FCMToken);
    final response =
        await DioClient.getInstance().post('GetFCMToken', data: formData);
    log("RESPONSE FCMTOKENImplementer " + response.toString());
    if (response.statusCode == 200) {
      var data = response.data;
      print(data.toString());
      return data != null ? data : [];
    } else {
      throw CustomHttpException(
          exceptionMsg: response.statusMessage.toString());
    }
  }

  static Future<dynamic> DeletegruopImplementer({
    @required String accessToken,
    @required String userid,
    @required String gruopid,
  }) async {
    FormData formData = new FormData.fromMap({
      'apiKey': '${CommonUtils.API_KEY}',
      'accessToken': '$accessToken',
      'userid': '$userid',
      'groupid': '$gruopid'
    });
    log("REQUEST DeletegruopImplementer:" + formData.fields.join(","));
    final response =
        await DioClient.getInstance().post('DeleteGroup', data: formData);
    log("RESPONSE DeletegruopImplementer " + response.toString());
    if (response.statusCode == 200) {
      var data = response.data;
      print(data.toString());
      return data != null ? data : [];
    } else {
      throw CustomHttpException(
          exceptionMsg: response.statusMessage.toString());
    }
  }

  static Future<model_advt> AdvertApiImplementer(
      {@required String accessToken,
      @required String userid,
      @required String title,
      @required String desc,
      @required String file}) async {
    FormData formData = new FormData.fromMap({
      'apiKey': '${CommonUtils.API_KEY}',
      'accessToken': accessToken,
      'userid': userid,
      'title': title,
      'description': desc,
      'file': '${file}',
      'type': '1',
      'link': '',
    });
    log("REQUEST AdvertApiImplementer:" + formData.fields.join(","));
    final response = await DioClient.getInstance()
        .post('CreateAdvertisement', data: formData);
    log("RESPONSE AdvertApiImplementer " + response.toString());
    if (response.statusCode == 200) {
      return model_advt.fromJson(response.data);
    } else {
      throw CustomHttpException(
          exceptionMsg: response.statusMessage.toString());
    }
  }

  static Future<Payment_list> ListPackagesImplementer() async {
    FormData formData = new FormData.fromMap({
      'apiKey': '${CommonUtils.API_KEY}',
    });
    log("REQUEST ListPackagesImplementer:" + formData.fields.join(","));
    final response =
        await DioClient.getInstance().post('ListPackages', data: formData);
    log("RESPONSE ListPackagesImplementer " + response.toString());
    if (response.statusCode == 200) {
      return Payment_list.fromJson(response.data);
    } else {
      throw CustomHttpException(
          exceptionMsg: response.statusMessage.toString());
    }
  }

  static Future<CommonResponse> sendBroadcastMessage({
    @required String accessToken,
    @required String userid,
    @required String message,
  }) async {
    FormData formData = new FormData.fromMap({
      'apiKey': '${CommonUtils.API_KEY}',
      'accessToken': accessToken,
      'user_id': userid,
      'message': message,
    });
    log("REQUEST sendBroadcastMessage:" + formData.fields.join(","));
    final response = await DioClient.getInstance()
        .post('CreateBroadcastMessage', data: formData);
    log("RESPONSE sendBroadcastMessage " + response.toString());
    if (response.statusCode == 200) {
      return CommonResponse.fromJson(response.data);
    } else {
      throw CustomHttpException(
          exceptionMsg: response.statusMessage.toString());
    }
  }

  static Future<CommonResponse> likeBroadcastMessage(
      {@required String accessToken,
      @required String userid,
      @required String messageId,
      @required String isLiked}) async {
    FormData formData = new FormData.fromMap({
      'apiKey': '${CommonUtils.API_KEY}',
      'accessToken': accessToken,
      'user_id': userid,
      'message_id': messageId,
      'is_liked': isLiked,
    });
    log("REQUEST likeBroadcastMessage:" + formData.fields.join(","));
    final response =
        await DioClient.getInstance().post('LikeMessage', data: formData);
    log("RESPONSE likeBroadcastMessage " + response.toString());
    if (response.statusCode == 200) {
      return CommonResponse.fromJson(response.data);
    } else {
      throw CustomHttpException(
          exceptionMsg: response.statusMessage.toString());
    }
  }

  static Future<CommonResponse> repostBroadcastMessage(
      {@required String accessToken,
      @required String userid,
      @required String messageId,
      @required String isLiked}) async {
    FormData formData = new FormData.fromMap({
      'apiKey': '${CommonUtils.API_KEY}',
      'accessToken': accessToken,
      'user_id': userid,
      'message_id': messageId,
    });
    log("REQUEST repostBroadcastMessage:" + formData.fields.join(","));
    final response =
        await DioClient.getInstance().post('RepostMessage', data: formData);
    log("RESPONSE repostBroadcastMessage " + response.toString());
    if (response.statusCode == 200) {
      return CommonResponse.fromJson(response.data);
    } else {
      throw CustomHttpException(
          exceptionMsg: response.statusMessage.toString());
    }
  }

  static Future<CommonResponse> addStory({
    @required String accessToken,
    @required String user_id,
    @required String type,
    @required File file,
    @required String caption,
  }) async {
    String fileName = file.path.split('/').last;
    FormData formData = new FormData.fromMap({
      'apiKey': '${CommonUtils.API_KEY}',
      'accessToken': '${accessToken}',
      'user_id': '${user_id}',
      'type': type,
      'story': await MultipartFile.fromFile(file.path, filename: fileName),
      'caption': '${caption}'
    });
    log("REQUEST addStory:" + formData.fields.join(","));
    final response =
        await DioClient.getInstance().post('AddStory', data: formData);
    log("RESPONSE addStory " + response.toString());
    if (response.statusCode == 200) {
      return CommonResponse.fromJson(response.data);
    } else {
      throw CustomHttpException(
          exceptionMsg: response.statusMessage.toString());
    }
  }

  static Future<UserStory> storyList({
    @required String accessToken,
    @required String userid,
  }) async {
    FormData formData = new FormData.fromMap({
      'apiKey': '${CommonUtils.API_KEY}',
      'accessToken': '$accessToken',
      'user_id': '$userid',
      'type[0]': 0
    });

    log("REQUEST storyList:" + formData.fields.join(","));
    final response =
        await DioClient.getInstance().post('ViewUserStory', data: formData);
    print("Response storyList:" + jsonEncode(response.data));

    if (response.statusCode == 200) {
      UserStory data = UserStory.fromJson(response.data);
      print(data);
      return data;
    } else {
      throw CustomHttpException(
          exceptionMsg: response.statusMessage.toString());
    }
  }

  //GO LIVE
  static Future<dynamic> GoliveImplementer(
      {@required String accessToken,
      String userid,
      String liveUrl,
      String livevalue}) async {
    FormData formData = new FormData.fromMap({
      'apiKey': '${CommonUtils.API_KEY}',
      'accessToken': '$accessToken',
      'userid': '$userid',
      'liveurl': '$liveUrl',
      'livevalue': '$livevalue'
    });
    log("REQUEST GoliveImplementer:" + formData.fields.join(","));
    final response =
        await DioClient.getInstance().post('LiveUser', data: formData);

    log("REQUEST GoliveImplementer:" + formData.fields.join(","));

    if (response.statusCode == 200) {
      var data = response.data;
      print(data.toString());
      return data != null ? data : [];
    } else {
      throw CustomHttpException(
          exceptionMsg: response.statusMessage.toString());
    }
  }

  //GolivewithFrndsImplementer
  static Future<dynamic> GolivewithFrndsImplementer(
      {@required String accessToken,
      @required String userid,
      String friends,
      String Url}) async {
    FormData formData = new FormData.fromMap({
      'apiKey': '${CommonUtils.API_KEY}',
      'accessToken': '$accessToken',
      'userid': '$userid',
      'friends': '$friends',
      'liveurl': '$Url'
    });
    log("REQUEST GolivewithFrndsImplementer:" + formData.fields.join(","));
    final response =
        await DioClient.getInstance().post('GoLive', data: formData);
    log("RESPONSE GolivewithFrndsImplementer " + response.toString());
    if (response.statusCode == 200) {
      var data = response.data;
      print(data.toString());
      return data != null ? data : [];
    } else {
      throw CustomHttpException(
          exceptionMsg: response.statusMessage.toString());
    }
  }

  static Future<GetAgoraToken> getAgoraToken({
    @required String accessToken,
    @required String userid,
  }) async {
    FormData formData = new FormData.fromMap({
      'apiKey': '${CommonUtils.API_KEY}',
      'accessToken': '$accessToken',
      'userid': '$userid',
    });

    log("REQUEST getAgoraToken:" + formData.fields.join(","));
    final response =
        await DioClient.getInstance().post('GetAgoraToken', data: formData);
    log("RESPONSE getAgoraToken " + response.toString());
    if (response.statusCode == 200) {
      GetAgoraToken data = GetAgoraToken.fromJson(response.data);
      print(data.toJson().toString());
      return data;
    } else {
      throw CustomHttpException(
          exceptionMsg: response.statusMessage.toString());
    }
  }

  static Future<GetFriends> GetFriendFeed({
    @required String accessToken,
    @required String userid,
    @required int isVip,
  }) async {
    FormData formData = new FormData.fromMap({
      'apiKey': '${CommonUtils.API_KEY}',
      'accessToken': '$accessToken',
      'user_id': '$userid',
      'is_vip': '$isVip',
    });

    log("REQUEST GetFriendFeed:" + formData.fields.join(","));
    final response =
        await DioClient.getInstance().post('FriendsFeed', data: formData);
    log("RESPONSE GetFriendFeed " + response.toString());
    if (response.statusCode == 200) {
      GetFriends data = GetFriends.fromJson(response.data);
      print(data.toJson().toString());
      return data;
    } else {
      throw CustomHttpException(
          exceptionMsg: response.statusMessage.toString());
    }
  }

  static Future<List<friendModel.Data>> GetFriendList({
    @required String accessToken,
    @required String userid,
    @required String search,
  }) async {
    FormData formData = new FormData.fromMap({
      'apiKey': '${CommonUtils.API_KEY}',
      'accessToken': '$accessToken',
      'userid': '$userid',
      'search': '$search',
    });

    log("REQUEST GetFriendFeed:" + formData.fields.join(","));
    final response =
        await DioClient.getInstance().post('AllUsers', data: formData);
    log("RESPONSE GetFriendFeed " + response.toString());
    if (response.statusCode == 200) {
      /*    FriendsListModel data = FriendsListModel.fromJson(response.data);
      print(data.toJson().toString());


      return data;*/
      var data = friendModel.SearchFriendsListModel.fromJson(response.data).data;
      return data == null
          ? []
          : friendModel.SearchFriendsListModel.fromJson(response.data).data;
    } else {
      throw CustomHttpException(
          exceptionMsg: response.statusMessage.toString());
    }
  }

  static Future<SearchFriendsListModel> GetRequestedFriendList({
    @required String accessToken,
    @required String userid,
  }) async {
    FormData formData = new FormData.fromMap({
      'apiKey': '${CommonUtils.API_KEY}',
      'accessToken': '$accessToken',
      'from_user_id': '$userid',
    });

    log("REQUEST GetRequestedFriendList:" + formData.fields.join(","));
    final response =
        await DioClient.getInstance().post('RequestedFriends', data: formData);
    log("RESPONSE GetRequestedFriendList " + response.toString());
    if (response.statusCode == 200) {
      /*    FriendsListModel data = FriendsListModel.fromJson(response.data);
      print(data.toJson().toString());


      return data;*/
      var data = SearchFriendsListModel.fromJson(response.data);
      return data;
    } else {
      throw CustomHttpException(
          exceptionMsg: response.statusMessage.toString());
    }
  }

  static Future<AddMoneyToWalleModel> AddMoneyToWallet({
    @required String accessToken,
    @required String userid,
    @required String amount,
    @required String payment_ref_id,
  }) async {
    FormData formData = new FormData.fromMap({
      'apiKey': '${CommonUtils.API_KEY}',
      'accessToken': '$accessToken',
      'userid': '$userid',
      'amount': '$amount',
      'payment_ref_id': '$payment_ref_id',
    });

    log("REQUEST AddMoneyToWallet:" + formData.fields.join(","));
    final response =
        await DioClient.getInstance().post('AddMoneyToWallet', data: formData);
    log("RESPONSE AddMoneyToWallet " + response.toString());
    if (response.statusCode == 200) {
      var data = AddMoneyToWalleModel.fromJson(response.data);
      return data;
    } else {
      throw CustomHttpException(
          exceptionMsg: response.statusMessage.toString());
    }
  }
 static Future<AddMoneyToWalleModel> sendMoneyToUser({
    @required String accessToken,
    @required String userid,
    @required String amount,
    @required String toUserId,
  }) async {
    FormData formData = new FormData.fromMap({
      'apiKey': '${CommonUtils.API_KEY}',
      'accessToken': '$accessToken',
      'from_user_id': '$userid',
      'to_user_id': '$toUserId',
      'amount': '$amount',
    });

    log("REQUEST SendMoney:" + formData.fields.join(","));
    final response =
        await DioClient.getInstance().post('SendMoney', data: formData);
    log("RESPONSE SendMoney " + response.toString());
    if (response.statusCode == 200) {
      var data = AddMoneyToWalleModel.fromJson(response.data);
      return data;
    } else {
      throw CustomHttpException(
          exceptionMsg: response.statusMessage.toString());
    }
  }

  static Future<AddMoneyToWalleModel> ApiCallForUpdateMemberShip({
    @required String accessToken,
    @required String userid,
    @required String packageid,
    @required String paymenttype,
  }) async {
    FormData formData = new FormData.fromMap({
      'apiKey': '${CommonUtils.API_KEY}',
      'accessToken': '$accessToken',
      'userid': '$userid',
      'packageid': '$packageid',
      'paymenttype': '$paymenttype',
    });

    log("REQUEST ApiCallForUpdateMemberShip:" + formData.fields.join(","));
    final response =
        await DioClient.getInstance().post('UpdatePlan', data: formData);
    log("RESPONSE ApiCallForUpdateMemberShip " + response.toString());
    if (response.statusCode == 200) {
      var data = AddMoneyToWalleModel.fromJson(response.data);
      return data;
    } else {
      throw CustomHttpException(
          exceptionMsg: response.statusMessage.toString());
    }
  }

  static Future<PaymentSuccessModel> ApiCallMakePayment({
    @required String accessToken,
    @required String userid,
    @required String amount,
    @required String nonce,
  }) async {
    FormData formData = new FormData.fromMap({
      'apiKey': '${CommonUtils.API_KEY}',
      'accessToken': '$accessToken',
      'userid': '$userid',
      'amount': '$amount',
      'nonce': '$nonce',
    });

    log("REQUEST ApiCallMakePayment:" + formData.fields.join(","));
    final response =
        await DioClient.getInstance().post('Payment', data: formData);
    log("RESPONSE ApiCallMakePayment " + response.toString());
    if (response.statusCode == 200) {
      var data = PaymentSuccessModel.fromJson(response.data);
      return data;
    } else {
      throw CustomHttpException(
          exceptionMsg: response.statusMessage.toString());
    }
  }

  static Future<WalletModel> FetchWalletData({
    @required String accessToken,
    @required String userid,
  }) async {
    FormData formData = new FormData.fromMap({
      'apiKey': '${CommonUtils.API_KEY}',
      'accessToken': '$accessToken',
      'userid': '$userid',
    });

    log("REQUEST FetchWalletData:" + formData.fields.join(","));
    final response =
        await DioClient.getInstance().post('Wallet', data: formData);
    log("RESPONSE FetchWalletData " + response.toString());
    if (response.statusCode == 200) {
      var data = WalletModel.fromJson(response.data);
      return data;
    } else {
      throw CustomHttpException(
          exceptionMsg: response.statusMessage.toString());
    }
  }

  static Future<WalletTransactionModel> FetchWalletTransaction({
    @required String accessToken,
    @required String userid,
  }) async {
    FormData formData = new FormData.fromMap({
      'apiKey': '${CommonUtils.API_KEY}',
      'accessToken': '$accessToken',
      'userid': '$userid',
    });

    log("REQUEST FetchWalletTransaction:" + formData.fields.join(","));
    final response = await DioClient.getInstance()
        .post('TransactionDetails', data: formData);
    log("RESPONSE FetchWalletTransaction " + response.toString());
    if (response.statusCode == 200) {
      var data = WalletTransactionModel.fromJson(response.data);
      return data;
    } else {
      throw CustomHttpException(
          exceptionMsg: response.statusMessage.toString());
    }
  }

  /*static Future<List<friendModel.Data>> searchFriendsListApiImplementer({
    @required String accessToken,
    @required String account_type,
    @required int offset,
    @required int limit,
    @required String search_query,
    @required String is_vip,
  }) async {
    FormData formData = new FormData.fromMap({
      'apiKey': '${CommonUtils.API_KEY}',
      'accessToken': '${accessToken}',
      'account_type': '${account_type}',
      'offset': '${offset}',
      'limit': '${limit}',
      'search_query': '${search_query}',
      'is_vip': '${is_vip}'
    });
    log("REQUEST searchFriends:" + formData.fields.join(","));
    final response =
    await DioClient.getInstance().post('SearchFriends', data: formData);
    log("RESPONSE searchFriends:" + response.toString());
    if (response.statusCode == 200) {
      var data =
          friendModel.SearchFriendsListModel.fromJson(response.data).data;
      return data == null
          ? []
          : friendModel.SearchFriendsListModel.fromJson(response.data).data;
    } else {
      throw CustomHttpException(
          exceptionMsg: response.statusMessage.toString());
    }
  }*/

  static Future<CommonResponse> sendRequestToJoinGoLive({
    @required String accessToken,
    @required String userId,
    @required String friendId,
  }) async {
    FormData formData = new FormData.fromMap({
      'apiKey': '${CommonUtils.API_KEY}',
      'accessToken': '${accessToken}',
      'userid': '${userId}',
      'friendid': '${friendId}',
    });
    log("REQUEST JoinToGoLive:" + formData.fields.join(","));
    final response =
        await DioClient.getInstance().post('JoinToGoLive', data: formData);
    log("RESPONSE JoinToGoLive:" + response.toString());
    if (response.statusCode == 200) {
      return CommonResponse.fromJson(response.data);
    } else {
      throw CustomHttpException(
          exceptionMsg: response.statusMessage.toString());
    }
  }

  static Future<CommonResponse> requestToJoinGoLive({
    @required String accessToken,
    @required String userId,
    @required String friendId,
  }) async {
    FormData formData = new FormData.fromMap({
      'apiKey': '${CommonUtils.API_KEY}',
      'accessToken': '${accessToken}',
      'userid': '${userId}',
      'friendid': '${friendId}',
    });
    log("REQUEST requestToJoinGoLive:" + formData.fields.join(","));
    final response = await DioClient.getInstance()
        .post('RequestToJoinGoLive', data: formData);
    log("RESPONSE requestToJoinGoLive:" + response.toString());
    if (response.statusCode == 200) {
      return CommonResponse.fromJson(response.data);
    } else {
      throw CustomHttpException(
          exceptionMsg: response.statusMessage.toString());
    }
  }
}
