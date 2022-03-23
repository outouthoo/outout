import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:out_out/api/api_implementer.dart';
import 'package:out_out/models/Payment_list.dart';
import 'package:out_out/pages/common/login_page.dart';
import 'package:out_out/providers/common_details_provider.dart';
import 'package:out_out/utils/common_dialog_util.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Packages extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return Packages_state();
  }
}

class Packages_state extends State<Packages> {
  List<aList> _list = new List();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  SharedPreferences _sharedPreferences;
  @override
  void initState() {

    // TODO: implement initState
    ApiImplementer.ListPackagesImplementer().then((value) {
      if (value.errorcode == "2") {
        _sharedPreferences =
            Provider.of<CommonDetailsProvider>(context).getPreferencesInstance;
        print("logout done");
        _sharedPreferences.clear();
           Navigator.of(context).pushNamedAndRemoveUntil(LoginScreen.routeName, (Route<dynamic> route) => false);
        CommonDialogUtil.showErrorSnack(
            context: context, msg: value.msg);
      } else {
        setState(() {
          _list = new List();
          _list.addAll(value.data.list);
        });

        print(_list.length);
      }
    }).onError((error, stackTrace) {
      Navigator.of(context).pop();
      print(stackTrace.toString());
      CommonDialogUtil.showErrorSnack(context: context, msg: error.toString());
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: new Scaffold(
            backgroundColor: Colors.white,
            key: _scaffoldKey,
            body: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: _list.length,
                itemBuilder: (context, index) {
                  return new Container(
                    child: new Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      color: Colors.deepPurple,
                      elevation: 10,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          ListTile(
                            leading:
                                Icon(Icons.add_business_outlined, size: 50),
                            title: Text(_list[index].name.toString(),
                                style: TextStyle(
                                    color: Colors.white, fontSize: 22)),
                            subtitle: Center(
                                child: Text(
                                    'Aimed at non premium customer ideal-for small businesses. Promotional video required.',
                                    style: TextStyle(color: Colors.white))),
                          ),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: FlatButton(
                                  child: Text('£ ${_list[index].price} /mo',
                                      style: TextStyle(
                                          fontSize: 25, color: Colors.white)),
                                  onPressed: () {},
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  height: 50.0,
                                  margin: EdgeInsets.all(20),
                                  child: RaisedButton(
                                    onPressed: () {
                                      // Navigator.of(context).push(
                                      //   MaterialPageRoute(
                                      //     builder: (BuildContext context) => Payment(
                                      //       onFinish: (number) async {
                                      //         // payment done
                                      //         final snackBar = SnackBar(
                                      //           content: Text("Payment done Successfully"),
                                      //           duration: Duration(seconds: 5),
                                      //           action: SnackBarAction(
                                      //             label: 'Close',
                                      //             onPressed: () {
                                      //               // Some code to undo the change.
                                      //             },
                                      //           ),
                                      //         );
                                      //         _scaffoldKey.currentState
                                      //             .showSnackBar(snackBar);
                                      //         print('order id: ' + number);
                                      //         print('ddasdas');
                                      //       },
                                      //     ),
                                      //   ),
                                      // );
                                    },
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(80.0)),
                                    padding: EdgeInsets.all(0.0),
                                    child: Ink(
                                      decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              Colors.pinkAccent,
                                              Colors.pink
                                            ],
                                            begin: Alignment.centerLeft,
                                            end: Alignment.centerRight,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(30.0)),
                                      child: Container(
                                        constraints: BoxConstraints(
                                            maxWidth: 250.0, minHeight: 50.0),
                                        alignment: Alignment.center,
                                        child: Text(
                                          "Buy",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                })));
  }
}
