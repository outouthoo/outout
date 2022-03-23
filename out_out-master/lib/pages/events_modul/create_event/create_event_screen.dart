import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:out_out/pages/events_modul/create_event/create_private_event.dart';
import 'package:out_out/pages/events_modul/create_event/create_public_event.dart';
import 'package:out_out/utils/custom_colors.dart';
import 'package:out_out/widget/common_app_bar.dart';

class CreateEventScreen extends StatefulWidget {
  static const routeName = '/create-event-screen';

  @override
  _CreateEventScreenState createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56.0),
        child: CommonAppBar(),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            color: Colors.grey,
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(vertical: 22.0),
            child: Text(
              'Create Event',
              style: TextStyle(
                color: CustomColor.colorAccent,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
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
                    unselectedLabelColor: Colors.black,
                    labelColor: Colors.white,
                    labelStyle: TextStyle(fontSize: 18),
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
                              horizontal: 12.0, vertical: 16.0),
                          child: Text(
                            " Public Event ",
                          ),
                        ),
                      ),
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12.0, vertical: 16.0),
                          child: Text(
                            " Private Event ",
                          ),
                        ),
                      )
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        CreatePublicEventPage(),
                        CreatePrivateEventPage(),
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
