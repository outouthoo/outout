import 'package:flutter/material.dart';

class AppError extends StatelessWidget {
  final String error;
  const AppError({Key key, this.error}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: Text(error != null ? error : "Oops! Something went wrong."),
      ),
    );
  }
}
