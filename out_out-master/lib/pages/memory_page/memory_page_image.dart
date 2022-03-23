import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:out_out/api/api_implementer.dart';
import 'package:out_out/models/list_media_model.dart' as media;
import 'package:out_out/pages/story_page/image_story_page.dart';
import 'package:out_out/providers/common_details_provider.dart';
import 'package:out_out/utils/commona_utils.dart';
import 'package:out_out/utils/custom_colors.dart';
import 'package:out_out/utils/icon_utils.dart';
import 'package:out_out/utils/preferences_constants.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MemoryPageImage extends StatefulWidget {
  @override
  _MemoryPageImageState createState() => _MemoryPageImageState();
}

class _MemoryPageImageState extends State<MemoryPageImage> {
  SharedPreferences _sharedPreferences;
  bool _isLoading = false;
  String _accessToken = '';
  String _userId = '';
  int _mediaType = CommonUtils.MEDIA_TYPE_IMAGE;
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
         print('isLastPage true');
         _pagingController.appendLastPage(newItems);
       } else {
         print('isLastPage false');
         // final nextPageKey = pageKey + newItems.length;
         final nextPageKey = pageKey + 1;
         _pagingController.appendPage(newItems, nextPageKey);
     }
    } catch (error) {
      print('_pagingController.error');
      print(error);
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
          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                CustomColor.colorAccent.withOpacity(0.4),
                CustomColor.colorPrimaryDark.withOpacity(0.4),
              ],
            ),
          ),
          child: RefreshIndicator(
            child: PagedGridView<int, media.Mediadata>(
              pagingController: _pagingController,
              showNewPageErrorIndicatorAsGridChild: true,
              showNoMoreItemsIndicatorAsGridChild: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 5.0,
                crossAxisSpacing: 5.0,
                childAspectRatio: 5 / 6,
              ),
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
    print('data');
    print(data);
    return Hero(
      tag: data.id,
      child: Card(
        elevation: 12,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15.0),
          child: InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) =>
                    ImageStoryPage(media: data, canIncreaseViewCount: false),
              ));
            },
            child: CachedNetworkImage(
              fit: BoxFit.fill,
              errorWidget: (context, _, te) => Image.asset(out_out_actionbar),
              placeholder: (context, _) => Image.asset(splash_logo),
              imageUrl: '${data.mediaUrl}',
              fadeInCurve: Curves.easeInOut,
            ),
          ),
        ),
      ),
    );
  }
}
