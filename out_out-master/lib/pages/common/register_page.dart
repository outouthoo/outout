import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:out_out/api/api_implementer.dart';
import 'package:out_out/coutry_code_picker/country_code_picker.dart';
import 'package:out_out/models/business_category_model.dart';
import 'package:out_out/models/business_packages_model.dart';
import 'package:out_out/models/business_packages_model.dart' as pck;
import 'package:out_out/models/drop_down_model/business_category_model.dart';
import 'package:out_out/models/drop_down_model/gender_model.dart';
import 'package:out_out/models/drop_down_model/type_of_account_model.dart';
import 'package:out_out/models/register_model.dart';
import 'package:out_out/providers/common_details_provider.dart';
import 'package:out_out/utils/common_dialog_util.dart';
import 'package:out_out/utils/custom_colors.dart';
import 'package:out_out/utils/permission_util.dart';
import 'package:out_out/widget/common_app_bar.dart';
import 'package:out_out/widget/common_gradiant_btn.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../datevalidation.dart';
import 'login_page.dart';

// enum GenderSelection { Male, FeMale, Other }

class RegisterUserScreen extends StatefulWidget {
  static const routeName = '/register-user-screen';

  @override
  _RegisterUserScreenState createState() => _RegisterUserScreenState();
}

class _RegisterUserScreenState extends State<RegisterUserScreen> {
  SharedPreferences _sharedPreferences;
  final _registerFormKey = GlobalKey<FormState>();
  final _firstNameTextEditingController = TextEditingController();
  final _lastNameTextEditingController = TextEditingController();
  final _emailIdTextEditingController = TextEditingController();
  final _mobileNoTextEditingController = TextEditingController();
  final _cityTextEditingController = TextEditingController();
  final _userNameTextEditingController = TextEditingController();
  final _passwordTextEditingController = TextEditingController();
  final _dateTextEditingController = TextEditingController();
  final _focusNodeLastNameEmailId = FocusNode();
  final _focusNodeEmailId = FocusNode();
  final _focusNodeMobileNo = FocusNode();
  final _focusNodeDate = FocusNode();
  final _focusNodeCity = FocusNode();
  final _focusNodeUserName = FocusNode();
  final _focusNodePassword = FocusNode();
  final picker = ImagePicker();
  // GenderSelection gender = GenderSelection.Male;
  bool _isAccepted = true;
  File _selectedFile = null;
  List<TypeOfAccountDropDownModel> typeOfAccountDropDownModelList = [];
  int _selectedTypeOfAccountPos = 0;
  RxBool _obscureText = true.obs;

  List<BusinessCategoryDropDownModel> businessCategoryDropDownModelList = [];
  int _selectedBusinessCategoryPos = 0;

  List<GenderDropDownModel> genderDropDownModelList = [];
  int _selectedGenderPos = 0;

  List<pck.Data> businessPackagesList = [];

  String selectedCountryCode = '+91';
  String catId="";

  @override
  void initState() {

    getBusinessCategoryApiCall();
    getBusinessPackagesApiCAll();
    addStaticAccountData();
    addStaticGenderData();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _sharedPreferences =
        Provider.of<CommonDetailsProvider>(context, listen: false)
            .getPreferencesInstance;
    super.didChangeDependencies();
  }

  void addStaticAccountData() {
    TypeOfAccountDropDownModel typeOfAccountSelect = TypeOfAccountDropDownModel(
        id: 0, value: 'Select Account Type*', position: 0);
    typeOfAccountDropDownModelList.add(typeOfAccountSelect);
    TypeOfAccountDropDownModel typeOfAccountNormal =
        TypeOfAccountDropDownModel(id: 0, value: 'Normal Account', position: 1);
    typeOfAccountDropDownModelList.add(typeOfAccountNormal);
    TypeOfAccountDropDownModel typeOfAccountBusiness =
        TypeOfAccountDropDownModel(
            id: 1, value: 'Business Account', position: 2);
    if(checkDateIsToday()) {
      typeOfAccountDropDownModelList.add(typeOfAccountBusiness);
    }
    TypeOfAccountDropDownModel typeOfAccountBusiness1 =
        TypeOfAccountDropDownModel(
            id: 2, value: 'Premium Account', position: 3);
    if(checkDateIsToday()) {
      typeOfAccountDropDownModelList.add(typeOfAccountBusiness1);
    }
    // TypeOfAccountDropDownModel typeOfAccountPremium =
    //     TypeOfAccountDropDownModel(
    //         id: 2, value: 'Premium Account', position: 3);
    // typeOfAccountDropDownModelList.add(typeOfAccountPremium);
  }

