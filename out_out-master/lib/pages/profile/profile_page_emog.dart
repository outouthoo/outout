import 'package:flutter/material.dart';

class ProfilePageEmoG extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return LayoutBuilder(
      builder: (context,constraints){
        return Container(
          height: constraints.maxHeight,
          color: Colors.grey,
          child: Center(
            child: Text(
              'No Data Found!',
              style: TextStyle(
                color: Colors.white54,
              ),
            ),
          ),
        );
      },
    );
  }
}