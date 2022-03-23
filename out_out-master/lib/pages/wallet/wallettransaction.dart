import 'package:flutter/material.dart';
import 'package:out_out/api/api_implementer.dart';
import 'package:out_out/pages/common/login_page.dart';
import 'package:out_out/providers/common_details_provider.dart';
import 'package:out_out/utils/common_dialog_util.dart';
import 'package:out_out/utils/custom_colors.dart';
import 'package:out_out/utils/icon_utils.dart';
import 'package:out_out/utils/preferences_constants.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:out_out/models/wallettransactionmodel.dart' as pck;

class WalletHistoryPage extends StatefulWidget {
  static const routeName = '/wallet-history-screen';

  @override
  _WalletHistoryPageState createState() => _WalletHistoryPageState();
}

class _WalletHistoryPageState extends State<WalletHistoryPage> {
  SharedPreferences _sharedPreferences;
  bool _isLoading = false;
  User user;
  SharedPreferences prefs;
  List<pck.Data> businessPackagesList = [];
  String _accessToken = '';
  String _userId = '';
  String packageId = '';
  String _userName = '';
  String _accountType = '';
  String _paymentStatus = '';

  @override
  void initState() {
    super.initState();
  }

  void getBusinessPackagesApiCAll() async {
    try {
      await ApiImplementer.FetchWalletTransaction(
              accessToken: _accessToken, userid: _userId)
          .then((value) {
        if (value.errorcode == ApiImplementer.SUCCESS && value.data != null) {
          _isLoading = false;
          businessPackagesList = value.data;
          setState(() {});
        }
        if (value.errorcode == ApiImplementer.FAIL) {
          _isLoading = false;
          CommonDialogUtil.showErrorSnack(context: context, msg: value.msg);
        } else if (value.errorcode == "2") {
          print("logout");
          _sharedPreferences.clear();
             Navigator.of(context).pushNamedAndRemoveUntil(LoginScreen.routeName, (Route<dynamic> route) => false);
          CommonDialogUtil.showErrorSnack(context: context, msg: value.msg);
        }
      });
    } catch (error) {
      print(error);
    }
  }

  @override
  void didChangeDependencies() {
    if (!_isLoading) {
      _sharedPreferences =
          Provider.of<CommonDetailsProvider>(context).getPreferencesInstance;

      _accessToken = _sharedPreferences.get(PreferenceConstants.ACCESS_TOKEN);
      _userId = _sharedPreferences.get(PreferenceConstants.USER_ID);
      _userName = _sharedPreferences.get(PreferenceConstants.USER_NAME);
      packageId = _sharedPreferences.get(PreferenceConstants.packageId);
      _accountType =
          _sharedPreferences.get(PreferenceConstants.ACCOUNT_TYPE) ?? '';
      _paymentStatus =
          _sharedPreferences.get(PreferenceConstants.payment_status) ?? '';
    }
    _isLoading = true;
    getBusinessPackagesApiCAll();

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black,
        elevation: 0.0,
        automaticallyImplyLeading: false,
        title: Container(height: 70, child: Image.asset(out_out_actionbar)),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        child: ListView.builder(
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8)),
                padding: EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Amount:',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  r"$"
                                  '${businessPackagesList[index].amount ?? '0'}',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                Text(
                                  'Date:',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  businessPackagesList[index].paymentDate,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            businessPackagesList[index].paymentRefId.isEmpty?Container():
                            Row(
                              children: [
                                Text(
                                  'Ref. ID:',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  businessPackagesList[index].paymentRefId,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ],
                        ),
                        businessPackagesList[index].trans_type != '0'
                            ? Chip(
                                backgroundColor: Colors.green,
                                label: Text(
                                  "Credit",
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              )
                            : Chip(
                                backgroundColor: Colors.redAccent,
                                label: Text(
                                  "Debit",
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                      ],
                    ),
                    SizedBox(height: 5,),
                    Text(
                      businessPackagesList[index].notes,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 13,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ) /* ListTile(
              title: Text(  r"$" '${businessPackagesList[index].amount??'0'}'),
              subtitle: Text(businessPackagesList[index].paymentDate),
            )*/
                ;
          },
          itemCount: businessPackagesList.length,
        ),
      ),
    );
  }
}
