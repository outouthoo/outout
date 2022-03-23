import 'dart:async';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_floating_menu/floating_menu_item.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:out_out/api/api_implementer.dart';
import 'package:out_out/chat/const.dart';
import 'package:out_out/models/business_packages_model.dart';
import 'package:out_out/pages/common/login_page.dart';
import 'package:out_out/pages/wallet/walletpage.dart';
import 'package:out_out/providers/common_details_provider.dart';
import 'package:out_out/utils/common_dialog_util.dart';
import 'package:out_out/utils/commona_utils.dart';
import 'package:out_out/utils/custom_colors.dart';
import 'package:out_out/utils/icon_utils.dart';
import 'package:out_out/utils/preferences_constants.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:out_out/models/business_packages_model.dart' as pck;

import '../datevalidation.dart';
import '../main.dart';
import 'memory_page/memory_page.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';

class MembershipPage extends StatefulWidget {
  static const routeName = '/membership-screen';

  @override
  _MembershipPageState createState() => _MembershipPageState();
}
class ExamplePaymentQueueDelegate implements SKPaymentQueueDelegateWrapper {
  @override
  bool shouldContinueTransaction(
      SKPaymentTransactionWrapper transaction, SKStorefrontWrapper storefront) {
    return true;
  }

  @override
  bool shouldShowPriceConsent() {
    return false;
  }
}
class _MembershipPageState extends State<MembershipPage> {
  SharedPreferences _sharedPreferences;
  bool _isLoading = false;
  final picker = ImagePicker();
  FirebaseMessaging messaging;
  SharedPreferences prefs;
  List<pck.Data> businessPackagesList = [];
  String _accessToken = '';
  String _userId = '';
  String _userName = '';
  String _accountType = '';
  String _paymentStatus = '';
  String packageId = '';
  InAppPurchase _iap = InAppPurchase.instance;
  final String premiumApp = 'outoutbronze1';
  final String premiumApp1 = 'outoutsilver1';
  final String premiumApp2 = 'outoutgold1';
  final String premiumApp3 = 'outoutcustom1';

  List<ProductDetails> _products = [];
  StreamSubscription<List<PurchaseDetails>> _subscription;
  Data selectedPackage;

  @override
  void initState() {
    _iap = IAPConnection.instance;
    final Stream purchaseUpdated = InAppPurchase.instance.purchaseStream;
    _subscription = purchaseUpdated.listen((purchaseDetailsList) {
      _listenToPurchaseUpdated(purchaseDetailsList);
    }, onDone: () {
      _subscription.cancel();
    }, onError: (error) {
      // handle error here.
    });
    _initialize();
    getBusinessPackagesApiCAll();
    super.initState();
  }

  void getBusinessPackagesApiCAll() {
    ApiImplementer.businessPackagesApiImplementer().then((value) {
      if (value.errorcode == '0') {
        BusinessPackagesModel businessPackagesModel = value;
        businessPackagesList = businessPackagesModel.data;
        setState(() {});
      } else if (value.errorcode == "2") {
        print("logout");
        _sharedPreferences.clear();
           Navigator.of(context).pushNamedAndRemoveUntil(LoginScreen.routeName, (Route<dynamic> route) => false);
        CommonDialogUtil.showErrorSnack(context: context, msg: value.msg);
      }
    }).onError((error, stackTrace) {});
  }


  bool _available = false;

  void _initialize() async {
    _available = await _iap.isAvailable();
    print("_available");
    print(_available);
    if (_available) {
      if (Platform.isIOS) {
        var iosPlatformAddition =
        _iap.getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
        await iosPlatformAddition.setDelegate(ExamplePaymentQueueDelegate());
      }
      await _getProducts();
    }
  }

  Future<void> _getProducts() async {
    Set<String> ids = Set.from([premiumApp, premiumApp1, premiumApp2, premiumApp3]);
    ProductDetailsResponse response = await _iap.queryProductDetails(ids);
    // final ProductDetailsResponse response = await InAppPurchase.instance.queryProductDetails(_kIds);
    print("ProductDetailsResponse");
    print(response.productDetails);
    setState(() {
      _products = response.productDetails;
      print("products-----$_products");
      print("products length-----${_products.length}");
    });
  }

  @override
  void dispose() {
    if (Platform.isIOS) {
      var iosPlatformAddition =
      _iap.getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
      iosPlatformAddition.setDelegate(null);
    }
    _subscription.cancel();
    super.dispose();
  }

