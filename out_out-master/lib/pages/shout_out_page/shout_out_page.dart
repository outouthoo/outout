import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:out_out/api/api_implementer.dart';
import 'package:out_out/pages/events_modul/create_event/create_event_screen.dart';
import 'package:out_out/pages/events_modul/view_events/view_events_page.dart';
import 'package:out_out/providers/common_details_provider.dart';
import 'package:out_out/utils/custom_colors.dart';
import 'package:out_out/utils/icon_utils.dart';
import 'package:out_out/utils/preferences_constants.dart';
import 'package:out_out/widget/dynamic_app_bar_for_searching.dart';
import 'package:out_out/widget/shoutout_list_item.dart';
import 'package:out_out/models/list_shoutout_model.dart' as shoutout;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShoutOutPage extends StatefulWidget {
  static const routeName = '/shout-out-page';

  @override
  _ShoutOutPageState createState() => _ShoutOutPageState();
}

class _ShoutOutPageState extends State<ShoutOutPage> {
  SharedPreferences _sharedPreferences;
  bool _isLoading = false;
  String _accessToken = '';
  String _fromUserId = '';

  // String _accountType = '';

  PagingController<int, shoutout.Data> _pagingController =
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
      List<shoutout.Data> newItems =
          await ApiImplementer.shoutoutListApiImplementer(
        accessToken: _accessToken,
        search_query: searchQuery,
        offset: pageKey,
        limit: searchFriendLimit,
      );
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
      body: Container(
        color: Colors.grey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(children: [
              Expanded(
                child: InkWell(
                  onTap: () {
                    Navigator.of(context)
                        .pushNamed(CreateEventScreen.routeName)
                        .then(
                      (value) {
                        if (value != null && value) {}
                      },
                    );
                  },
                  child: Container(
                    alignment: Alignment.center,
                    padding:
                        EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                    color: CustomColor.colorCanvas,
                    child: Text(
                      'Create Event',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                        color: CustomColor.colorAccent,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: () {
                    Navigator.of(context)
                        .pushNamed(ViewEventsPage.routeName)
                        .then(
                          (value) {
                        if (value != null && value) {}
                      },
                    );
                  },
                  child: Container(
                    alignment: Alignment.center,
                    padding:
                        EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                    color: CustomColor.colorCanvas,
                    child: Text(
                      'View Events',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                        color: CustomColor.colorAccent,
                      ),
                    ),
                  ),
                ),
              ),
            ]),
            Expanded(
              child: Container(
                padding: EdgeInsets.only(
                  top: 16.0,
                  left: 16.0,
                  right: 16.0,
                ),
                child: RefreshIndicator(
                  onRefresh: () {
                    _pagingController = PagingController(firstPageKey: 1);
                    listenToPageChange();
                    Future<void> futureResult = _fetchPage(
                        pageKey: 1, searchFriendLimit: 60, searchQuery: '');
                    setState(() {});
                    return futureResult;
                  },
                  child: PagedGridView<int, shoutout.Data>(
                    pagingController: _pagingController,
                    showNewPageErrorIndicatorAsGridChild: true,
                    showNoMoreItemsIndicatorAsGridChild: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16.0,
                      mainAxisSpacing: 16.0,
                      childAspectRatio: 4 / 5,
                    ),
                    builderDelegate: PagedChildBuilderDelegate<shoutout.Data>(
                      itemBuilder: (context, item, index) => ShoutoutListItem(
                        data: item,
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
