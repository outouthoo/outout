import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:out_out/utils/custom_colors.dart';
import 'package:out_out/widget/common_app_bar.dart';

class ForgotPasswordPage extends StatefulWidget {
  static const routeName = '/forgot-password-page';

  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {

  final _mobileNoTextEditingController = TextEditingController();
  final _forgotPasswordFormKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _mobileNoTextEditingController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56.0),
        child: CommonAppBar(),
      ),
      body: Container(
        margin: EdgeInsets.all(16.0),
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 16.0),
          child: Form(
            key: _forgotPasswordFormKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _mobileNoTextEditingController,
                  maxLength: 10,
                  validator: (value){
                    if(value.isEmpty){
                      return 'Please enter mobile number';
                    }else if(value.length != 10){
                      return 'Please enter valid mobile number';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: 'Mobile No',
                    hintText: 'Enter Mobile No',
                    counterText: '',
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 20.0, horizontal: 28.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(
                        color: Colors.blue,
                        width: 2.0,
                      ),
                    ),
                  ),
                  keyboardType: TextInputType.phone,
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 16.0),
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: () {
                      if(_forgotPasswordFormKey.currentState.validate()){

                      }
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                          if (states.contains(MaterialState.pressed))
                            return Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(0.5);
                          return null; // Use the component's default.
                        },
                      ),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal:8.0,vertical: 12.0),
                      child: Text('SEND OTP'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
