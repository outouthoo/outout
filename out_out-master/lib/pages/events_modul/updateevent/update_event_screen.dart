import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:out_out/pages/events_modul/create_event/create_private_event.dart';
import 'package:out_out/pages/events_modul/create_event/create_public_event.dart';
import 'package:out_out/utils/custom_colors.dart';
import 'package:out_out/widget/common_app_bar.dart';
import 'package:out_out/models/list_events_model.dart' as eventList;

import 'update_private_event.dart';
import 'update_public_event.dart';
class UpdateEventScreen extends StatefulWidget {
  static const routeName = '/update-event-screen';
  eventList.Data data;
  UpdateEventScreen({Key key,  this.data,}) : super(key: key);
  @override
  _UpdateEventScreenState createState() => _UpdateEventScreenState();
}

class _UpdateEventScreenState extends State<UpdateEventScreen> {
  @override
  Widget build(BuildContext context) {
    print(widget.data.eventType);
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
              'Update Event',
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
              initialIndex: widget.data.eventType=='1'?0:1,
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
                        UpdatePublicEventPage(data:widget.data),
                        UpdatePrivateEventPage(data:widget.data ,),
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
