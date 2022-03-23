import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:out_out/pages/common/login_page.dart';
import 'package:out_out/pages/memory_page/memory_page.dart';
import 'package:out_out/providers/common_details_provider.dart';
import 'package:out_out/utils/icon_utils.dart';
import 'package:out_out/utils/preferences_constants.dart';
import 'package:provider/provider.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    Future.delayed(Duration(seconds: 1), () async {
      CommonDetailsProvider commonDetailsProvider =
          Provider.of<CommonDetailsProvider>(context, listen: false);
      await commonDetailsProvider.initPreferences();
      commonDetailsProvider.initCamera();
      bool isLoggedIn = commonDetailsProvider.getPreferencesInstance
          .getBool(PreferenceConstants.IS_USER_LOGGED_IN);
      /*if (isLoggedIn != null && isLoggedIn) {
        Navigator.of(context).pushReplacementNamed(MemoryPage.routeName);
      } else {*/
           Navigator.of(context).pushNamedAndRemoveUntil(LoginScreen.routeName, (Route<dynamic> route) => false);
      // }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(16.0),
        height: size.height,
        width: size.width,
        decoration: BoxDecoration(
          color: Colors.white,
          image:
              DecorationImage(
                  image: AssetImage(bg_splash), fit: BoxFit.fill),
        ),
       /* child: Image.asset(
          splash_logo,
          fit: BoxFit.fitWidth,
        ),*/
      ),
    );
  }
}
