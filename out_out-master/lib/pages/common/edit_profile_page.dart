import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:out_out/api/api_implementer.dart';
import 'package:out_out/coutry_code_picker/country_code_picker.dart';
import 'package:out_out/models/business_category_model.dart';
import 'package:out_out/models/drop_down_model/business_category_model.dart';
import 'package:out_out/models/drop_down_model/gender_model.dart';
import 'package:out_out/models/drop_down_model/type_of_account_model.dart';
import 'package:out_out/models/update_profile_model.dart' as updateProfile;
import 'package:out_out/providers/common_details_provider.dart';
import 'package:out_out/utils/common_dialog_util.dart';
import 'package:out_out/utils/permission_util.dart';
import 'package:out_out/utils/preferences_constants.dart';
import 'package:out_out/widget/common_app_bar.dart';
import 'package:out_out/widget/common_gradiant_btn.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../datevalidation.dart';
import 'login_page.dart';

// enum GenderSelection { Male, FeMale,Other }

class EditProfilePage extends StatefulWidget {
  static const routeName = '/edit-profile-page';

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  SharedPreferences _sharedPreferences;

  final _registerFormKey = GlobalKey<FormState>();
  final _firstNameTextEditingController = TextEditingController();
  final _lastNameTextEditingController = TextEditingController();
  final _emailIdTextEditingController = TextEditingController();
  final _mobileNoTextEditingController = TextEditingController();
  final _webTextEditingController = TextEditingController();
  final _bioTextEditingController = TextEditingController();
  final _cityTextEditingController = TextEditingController();
  final _dateTextEditingController = TextEditingController();
  final _banknameController = TextEditingController();
  final _accountholderController = TextEditingController();
  final _swiftController = TextEditingController();
  final _bankcodeController = TextEditingController();
  final _accountnoController = TextEditingController();
  final _focusNodeLastNameEmailId = FocusNode();
  final _focusNodeEmailId = FocusNode();
  final _focusNodeBioNo = FocusNode();
  final _focusNodeWebsite = FocusNode();
  final _focusNodeMobileNo = FocusNode();
  final _focusNodeDate = FocusNode();
  final _focusNodeCity = FocusNode();
  final _focusNodeBankName = FocusNode();
  final _focusNodeBankAc = FocusNode();
  final _focusNodeBankACHolder = FocusNode();
  final _focusNodeBankCode = FocusNode();
  final _focusNodeSwiftCode = FocusNode();
  final picker = ImagePicker();

  // GenderSelection gender = GenderSelection.Male;
  bool _isAccepted = true;
  File _selectedFile = null;
  bool _isLoaded = false;
  List<TypeOfAccountDropDownModel> typeOfAccountDropDownModelList = [];
  int _selectedTypeOfAccountPos = 0;

  List<BusinessCategoryDropDownModel> businessCategoryDropDownModelList = [];
  int _selectedBusinessCategoryPos = 0;

  List<GenderDropDownModel> genderDropDownModelList = [];
  int _selectedGenderPos = 0;

  String selectedCountryCode = '+91';

  @override
  void initState() {
    getBusinessCategoryApiCall();
    addStaticAccountData();
    addStaticGenderData();
    super.initState();
  }

