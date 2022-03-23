import 'package:flutter/material.dart';
import 'package:out_out/models/vip_frnds.dart' as vip;
import 'package:out_out/models/vip_frnds.dart';
import 'package:out_out/utils/custom_colors.dart';
import 'package:out_out/models/list_notification_model.dart'

as notificationModel;
import 'package:out_out/models/business_frnds.dart' as bsfrnd;
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
class VIPListItem extends StatelessWidget {

  vip.Data data;

  VIPListItem({@required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
      //  key: ValueKey(data.userId),
        leading: CircleAvatar(
          radius: 27.0,
          backgroundImage: NetworkImage(data.profileImage),
        ),
        title: Text(data.username),
        subtitle: Wrap(
          children: [
          //  getDynamicWidget(status: widget.data.status),
          ],
        ),
        // subtitle: Text(data.email),
        // trailing: Wrap(
        //   children: [
        //
        //   ],
        // ),
        // Obx(
        //   () {
        //     _reqStatus = widget.data.status;
        //     setState(() {});
        //     return getDynamicWidget(status: widget.data.status);
        //   },
        // ),
      )
    );
  }

}
class BUSINESSListItem extends StatelessWidget {

  bsfrnd.Data data;

  BUSINESSListItem({@required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(vertical: 8.0),
        child: ListTile(
          //  key: ValueKey(data.userId),
          leading: CircleAvatar(
            radius: 27.0,
            backgroundImage: NetworkImage(data.profileImage),
          ),
          title: Text(data.username),
          subtitle: Wrap(
            children: [
              //  getDynamicWidget(status: widget.data.status),
            ],
          ),
          // subtitle: Text(data.email),
          // trailing: Wrap(
          //   children: [
          //
          //   ],
          // ),
          // Obx(
          //   () {
          //     _reqStatus = widget.data.status;
          //     setState(() {});
          //     return getDynamicWidget(status: widget.data.status);
          //   },
          // ),
        )
    );
  }

}
