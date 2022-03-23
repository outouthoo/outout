import 'package:flutter/material.dart';
import 'package:flutter_braintree/flutter_braintree.dart';
// import 'package:flutter_braintree/flutter_braintree.dart';
import 'package:out_out/api/api_implementer.dart';
import 'package:out_out/pages/common/login_page.dart';
import 'package:out_out/pages/wallet/wallettransaction.dart';
import 'package:out_out/providers/common_details_provider.dart';
import 'package:out_out/utils/common_dialog_util.dart';
import 'package:out_out/utils/commona_utils.dart';
import 'package:out_out/utils/custom_colors.dart';
import 'package:out_out/utils/icon_utils.dart';
import 'package:out_out/utils/preferences_constants.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'listFriendForSendMoney.dart';

class WalletPage extends StatefulWidget {
  static const routeName = '/wallet-screen';

  @override
  _WalletPageState createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  SharedPreferences _sharedPreferences;
  bool _isLoading = false;
  SharedPreferences prefs;
  String _accessToken = '';
  String _userId = '';
  String _userName = '';
  String _accountType = '';
  String _paymentStatus = '';
  String walletAmount = "0";
  User _user;

  @override
  void initState() {
    _user = Provider.of<CommonDetailsProvider>(context, listen: false).user;
    super.initState();
  }

