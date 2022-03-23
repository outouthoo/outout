import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:out_out/api/api_implementer.dart';
import 'package:out_out/models/list_notification_model.dart'
    as notificationModel;
import 'package:out_out/models/vip_frnds.dart' as vip;
import 'package:out_out/pages/common/login_page.dart';
import 'package:out_out/pages/friends_feed/search_vip_friends.dart';
import 'package:out_out/providers/common_details_provider.dart';
import 'package:out_out/utils/common_dialog_util.dart';
import 'package:out_out/utils/commona_utils.dart';
import 'package:out_out/utils/custom_colors.dart';
import 'package:out_out/utils/preferences_constants.dart';
import 'package:out_out/widget/item_notification_list.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VipFriends extends StatefulWidget {
  @override
  _VipFriendsState createState() => _VipFriendsState();
}

class _VipFriendsState extends State<VipFriends> {
  SharedPreferences _sharedPreferences;

  bool _isLoading = false;
  String _accessToken = '';
  String _userId = '';
  PagingController<int, vip.Data> _pagingController =
      PagingController(firstPageKey: 1);

  @override
  void initState() {
    user = Provider.of<CommonDetailsProvider>(context, listen: false).user;
    print(_accessToken);

    listenToPageChange();
    super.initState();
  }

  void listenToPageChange() {
    _pagingController.addPageRequestListener(
      (pageKey) {
        // print('CALLED------------ ${pageKey}');
        _fetchPage(pageKey);
      },
    );
  }

  User user;

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  Future _fetchPage(int pageKey) async {
    List<vip.Data> newItems = new List();
    user = Provider.of<CommonDetailsProvider>(context, listen: false).user;
    print(_accessToken);
    await ApiImplementer.ListVIPAccountsApiImplementer(
      accessToken: user.accessToken,
      user_id: user.userId,
    ).then((value) {
      if (value.errorcode == '2') {
        print("logout");
        _sharedPreferences.clear();
        Navigator.of(context)
            .pushReplacementNamed(LoginScreen.routeName);
        CommonDialogUtil.showErrorSnack(
            context: context, msg: value.msg);
      }
      else {
        setState(() {
          newItems.addAll(value.data);
        });
      }
    });
    try {
      if (newItems == null || newItems.length <= 0) {
        newItems = [];
      }
      final isLastPage = newItems.length < CommonUtils.NOTIFICATION_COUNT;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        // final nextPageKey = pageKey + newItems.length;
        final nextPageKey = pageKey + 1;
        _pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  void didChangeDependencies() {
    if (!_isLoading) {
      _sharedPreferences =
          Provider.of<CommonDetailsProvider>(context).getPreferencesInstance;
      _accessToken =
          _sharedPreferences.getString(PreferenceConstants.ACCESS_TOKEN);
      _userId = _sharedPreferences.getString(PreferenceConstants.USER_ID);
    }
    _isLoading = true;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 12.0),
      color: CustomColor.colorCanvas,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => SearchVipFriends(),
                ),
              );
            },
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 18.0),
              padding: EdgeInsets.symmetric(
                vertical: 12.0,
                horizontal: 16.0,
              ),
              decoration: BoxDecoration(
                border: Border.all(width: 0.8, color: Colors.grey),
                borderRadius: BorderRadius.circular(30.0),
                color: Colors.white,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Search VIP friends...',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.search,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              child: PagedListView<int, vip.Data>(
                pagingController: _pagingController,
                builderDelegate: PagedChildBuilderDelegate<vip.Data>(
                  itemBuilder: (context, item, index) => VIPListItem(
                    data: item,
                  ),
                ),
              ),
              onRefresh: () {
                _pagingController = PagingController(firstPageKey: 1);
                listenToPageChange();
                Future<void> futureResult = _fetchPage(1);
                setState(() {});
                return futureResult;
              },
            ),
          ),
        ],
      ),
    );
  }
}
