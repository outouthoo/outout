import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:image_picker/image_picker.dart';
import 'package:out_out/pages/memory_page/memory_page.dart';
import 'package:out_out/providers/common_details_provider.dart';
import 'package:out_out/utils/common_dialog_util.dart';
import 'package:out_out/utils/icon_utils.dart';
import 'package:out_out/utils/permission_util.dart';
import 'package:out_out/utils/preferences_constants.dart';
import 'package:out_out/widget/common_gradiant_btn.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'api/api_implementer.dart';

class advertisement extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
 return advertisement_state();
  }

}
class advertisement_state extends State<advertisement>{

  final _emailIdTextEditingController = TextEditingController();
  final _mobileNoTextEditingController = TextEditingController();

  final _dateTextEditingController = TextEditingController();
  final _focusNodeEmailId = FocusNode();
  final _focusNodeMobileNo = FocusNode();
  final _focusNodeDate = FocusNode();
  final _focusNodeCity = FocusNode();
  final picker = ImagePicker();
  File  _selectedFile;
  SharedPreferences _sharedPreferences;
  bool _isLoading = false;
  RxString _profileUrl = ''.obs;
  RxString _userName = ''.obs;
  RxString _city = ''.obs;
  RxString _birthDate = ''.obs;
  String _accessToken = '';
  String _userId = '';
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
  void didChangeDependencies() {
    if (!_isLoading) {


      _sharedPreferences = Provider.of<CommonDetailsProvider>(context).getPreferencesInstance;
      _profileUrl.value =
          _sharedPreferences.get(PreferenceConstants.PROFILE_IMAGE);
      _userName.value =
      '${_sharedPreferences.get(PreferenceConstants.FIRST_NAME)} ${_sharedPreferences.get(PreferenceConstants.LAST_NAME)}';
      _city.value = _sharedPreferences.get(PreferenceConstants.CITY);
      _birthDate.value = _sharedPreferences.get(PreferenceConstants.DOB);
      _accessToken = _sharedPreferences.get(PreferenceConstants.ACCESS_TOKEN);
      _userId = _sharedPreferences.get(PreferenceConstants.USER_ID);
      print("mohit");
      print(_userId);

    }
    _isLoading = true;
    super.didChangeDependencies();

  }
  @override
  Widget build(BuildContext context) {
    TargetPlatform platform = Theme.of(context).platform;
   return Scaffold(
     appBar:  AppBar(
       centerTitle: true,
       backgroundColor: Colors.black,
       elevation: 0.0,
       automaticallyImplyLeading: false,
       leading: IconButton(
         icon: Icon(
           Icons.arrow_back_ios,
           color: Colors.white,
         ),
         onPressed: () {
           Navigator.of(context).pushNamed(MemoryPage.routeName);
         },
       ),
       title: Container(height: 70,
           child: Image.asset(out_out_actionbar)),
       actions: [

       ],
     ),
     body:SingleChildScrollView(
       child: Form(
       //  key: _registerFormKey,
         child: Container(
           margin: EdgeInsets.symmetric(horizontal: 16.0),
           child: Column(
             mainAxisAlignment: MainAxisAlignment.center,
             crossAxisAlignment: CrossAxisAlignment.stretch,
             children: [
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
                       labelText: 'Title',
                       hintText: 'Title',
                       icon: Icon(Icons.title),
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
                 child: TextFormField(maxLines: 7,
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
                       labelText: 'Desc',
                       hintText: 'Desc.....',
                       counterText: '',
                       icon: Icon(Icons.description),
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
               ),
               Container(
                 margin: EdgeInsets.symmetric(vertical: 16.0),
                 child: TextFormField(
                   controller: _dateTextEditingController,
                   focusNode: _focusNodeDate,
                   onFieldSubmitted: (value) {
                     _focusNodeCity.requestFocus();
                   },
                   validator: (value) {
                     if (value.isEmpty) {
                       return 'Shedule ';
                     }
                     return null;
                   },
                   onTap: () {
                     CommonDialogUtil.showCommonDatePicker(
                         context: context,
                       //  onDateSelected: onDateSelected,
                         firstDateYear: 1960,
                         lastDateYear: 2022);
                   },
                   readOnly: true,
                   decoration: InputDecoration(
                     labelText: 'Shedule on',
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
                Wrap(
                 alignment: WrapAlignment.center,
                 children: [ InkWell(
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
                   child:
                   Container(
                     margin: EdgeInsets.symmetric(vertical: 34.0),
                     decoration: BoxDecoration(
                       borderRadius: BorderRadius.circular(60.0),
                       color: Colors.blue.withOpacity(0.2),
                     ),
                     height: 190.0,
                     width: 310.0,
                     child: Stack(
                       children: [
                         _selectedFile == null
                             ? Center(
                           child: Icon(
                             Icons.image,
                             size: 80,
                             color: Colors.blue.withOpacity(0.4),
                           ),
                         )
                             : ClipRRect(
                           borderRadius: BorderRadius.circular(10.0),
                           child: Container(
                             child: Image.file(
                               _selectedFile,
                               fit: BoxFit.cover,
                             ),
                             height: 190.0,
                             width: 310.0,
                           ),
                         ),
                         Container(
                           alignment: Alignment.bottomCenter,
                           margin: EdgeInsets.only(left: 45.0),
                           child: ClipRRect(
                             borderRadius: BorderRadius.circular(30.0),

                           ),
                         ),
                       ],
                     ),
                   )),
                 ],
               ),
               Container(
                 margin: EdgeInsets.symmetric(vertical: 28.0),
                 child: InkWell(
                   onTap: () {



                     String phone_number =
                         '${_mobileNoTextEditingController.text.trim()}';
                     String dob = _dateTextEditingController.text;
                     String email = _emailIdTextEditingController.text;



                    Uint8List bytes = _selectedFile.readAsBytesSync();
                     String profile_image = base64.encode(bytes);

                     CommonDialogUtil.showProgressDialog(
                         context, 'Please wait...');
                     ApiImplementer.AdvertApiImplementer(accessToken:_accessToken ,title:email ,desc:phone_number ,
                       userid: _userId,


                       file: profile_image,
                     ).then((value) {
                       Navigator.of(context).pop();

                     }).onError((error, stackTrace) {
                       Navigator.of(context).pop();
                       print(stackTrace.toString());
                       CommonDialogUtil.showErrorSnack(
                           context: context, msg: error.toString());
                     });



















                   },



                   child: Padding(
                     padding: const EdgeInsets.symmetric(horizontal: 28.0),
                     child: Center(
                       child: CommonGradiantButton(
                         title: 'Save',
                       ),
                     ),
                   ),
                 ),
               ),
             ],
           ),
         ),
       ),
     )
   );
  }

}