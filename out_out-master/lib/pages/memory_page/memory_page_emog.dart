import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:image_picker/image_picker.dart';
import 'package:out_out/Golive/Loading.dart';
import 'package:out_out/api/api_implementer.dart';
import 'package:out_out/chat/widget/full_photo.dart';
import 'package:out_out/chat/widget/loading.dart';
import 'package:out_out/models/Leaderboard.dart';
import 'package:out_out/models/outout_regret.dart';
import 'package:out_out/pages/common/login_page.dart';
import 'package:out_out/pages/story_page/image_story_page.dart';
import 'package:out_out/providers/common_details_provider.dart';
import 'package:out_out/utils/common_dialog_util.dart';
import 'package:out_out/utils/custom_colors.dart';
import 'package:out_out/utils/icon_utils.dart';
import 'package:out_out/utils/preferences_constants.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MemoryPageEmoG extends StatefulWidget {
  @override
  _MemoryPageEmoGState createState() => _MemoryPageEmoGState();
}

class _MemoryPageEmoGState extends State<MemoryPageEmoG> {
  SharedPreferences _sharedPreferences;
  bool _isLoading = false;
  RxString _profileUrl = ''.obs;
  RxString _userName = ''.obs;
  RxString _city = ''.obs;
  RxString _birthDate = ''.obs;
  String _accessToken = '';
  String _userId = '';
  final picker = ImagePicker();

  OutOutRegretModel regretModel;

  @override
  void didChangeDependencies() {
    if (!_isLoading) {
      _sharedPreferences =
          Provider.of<CommonDetailsProvider>(context).getPreferencesInstance;
      _profileUrl.value =
          _sharedPreferences.get(PreferenceConstants.PROFILE_IMAGE);

      _userName.value =
          '${_sharedPreferences.get(PreferenceConstants.FIRST_NAME)} ${_sharedPreferences.get(PreferenceConstants.LAST_NAME)}';
      _city.value = _sharedPreferences.get(PreferenceConstants.CITY);
      _birthDate.value = _sharedPreferences.get(PreferenceConstants.DOB);
      _accessToken = _sharedPreferences.get(PreferenceConstants.ACCESS_TOKEN);
      _userId = _sharedPreferences.get(PreferenceConstants.USER_ID);
      print("mohit");
      print(_userId);
      print(_accessToken);
    }
    _isLoading = true;
    super.didChangeDependencies();
  }

  bool vip = true;
  User user;
  Leaderboard leadboard = new Leaderboard();

  @override
  void initState() {
    user = Provider.of<CommonDetailsProvider>(context, listen: false).user;
    print('user.accessToken');
    print(user.accessToken);
    getOutOutRegret();
    ApiImplementer.LeaderboardImplementer(
            accessToken: user.accessToken, userid: user.userId)
        .then((value) {
      setState(() {
        print('LeaderboardImplementer');
        if (value['errorcode'] == "2") {
          print("logout");
          _sharedPreferences.clear();
             Navigator.of(context).pushNamedAndRemoveUntil(LoginScreen.routeName, (Route<dynamic> route) => false);
          CommonDialogUtil.showErrorSnack(context: context, msg: value['msg']);
        } else {
          print(value);
          leadboard = Leaderboard.fromJson(value);

          /* if(leadboard.data.isEmpty){
            Fluttertoast.showToast(msg: "OutOut Regrets");
          }*/
          // print('leadboard.errorcode.toString()');
          // print(leadboard.errorcode.toString());
          // print(value.toString());
        }
      });
    });

    super.initState();
  }

