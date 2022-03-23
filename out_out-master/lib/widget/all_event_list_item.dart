import 'package:flutter/material.dart';
import 'package:out_out/api/api_implementer.dart';
import 'package:out_out/models/join_event_model.dart';
import 'package:out_out/models/list_events_model.dart' as eventList;
import 'package:out_out/pages/common/login_page.dart';
import 'package:out_out/providers/common_details_provider.dart';
import 'package:out_out/utils/common_dialog_util.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AllEventListItem extends StatelessWidget {
  eventList.Data data;
  Function onEventJoined;
  String accessToken;
  String userId;
  SharedPreferences _sharedPreferences;

  AllEventListItem({
    @required this.data,
    @required this.onEventJoined,
    @required this.accessToken,
    @required this.userId,
  });

  void joinEventById(BuildContext context, String eventId) {
    CommonDialogUtil.showProgressDialog(context, 'Please wait..');
    // Navigator.of(context).push(MaterialPageRoute(
    //   builder: (context) => Packages(),
    // )).then((value) =>

    _sharedPreferences =
        Provider.of<CommonDetailsProvider>(context).getPreferencesInstance;
    ApiImplementer.joinEventApiImplementer(
            accessToken: accessToken, userid: userId, eventid: eventId)
        .then((value) {
      if (value.errorcode == "2") {
        print("logout");
        _sharedPreferences.clear();
        Navigator.of(context)
            .pushReplacementNamed(LoginScreen.routeName);
        CommonDialogUtil.showErrorSnack(
            context: context, msg: value.msg);
      } else {
        Navigator.of(context).pop();
        JoinEventModel joinEventModel = value;
        if (joinEventModel.errorcode == '0') {
          //CommonDialogUtil.showSuccessSnack(context: context, msg: value.msg);
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Event Joined Success"),
                content: Text(value.msg),
                actions: [
                  TextButton(
                    child: Text("OK"),
                    onPressed: () {
                      Navigator.pop(context);
                      onEventJoined();
                    },
                  )
                ],
              );
            },
          );
        } else {
          CommonDialogUtil.showErrorSnack(context: context, msg: value.msg);
        }
      }
    }).onError((error, stackTrace) {
      Navigator.of(context).pop();
      CommonDialogUtil.showErrorSnack(context: context, msg: error.toString());
    });
    // );
  }

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Card(
        margin: EdgeInsets.only(left: 12.0, right: 12.0, top: 12.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Container(
          padding: EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  buildSinglePart(
                      labelName: 'Event Name',
                      labelValue: '${data.eventName ?? '-'}'),
                  buildSinglePart(
                      labelName: 'Event Date',
                      labelValue: '${data.eventDate ?? '-'}'),
                ],
              ),
              SizedBox(
                height: 6.0,
              ),
              Row(
                children: [
                  buildSinglePart(
                      labelName: 'Event Place',
                      labelValue: '${data.eventCity ?? '-'}'),
                  buildSinglePart(
                      labelName: 'Price', labelValue: '\$${data.price ?? '-'}'),
                ],
              ),
              SizedBox(
                height: 8.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 152.0,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        joinEventById(context, data.id);
                      },
                      icon: Icon(
                        Icons.event,
                        color: Colors.white,
                      ),
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                            if (states.contains(MaterialState.pressed))
                              return Colors.red.withOpacity(0.5);
                            return null; // Use the component's default.
                          },
                        ),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                      ),
                      label: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 8.0),
                        child: Text('Join Event'),
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSinglePart(
      {@required String labelName, @required String labelValue}) {
    return Expanded(
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$labelName',
              style: TextStyle(
                fontSize: 13.0,
              ),
            ),
            Text(
              '$labelValue',
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