  void addStaticGenderData() {
    GenderDropDownModel selectGenderDropDownModel =
        GenderDropDownModel(id: 0, value: 'Select Gender', position: 0);
    genderDropDownModelList.add(selectGenderDropDownModel);

    GenderDropDownModel maleGenderDropDownModel =
        GenderDropDownModel(id: 0, value: 'Male', position: 1);
    genderDropDownModelList.add(maleGenderDropDownModel);

    GenderDropDownModel feMaleGenderDropDownModel =
        GenderDropDownModel(id: 1, value: 'Female', position: 2);
    genderDropDownModelList.add(feMaleGenderDropDownModel);

    GenderDropDownModel otherGenderDropDownModel =
        GenderDropDownModel(id: 2, value: 'Other', position: 3);
    genderDropDownModelList.add(otherGenderDropDownModel);
  }

  void getBusinessCategoryApiCall() {
    ApiImplementer.businessCategoryApiImplementer().then((value) {
      if (value.errorcode == '0') {
        BusinessCategoryModel businessCategoryModel = value;
        BusinessCategoryDropDownModel businessCategoryDropDownModel =
            BusinessCategoryDropDownModel(
                id: 0, value: 'Select Business Category*', position: 0);
        businessCategoryDropDownModelList.add(businessCategoryDropDownModel);
        for (int i = 0; i < businessCategoryModel.data.length; i++) {
          businessCategoryDropDownModel = BusinessCategoryDropDownModel(
              id: int.parse(businessCategoryModel.data[i].id),
              value: businessCategoryModel.data[i].name,
              position: i + 1);
          businessCategoryDropDownModelList.add(businessCategoryDropDownModel);
        }
      }else if (value.errorcode == "2") {
        print("logout");
        _sharedPreferences.clear();
           Navigator.of(context).pushNamedAndRemoveUntil(LoginScreen.routeName, (Route<dynamic> route) => false);
        CommonDialogUtil.showErrorSnack(context: context, msg: value.msg);
      }
    }).onError((error, stackTrace) {});
  }

  void getBusinessPackagesApiCAll() {
    ApiImplementer.businessPackagesApiImplementer().then((value) {
      if (value.errorcode == '0') {
        BusinessPackagesModel businessPackagesModel = value;
        businessPackagesList = businessPackagesModel.data;
      }else if (value.errorcode == "2") {
        print("logout");
        _sharedPreferences.clear();
           Navigator.of(context).pushNamedAndRemoveUntil(LoginScreen.routeName, (Route<dynamic> route) => false);
        CommonDialogUtil.showErrorSnack(context: context, msg: value.msg);
      }
    }).onError((error, stackTrace) {});
  }

  void onDateSelected(DateTime dateTime) {
    setState(() {
      _dateTextEditingController.text =
          DateFormat('dd/MM/yyyy').format(dateTime);
    });
  }

  void onImageSelected(File file) {
    // Navigator.of(context).pop();
    _selectedFile = file;
    setState(() {});
  }

  void onImageCaptured(File file) {
    // Navigator.of(context).pop();
    _selectedFile = file;
    setState(() {});
  }

  @override
  void dispose() {
    _firstNameTextEditingController.dispose();
    _lastNameTextEditingController.dispose();
    _emailIdTextEditingController.dispose();
    _mobileNoTextEditingController.dispose();
    _dateTextEditingController.dispose();
    _focusNodeLastNameEmailId.dispose();
    _cityTextEditingController.dispose();
    _focusNodeCity.dispose();
    _userNameTextEditingController.dispose();
    _passwordTextEditingController.dispose();
    _focusNodeUserName.dispose();
    _focusNodePassword.dispose();
    super.dispose();
  }

