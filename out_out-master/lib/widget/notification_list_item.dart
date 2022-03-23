import 'package:flutter/material.dart';
import 'package:out_out/utils/custom_colors.dart';
import 'package:out_out/models/list_notification_model.dart'
as notificationModel;

class NotificationListItem extends StatelessWidget {

  notificationModel.Data data;

  NotificationListItem({@required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        trailing: Container(
          width: 48,
          height: 48,
          //BoxDecoration Widget
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(
                  '${data.mediaUrl}'),
              fit: BoxFit.cover,
            ), //DecorationImage
            border: Border.all(
              width: 3,
              color: CustomColor.colorPrimaryDark,
            ), //Border.all
            borderRadius: BorderRadius.circular(15),
          ), //BoxDecoration
        ),
        leading: Container(
          width: 48,
          height: 48,
          //BoxDecoration Widget
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(
                  '${data.mediaThumbnail}'),
              fit: BoxFit.cover,
            ), //DecorationImage
            border: Border.all(
              width: 3,
              color: CustomColor.colorPrimaryDark,
            ), //Border.all
            borderRadius: BorderRadius.circular(15),
          ), //BoxDecoration
        ),
        title: Text('${data.fullName}'),
        subtitle: Row(
          children: [
            Icon(
              Icons.location_on,
              color: CustomColor.colorPrimary,
            ),
            Text('${data.city}'),
          ],
        ),
      ),
    );
  }

}