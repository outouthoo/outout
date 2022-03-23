import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:out_out/utils/icon_utils.dart';

class CommonAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      backgroundColor: Colors.black,
      elevation: 0.0,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
          color: Colors.white,
        ),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      title: Container(height: 70,
          child: Image.asset(out_out_actionbar)),
    );
  }
}
