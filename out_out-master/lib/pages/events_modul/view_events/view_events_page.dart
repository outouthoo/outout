import 'package:flutter/material.dart';
import 'package:out_out/pages/events_modul/view_events/all_events.dart';
import 'package:out_out/pages/events_modul/view_events/your_events.dart';
import 'package:out_out/utils/custom_colors.dart';
import 'package:out_out/utils/icon_utils.dart';

class ViewEventsPage extends StatefulWidget {
  static const String routeName = '/view-events-page';

  @override
  _ViewEventsPageState createState() => _ViewEventsPageState();
}

class _ViewEventsPageState extends State<ViewEventsPage> {
  @override
  Widget build(BuildContext context) {
    TargetPlatform platform = Theme.of(context).platform;
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
      body: Column(
        children: [
          Expanded(
            child: DefaultTabController(
              length: 2,
              initialIndex: 0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TabBar(
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
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12.0,
                            vertical: 12.0,
                          ),
                          child: Text('Your Events'),
                        ),
                      ),
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12.0,
                            vertical: 12.0,
                          ),
                          child: Text('All Events'),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        YourEvents(),
                        AllEvents(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
