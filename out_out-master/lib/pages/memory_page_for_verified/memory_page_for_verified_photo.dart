import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:out_out/utils/icon_utils.dart';

class MemoryPageForVerifiedPhoto extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          padding: EdgeInsets.all(8.0),
          height: constraints.maxHeight,
          color: Colors.grey,
          child: GridView.builder(
            itemCount: 50,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
              childAspectRatio: 4/5,
            ),
            itemBuilder: (context, index) {
              return Container(
                child: Image.asset(
                  new_dummy,
                  fit: BoxFit.fill,
                ),
              );
            },
          ),
        );
      },
    );
  }
}
