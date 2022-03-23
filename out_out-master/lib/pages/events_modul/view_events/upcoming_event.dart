import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:out_out/api/api_implementer.dart';
import 'package:out_out/providers/common_details_provider.dart';
import 'package:out_out/utils/commona_utils.dart';
import 'package:out_out/utils/custom_colors.dart';
import 'package:out_out/utils/icon_utils.dart';
import 'package:out_out/utils/preferences_constants.dart';
import 'package:out_out/widget/common_app_bar.dart';
import 'package:out_out/models/list_events_model.dart' as eventList;
import 'package:out_out/widget/all_event_list_item.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UpcomingEvents extends StatefulWidget{
  static const String routeName = '/upcoming_event';
  @override
  _UpcomingEventsState createState() => _UpcomingEventsState();
}

class _UpcomingEventsState extends State<UpcomingEvents> {
  SharedPreferences _sharedPreferences;

  bool _isLoading = false;

  String _accessToken = '';

  String _userId = '';

  PagingController<int, eventList.Data> _pagingController =
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
  void onEventJoined() {
    _pagingController = PagingController(firstPageKey: 1);
    listenToPageChange();
    _fetchPage(pageKey: 1, searchFriendLimit: 60, searchQuery: '');
    setState(() {});
  }

  Future<void> _fetchPage({
    @required int pageKey,
    @required int searchFriendLimit,
    @required String searchQuery,
  }) async {
    try {
      List<eventList.Data> newItems =
      await ApiImplementer.upcommingEventListApiImplementer(
        accessToken: _accessToken,
        userid: _userId,
        offset: '0',
        limit: '10',
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
      _userId = _sharedPreferences.getString(PreferenceConstants.USER_ID);
      // _accountType = _sharedPreferences.getString(PreferenceConstants.ACCOUNT_TYPE);
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
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black,
        elevation: 0.0,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title:  Container(height: 70,
            child: Image.asset(out_out_actionbar)),
      ),
      body: Container(
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    0.0,
                  ),
                ),
                gradient: LinearGradient(
                  colors: [
                    CustomColor.colorAccent,
                    CustomColor.colorPrimaryDark,
                  ],
                ),
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12.0,
                    vertical: 12.0,
                  ),
                  child: Text('Upcoming Events',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14,color: Colors.white),),
                ),
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () {
                  _pagingController = PagingController(firstPageKey: 1);
                  listenToPageChange();
                  Future<void> futureResult =
                  _fetchPage(pageKey: 1, searchFriendLimit: 60, searchQuery: '');
                  setState(() {});
                  return futureResult;
                },
                child: PagedListView<int, eventList.Data>(
                  // separatorBuilder: (context, _) => Divider(
                  //   height: 8.0,
                  // ),
                  pagingController: _pagingController,
                  builderDelegate: PagedChildBuilderDelegate<eventList.Data>(
                    itemBuilder: (context, item, index) => AllEventListItem(
                      data: item,
                      onEventJoined: onEventJoined,
                      accessToken: _accessToken,
                      userId: _userId,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      )
    );
  }
}