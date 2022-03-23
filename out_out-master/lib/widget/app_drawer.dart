import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:out_out/providers/common_details_provider.dart';
import 'package:out_out/utils/custom_colors.dart';
import 'package:out_out/utils/icon_utils.dart';
import 'package:out_out/utils/preferences_constants.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppDrawer extends StatefulWidget {
  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  SharedPreferences _sharedPreferences;
  bool _isLoading = false;
  RxString _profileUrl = ''.obs;
  RxString _userName = ''.obs;
  RxString _city = ''.obs;
  RxString _birthDate = ''.obs;
  RxString _userEmail = ''.obs;

  @override
  void didChangeDependencies() {
    if (!_isLoading) {
      _sharedPreferences =
          Provider.of<CommonDetailsProvider>(context).getPreferencesInstance;
      _profileUrl.value =
          _sharedPreferences.get(PreferenceConstants.PROFILE_IMAGE);
      _userEmail.value = _sharedPreferences.get(PreferenceConstants.EMAIL_ID);
      _userName.value =
          '${_sharedPreferences.get(PreferenceConstants.FIRST_NAME)} ${_sharedPreferences.get(PreferenceConstants.LAST_NAME)}';
      _city.value = _sharedPreferences.get(PreferenceConstants.CITY);
      _birthDate.value = _sharedPreferences.get(PreferenceConstants.DOB);
      setState(() {});
    }
    _isLoading = true;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(_userName.value),
            accountEmail: Text(_userEmail.value),
            currentAccountPicture: CircleAvatar(
              radius: 30.0,
              backgroundColor: CustomColor.colorAccent,
              backgroundImage: NetworkImage(
                _profileUrl.value,
              ),
            ),
            otherAccountsPictures: [
              InkWell(
                onTap: () {},
                child: CircleAvatar(
                  backgroundColor: CustomColor.colorAccent,
                  radius: 16.0,
                  child: Icon(
                    Icons.edit,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          ListTile(
            onTap: () {},
            contentPadding:
                EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            leading: Icon(FontAwesomeIcons.userFriends,color: CustomColor.colorPrimary,),
            title: Text(
              'Friend Feed',
              style: TextStyle(fontSize: 16.0),
            ),
          ),
          Divider(
            height: 0.0,
            color: Colors.grey,
          ),
          ListTile(
            onTap: () {},
            contentPadding:
            EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            leading: Icon(FontAwesomeIcons.businessTime,color: CustomColor.colorPrimary,),
            title: Text(
              'Shout Out Page',
              style: TextStyle(fontSize: 16.0),
            ),
          ),
          Divider(
            height: 0.0,
            color: Colors.grey,
          ),
          ListTile(
            onTap: () {},
            contentPadding:
            EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            leading: Icon(FontAwesomeIcons.solidBell,color: CustomColor.colorPrimary,),
            title: Text(
              'Notifications',
              style: TextStyle(fontSize: 16.0),
            ),
            trailing: Chip(label: Text('10+'),),
          ),
          Divider(
            height: 0.0,
            color: Colors.grey,
          ),
          ListTile(
            onTap: () {},
            contentPadding:
            EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            leading: Icon(Icons.chat,color: CustomColor.colorPrimary,),
            title: Text(
              'Chat',
              style: TextStyle(fontSize: 16.0),
            ),
          ),
          Divider(
            height: 0.0,
            color: Colors.grey,
          ),
          ListTile(
            onTap: () {},
            contentPadding:
            EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            leading: Icon(Icons.settings,color: CustomColor.colorPrimary,),
            title: Text(
              'Settings',
              style: TextStyle(fontSize: 16.0),
            ),
          ),
          Divider(
            height: 0.0,
            color: Colors.grey,
          ),
        ],
      ),
    );
  }
}