  bool isValid() {
    if (_selectedFile == null) {
      CommonDialogUtil.showErrorSnack(
          context: context, msg: 'Please upload photo!');
      return false;
    } else if (!_registerFormKey.currentState.validate()) {
      return false;
      // } else if (_selectedGenderPos == 0) {
      //   CommonDialogUtil.showErrorSnack(
      //       context: context, msg: 'Please select gender');
      //   return false;
    } else if (_selectedTypeOfAccountPos == 0) {
      CommonDialogUtil.showErrorSnack(
          context: context, msg: 'Please select account type');
      return false;
    } else if (_selectedTypeOfAccountPos == 2 &&
        _selectedBusinessCategoryPos == 0) {
      CommonDialogUtil.showErrorSnack(
          context: context, msg: 'Please select business category');
      return false;
    } else if (_isAccepted == false) {
      CommonDialogUtil.showErrorSnack(
          context: context, msg: 'Please accept Temrs and Conditions');
      return false;
    }
    return true;
  }

  Future showPremiumUserDialog() {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding:
              EdgeInsets.only(top: 0.0, bottom: 0.0, left: 0.0, right: 0.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
          ),
          content: ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: Column(
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
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Icon(
                              FontAwesomeIcons.solidGem,
                              size: 48.0,
                              color: Colors.white,
                            ),
                            Text(
                              'Premium Account',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14.0,
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
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
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      EdgeInsets.symmetric(vertical: 16.0, horizontal: 18.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 6.0),
                        child: Row(
                          children: [
                            Text(
                              'Plan:',
                              style: TextStyle(
                                fontSize: 13.0,
                              ),
                            ),
                            Spacer(),
                            Text(
                              'Premium',
                              style: TextStyle(
                                fontSize: 13.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 6.0),
                        child: Row(
                          children: [
                            Text(
                              'Plan price:',
                              style: TextStyle(
                                fontSize: 13.0,
                              ),
                            ),
                            Spacer(),
                            Text(
                              '₹500.0',
                              style: TextStyle(
                                fontSize: 13.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 6.0),
                        child: Row(
                          children: [
                            Text(
                              'Plan cycle:',
                              style: TextStyle(
                                fontSize: 13.0,
                              ),
                            ),
                            Spacer(),
                            Text(
                              'Monthly',
                              style: TextStyle(
                                fontSize: 13.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        height: 6.0,
                        color: Colors.black,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 6.0),
                        child: Row(
                          children: [
                            Text(
                              'Total Amount:',
                              style: TextStyle(
                                fontSize: 13.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Spacer(),
                            Text(
                              '₹500.0',
                              style: TextStyle(
                                fontSize: 13.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 8.0),
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                          },
                          icon: Icon(
                            Icons.payment,
                            color: Colors.white,
                          ),
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                                if (states.contains(MaterialState.pressed))
                                  return Theme.of(context)
                                      .colorScheme
                                      .primary
                                      .withOpacity(0.5);
                                return null; // Use the component's default.
                              },
                            ),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                            ),
                          ),
                          label: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 8.0),
                            child: Text('PAY NOW'),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future showBusinessPackagesDialog() {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding:
              EdgeInsets.only(top: 0.0, bottom: 0.0, left: 0.0, right: 0.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
          ),
          content: ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: Column(
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
                      Container(
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
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 200.0,
                  width: 300.0,
                  padding:
                      EdgeInsets.symmetric(vertical: 16.0, horizontal: 18.0),
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
                        onTap: () {},
                        title: Text(businessPackagesList[index].name),
                        subtitle: Text(businessPackagesList[index].duration),
                        trailing: Chip(
                          backgroundColor: CustomColor.colorAccent,
                          label: Text(
                            '₹${businessPackagesList[index].price}',
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
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    TargetPlatform platform = Theme.of(context).platform;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56.0),
        child: CommonAppBar(),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _registerFormKey,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Wrap(
                  alignment: WrapAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 34,bottom: 15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(60.0),
                        color: Colors.blue.withOpacity(0.2),
                      ),
                      height: 90.0,
                      width: 90.0,
                      child: Stack(
                        children: [
                          _selectedFile == null
                              ? Center(
                                  child: Icon(
                                    Icons.person,
                                    size: 60,
                                    color: Colors.blue.withOpacity(0.4),
                                  ),
                                )
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(60.0),
                                  child: Container(
                                    child: Image.file(
                                      _selectedFile,
                                      fit: BoxFit.cover,
                                    ),
                                    height: 90.0,
                                    width: 90.0,
                                  ),
                                ),
                          Container(
                            alignment: Alignment.bottomCenter,
                            margin: EdgeInsets.only(left: 45.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(30.0),
                              child: Card(
                                color: Colors.blue,
                                elevation: 4.0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                                margin: EdgeInsets.zero,
                                child: InkWell(
                                  onTap: () {
                                    PermissionUtil.checkPermission(platform)
                                        .then((hasGranted) {
                                      if (hasGranted != null && hasGranted) {
                                        CommonDialogUtil
                                            .uploadImageCommonModalBottomSheet(
                                          context: context,
                                          picker: picker,
                                          onImageSelected: onImageSelected,
                                          onImageCaptured: onImageCaptured,
                                        );
                                      }
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(6.0),
                                    child: Icon(
                                      _selectedFile == null
                                          ? Icons.camera_alt
                                          : Icons.edit,
                                      color: Colors.white,
                                      size: 28.0,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Container(
                    margin: EdgeInsets.only(bottom: 30.0),
                    child: Center(child: Text('Profile Photo*'))),
                Container(
                  margin: EdgeInsets.only(bottom: 16.0),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 16.0),
                        child: Icon(Icons.person),
                      ),
                      Expanded(
                        child: TextFormField(
                          controller: _firstNameTextEditingController,
                          onFieldSubmitted: (value) {
                            _focusNodeLastNameEmailId.requestFocus();
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter first name';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                              labelText: 'First Name*',
                              hintText: 'First Name',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide(
                                  color: Colors.blue,
                                  width: 2.0,
                                ),
                              )),
                          keyboardType: TextInputType.text,
                        ),
                      ),
                      SizedBox(
                        width: 8.0,
                      ),
                      Expanded(
                        child: TextFormField(
                          controller: _lastNameTextEditingController,
                          focusNode: _focusNodeLastNameEmailId,
                          onFieldSubmitted: (value) {
                            _focusNodeEmailId.requestFocus();
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter last name';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                              labelText: 'Last Name*',
                              hintText: 'Last Name',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide(
                                  color: Colors.blue,
                                  width: 2.0,
                                ),
                              )),
                          keyboardType: TextInputType.text,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 16.0),
                  child: TextFormField(
                    controller: _emailIdTextEditingController,
                    focusNode: _focusNodeEmailId,
                    onFieldSubmitted: (value) {
                      _focusNodeMobileNo.requestFocus();
                    },
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter emailId';
                      } else if (!value.contains('@')) {
                        return 'Please enter  valid email address';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        labelText: 'Email-Id*',
                        hintText: 'Enter emailId',
                        icon: Icon(Icons.email),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(
                            color: Colors.blue,
                            width: 2.0,
                          ),
                        )),
                    keyboardType: TextInputType.emailAddress,
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 16.0),
                  child: TextFormField(
                    controller: _mobileNoTextEditingController,
                    focusNode: _focusNodeMobileNo,
                    onFieldSubmitted: (value) {
                      _focusNodeDate.requestFocus();
                    },
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter mobile number.';
                      } else if (value.length != 10) {
                        return 'Please enter  valid mobile number.';
                      }
                      return null;
                    },
                    maxLength: 10,
                    decoration: InputDecoration(
                        labelText: 'Mobile No*',
                        hintText: 'Enter mobile no.',
                        counterText: '',
                        icon: Icon(Icons.phone),
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 4.0, horizontal: 10.0),
                        prefix: CountryCodePicker(
                          padding: EdgeInsets.zero,
                          onChanged: (countryCode) {
                            selectedCountryCode = countryCode.toString();
                            _focusNodeMobileNo.requestFocus();
                          },
                          initialSelection: 'IN',
                          showFlag: false,
                          showCountryOnly: false,
                          showOnlyCountryWhenClosed: false,
                          alignLeft: false,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(
                            color: Colors.blue,
                            width: 2.0,
                          ),
                        )),
                    keyboardType: TextInputType.phone,
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 16.0),
                  child: TextFormField(
                    controller: _dateTextEditingController,
                    focusNode: _focusNodeDate,
                    onFieldSubmitted: (value) {
                      _focusNodeCity.requestFocus();
                    },
                    // validator: (value) {
                    //   if (value.isEmpty) {
                    //     return 'Please select your DOB';
                    //   }
                    //   return null;
                    // },
                    onTap: () {
                      CommonDialogUtil.showCommonDatePicker(
                          context: context,
                          onDateSelected: onDateSelected,
                          firstDateYear: 1960,
                          lastDateYear: 2022);
                    },
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: 'Select DOB*',
                      hintText: 'dd/MM/yyy',
                      icon: Icon(Icons.calendar_today),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(
                          color: Colors.blue,
                          width: 2.0,
                        ),
                      ),
                    ),
                    keyboardType: TextInputType.text,
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 16.0),
                  child: TextFormField(
                    controller: _cityTextEditingController,
                    focusNode: _focusNodeCity,
                    // inputFormatters: [ WhitelistingTextInputFormatter(RegExp("[a-zA-Z]")),],
                    inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[a-zA-Z]')),],
                    onFieldSubmitted: (value) {
                      _focusNodeUserName.requestFocus();
                    },
                    // validator: (value) {
                    //   if (value.isEmpty) {
                    //     return 'Please enter city name';
                    //   }
                    //   return null;
                    // },
                    decoration: InputDecoration(
                        labelText: 'City Name*',
                        hintText: 'Enter City Name.',
                        counterText: '',
                        icon: Icon(Icons.location_city),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(
                            color: Colors.blue,
                            width: 2.0,
                          ),
                        )),
                    keyboardType: TextInputType.text,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    top: 16.0,
                    bottom: 16.0,
                    left: 38.0,
                  ),
                  padding: const EdgeInsets.symmetric(
                      vertical: 2.0, horizontal: 12.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(width: 1.0, color: Colors.grey),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton(
                      value: _selectedGenderPos,
                      onChanged: (position) {
                        FocusScope.of(context).requestFocus(new FocusNode());
                        setState(() {
                          _selectedGenderPos = position;
                        });
                      },
                      items: [
                        ...genderDropDownModelList
                            .map(
                              (e) => DropdownMenuItem(
                                child: Text(
                                  '${e.value}',
                                ),
                                value: e.position,
                              ),
                            )
                            .toList(),
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 16.0),
                  child: TextFormField(
                    controller: _userNameTextEditingController,
                    focusNode: _focusNodeUserName,
                    onFieldSubmitted: (value) {
                      _focusNodePassword.requestFocus();
                    },
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter username';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        labelText: 'User Name*',
                        hintText: 'Enter User Name.',
                        counterText: '',
                        icon: Icon(Icons.person),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(
                            color: Colors.blue,
                            width: 2.0,
                          ),
                        )),
                    keyboardType: TextInputType.text,
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 16.0),
                  child: Obx(() => TextFormField(
                        controller: _passwordTextEditingController,
                        focusNode: _focusNodePassword,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter password';
                          } else if (value.length < 7) {
                            return 'Password must be greater than 7 character long!';
                          }
                          return null;
                        },
                        obscureText: _obscureText.value,
                        decoration: InputDecoration(
                          labelText: 'Password*',
                          hintText: 'Enter password',
                          counterText: '',
                          icon: Icon(Icons.lock),
                          suffix: InkWell(
                            onTap: () =>
                                _obscureText.value = !_obscureText.value,
                            child: Icon(
                              _obscureText.value
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.grey,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(
                              color: Colors.blue,
                              width: 2.0,
                            ),
                          ),
                        ),
                        keyboardType: TextInputType.text,
                      )),
                ),
                Container(
                  margin: EdgeInsets.only(
                    top: 16.0,
                    bottom: 16.0,
                    left: 38.0,
                  ),
                  padding: const EdgeInsets.symmetric(
                      vertical: 2.0, horizontal: 12.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(width: 1.0, color: Colors.grey),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton(
                      value: _selectedTypeOfAccountPos,
                      onChanged: (position) {
                        FocusScope.of(context).requestFocus(new FocusNode());
                        setState(() {
                          _selectedTypeOfAccountPos = position;
                        });
                      },
                      items: [
                        ...typeOfAccountDropDownModelList
                            .map(
                              (e) => DropdownMenuItem(
                                child: Text(
                                  '${e.value}',
                                ),
                                value: e.position,
                              ),
                            )
                            .toList(),
                      ],
                    ),
                  ),
                ),
                if (_selectedTypeOfAccountPos == 2||_selectedTypeOfAccountPos == 3)
                  Container(
                    margin: EdgeInsets.only(
                      top: 16.0,
                      bottom: 16.0,
                      left: 38.0,
                    ),
                    padding: const EdgeInsets.symmetric(
                        vertical: 2.0, horizontal: 12.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(width: 1.0, color: Colors.grey),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton(
                        value: _selectedBusinessCategoryPos,
                        onChanged: (position) {
                          FocusScope.of(context).requestFocus(new FocusNode());
                          setState(() {
                            _selectedBusinessCategoryPos = position;
                          });
                        },
                        items: [
                          ...businessCategoryDropDownModelList
                              .map(
                                (e) => DropdownMenuItem(
                                  child: Text(
                                    '${e.value}',
                                  ),
                                  value: e.position,
                                ),
                              )
                              .toList(),
                        ],
                      ),
                    ),
                  ),
                Container(
                  padding: EdgeInsets.only(left: 12.0),
                  child: ListTile(
                    title: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text: 'By proceeding further you are agreeing with our',
                        style: TextStyle(
                          color: Colors.black,
                        ),
                        children: [
                          TextSpan(
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => print('sdf'),
                            text: ' Terms & Conditions ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(text: 'and'),
                          TextSpan(
                            text: ' Privacy Policy ',
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => print('sdf'),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    leading: Checkbox(
                      value: _isAccepted,
                      onChanged: (value) {
                        setState(() {
                          _isAccepted = !_isAccepted;
                        });
                      },
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 38.0),
                  child: InkWell(
                    onTap: () {
                      if (isValid()) {
                        String first_name =
                            _firstNameTextEditingController.text;
                        String last_name = _lastNameTextEditingController.text;
                        int selectedGender =
                            genderDropDownModelList[_selectedGenderPos].id;
                        String phone_number = '$selectedCountryCode'.trim() +
                            '${_mobileNoTextEditingController.text.trim()}';
                        String dob = _dateTextEditingController.text;
                        String email = _emailIdTextEditingController.text;
                        String username = _userNameTextEditingController.text;
                        String password = _passwordTextEditingController.text;
                        double latitude = 29.94;
                        double longitude = -95.35;
                        String city = _cityTextEditingController.text;
                        int account_type = typeOfAccountDropDownModelList[
                                _selectedTypeOfAccountPos]
                            .id;
                        int terms_and_conditions = _isAccepted ? 1 : 0;
                        Uint8List bytes = _selectedFile.readAsBytesSync();
                        String profile_image = base64.encode(bytes);
                        catId=account_type==1?businessCategoryDropDownModelList[_selectedBusinessCategoryPos].id.toString():"";
                        CommonDialogUtil.showProgressDialog(
                            context, 'Please wait...');
                        ApiImplementer.registerApiImplementer(
                          first_name: first_name,
                          last_name: last_name,
                          gender: selectedGender,
                          phone_number: phone_number,
                          dob: dob,
                          email: email,
                          username: username,
                          password: password,
                          latitude: latitude,
                          longitude: longitude,
                          city: city,
                          catId: catId,
                          account_type: account_type,
                          terms_and_conditions: terms_and_conditions,
                          profile_image: profile_image,
                        ).then((value) {
                          Navigator.of(context).pop();
                          RegisterModel registerModel = value;
                          if (registerModel.errorcode == '0') {
                            CommonDialogUtil.showSuccessSnack(
                                context: context, msg: registerModel.msg);
                            Navigator.of(context).pop();
                            /* if (_selectedTypeOfAccountPos == 1) {
                              Navigator.of(context).pop();
                            } else if (_selectedTypeOfAccountPos == 2) {
                              // showBusinessPackagesDialog();

                              // } else if (_selectedTypeOfAccountPos == 3) {
                              //   showPremiumUserDialog();
                            }*/
                          } else {
                            CommonDialogUtil.showErrorSnack(
                                context: context, msg: registerModel.msg);
                          }
                        }).onError((error, stackTrace) {
                          Navigator.of(context).pop();
                          print(stackTrace.toString());
                          CommonDialogUtil.showErrorSnack(
                              context: context, msg: error.toString());
                        });
                      }
                    },
                    child: CommonGradiantButton(
                      title: 'REGISTER',
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
