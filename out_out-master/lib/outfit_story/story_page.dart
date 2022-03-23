import 'package:flutter/material.dart';
import 'package:out_out/api/api_implementer.dart';
import 'package:out_out/chat/widget/loading.dart';
import 'package:out_out/pages/common/login_page.dart';
import 'package:out_out/providers/common_details_provider.dart';
import 'package:out_out/utils/common_dialog_util.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:story_view/story_view.dart';

class StoryViewPage extends StatefulWidget {
  final String title;
  final String image;
  final String userId;

  const StoryViewPage({Key key, this.title, this.image, this.userId})
      : super(key: key);

  @override
  _StoryViewPageState createState() => _StoryViewPageState();
}

class _StoryViewPageState extends State<StoryViewPage> {
  final storyController = StoryController();
  User _user;
  List<StoryItem> _storyItemList;
  SharedPreferences _sharedPreferences;

  @override
  void initState() {
    super.initState();

    _storyItemList = [];
    getStoryList();
  }

  @override
  void dispose() {
    storyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(widget.title),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: _storyItemList.length > 0
          ? StoryView(
              storyItems: _storyItemList,
              onStoryShow: (s) {
                print("Showing a story");
              },
              onComplete: () {
                Navigator.pop(context);
              },
              progressPosition: ProgressPosition.top,
              repeat: false,
              controller: storyController,
            )
          : Loading(),
    );
  }

  void getStoryList() {
    List<StoryItem> list = [];
    _user = Provider.of<CommonDetailsProvider>(context, listen: false).user;
    ApiImplementer.storyList(
            accessToken: _user.accessToken, userid: widget.userId)
        .then((value) {
      if (value.errorcode == ApiImplementer.SUCCESS) {
        value.data.forEach((element) {
          list.add(StoryItem.pageImage(
              url: element.story,
              caption: element.caption,
              controller: storyController));
        });
        setState(() {
          _storyItemList = list;
        });
      }else if (value.errorcode == "2") {
        _sharedPreferences =
            Provider.of<CommonDetailsProvider>(context).getPreferencesInstance;
        print("logout done");
        _sharedPreferences.clear();
        Navigator.of(context)
            .pushReplacementNamed(LoginScreen.routeName);
        CommonDialogUtil.showErrorSnack(
            context: context, msg: value.msg);
      }
    });
  }
}
