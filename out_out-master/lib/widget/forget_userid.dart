import 'package:flutter/material.dart';

class ForgotUserId extends StatefulWidget {
  Function onForgotPasswordClick;

  ForgotUserId({@required this.onForgotPasswordClick});

  @override
  _ForgotUserIdState createState() => _ForgotUserIdState();
}

class _ForgotUserIdState extends State<ForgotUserId> {
  final _emailIdTextEditingController = TextEditingController();

  final _changePasswordFormKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailIdTextEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _changePasswordFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Stack(

              children: [
                Padding(
                  padding: EdgeInsets.only(top: 25.0),
                  child: Center(child: Text("Forgot Username")),
                ),
                Container(
                  margin: EdgeInsets.only(top: 12.0, left: 24.0, right: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
              child: TextFormField(
                controller: _emailIdTextEditingController,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter emailId';
                  } else if (!value.contains('@')) {
                    return 'Please enter valid emailId';
                  }
                  return null;
                },
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email-Id',
                  hintText: 'Enter Email-Id',
                  counterText: '',
                  contentPadding:
                  EdgeInsets.symmetric(vertical: 18.0, horizontal: 16.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(
                      color: Colors.blue,
                      width: 2.0,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
              child: ElevatedButton(
                onPressed: () {
                  if (_changePasswordFormKey.currentState.validate()) {
                    String emailId = _emailIdTextEditingController.text;
                    Navigator.of(context).pop();
                    widget.onForgotPasswordClick(emailId: emailId);
                  }
                },
                child: Text('Forgot UserName'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
