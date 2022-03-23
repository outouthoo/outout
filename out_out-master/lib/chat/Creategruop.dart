import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:out_out/api/api_implementer.dart';
import 'package:out_out/models/friendList_model.dart' as FriendList;
import 'package:out_out/providers/common_details_provider.dart';
import 'package:out_out/utils/custom_colors.dart';
import 'package:out_out/utils/preferences_constants.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Chatlist.dart';

class add_Frnds_gruop extends StatefulWidget {
  final String gruopId;
  add_Frnds_gruop({Key key, this.gruopId}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return add_gruop_state();
  }
}

class add_gruop_state extends State<add_Frnds_gruop> {
  String _accessToken = '';
  RxString _profileUrl = ''.obs;
  RxString _userName = ''.obs;
  RxString _city = ''.obs;
  RxString _birthDate = ''.obs;
  String _userId = '';
  bool _isLoading = false;
  List<FriendList.Data> _data = new List();
  SharedPreferences _sharedPreferences;
  List<bool> checkvalue = new List();
  TextEditingController _groupcontroller = new TextEditingController();
  List<FriendList.Data> _Checkeddata = new List();
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
    }
    _isLoading = true;
    super.didChangeDependencies();
  }

  @override
  void initState() {
    ApiImplementer.ListFriendApiImplementer(
      accessToken: _accessToken.toString(),
      userid: _userId.toString(),
      limit: 2,
      offset: 5,
    ).then((value) {
      _data.addAll(value);
      for (int i = 0; i <= _data.length + 1; i++) {
        checkvalue.add(false);
      }
      setState(() {});
    });
    super.initState();
  }

  Function_addusersingruop() {
    print(_userId.toString());

    ApiImplementer.AddFrndsingruopApiImplementer(
            accessToken: _accessToken.toString(),
            gruopid: int.parse(widget.gruopId.toString()),
            addusers: "2,3",
            userid: _userId)
        .then((value) {
      //  Function_getData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(
          "Add Frnds In Group",
        )),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FlatButton(
            onPressed: () {
              setState(() {
                print(checkvalue.toString());
                Function_addusersingruop();
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Chat_gruop_list(),
                    ));
              });
            },
            child: Container(
                color: Colors.black,
                height: 50,
                width: 120,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                      child: Text(
                    "Save",
                    style: TextStyle(color: Colors.white),
                  )),
                ))),
        body: ListView.builder(
          shrinkWrap: true,
          padding: EdgeInsets.all(10.0),
          itemBuilder: (context, index) => CheckboxListTile(
            value: checkvalue[index],
            onChanged: (value) {
              setState(() {
                checkvalue[index] = value;
                print(value);
              });
            },
            activeColor: Colors.pink,
            checkColor: Colors.white,
            title: Container(
              child: Column(
                children: [
                  TextButton(
                    child: Row(
                      children: <Widget>[
                        Material(
                          child: _data.length != 0
                              ? Image.network(
                                  _data[index].profileImage,
                                  fit: BoxFit.fill,
                                  width: 60.0,
                                  height: 60.0,
                                  loadingBuilder: (BuildContext context,
                                      Widget child,
                                      ImageChunkEvent loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return Container(
                                      width: 50,
                                      height: 50,
                                      child: Center(
                                        child: CircularProgressIndicator(
                                          color: CustomColor.colorAccent,
                                          value: loadingProgress
                                                          .expectedTotalBytes !=
                                                      null &&
                                                  loadingProgress
                                                          .expectedTotalBytes !=
                                                      null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  loadingProgress
                                                      .expectedTotalBytes
                                              : null,
                                        ),
                                      ),
                                    );
                                  },
                                  errorBuilder: (context, object, stackTrace) {
                                    return Icon(
                                      Icons.account_circle,
                                      size: 50.0,
                                      color: CustomColor.color_gray,
                                    );
                                  },
                                )
                              : Icon(
                                  Icons.account_circle,
                                  size: 50.0,
                                  color: CustomColor.color_gray,
                                ),
                          //  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          clipBehavior: Clip.hardEdge,
                        ),
                        Container(
                          child: Text(
                            '${_data[index].fullName}',
                            maxLines: 1,
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.bold),
                          ),
                          alignment: Alignment.centerLeft,
                          margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 5.0),
                        ),
                      ],
                    ),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          CustomColor.color_gray),
                      shape: MaterialStateProperty.all<OutlinedBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                      ),
                    ),
                  ),
                  Divider()
                ],
              ),
              margin: EdgeInsets.only(bottom: 10.0, left: 5.0, right: 5.0),
            ),
          ),
          itemCount: _data.length,
        ));
  }
}
