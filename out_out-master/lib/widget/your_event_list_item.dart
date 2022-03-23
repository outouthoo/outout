import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:out_out/api/api_implementer.dart';
import 'package:out_out/models/delete_event_model.dart';
import 'package:out_out/models/list_events_model.dart' as eventList;
import 'package:out_out/pages/common/login_page.dart';
import 'package:out_out/pages/events_modul/updateevent/update_event_screen.dart';
import 'package:out_out/providers/common_details_provider.dart';
import 'package:out_out/utils/common_dialog_util.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class YourEventListItem extends StatelessWidget {
  eventList.Data data;
  Function onEventDeleted;
  Function onEventEdited;
  String accessToken;
  String userId;
  SharedPreferences _sharedPreferences;

  YourEventListItem({
    @required this.data,
    @required this.onEventDeleted,
    @required this.onEventEdited,
    @required this.accessToken,
    @required this.userId,
  });


  void deleteEvent(BuildContext context, String eventId) {
    CommonDialogUtil.showProgressDialog(context, 'Please wait..');
    ApiImplementer.deleteEventApiImplementer(
      accessToken: accessToken,
      userid: userId,
      eventid: eventId,
    ).then((value) {
      Navigator.of(context).pop();
      DeleteEventModel deleteEventModel = value;
      if(deleteEventModel.errorcode == '0'){
        CommonDialogUtil.showSuccessSnack(context: context, msg: value.msg);
        onEventDeleted();
      }else if (value.errorcode == "2") {
        _sharedPreferences =
            Provider.of<CommonDetailsProvider>(context).getPreferencesInstance;
        print("logout done");
        _sharedPreferences.clear();
        Navigator.of(context)
            .pushReplacementNamed(LoginScreen.routeName);
        CommonDialogUtil.showErrorSnack(
            context: context, msg: value.msg);
      } else{
        CommonDialogUtil.showErrorSnack(context: context, msg: value.msg);
      }
    }).onError((error, stackTrace){
      Navigator.of(context).pop();
      CommonDialogUtil.showErrorSnack(context: context, msg: error.toString());
    });
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
                      labelValue: '${data.eventCity?? '-'}'),
                  buildSinglePart(
                      labelName: 'Price', labelValue: '\$${data.price ?? '-'}'),
                ],
              ),
              SizedBox(
                height: 8.0,
              ),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UpdateEventScreen(data:

                                data
                            ),
                          ),
                        );
                      },
                      icon: Icon(
                        Icons.edit,
                        color: Colors.white,
                      ),
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                            if (states.contains(MaterialState.pressed))
                              return Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withOpacity(0.5);
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
                            horizontal: 4.0, vertical: 6.0),
                        child: Text('Edit'),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 22.0,
                  ),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        deleteEvent(context, data.id);
                      },
                      icon: Icon(
                        Icons.delete,
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
                        child: Text('Delete'),
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
