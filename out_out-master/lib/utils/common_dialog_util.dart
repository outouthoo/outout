import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:out_out/flutter_emoji_keyboard/src/emoji_keyboard_widget.dart';
import 'package:out_out/utils/commona_utils.dart';
import 'package:out_out/utils/custom_colors.dart';
import 'package:out_out/widget/login_with_otp.dart';

class CommonDialogUtil {
  static void selectedImageFromGallery({
    @required BuildContext context,
    @required ImagePicker picker,
    @required Function onImageSelected,
  }) async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    File selectedFile = File(pickedFile.path);
    if (selectedFile != null) {
      onImageSelected(selectedFile);
    }
  }

  static void selectedVideoFromGallery({
    @required BuildContext context,
    @required ImagePicker picker,
    @required Function onVideoSelected,
  }) async {
    final pickedFile = await picker.getVideo(source: ImageSource.gallery);
    File selectedFile = File(pickedFile.path);
    if (selectedFile != null) {
      onVideoSelected(selectedFile);
    }
  }

  static void selectImageOrVideoFromGalleryBottomSheet({
    @required BuildContext context,
    @required ImagePicker picker,
    @required Function onImageSelected,
    @required Function onVideoSelected,
  }) {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16.0),
            topRight: Radius.circular(16.0),
          ),
        ),
        backgroundColor: Colors.white,
        builder: (BuildContext bc) {
          return Container(
            padding: EdgeInsets.all(16.0),
            child: new Wrap(
              children: <Widget>[
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 10.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.0),
                          border: Border.all(
                            color: Colors.blue,
                          ),
                        ),
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                            CommonDialogUtil.selectImageFromGallary(
                              context: context,
                              picker: picker,
                              onImageSelected: onImageSelected,
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 8.0,
                            ),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.photo,
                                  size: 50.0,
                                  color: Colors.blue,
                                ),
                                SizedBox(
                                  height: 8.0,
                                ),
                                Text(
                                  'Select Photos',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.blue,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 10.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.0),
                          border: Border.all(
                            color: Colors.blue,
                          ),
                        ),
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                            CommonDialogUtil.selectedVideoFromGallery(
                              context: context,
                              picker: picker,
                              onVideoSelected: onVideoSelected,
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.videocam_rounded,
                                  size: 50.0,
                                  color: Colors.blue,
                                ),
                                SizedBox(
                                  height: 8.0,
                                ),
                                Text(
                                  'Select Videos',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.blue,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        });
  }

  static void uploadImageAndVideoFromCameraOrGalleryCommonModalBottomSheet({
    @required BuildContext context,
    @required ImagePicker picker,
    @required Function onCameraTap,
    @required Function onImageSelected,
    @required Function onVideoSelected,
  }) {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16.0),
            topRight: Radius.circular(16.0),
          ),
        ),
        backgroundColor: Colors.white,
        builder: (BuildContext bc) {
          return Container(
            padding: EdgeInsets.all(16.0),
            child: new Wrap(
              children: <Widget>[
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 10.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.0),
                          border: Border.all(
                            color: Colors.blue,
                          ),
                        ),
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                            CommonDialogUtil
                                .selectImageOrVideoFromGalleryBottomSheet(
                              context: context,
                              picker: picker,
                              onImageSelected: onImageSelected,
                              onVideoSelected: onVideoSelected,
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 8.0,
                            ),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.photo,
                                  size: 50.0,
                                  color: Colors.blue,
                                ),
                                SizedBox(
                                  height: 8.0,
                                ),
                                Text(
                                  'Gallery',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.blue,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 10.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.0),
                          border: Border.all(
                            color: Colors.blue,
                          ),
                        ),
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                            onCameraTap();
                            // CommonDialogUtil
                            //     .selectImageOrVideoFromGalleryBottomSheet(
                            //   context: context,
                            //   picker: picker,
                            //   onImageSelected: onImageSelected,
                            //   onVideoSelected: onVideoSelected,
                            // );
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.camera,
                                  size: 50.0,
                                  color: Colors.blue,
                                ),
                                SizedBox(
                                  height: 8.0,
                                ),
                                Text(
                                  'Camera',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.blue,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        });
  }

  static void uploadImageCommonModalBottomSheet({
    @required BuildContext context,
    @required ImagePicker picker,
    @required Function onImageSelected,
    @required Function onImageCaptured,
  }) {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16.0),
            topRight: Radius.circular(16.0),
          ),
        ),
        backgroundColor: Colors.white,
        builder: (BuildContext bc) {
          return Container(
            padding: EdgeInsets.all(16.0),
            child: new Wrap(
              children: <Widget>[
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 10.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.0),
                          border: Border.all(
                            color: Colors.blue,
                          ),
                        ),
                        child: InkWell(
                          onTap: () {
                            // Navigator.of(context).pop();
                            CommonDialogUtil.captureImage(
                                context: context,
                                picker: picker,
                                onImageCaptured: onImageCaptured);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 8.0,
                            ),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.camera_alt,
                                  size: 50.0,
                                  color: Colors.blue,
                                ),
                                SizedBox(
                                  height: 8.0,
                                ),
                                Text(
                                  'Capture Image',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.blue,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 10.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.0),
                          border: Border.all(
                            color: Colors.blue,
                          ),
                        ),
                        child: InkWell(
                          onTap: () {
                            // Navigator.of(context).pop();
                            CommonDialogUtil.selectImageFromGallary(
                                context: context,
                                picker: picker,
                                onImageSelected: onImageSelected);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.photo,
                                  size: 50.0,
                                  color: Colors.blue,
                                ),
                                SizedBox(
                                  height: 8.0,
                                ),
                                Text(
                                  'Select From Gallary',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.blue,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        });
  }

  static void emojiKeyboardBottomSheet(
      {@required BuildContext context, @required Function onEmojiSelected}) {
    showModalBottomSheet(
        context: context,
        // shape: RoundedRectangleBorder(
        //   borderRadius: BorderRadius.only(
        //     topLeft: Radius.circular(16.0),
        //     topRight: Radius.circular(16.0),
        //   ),
        // ),
        backgroundColor: Colors.white,
        builder: (BuildContext bc) {
          return Container(
            child: EmojiKeyboard(
              onEmojiSelected: onEmojiSelected,
            ),
          );
        });
  }

  static void verifyOTPCommonModalBottomSheet({
    @required BuildContext context,
    @required String mobileNo,
    @required Function onOTPEntered,
    @required Function onResendOTP,
    @required Function onVerifyOTP,
  }) {
    showModalBottomSheet(
        context: context,
        isDismissible: false,
        enableDrag: false,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16.0),
            topRight: Radius.circular(16.0),
          ),
        ),
        backgroundColor: Colors.white,
        builder: (BuildContext bc) {
          return SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      icon: Icon(
                        Icons.close,
                        size: 30.0,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 20.0),
                    child: Icon(
                      Icons.message,
                      size: 60.0,
                      color: CustomColor.colorAccent,
                    ),
                  ),
                  Text(
                    'OTP Verification',
                    style: TextStyle(fontSize: 16.0),
                  ),
                  SizedBox(
                    height: 4.0,
                  ),
                  Text(
                    'Enter the OTP send to ${mobileNo}',
                    style: TextStyle(fontSize: 14.0),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    child: OTPTextField(
                      length: 4,
                      width: MediaQuery.of(context).size.width,
                      fieldWidth: 50,
                      style: TextStyle(fontSize: 17),
                      textFieldAlignment: MainAxisAlignment.spaceAround,
                      fieldStyle: FieldStyle.underline,
                      onCompleted: (pin) {
                        onOTPEntered(pin);
                      },
                      onChanged: (pin) {
                        onOTPEntered(pin);
                      },
                    ),
                  ),
                  Container(
                    child: TextButton.icon(
                      icon: Icon(
                        Icons.refresh,
                      ),
                      onPressed: () {
                        onResendOTP();
                      },
                      label: Text('Resend OTP'),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 28.0),
                    alignment: Alignment.centerRight,
                    child: ElevatedButton.icon(
                      icon: Icon(
                        Icons.done_all,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        onVerifyOTP();
                      },
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
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                      ),
                      label: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 12.0),
                        child: Text('Verify OTP'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  static void loginWithOTPCommonModalBottomSheet({
    @required BuildContext context,
    @required Function onMobileNoEntered,
  }) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        isDismissible: false,
        enableDrag: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16.0),
            topRight: Radius.circular(16.0),
          ),
        ),
        backgroundColor: Colors.white,
        builder: (BuildContext bc) {
          return Container(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    icon: Icon(
                      Icons.close,
                      size: 30.0,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 18.0),
                  child: Text(
                    'What\'s your mobile number ?',
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.black,
                    ),
                  ),
                ),
                Text(
                  'Enter your mobile number below to login in\nOutOut.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14.0),
                ),
                Container(
                  child: LoginWithOTP(
                    onMobileNoEntered: onMobileNoEntered,
                  ),
                ),
              ],
            ),
          );
        });
  }

  static void showAboutUsDialog({@required BuildContext context}) {
    showAboutDialog(
        context: context,
        applicationVersion: '1.0.0',
        applicationLegalese:
            'Our aim is to help customers and businesses in any way we can. OutOut has been created in the hope it’s going to be a positive experience for everyone involved,our customers businesses and local suppliers. There is a great demand for this terrific app which ultimately captures the essential elements of hospitality that is currently missing from our lives.');
  }

  static void selectedImageOrVideoFromGallery({
    @required BuildContext context,
    @required ImagePicker picker,
    @required Function onImageOrVideoSelected,
  }) async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    File selectedFile = File(pickedFile.path);
    if (selectedFile != null) {
      // // int fileLength = await selectedFile.length();
      // // if (fileLength > 500000) {//500KB
      // //   CommonDialogUtil.showToastMsg(
      // //       context: context, toastMsg: 'File length must me less than 500KB');
      // // } else {
      // Navigator.of(context).pop();
      onImageOrVideoSelected(selectedFile);
    }
  }

  static void selectImageFromGallary({
    @required BuildContext context,
    @required ImagePicker picker,
    @required Function onImageSelected,
  }) async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    File selectedFile = File(pickedFile.path);
    if (selectedFile != null) {
      int fileLength = await selectedFile.length();

      //   Navigator.of(context).pop();
      onImageSelected(selectedFile);
    }
  }

  static void captureImage({
    @required BuildContext context,
    @required ImagePicker picker,
    @required Function onImageCaptured,
  }) async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    File selectedFile = File(pickedFile.path);
    if (selectedFile != null) {
      int fileLength = await selectedFile.length();

      Navigator.of(context).pop();
      onImageCaptured(selectedFile);
    }
  }

  static void showCommonDatePicker({
    @required BuildContext context,
    @required Function onDateSelected,
    @required int firstDateYear,
    @required int lastDateYear,
  }) {
    showDatePicker(
      context: context,
      initialDate: DateTime(lastDateYear).subtract(Duration(days: 365*13)),
      firstDate: DateTime(firstDateYear),
      lastDate: DateTime(lastDateYear).subtract(Duration(days: 365*13)),
    ).then((value) {
      if (value != null) {
        onDateSelected(value);
      }
    });
  }

  static void showErrorSnack({
    @required BuildContext context,
    @required String msg,
    Color txtColor = Colors.red,
  }) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              Icons.error_outline,
              color: Colors.red,
            ),
            SizedBox(
              width: 8.0,
            ),
            Expanded(
              child: Text(
                msg,
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: txtColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static void showSuccessSnack({
    @required BuildContext context,
    @required String msg,
    Color txtColor = Colors.green,
  }) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Expanded(
              child: Text(
                msg,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: txtColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Icon(
              Icons.done_all,
              color: txtColor,
            ),
          ],
        ),
      ),
    );
  }

  static void showToastMsg({
    @required BuildContext context,
    @required String toastMsg,
  }) {
    showToast(toastMsg,
        context: context,
        animation: StyledToastAnimation.slideFromTop,
        reverseAnimation: StyledToastAnimation.slideToTop,
        position: StyledToastPosition.top,
        startOffset: Offset(0.0, -3.0),
        reverseEndOffset: Offset(0.0, -3.0),
        duration: Duration(seconds: 6),
        //Animation duration   animDuration * 2 <= duration
        animDuration: Duration(seconds: 2),
        curve: Curves.elasticOut,
        reverseCurve: Curves.fastOutSlowIn);
  }

  static Future<void> showProgressDialog(BuildContext context, String msg) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Container(
            height: 74,
            width: MediaQuery.of(context).size.width * 0.80,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: CustomColor.colorCanvas,
            ),
            padding: EdgeInsets.symmetric(
              vertical: 8.0,
              horizontal: 18.0,
            ),
            child: Container(
              child: Row(
                children: [
                  // SpinKitCircle(color: CustomColor.colorAccent,size: 58.0,),
                  SpinKitChasingDots(
                    itemBuilder: (BuildContext context, int index) {
                      return DecoratedBox(
                        decoration: BoxDecoration(
                          color: index.isEven
                              ? CustomColor.colorPrimary
                              : CustomColor.colorAccent,
                        ),
                      );
                    },
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  Material(
                    child: FittedBox(
                      child: Text(
                        msg,
                        style: TextStyle(
                          fontSize: CommonUtils.FONT_SIZE_14,
                          fontFamily: CommonUtils.FONT_FAMILY_UBUNTU_MEDIUM,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Future<bool> confirmAlert(BuildContext context, String confirmText,
    {String okText = 'YES', String cancelText = 'CANCEL'}) async {
  bool result = false;
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        title: const Text("Out Out"),
        content: Text(confirmText),
        actions: <Widget>[
          TextButton(
              onPressed: () =>
                  {result = false, Navigator.of(context).pop(false)},
              child: Text(cancelText)),
          TextButton(
            onPressed: () => {result = true, Navigator.of(context).pop(true)},
            child: Text(okText),
          ),
        ],
      );
    },
  );
  return result;
}
