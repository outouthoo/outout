import 'package:flutter/material.dart';
import 'package:out_out/utils/custom_colors.dart';
import 'package:out_out/models/list_shoutout_model.dart' as shoutout;


class ShoutoutListItem extends StatelessWidget{

  shoutout.Data data;

  ShoutoutListItem({@required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      //BoxDecoration Widget
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(
              '${data.profileImage}'),
          fit: BoxFit.cover,
        ), //DecorationImage
        border: Border.all(
          width: 4,
          color: CustomColor.colorPrimaryDark,
        ), //Border.all
        borderRadius: BorderRadius.circular(15),
      ), //BoxDecoration
    );
  }

}