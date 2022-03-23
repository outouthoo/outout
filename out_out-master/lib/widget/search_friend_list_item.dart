import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:out_out/api/api_implementer.dart';
import 'package:out_out/models/add_friend_model.dart';
import 'package:out_out/models/search_friends_list_model.dart' as friendModel;
import 'package:out_out/pages/common/login_page.dart';
import 'package:out_out/providers/common_details_provider.dart';
import 'package:out_out/utils/common_dialog_util.dart';
import 'package:out_out/utils/commona_utils.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchFriendListItem extends StatefulWidget {
  friendModel.Data data;
  String accessToken = '';
  String fromUserId = '';

  SearchFriendListItem({
    @required this.accessToken,
    @required this.fromUserId,
    @required this.data,
  });

  @override
  _SearchFriendListItemState createState() => _SearchFriendListItemState();
}

class _SearchFriendListItemState extends State<SearchFriendListItem> {
  // RxString _reqStatus = ''.obs;
  String _reqStatus = '';
  String toUserId = '';
  SharedPreferences _sharedPreferences;

  @override
  void initState() {
    toUserId = widget.data.userId;
    super.initState();
  }
@override
  void didChangeDependencies() {
  _sharedPreferences =
      Provider.of<CommonDetailsProvider>(context).getPreferencesInstance;
    super.didChangeDependencies();
  }
  void addFriendReqApiCall() {
    CommonDialogUtil.showProgressDialog(context, 'Please wait...');
    ApiImplementer.addFriendsApiImplementer(
      accessToken: widget.accessToken,
      from_user_id: widget.fromUserId,
      to_user_id: toUserId,
      status: CommonUtils.ADD_FRIEND_PENDING_STATUS,
      is_follow: '',
    ).then((value) {
      Navigator.of(context).pop();
      AddFriendModel addFriendModel = value;
      if (value.errorcode == '0') {
        widget.data.status = CommonUtils.ADD_FRIEND_PENDING_STATUS;
        _reqStatus = CommonUtils.ADD_FRIEND_PENDING_STATUS;
        setState(() {});
        CommonDialogUtil.showSuccessSnack(
            context: context, msg: addFriendModel.msg.toString());
      } else if (value.errorcode == "2") {
        print("logout");
        _sharedPreferences.clear();
        Navigator.of(context)
            .pushReplacementNamed(LoginScreen.routeName);
        CommonDialogUtil.showErrorSnack(
            context: context, msg: value.msg);
      } else {
        CommonDialogUtil.showErrorSnack(
            context: context, msg: addFriendModel.msg.toString());
      }
    }).onError((error, stackTrace) {
      Navigator.of(context).pop();
      CommonDialogUtil.showErrorSnack(context: context, msg: error.toString());
    });
  }

  void acceptFriendReqApiCall() {
    CommonDialogUtil.showProgressDialog(context, 'Please wait...');
    ApiImplementer.addFriendsApiImplementer(
      accessToken: widget.accessToken,
      from_user_id: widget.fromUserId,
      to_user_id: toUserId,
      status: CommonUtils.ADD_FRIEND_ACCEPTED_STATUS,
      is_follow: '',
    ).then((value) {
      Navigator.of(context).pop();
      AddFriendModel addFriendModel = value;
      if (value.errorcode == '0') {
        widget.data.status = CommonUtils.ADD_FRIEND_ACCEPTED_STATUS;
        _reqStatus = CommonUtils.ADD_FRIEND_ACCEPTED_STATUS;
        setState(() {});
        CommonDialogUtil.showSuccessSnack(
            context: context, msg: addFriendModel.msg.toString());
      } else if (value.errorcode == "2") {
        print("logout");
        _sharedPreferences.clear();
        Navigator.of(context)
            .pushReplacementNamed(LoginScreen.routeName);
        CommonDialogUtil.showErrorSnack(
            context: context, msg: value.msg);
      } else {
        CommonDialogUtil.showErrorSnack(
            context: context, msg: addFriendModel.msg.toString());
      }
    }).onError((error, stackTrace) {
      Navigator.of(context).pop();
      CommonDialogUtil.showErrorSnack(context: context, msg: error.toString());
    });
  }