  void getOutOutRegret() {
    ApiImplementer.getOutOutRegret(
            accessToken: user.accessToken, userid: user.userId)
        .then((value) {
      setState(() {
        print('getOutOutRegret');
        if (value['errorcode'] == "2") {
          print("logout");
          _sharedPreferences.clear();
             Navigator.of(context).pushNamedAndRemoveUntil(LoginScreen.routeName, (Route<dynamic> route) => false);
          CommonDialogUtil.showErrorSnack(context: context, msg: value['msg'] ?? '');
        } else {
          print(value);
          regretModel = OutOutRegretModel.fromJson(value);

          /* if(leadboard.data.isEmpty){
            Fluttertoast.showToast(msg: "OutOut Regrets");
          }*/
          print('leadboard.errorcode.toString()');
          print(leadboard.errorcode.toString());
          print(value.toString());
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          height: constraints.maxHeight,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                CustomColor.colorAccent.withOpacity(0.4),
                CustomColor.colorPrimaryDark.withOpacity(0.4),
              ],
            ),
          ),
          child: Container(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'OutOut Regret',
                    style: TextStyle(
                      color: CustomColor.colorPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  (regretModel != null && regretModel.data != null)
                      ? Container(
                          height: 90,
                          child: regretModel.data.length != 0
                              ? ListView.builder(
                                  shrinkWrap: false,
                                  scrollDirection: Axis.horizontal,
                                  itemCount: regretModel.data.length,
                                  itemBuilder: (BuildContext context,
                                          int index) =>
                                      Container(
                                        height: 90,
                                        width: 90,
                                        child: Hero(
                                          tag: regretModel.data[index],
                                          child: Card(
                                            elevation: 12,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        15.0)),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(15.0),
                                              child: InkWell(
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          FullPhoto(
                                                        url: regretModel
                                                            .data[index].story,
                                                      ),
                                                    ),
                                                  );
                                                },
                                                child: CachedNetworkImage(
                                                  fit: BoxFit.fill,
                                                  errorWidget: (context, _,
                                                          te) =>
                                                      Image.asset(
                                                          out_out_actionbar),
                                                  placeholder: (context, _) =>
                                                      Image.asset(splash_logo),
                                                  imageUrl: regretModel
                                                      .data[index].story,
                                                  fadeInCurve: Curves.easeInOut,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ))
                              : Center(
                                  child: Text(
                                    regretModel?.msg ??
                                        "No OutOut Regrets found!",
                                    style: TextStyle(
                                      color: Colors.black54,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                ),
                        )
                      : Center(
                          child: Text(
                            regretModel?.msg ?? "No OutOut Regrets found!",
                            style: TextStyle(
                              color: Colors.black54,
                              fontWeight: FontWeight.w500,
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                  SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: vip
                        ? Wrap(
                            children: [
                              Container(
                                padding: EdgeInsets.all(8.0),
                                child: Center(
                                  child: Text(
                                    'Leaderboard',
                                    style: TextStyle(
                                      color: CustomColor.colorPrimary,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25.0,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: CustomColor.colorPrimary,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                child: Container(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      leadboard.data == null
                                          ? Loading()
                                          : leadboard.data.isEmpty
                                              ? Container(
                                                  height: MediaQuery.of(context)
                                                      .size
                                                      .height,
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  child: Center(
                                                    heightFactor:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height -
                                                            0,
                                                    widthFactor:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width -
                                                            0,
                                                    child:
                                                        Text("no Data Found"),
                                                  ),
                                                )
                                              : GridView.builder(
                                                  shrinkWrap: true,
                                                  physics:
                                                      const NeverScrollableScrollPhysics(),
                                                  itemCount: 6,
                                                  gridDelegate:
                                                      SliverGridDelegateWithFixedCrossAxisCount(
                                                          crossAxisCount: 2,
                                                          crossAxisSpacing: 2.0,
                                                          childAspectRatio: 2,
                                                          mainAxisSpacing: 1.8),
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          int index) {
                                                    return Center(
                                                      child: ListTile(
                                                        contentPadding:
                                                            EdgeInsets.zero,
                                                        leading: Container(
                                                          height: 100,
                                                          width: 84,
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceEvenly,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Text(
                                                                '${index + 1} ',
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize:
                                                                      18.0,
                                                                ),
                                                              ),
                                                              Container(
                                                                width: 44,
                                                                height: 44,
                                                                //BoxDecoration Widget
                                                                decoration:
                                                                    BoxDecoration(
                                                                  image:
                                                                      DecorationImage(
                                                                    image: NetworkImage(leadboard
                                                                        .data[
                                                                            index]
                                                                        .profileimage),
                                                                    fit: BoxFit
                                                                        .cover,
                                                                  ), //DecorationImage
                                                                  border: Border
                                                                      .all(
                                                                    width: 3,
                                                                    color: CustomColor
                                                                        .colorPrimaryDark,
                                                                  ), //Border.all
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              15),
                                                                ), //BoxDecoration
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        title: Text(
                                                          '${leadboard.data[index].firstName} ${leadboard.data[index].lastName}',
                                                          style: TextStyle(
                                                            color: CustomColor
                                                                .colorPrimary,
                                                          ),
                                                        ),
                                                        subtitle: Text(
                                                          '${leadboard.data[index].points} points',
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                )
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          vip = !vip;
                                        });
                                      },
                                      child: Text(
                                        'VIP',
                                        style: TextStyle(
                                          color: CustomColor.colorPrimary,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.chat,
                                          color: CustomColor.colorPrimary),
                                      onPressed: () {},
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '😂\n\n Oops looks like\nyou\'re not a VIP\nfriends...',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: CustomColor.colorPrimary,
                                  fontSize: 20.0,
                                ),
                              ),
                              Wrap(
                                alignment: WrapAlignment.center,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        vip = !vip;
                                      });
                                    },
                                    child: Container(
                                      width: 240,
                                      margin:
                                          EdgeInsets.symmetric(vertical: 30.0),
                                      padding:
                                          EdgeInsets.symmetric(vertical: 12.0),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [
                                            CustomColor.colorAccent,
                                            CustomColor.colorPrimary
                                          ],
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(16.0),
                                      ),
                                      child: Text(
                                        'request to be VIP 😎',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