  void AddMoneyApiCall(String amount, String transactionId) async {
    try {
      await ApiImplementer.AddMoneyToWallet(
              accessToken: _user.accessToken,
              userid: _user.userId,
              payment_ref_id: transactionId,
              amount: amount)
          .then((value) {
        if (value.errorcode == ApiImplementer.SUCCESS && value.data != null) {
          _isLoading = false;
          CommonDialogUtil.showSuccessSnack(context: context, msg: value.msg);
          FetchWalletData();
          // walletAmount= value.data[0].wallet;
          // setState(() {});
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
    } catch (error) {}
  }

  void FetchWalletData() async {
    try {
      await ApiImplementer.FetchWalletData(
              accessToken: _user.accessToken, userid: _user.userId)
          .then((value) {
        if (value.errorcode == ApiImplementer.SUCCESS && value.data != null) {
          _isLoading = false;
          walletAmount = value.data.wallet;

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
    } catch (error) {}
  }

  void PaymentAPiCall(String amount) async {
    try {
      /*var request = BraintreeDropInRequest(
        tokenizationKey: CommonUtils.tokenizationKey,
        collectDeviceData: true,
        googlePaymentRequest: BraintreeGooglePaymentRequest(
          totalPrice: amount,
          currencyCode: 'USD',
          billingAddressRequired: false,
        ),
        paypalRequest: BraintreePayPalRequest(
          amount: amount,
          displayName: _userName,
        ),
        cardEnabled: true,
      );
      final result = await BraintreeDropIn.start(request);
      if (result != null) {
        print('Nonce: ${result.paymentMethodNonce.nonce}');

        // makePayment(result.paymentMethodNonce.nonce, amount);
      }else{
        Navigator.pop(context);
      }*/
     final request = BraintreePayPalRequest(amount: amount ,currencyCode:'USD',displayName: _userName  );
      BraintreePaymentMethodNonce result = await Braintree.requestPaypalNonce(
        CommonUtils.tokenizationKey,
        request,
      );
      if (result != null) {
        print('Nonce: ${result.nonce}');

        makePayment(result.nonce, amount);

      } else {
        print('PayPal flow was canceled.');
      }
    } catch (e) {
      print(e);
    }
  }

  void makePayment(String nonce, String amount) async {
    await ApiImplementer.ApiCallMakePayment(
            accessToken: _user.accessToken,
            userid: _user.userId,
            amount: amount,
            nonce: nonce)
        .then((value) {
      if (value.errorcode == ApiImplementer.SUCCESS && value.data != null) {
        _isLoading = false;
        // getBusinessPackagesApiCAll();
        CommonDialogUtil.showSuccessSnack(context: context, msg: value.msg);
        // ApiCallForUpdateMemberShip(id);
        amountTEC.text="";
        AddMoneyApiCall(amount, value.data.transactionId);
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
  }

  @override
  void didChangeDependencies() {
    if (!_isLoading) {
      _sharedPreferences =
          Provider.of<CommonDetailsProvider>(context).getPreferencesInstance;

      _accessToken = _sharedPreferences.get(PreferenceConstants.ACCESS_TOKEN);
      _userId = _sharedPreferences.get(PreferenceConstants.USER_ID);
      _userName = _sharedPreferences.get(PreferenceConstants.USER_NAME);
      _accountType =
          _sharedPreferences.get(PreferenceConstants.ACCOUNT_TYPE) ?? '';
      _paymentStatus =
          _sharedPreferences.get(PreferenceConstants.payment_status) ?? '';
    }
    _isLoading = true;
    FetchWalletData();
    super.didChangeDependencies();
  }

  final TextEditingController amountTEC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    TargetPlatform platform = Theme.of(context).platform;

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
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      0.0,
                    ),
                  ),
                  gradient: LinearGradient(
                    colors: [
                      CustomColor.colorAccent,
                      CustomColor.colorPrimaryDark,
                    ],
                  ),
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12.0,
                      vertical: 12.0,
                    ),
                    child: Text('Wallet',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14,color: Colors.white),),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          alignment: Alignment.center,
                          height: 160,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(Radius.circular(10))),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                r"$" " $walletAmount",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w900,
                                    fontSize: 20),
                              ),
                              // UiSpacer.verticalSpace(space: 5),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                "Current Balance",
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w900,
                                    fontSize: 16),
                              )
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pushNamed(
                                context, WalletHistoryPage.routeName);
                          },
                          child: Column(
                            children: [
                              SizedBox(
                                height: 160,
                              ),
                              Container(
                                height: 90,
                                width: 90,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.account_balance_wallet_rounded,
                                      size: 30.0,
                                      color: Colors.white,
                                    ),
                                    Text(
                                      "History",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w900,
                                          fontSize: 14),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Amount",
                      style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.w600,
                          fontSize: 14),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: TextFormField(
                        decoration: new InputDecoration(
                          border: InputBorder.none,
                        ),
                        keyboardType: TextInputType.phone,
                        controller: amountTEC,
                        validator: validateEmpty,
                      ),
                      decoration: BoxDecoration(
                          color: Color(0xFFF3F6FA),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            setPriceAmount('10');
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.18,
                            height: 35,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: Color(0xFFF3F6FA),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            child: Text(
                              r"$" " 10",
                              style: TextStyle(
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12),
                            ),
                          ),
                        ) /*.onInkTap(() {vm.setPriceAmount("10");}*/,
                        InkWell(
                          onTap: () {
                            setPriceAmount('100');
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.18,
                            height: 35,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: Color(0xFFF3F6FA),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            child: Text(
                              r"$" " 100",
                              style: TextStyle(
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            setPriceAmount('200');
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.2,
                            height: 35,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: Color(0xFFF3F6FA),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            child: Text(
                              r"$" " 200",
                              style: TextStyle(
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            setPriceAmount('250');
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.2,
                            height: 35,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: Color(0xFFF3F6FA),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            child: Text(
                              r"$" " 250",
                              style: TextStyle(
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: InkWell(
                        onTap: () {
                          PaymentAPiCall(amountTEC.text.toString());
                          // AddMoneyApiCall();
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.6,
                          height: 40,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.all(Radius.circular(50))),
                          child: Text(
                            "Add Money",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 16),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: InkWell(
                        onTap: () async{
                          // PaymentAPiCall(amountTEC.text.toString());
                          // AddMoneyApiCall();
                        var data=await  Navigator.of(context)
                              .push(MaterialPageRoute(
                            builder: (context) => ListFriendForSendMoney(),
                          ));
                        if(data!=null){
                          FetchWalletData();
                        }
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.6,
                          height: 40,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.all(Radius.circular(50))),
                          child: Text(
                            "Send Money",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 16),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  static String validateEmpty(String value, {String errorTitle}) {
    if (value.isEmpty || value.trim().isEmpty || value.length < 6) {
      return '$errorTitle is empty';
    }
    return null;
  }

  setPriceAmount(String amount) {
    amountTEC.text = amount;
    setState(() {});
  }
}
