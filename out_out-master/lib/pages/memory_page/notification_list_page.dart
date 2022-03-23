import 'package:flutter/material.dart';
import 'package:out_out/pages/memory_page/notification_list.dart';
import 'package:out_out/utils/commona_utils.dart';
import 'package:out_out/utils/custom_colors.dart';
import 'package:out_out/utils/icon_utils.dart';

class NotificationListPage extends StatefulWidget {
  const NotificationListPage({Key key}) : super(key: key);

  @override
  _NotificationListPageState createState() => _NotificationListPageState();
}

class _NotificationListPageState extends State<NotificationListPage>
    with TickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    // TODO: implement initState
    _tabController = TabController(vsync: this, initialIndex: 0, length: 4);
    super.initState();
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
        title: Container(height: 70, child: Image.asset(out_out_actionbar)),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TabBar(
            controller: _tabController,
            indicatorWeight: 0.0,
            indicatorColor: Colors.transparent,
            isScrollable: false,
            unselectedLabelColor: Colors.grey,
            indicator: ShapeDecoration(
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
            tabs: [
              Container(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: Text(
                    'Feed',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ),
              Container(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: Text(
                    'Broadcast',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ),
              Container(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: Text(
                    'Your Events',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ),
              Container(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: Text(
                    'Events',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                NotificationPage(type: CommonUtils.NOTIFICATION_TYPE_FEED),
                NotificationPage(type: CommonUtils.NOTIFICATION_TYPE_BROADCAST),
                NotificationPage(type: CommonUtils.NOTIFICATION_TYPE_STORY),
                NotificationPage(type: CommonUtils.NOTIFICATION_TYPE_PLACES),
                // VipFriends(),
                // BusinessFriends(),
                // NormalFriends(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
