import 'package:flutter/material.dart';
import 'package:out_out/models/comment_list_model.dart';
import 'package:out_out/utils/commona_utils.dart';
import 'package:out_out/utils/custom_colors.dart';

class ItemCommentList extends StatelessWidget {
  final CommentList commentData;
  const ItemCommentList({Key key, this.commentData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(3),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: CustomColor.colorPrimary.withOpacity(0.5),
          borderRadius: BorderRadius.circular(5)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                commentData.username,
                style: Theme.of(context).primaryTextTheme.subtitle1,
              ),
              Text(
                CommonUtils().getLocalDateTimeStdFormat(
                    DateTime.parse(commentData.createdAt)),
                style: Theme.of(context).primaryTextTheme.caption,
              )
            ],
          ),
          Padding(
            padding: EdgeInsets.only(left: 5, top: 5),
            child: Text(commentData.comment),
          )
        ],
      ),
    );
  }
}
