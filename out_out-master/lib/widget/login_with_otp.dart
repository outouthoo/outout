import 'package:out_out/coutry_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:out_out/utils/common_dialog_util.dart';
import 'package:out_out/widget/common_app_bar.dart';

class LoginWithOTP extends StatefulWidget {

  Function onMobileNoEntered;

  LoginWithOTP({@required this.onMobileNoEntered});

  @override
  _LoginWithOTPState createState() => _LoginWithOTPState();
}

class _LoginWithOTPState extends State<LoginWithOTP> {
  final _mobileNoTextEditingController = TextEditingController();
  final _loginWithOTPFormKey = GlobalKey<FormState>();
  String selectedCountryCode = '+91';

  @override
  void dispose() {
    _mobileNoTextEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _loginWithOTPFormKey,
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(vertical: 40.0,horizontal: 24.0),
            child: TextFormField(
              controller: _mobileNoTextEditingController,
              maxLength: 10,
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter mobile number';
                } else if (value.length != 10) {
                  return 'Please enter valid mobile number';
                }
                return null;
              },
              decoration: InputDecoration(
                labelText: 'Mobile No',
                hintText: 'Enter Mobile No',
                counterText: '',
                prefix: CountryCodePicker(
                  padding: EdgeInsets.zero,
                  onChanged: (countryCode) {
                    selectedCountryCode = countryCode.toString();
                  },
                  initialSelection: 'IN',
                  showCountryOnly: false,
                  showFlag: false,
                  showOnlyCountryWhenClosed: false,
                  alignLeft: false,
                ),
                contentPadding: EdgeInsets.symmetric(
                    vertical: 4.0, horizontal: 10.0),
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
          ),
          Container(
            margin: EdgeInsets.only(bottom: 28.0,right: 24.0),
            alignment: Alignment.centerRight,
            child: ElevatedButton.icon(
              icon: Icon(Icons.login,color: Colors.white,),
              onPressed: () {
                if(_loginWithOTPFormKey.currentState.validate()){
                  Navigator.of(context).pop();
                  widget.onMobileNoEntered('${selectedCountryCode.trim()}' + '${_mobileNoTextEditingController.text.trim()}');
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
              label: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 8.0, vertical: 12.0),
                child: Text('LOGIN'),
              ),
            ),
          )
        ],
      ),
    );
  }
}
