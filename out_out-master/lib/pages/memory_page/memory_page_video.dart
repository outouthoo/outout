import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:out_out/api/api_implementer.dart';
import 'package:out_out/models/list_media_model.dart' as media;
import 'package:out_out/pages/story_page/video_story_page.dart';
import 'package:out_out/providers/common_details_provider.dart';
import 'package:out_out/utils/commona_utils.dart';
import 'package:out_out/utils/custom_colors.dart';
import 'package:out_out/utils/icon_utils.dart';
import 'package:out_out/utils/preferences_constants.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MemoryPageVideo extends StatefulWidget {
  @override
  _MemoryPageVideoState createState() => _MemoryPageVideoState();
}

class _MemoryPageVideoState extends State<MemoryPageVideo> {
  SharedPreferences _sharedPreferences;

  bool _isLoading = false;
  String _accessToken = '';
  String _userId = '';
  int _mediaType = CommonUtils.MEDIA_TYPE_VIDEO;

  PagingController<int, media.Mediadata> _pagingController =
      PagingController(firstPageKey: 1);
  // int _pageNo = 1;

  @override
  void initState() {
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

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      List<media.Mediadata> newItems =
          await ApiImplementer.getListOfMediaApiImplementer(
        accessToken: _accessToken,
        user_id: _userId,
        media_type: _mediaType,
        offset: pageKey,
        limit: CommonUtils.PAGE_LIMIT,
      );
      if (newItems == null || newItems.length <= 0) {
        newItems = [];
      }
      final isLastPage = newItems.length < CommonUtils.PAGE_LIMIT;
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
          child: RefreshIndicator(
            child: PagedListView<int, media.Mediadata>(
              pagingController: _pagingController,
              builderDelegate: PagedChildBuilderDelegate<media.Mediadata>(
                itemBuilder: (context, item, index) => buildPictureItem(
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
        );
      },
    );
  }

  Widget buildPictureItem({@required media.Mediadata data}) {
    return Card(
      elevation: 4.0,
      margin: EdgeInsets.all(12.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        //to expand to device width
        children: [
          ListTile(
            contentPadding:
                EdgeInsets.only(left: 8.0, right: 0.0, bottom: 0.0, top: 0.0),
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(30.0),
              child: CachedNetworkImage(
                fit: BoxFit.cover,
                height: 48.0,
                width: 48.0,
                errorWidget: (context, _, te) => Image.asset(out_out_actionbar),
                placeholder: (context, _) => Image.asset(splash_logo),
                imageUrl: data.profileImage,
                fadeInCurve: Curves.easeInOut,
              ),
            ),
            title: Text(data.username??""),
            subtitle: Text(""),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 8.0,
              bottom: 6.0,
            ),
            child: Text(data.caption),
          ),
          InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => VideoStoryPage(
                    canIncreaseViewCount: false,
                    data: data,
                  ),
                ),
              );
            },
            child: Stack(
              fit: StackFit.passthrough,
              children: [
                CachedNetworkImage(
                  fit: BoxFit.cover,
                  height: 180.0,
                  errorWidget: (context, _, te) => Image.asset(splash_logo),
                  placeholder: (context, _) => Image.asset(splash_logo),
                  imageUrl: data.mediaThumbnail,
                  fadeInCurve: Curves.easeInOut,
                ),
                Positioned(
                  bottom: 0.0,
                  right: 0.0,
                  left: 0.0,
                  top: 0.0,
                  child: Icon(
                    Icons.play_arrow,
                    color: Colors.white,
                    size: 50,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Icon(
                  Icons.thumb_up_alt_outlined,
                  color: Colors.grey.withOpacity(0.9),
                  size: 20.0,
                ),
                SizedBox(
                  width: 3.0,
                ),
                Text(
                  (data.likes == null ? '0' : '${data.likes}'),
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                // Text(data.likes.toString()),
                SizedBox(
                  width: 8.0,
                ),
                // Text('${data.views} views'),
                Text(
                  (data.views == null ? '0 views' : '${data.views} views'),
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