  void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
      if (purchaseDetails.status != PurchaseStatus.pending) {

        if (purchaseDetails.status == PurchaseStatus.error) {
          // _handleError(purchaseDetails.error!);
        } else if (purchaseDetails.status == PurchaseStatus.purchased) {
          bool valid = await _verifyPurchase(purchaseDetails);
          if (valid) {
            // _deliverProduct(purchaseDetails);
            ApiCallForUpdateMemberShip(
                selectedPackage.id, "outout(${selectedPackage.name})");
            print('_verifyPurchase true');
          } else {
            print('_verifyPurchase false');
            _handleInvalidPurchase(purchaseDetails);
          }
        }
        if (purchaseDetails.pendingCompletePurchase) {
          await InAppPurchase.instance.completePurchase(purchaseDetails);
        }
      }
    });
  }

  Future<bool> _verifyPurchase(PurchaseDetails purchaseDetails) {
    // IMPORTANT!! Always verify a purchase before delivering the product.
    // For the purpose of an example, we directly return true.
    return Future<bool>.value(true);
  }

  void _handleInvalidPurchase(PurchaseDetails purchaseDetails) {
    // handle invalid purchase here if  _verifyPurchase` failed.
  }

  void ApiCallForUpdateMemberShip(String packageid, String paymenttype) async {
    try {
      await ApiImplementer.ApiCallForUpdateMemberShip(
          accessToken: _accessToken,
          userid: _userId,
          paymenttype: paymenttype,
          packageid: packageid)
          .then((value) {
        if (value.errorcode == ApiImplementer.SUCCESS && value.data != null) {
          _isLoading = false;
          CommonDialogUtil.showSuccessSnack(context: context, msg: value.msg);
          _sharedPreferences.setString(
              PreferenceConstants.packageId, packageid??'0');
          Navigator.pushReplacementNamed(context, MemoryPage.routeName);
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
      _accountType =
          _sharedPreferences.get(PreferenceConstants.ACCOUNT_TYPE) ?? '';
      _paymentStatus =
          _sharedPreferences.get(PreferenceConstants.payment_status) ?? '';
    }
    _isLoading = true;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    TargetPlatform platform = Theme.of(context).platform;
    final List<FloatingMenuItem> floatMenuList = [
      FloatingMenuItem(
          id: 1,
          icon: Icons.add_photo_alternate,
          backgroundColor: Colors.white),
      FloatingMenuItem(
          id: 2, icon: Icons.list_alt, backgroundColor: Colors.white),
      FloatingMenuItem(
          id: 3,
          icon: FlutterIcons.add_user_ent,
          backgroundColor: Colors.white),
    ];

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black,
        elevation: 0.0,
        automaticallyImplyLeading: false,
        title: Container(height: 70, child: Image.asset(out_out_actionbar)),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 90.0,
            color: CustomColor.colorAccent,
            child: Stack(
              children: [
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Icon(
                        Icons.business,
                        size: 48.0,
                        color: Colors.white,
                      ),
                      Text(
                        'Select Business Package',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.0,
                        ),
                      )
                    ],
                  ),
                ),
                /*Container(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: Icon(
                      Icons.close,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    },
                  ),
                ),*/
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 18.0),
            child: ListView.separated(
              shrinkWrap: true,
              separatorBuilder: (context, index) {
                return Divider(
                  height: 0.0,
                  color: Colors.black,
                );
              },
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () async {
                    if (packageId != businessPackagesList[index].id) {
                      if(checkDateIsToday()){
                        await checkWalletBalance(businessPackagesList[index]);
                      }else{
                        for (var prod in _products) {
                          // print(prod.id);
                          if (prod.id ==
                              businessPackagesList[index].inapppurchase_key) {
                            selectedPackage = businessPackagesList[index];
                            final PurchaseParam purchaseParam =
                            PurchaseParam(productDetails: prod);
                            _iap.buyConsumable(
                                purchaseParam: purchaseParam);
                          }
                        }
                      }
                    }

                  },
                  title: Text(businessPackagesList[index].name),
                  subtitle: Text(businessPackagesList[index].duration=='0'?'Per Month':'Per Year'),
                  trailing: Chip(
                    backgroundColor: CustomColor.colorAccent,
                    label: Text(
                      r"$" " ${businessPackagesList[index].price}/${businessPackagesList[index].duration=='0'?'M':'Y'}",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                );
              },
              itemCount: businessPackagesList.length,
            ),
          ),
        ],
      ),
    );
  }

  Future<bool> checkWalletBalance(Data businessPackagesList) async {
    try {
      await ApiImplementer.FetchWalletData(
          accessToken: _accessToken, userid: _userId)
          .then((value) {
        if (value.errorcode == ApiImplementer.SUCCESS && value.data != null) {
          _isLoading = false;
          // walletAmount= value.data.wallet;

          if (double.parse(businessPackagesList.price) >
              double.parse(value.data.wallet)) {
            print('less');
            showDialogForPayment(businessPackagesList, false);
          } else {
            showDialogForPayment(businessPackagesList, true);
          }
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

  showDialogForPayment(Data businessPackagesItem, bool isShowWallet) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            contentPadding: EdgeInsets.only(top: 10.0),
            content: Container(
              width: 400.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        "Payment Options",
                        style: TextStyle(fontSize: 24.0),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      if (isShowWallet) {
                        ApiCallForUpdateMemberShip(
                            businessPackagesItem.id, "wallet");
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => WalletPage()),
                        );
                      }
                    },
                    child: Container(
                      margin: EdgeInsets.all(10.0),
                      height: 40,
                      padding: EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.all(Radius.circular(32.0)),
                      ),
                      child: Text(
                        isShowWallet ? 'Pay From Wallet' : "Add Money in Wallet",
                        style: TextStyle(color: Colors.white, fontSize: 14),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Platform.isIOS
                      ? InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      for (var prod in _products) {
                        // print(prod.id);
                        if (prod.id ==
                            businessPackagesItem.inapppurchase_key) {
                          selectedPackage = businessPackagesItem;
                          final PurchaseParam purchaseParam =
                          PurchaseParam(productDetails: prod);
                          _iap.buyConsumable(
                              purchaseParam: purchaseParam);
                        }
                      }
                    },
                    child: Container(
                      height: 40,
                      margin: EdgeInsets.all(10.0),
                      padding: EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius:
                        BorderRadius.all(Radius.circular(32.0)),
                      ),
                      child: Text(
                        "In APP Purchase",
                        style:
                        TextStyle(color: Colors.white, fontSize: 14),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                      : Container(),
                  SizedBox(
                    height: 5.0,
                  ),
                ],
              ),
            ),
          );
        });
  }
}

