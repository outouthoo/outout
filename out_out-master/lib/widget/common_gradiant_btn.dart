import 'package:flutter/material.dart';
import 'package:out_out/utils/custom_colors.dart';

class CommonGradiantButton extends StatelessWidget {
  String title;

  CommonGradiantButton({@required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.0),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [CustomColor.colorAccent, CustomColor.colorPrimary],
        ),
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Text(
        title,
        style: TextStyle(
          color: Colors.white,
          fontSize: 16.0,
        ),
      ),
    );
  }
}
