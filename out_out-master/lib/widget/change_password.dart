import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

class ChangePassword extends StatefulWidget {
  Function onPasswordChangedClick;

  ChangePassword({@required this.onPasswordChangedClick});

  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final _newPasswordTextEditingController = TextEditingController();
  final _confirmPasswordTextEditingController = TextEditingController();
  RxBool _obscureTextNewPass = true.obs;
  RxBool _obscureTextConfirmPass = true.obs;
  final _focusNodeConfirmPassword = FocusNode();
  final _changePasswordFormKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _newPasswordTextEditingController.dispose();
    _confirmPasswordTextEditingController.dispose();
    _focusNodeConfirmPassword.dispose();
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
            Container(
              margin: EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
              child: Obx(
                () => TextFormField(
                  controller: _newPasswordTextEditingController,
                  onFieldSubmitted: (value) {
                    _focusNodeConfirmPassword.requestFocus();
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter new password';
                    }
                    return null;
                  },
                  obscureText: _obscureTextNewPass.value,
                  decoration: InputDecoration(
                    labelText: 'New Password',
                    hintText: 'Enter new password',
                    counterText: '',
                    icon: Icon(Icons.lock),
                    suffix: InkWell(
                      onTap: () => _obscureTextNewPass.value =
                          !_obscureTextNewPass.value,
                      child: Icon(
                        _obscureTextNewPass.value
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Colors.grey,
                      ),
                    ),
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
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
              child: Obx(
                () => TextFormField(
                  controller: _confirmPasswordTextEditingController,
                  focusNode: _focusNodeConfirmPassword,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter confirm password';
                    } else if (value !=
                        _newPasswordTextEditingController.text) {
                      return 'new & confirm pass not matched';
                    }
                    return null;
                  },
                  obscureText: _obscureTextConfirmPass.value,
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
                    hintText: 'Enter confirm password',
                    counterText: '',
                    icon: Icon(Icons.lock),
                    suffix: InkWell(
                      onTap: () => _obscureTextConfirmPass.value =
                          !_obscureTextConfirmPass.value,
                      child: Icon(
                        _obscureTextConfirmPass.value
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Colors.grey,
                      ),
                    ),
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
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
              child: ElevatedButton(
                onPressed: () {
                  if (_changePasswordFormKey.currentState.validate()) {
                    String newPass = _newPasswordTextEditingController.text;
                    String confirmPass =
                        _confirmPasswordTextEditingController.text;
                    Navigator.of(context).pop();
                    widget.onPasswordChangedClick(
                        newPass: newPass, confirmPass: confirmPass);
                  }
                },
                child: Text('Change Password'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
