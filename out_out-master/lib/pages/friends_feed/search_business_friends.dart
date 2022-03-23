import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:out_out/api/api_implementer.dart';
import 'package:out_out/models/search_friends_list_model.dart' as friendModel;
import 'package:out_out/providers/common_details_provider.dart';
import 'package:out_out/utils/common_dialog_util.dart';
import 'package:out_out/utils/custom_colors.dart';
import 'package:out_out/utils/preferences_constants.dart';
import 'package:out_out/widget/common_app_bar.dart';
import 'package:out_out/widget/dynamic_app_bar_for_searching.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:out_out/widget/search_business_friends_list_item.dart';

class SearchBusinessFriends extends StatefulWidget {
  @override
  _SearchBusinessFriendsState createState() => _SearchBusinessFriendsState();
}

class _SearchBusinessFriendsState extends State<SearchBusinessFriends> {
  SharedPreferences _sharedPreferences;
  bool _isLoading = false;
  String _accessToken = '';
  String _fromUserId = '';

  // String _accountType = '';

  PagingController<int, friendModel.Data> _pagingController =
      PagingController(firstPageKey: 1);

  @override
  void initState() {
    listenToPageChange();
    super.initState();
  }

  void listenToPageChange() {
    _pagingController.addPageRequestListener(
      (pageKey) {
        _fetchPage(pageKey: pageKey, searchFriendLimit: 60, searchQuery: '');
      },
    );
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  Future<void> _fetchPage({
    @required int pageKey,
    @required int searchFriendLimit,
    @required String searchQuery,
  }) async {
    try {
      List<friendModel.Data> newItems =
          await ApiImplementer.searchFriendsListApiImplementer(
        accessToken: _accessToken,
        account_type: '1',
        offset: pageKey,
        limit: searchFriendLimit,
        search_query: searchQuery,
        is_vip: '',
      );
print(newItems.map((e) => e.userId.toString()));
      if (newItems == null || newItems.length <= 0) {
        newItems = [];
      }
      final isLastPage = newItems.length < searchFriendLimit;
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
      _fromUserId = _sharedPreferences.getString(PreferenceConstants.USER_ID);
      // _accountType = _sharedPreferences.getString(PreferenceConstants.ACCOUNT_TYPE);

      // print('ACCOUNT TYPE:::::::::- ${_accountType}');

    }
    _isLoading = true;
    super.didChangeDependencies();
  }

  void onClear() {
    _pagingController = PagingController(firstPageKey: 1);
    listenToPageChange();
    Future<void> futureResult = _fetchPage(
      pageKey: 1,
      searchFriendLimit: 500,
      searchQuery: '',
    );
    setState(() {});
  }

  void onTextSearching(String searchText) {
    if (searchText.length > 2) {
      _pagingController = PagingController(firstPageKey: 1);
      listenToPageChange();
      Future<void> futureResult = _fetchPage(
        pageKey: 1,
        searchFriendLimit: 500,
        searchQuery: searchText,
      );
      setState(() {});
    } else {
      if (searchText != null && searchText.isNotEmpty) {
        _pagingController = PagingController(firstPageKey: 1);
        listenToPageChange();
        Future<void> futureResult = _fetchPage(
          pageKey: 1,
          searchFriendLimit: 500,
          searchQuery: '',
        );
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56.0),
        child: DynamicAppbarForSearching(
          onClear: onClear,
          onTextSearching: onTextSearching,
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () {
          _pagingController = PagingController(firstPageKey: 1);
          listenToPageChange();
          Future<void> futureResult =
              _fetchPage(pageKey: 1, searchFriendLimit: 60, searchQuery: '');
          setState(() {});
          return futureResult;
        },
        child: PagedListView<int, friendModel.Data>.separated(
          separatorBuilder: (context, _) => Divider(
            height: 8.0,
          ),
          pagingController: _pagingController,
          builderDelegate: PagedChildBuilderDelegate<friendModel.Data>(
            itemBuilder: (context, item, index) => SearchBusinessFriendsListItem(
              accessToken: _accessToken,
              fromUserId: _fromUserId,
              data: item,
            ),
          ),
        ),
      ),
    );
  }
}
