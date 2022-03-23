import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:out_out/models/ChatGruoplist.dart' as ChatGruoplist;
import 'package:out_out/models/notifications/broadcast_message_notification.dart';
import 'package:out_out/utils/preferences_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CommonDetailsProvider extends ChangeNotifier {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  SharedPreferences _sharedPreferences;
  RequestToGoLiveNotification _requestToGoLiveNotification;
  List<RequestToGoLiveNotification> _reqList = [];
  List<CameraDescription> _cameras;
  User _user;
  bool _isEndedLive = false;

  User get user => _user;

  SharedPreferences get getPreferencesInstance => _sharedPreferences;

  List<CameraDescription> get getCameraList => _cameras;

  RequestToGoLiveNotification get requestToGoLiveNotification =>
      _requestToGoLiveNotification;

  List<RequestToGoLiveNotification> get reqList => _reqList;

  void addReqList(RequestToGoLiveNotification value) {
    _reqList.add(value);
    print("LISTT SIZE:" + _reqList.length.toString());
    notifyListeners();
  }

  void clearReqList() {
    _reqList.clear();
    print("LISTT SIZE:" + _reqList.length.toString());
    notifyListeners();
  }

  bool get isEndedLive => _isEndedLive;

  set isEndedLive(bool value) {
    _isEndedLive = value;
    notifyListeners();
  }

  set requestToGoLiveNotification(RequestToGoLiveNotification value) {
    _requestToGoLiveNotification = value;
  }

  Future<void> initPreferences() async {
    _sharedPreferences = await _prefs;
    initUser();
  }

  Future<Null> initCamera() async {
    WidgetsFlutterBinding.ensureInitialized();
    _cameras = await availableCameras();
  }

  void initUser() {
    _user = User(
        _sharedPreferences.get(PreferenceConstants.ACCESS_TOKEN),
        _sharedPreferences.get(PreferenceConstants.USER_ID),
        _sharedPreferences.get(PreferenceConstants.ACCOUNT_TYPE));
    notifyListeners();
  }

  List<ChatGruoplist.ChatData> _chatGruoplist = new List();
  void Fun_chatdata(ChatGruoplist.ChatData _chatdata) {
    // _chatGruoplist.clear();
    _chatGruoplist.add(_chatdata);

    print(_chatGruoplist.length);
  }

  void Fun_deletechatdata(int index) {
    _chatGruoplist.removeWhere((item) => item.chatid == index);
  }

  List<ChatGruoplist.ChatData> get getchatdatalist => _chatGruoplist;
}

class User {
  String accessToken;
  String userId;
  String accountType;
  User(this.accessToken, this.userId, this.accountType);
}