  void rejectFriendReqApiCall() {
    CommonDialogUtil.showProgressDialog(context, 'Please wait...');
    ApiImplementer.addFriendsApiImplementer(
      accessToken: widget.accessToken,
      from_user_id: widget.fromUserId,
      to_user_id: toUserId,
      status: CommonUtils.ADD_FRIEND_REJECTED_STATUS,
      is_follow: '',
    ).then((value) {
      Navigator.of(context).pop();
      AddFriendModel addFriendModel = value;
      if (value.errorcode == '0') {
        widget.data.status = CommonUtils.ADD_FRIEND_REJECTED_STATUS;
        _reqStatus = CommonUtils.ADD_FRIEND_REJECTED_STATUS;
        setState(() {});
        CommonDialogUtil.showSuccessSnack(
            context: context, msg: addFriendModel.msg.toString());
      }  else if (value.errorcode == "2") {
        print("logout");
        _sharedPreferences.clear();
        Navigator.of(context)
            .pushReplacementNamed(LoginScreen.routeName);
        CommonDialogUtil.showErrorSnack(
            context: context, msg: value.msg);
      }else {
        CommonDialogUtil.showErrorSnack(
            context: context, msg: addFriendModel.msg.toString());
      }
    }).onError((error, stackTrace) {
      Navigator.of(context).pop();
      CommonDialogUtil.showErrorSnack(context: context, msg: error.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      key: ValueKey(widget.data.userId),
      leading: CircleAvatar(
        radius: 27.0,
        backgroundImage: NetworkImage(widget.data.profileImage),
      ),
      title: Text(widget.data.username),
      subtitle: Wrap(
        children: [
          getDynamicWidget(status: widget.data.status),
        ],
      ),
      // subtitle: Text(data.email),
      // trailing: Wrap(
      //   children: [
      //
      //   ],
      // ),
      // Obx(
      //   () {
      //     _reqStatus = widget.data.status;
      //     setState(() {});
      //     return getDynamicWidget(status: widget.data.status);
      //   },
      // ),
    );
  }

  Widget getDynamicWidget({@required String status}) {
    if (status == null || status.isEmpty) {
      return buildCardForAddFriend();
    } else if (status == CommonUtils.ADD_FRIEND_PENDING_STATUS) {
      return buildCardForAcceptAndRejectReq();
    } else if (status == CommonUtils.ADD_FRIEND_ACCEPTED_STATUS) {
      return buildCardForRejectReq();
    } else if (status == CommonUtils.ADD_FRIEND_REJECTED_STATUS) {
      return Container();
    }
    return Container();
  }

  Widget buildCardForAddFriend() {
    return InkWell(
      onTap: () {
        addFriendReqApiCall();
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        color: Colors.blueGrey,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 8.0),
          child: Text(
            ' Add ',
            style: TextStyle(
              color: Colors.white,
            ),
            textScaleFactor: 1.2,
          ),
        ),
      ),
    );
  }

  Widget buildCardForAcceptAndRejectReq() {
    return Wrap(
      direction: Axis.horizontal,
      children: [
        InkWell(
          onTap: () {
            acceptFriendReqApiCall();
          },
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            color: Colors.green,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 6.0, horizontal: 8.0),
              child: Text(
                ' Accept ',
                style: TextStyle(
                  color: Colors.white,
                ),
                textScaleFactor: 1.2,
              ),
            ),
          ),
        ),
        SizedBox(
          width: 6.0,
        ),
        buildCardForRejectReq(),
      ],
    );
  }

  Widget buildCardForRejectReq() {
    return InkWell(
      onTap: () {
        rejectFriendReqApiCall();
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        color: Colors.red,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 8.0),
          child: Text(
            ' Reject ',
            style: TextStyle(
              color: Colors.white,
            ),
            textScaleFactor: 1.2,
          ),
        ),
      ),
    );
  }
}