  void addStaticAccountData() {
    TypeOfAccountDropDownModel typeOfAccountSelect = TypeOfAccountDropDownModel(
        id: 0, value: 'Select Account Type', position: 0);
    typeOfAccountDropDownModelList.add(typeOfAccountSelect);
    TypeOfAccountDropDownModel typeOfAccountNormal =
    TypeOfAccountDropDownModel(id: 0, value: 'Normal Account', position: 1);
    typeOfAccountDropDownModelList.add(typeOfAccountNormal);
    TypeOfAccountDropDownModel typeOfAccountBusiness =
    TypeOfAccountDropDownModel(
        id: 1, value: 'Business Account', position: 2);
    typeOfAccountDropDownModelList.add(typeOfAccountBusiness);
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
            id: 0, value: 'Select Business Category', position: 0);
        businessCategoryDropDownModelList.add(businessCategoryDropDownModel);
        for (int i = 0; i < businessCategoryModel.data.length; i++) {
          businessCategoryDropDownModel = BusinessCategoryDropDownModel(
              id: int.parse(businessCategoryModel.data[i].id),
              value: businessCategoryModel.data[i].name,
              position: i + 1);
          businessCategoryDropDownModelList.add(businessCategoryDropDownModel);
        }
      } else if (value.errorcode == "2") {
        print("logout");
        _sharedPreferences.clear();
           Navigator.of(context).pushNamedAndRemoveUntil(LoginScreen.routeName, (Route<dynamic> route) => false);
        CommonDialogUtil.showErrorSnack(context: context, msg: value.msg);
      }
    }).onError((error, stackTrace) {});
  }

  @override
  void didChangeDependencies() {
    if (!_isLoaded) {
      _sharedPreferences =
          Provider
              .of<CommonDetailsProvider>(context, listen: false)
              .getPreferencesInstance;
      _firstNameTextEditingController.text =
          _sharedPreferences.getString(PreferenceConstants.FIRST_NAME);
      _lastNameTextEditingController.text =
          _sharedPreferences.getString(PreferenceConstants.LAST_NAME);
      _emailIdTextEditingController.text =
          _sharedPreferences.getString(PreferenceConstants.EMAIL_ID);
      _mobileNoTextEditingController.text =
          _sharedPreferences.getString(PreferenceConstants.MOBILE_NO);
      _cityTextEditingController.text =
          _sharedPreferences.getString(PreferenceConstants.CITY);
      _dateTextEditingController.text =
          _sharedPreferences.getString(PreferenceConstants.DOB);
      _webTextEditingController.text =
          _sharedPreferences.getString(PreferenceConstants.WEBSITE);
      _bioTextEditingController.text =
          _sharedPreferences.getString(PreferenceConstants.Bio);
      String genderSt =
      _sharedPreferences.getString(PreferenceConstants.GENDER);
      _selectedGenderPos = (genderSt == null || genderSt.isEmpty)
          ? 0
          : int.parse(_sharedPreferences.getString(PreferenceConstants.GENDER));
      _selectedTypeOfAccountPos = int.parse(
          _sharedPreferences.getString(PreferenceConstants.ACCOUNT_TYPE)) +
          1;
      setState(() {});
    }
    _isLoaded = true;
    super.didChangeDependencies();
  }

  void setUserLoginDetails(
      {@required updateProfile.UpdateProfileModel updateProfileModel}) {
    updateProfile.Data userDetails = updateProfileModel.data[0];

    _sharedPreferences.setString(
        PreferenceConstants.USER_NAME, userDetails.username);
    _sharedPreferences.setString(PreferenceConstants.USER_ID, userDetails.id);
    _sharedPreferences.setString(
        PreferenceConstants.FIRST_NAME, userDetails.firstName);
    _sharedPreferences.setString(
        PreferenceConstants.LAST_NAME, userDetails.lastName);
    _sharedPreferences.setString(PreferenceConstants.DOB, userDetails.dob);
    _sharedPreferences.setString(
        PreferenceConstants.GENDER, userDetails.gender);
    _sharedPreferences.setString(
        PreferenceConstants.MOBILE_NO, userDetails.phoneNumber);
    _sharedPreferences.setString(
        PreferenceConstants.EMAIL_ID, userDetails.email);
    _sharedPreferences.setString(
        PreferenceConstants.ACCOUNT_TYPE, userDetails.accountType);
    _sharedPreferences.setString(PreferenceConstants.LAT, userDetails.latitude);
    _sharedPreferences.setString(
        PreferenceConstants.LONG, userDetails.longitude);
    _sharedPreferences.setString(PreferenceConstants.CITY, userDetails.city);
    _sharedPreferences.setString(
        PreferenceConstants.PROFILE_IMAGE, userDetails.profileImage);
    _sharedPreferences.setString(
        PreferenceConstants.IS_VERIFIED, userDetails.isVerified);
    _sharedPreferences.setString(PreferenceConstants.IS_VIP, userDetails.isVIP);
    Provider.of<CommonDetailsProvider>(context, listen: false).initUser();
  }

  void onDateSelected(DateTime dateTime) {
    setState(() {
      _dateTextEditingController.text =
          DateFormat('dd/MM/yyyy').format(dateTime);
    });
  }

  void onImageSelected(File file) {
    Navigator.of(context).pop();
    _selectedFile = file;
    setState(() {});
  }

  void onImageCaptured(File file) {
    Navigator.of(context).pop();
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
    super.dispose();
  }

  bool isValid() {
    // if (_selectedFile == null) {
    //   CommonDialogUtil.showErrorSnack(
    //       context: context, msg: 'Please upload photo!');
    //   return false;
    // } else
    if (!_registerFormKey.currentState.validate()) {
      return false;
      // } else if (_selectedGenderPos == 0) {
      //   CommonDialogUtil.showErrorSnack(
      //       context: context, msg: 'Please select gender');
      //   return false;
    } else if (_isAccepted == false) {
      CommonDialogUtil.showErrorSnack(
          context: context, msg: 'Please accept Temrs and Conditions');
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    TargetPlatform platform = Theme
        .of(context)
        .platform;
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
                      margin: EdgeInsets.symmetric(vertical: 34.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(60.0),
                        color: Colors.blue.withOpacity(0.2),
                      ),
                      height: 90.0,
                      width: 90.0,
                      child: Stack(
                        children: [
                          _selectedFile == null
                              ? CircleAvatar(
                            radius: 45.0,
                            backgroundImage: NetworkImage(
                              _sharedPreferences.getString(
                                  PreferenceConstants.PROFILE_IMAGE),
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
                              labelText: 'First Name',
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
                              labelText: 'Last Name',
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
                      _focusNodeWebsite.requestFocus();
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
                        labelText: 'Email-Id',
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
                    controller: _webTextEditingController,
                    focusNode: _focusNodeWebsite,
                    onFieldSubmitted: (value) {
                      _focusNodeBioNo.requestFocus();
                    },
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter website url';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        labelText: 'Website',
                        hintText: 'Enter Website',
                        counterText: '',
                        icon: Icon(Icons.web_sharp),
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 4.0, horizontal: 10.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(
                            color: Colors.blue,
                            width: 2.0,
                          ),
                        )),
                    keyboardType: TextInputType.url,
                  ),
                ),Container(
                  margin: EdgeInsets.symmetric(vertical: 16.0),
                  child: TextFormField(
                    controller: _bioTextEditingController,
                    focusNode: _focusNodeBioNo,
                    onFieldSubmitted: (value) {
                      _focusNodeMobileNo.requestFocus();
                    },
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter bio';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        labelText: 'Bio',
                        hintText: 'Enter Bio',
                        counterText: '',
                        icon: Icon(Icons.edit),
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 4.0, horizontal: 10.0),

                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(
                            color: Colors.blue,
                            width: 2.0,
                          ),
                        )),
                    keyboardType: TextInputType.text,
                  ),
                ),Container(
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
                        labelText: 'Mobile No',
                        hintText: 'Enter mobile no.',
                        counterText: '',
                        icon: Icon(Icons.phone),
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 4.0, horizontal: 10.0),
                        prefix: CountryCodePicker(
                          padding: EdgeInsets.zero,
                          onChanged: (countryCode) {
                            selectedCountryCode = countryCode.toString();
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
                      labelText: 'Select DOB',
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
                    // onFieldSubmitted: (value) {
                    //   _focusNodeUserName.requestFocus();
                    // },
                    // validator: (value) {
                    //   if (value.isEmpty) {
                    //     return 'Please enter city name';
                    //   }
                    //   return null;
                    // },
                    decoration: InputDecoration(
                        labelText: 'City Name',
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
                        setState(() {
                          _selectedGenderPos = position;
                        });
                      },
                      items: [
                        ...genderDropDownModelList
                            .map(
                              (e) =>
                              DropdownMenuItem(
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
                checkDateIsToday()
                    ? Container(
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
                        setState(() {
                          _selectedTypeOfAccountPos = position;
                        });
                      },
                      items: [
                        ...typeOfAccountDropDownModelList
                            .map(
                              (e) =>
                              DropdownMenuItem(
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
                ) : Container(),
                checkDateIsToday()
                    ? _selectedTypeOfAccountPos == 2
                    ? Container(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width * 0.70,
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                          top: 16.0,
                          bottom: 16.0,
                          left: 38.0,
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 2.0, horizontal: 12.0),
                        child: TextFormField(
                          controller: _banknameController,
                          focusNode: _focusNodeBankName,
                          onFieldSubmitted: (value) {
                            _focusNodeBankAc.requestFocus();
                          },
                          decoration: InputDecoration(
                              labelText: 'Bank Name',
                              hintText: 'Bank Name',
                              border: OutlineInputBorder(
                                borderRadius:
                                BorderRadius.circular(10.0),
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
                        child: TextFormField(
                          controller: _accountnoController,
                          focusNode: _focusNodeBankAc,
                          onFieldSubmitted: (value) {
                            _focusNodeBankACHolder.requestFocus();
                          },
                          decoration: InputDecoration(
                              labelText: 'Account No.',
                              hintText: 'Account No.',
                              border: OutlineInputBorder(
                                borderRadius:
                                BorderRadius.circular(10.0),
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
                        child: TextFormField(
                          controller: _accountholderController,
                          focusNode: _focusNodeBankACHolder,
                          onFieldSubmitted: (value) {
                            _focusNodeBankCode.requestFocus();
                          },
                          decoration: InputDecoration(
                              labelText: 'Account Holder',
                              hintText: 'Account Holder',
                              border: OutlineInputBorder(
                                borderRadius:
                                BorderRadius.circular(10.0),
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
                        child: TextFormField(
                          controller: _bankcodeController,
                          focusNode: _focusNodeSwiftCode,
                          onFieldSubmitted: (value) {
                            // _focusNodeMobileNo.requestFocus();
                            _focusNodeSwiftCode.requestFocus();
                          },
                          decoration: InputDecoration(
                              labelText: 'Bank Code',
                              hintText: 'Bank Code',
                              border: OutlineInputBorder(
                                borderRadius:
                                BorderRadius.circular(10.0),
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
                        child: TextFormField(
                          controller: _swiftController,
                          focusNode: _focusNodeSwiftCode,
                          onFieldSubmitted: (value) {
                            // _focusNodeMobileNo.requestFocus();
                          },
                          decoration: InputDecoration(
                              labelText: 'Swift Code',
                              hintText: 'Swift Code',
                              border: OutlineInputBorder(
                                borderRadius:
                                BorderRadius.circular(10.0),
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
                )
                    : Container()
                    : Container(),
                checkDateIsToday()
                    ? Container(
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
                        setState(() {
                          _selectedBusinessCategoryPos = position;
                        });
                      },
                      items: [
                        ...businessCategoryDropDownModelList
                            .map(
                              (e) =>
                              DropdownMenuItem(
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
                ) : Container(),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 38.0),
                  child: InkWell(
                    onTap: () {
                      // if (_selectedTypeOfAccountPos == 2) {
                      //   Navigator.of(context).push(MaterialPageRoute(
                      //     builder: (context) => Packages(),
                      //   ));
                      // } else if (_selectedTypeOfAccountPos == 3) {
                      //   Navigator.of(context).push(MaterialPageRoute(
                      //     builder: (context) => Packages(),
                      //   ));
                      // } else {
                      if (isValid()) {
                        String first_name =
                            _firstNameTextEditingController.text;
                        String last_name = _lastNameTextEditingController.text;
                        int selectedGender =
                            genderDropDownModelList[_selectedGenderPos].id;
                        String phone_number = '$selectedCountryCode' +
                            '${_mobileNoTextEditingController.text}';
                        String dob = _dateTextEditingController.text;
                        String email = _emailIdTextEditingController.text;
                        double latitude = 29.94;
                        double longitude = -95.35;
                        String city = _cityTextEditingController.text;
                        int account_type = typeOfAccountDropDownModelList[
                        _selectedTypeOfAccountPos]
                            .id;
                        int terms_and_conditions = _isAccepted ? 1 : 0;
                        String website =  _webTextEditingController.text;
                        String bio =  _bioTextEditingController.text;
                        String profile_image = '';
                        if (_selectedFile != null) {
                          Uint8List bytes = _selectedFile.readAsBytesSync();
                          profile_image = base64.encode(bytes);
                        }
                        CommonDialogUtil.showProgressDialog(
                            context, 'Please wait...');
                        ApiImplementer.updateProfileApiImplementer(
                            accessToken: _sharedPreferences
                                .get(PreferenceConstants.ACCESS_TOKEN),
                            userid: _sharedPreferences
                                .get(PreferenceConstants.USER_ID), username: _sharedPreferences
                                .get(PreferenceConstants.USER_NAME),
                            first_name: first_name,
                            last_name: last_name,
                            gender: selectedGender,
                            phone_number: phone_number,
                            dob: dob,
                            email: email,
                            latitude: latitude,
                            longitude: longitude,
                            city: city,
                            account_holder:
                            _accountholderController.text.trim(),
                            account_no: _accountnoController.text,
                            bank_code: _bankcodeController.text,
                            bank_name: _banknameController.text.trim(),
                            swift_code: _swiftController.text.trim(),
                            account_type: account_type,
                            terms_and_conditions: terms_and_conditions,
                            website:website,
                            bio:bio,
                            profile_image: profile_image)
                            .then((value) {
                          Navigator.of(context).pop();
                          updateProfile.UpdateProfileModel updateProfileModel =
                              value;
                          if (updateProfileModel.errorcode == '0') {
                            setUserLoginDetails(
                                updateProfileModel: updateProfileModel);
                            CommonDialogUtil.showSuccessSnack(
                                context: context, msg: updateProfileModel.msg);
                            Navigator.of(context).pop(true);
                          } else if (updateProfileModel.errorcode == "2") {
                            print("logout");
                            _sharedPreferences.clear();
                            Navigator.of(context)
                                .pushReplacementNamed(LoginScreen.routeName);
                            CommonDialogUtil.showErrorSnack(
                                context: context, msg: updateProfileModel.msg);
                          } else {
                            CommonDialogUtil.showErrorSnack(
                                context: context, msg: updateProfileModel.msg);
                          }
                        }).onError((error, stackTrace) {
                          Navigator.of(context).pop();
                          print(stackTrace.toString());
                          CommonDialogUtil.showErrorSnack(
                              context: context, msg: error.toString());
                        });
                      }
                      // }
                    },
                    child: CommonGradiantButton(
                      title: 'UPDATE',
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
