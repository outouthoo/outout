import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:out_out/pages/common/video_view_page.dart';
import 'package:out_out/providers/common_details_provider.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';
import 'package:out_out/pages/common/image_view_page.dart';

class VideoUploadPage extends StatefulWidget {
  static const routeName = '/video-upload-page';

  @override
  _VideoUploadPageState createState() => _VideoUploadPageState();
}

class _VideoUploadPageState extends State<VideoUploadPage> {
  CameraController _cameraController;
  CommonDetailsProvider _commonDetailsProvider;
  bool _isLoading = false;
  RxBool _isFlashOn = false.obs;
  RxBool _isRecording = false.obs;
  RxBool _isFrontCamera = false.obs;
  RxDouble _transformAngle = 0.0.obs;
  RxString _currentStatus = 'Hold for Video,tap for photo'.obs;

  @override
  void didChangeDependencies() {
    if (!_isLoading) {
      _commonDetailsProvider =
          Provider.of<CommonDetailsProvider>(context, listen: false);
      _cameraController = CameraController(
          _commonDetailsProvider.getCameraList[0], ResolutionPreset.high);
    }
    _isLoading = true;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FutureBuilder(
            future: _cameraController.initialize(),
            builder: (context, snapShot) {
              if (snapShot.connectionState == ConnectionState.waiting) {
                return Container(
                  height: deviceSize.height * 0.8 + 30.0,
                  color: Colors.black,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              return CameraPreview(_cameraController);
            },
          ),
          Expanded(
            child: Container(
              alignment: Alignment.center,
              color: Colors.black,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        icon: Obx(
                          () => Icon(
                            _isFlashOn.value ? Icons.flash_on : Icons.flash_off,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                        onPressed: () {
                          if (!_isFrontCamera.value) {
                            _isFlashOn.value = !_isFlashOn.value;
                            _isFlashOn.value
                                ? _cameraController
                                    .setFlashMode(FlashMode.torch)
                                : _cameraController.setFlashMode(FlashMode.off);
                          }
                        },
                      ),
                      GestureDetector(
                        onLongPress: () async {
                          await _cameraController.startVideoRecording();
                          _currentStatus.value = 'Recording started...';
                          _isRecording.value = true;
                        },
                        onLongPressUp: () async {
                          XFile xFile =
                              await _cameraController.stopVideoRecording();
                          if(_isFlashOn.value){
                            _cameraController.setFlashMode(FlashMode.off);
                          }
                          _currentStatus.value = 'Hold for video,tap for photo';
                          _isRecording.value = false;
                          print(xFile.path);
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => VideoViewPage(),
                            ),
                          ).then((value){
                            if(value != null && value){
                             Navigator.of(context).pop(true);
                            }
                          });
                        },
                        onTap: () async {
                          if (!_isRecording.value) {
                            XFile file = await _cameraController.takePicture();
                            if(_isFlashOn.value){
                              _cameraController.setFlashMode(FlashMode.off);
                            }
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (builder) => ImageViewPage(

                                ),
                              ),
                            ).then((value){
                              if(value != null && value){
                                Navigator.of(context).pop(true);
                              }
                            });
                          }
                        },
                        child: Obx(
                          () => Icon(
                            _isRecording.value
                                ? Icons.radio_button_on
                                : Icons.panorama_fish_eye,
                            color:
                                _isRecording.value ? Colors.red : Colors.white,
                            size: _isRecording.value ? 90 : 70,
                          ),
                        ),
                      ),
                      Obx(
                        () => IconButton(
                          icon: Transform.rotate(
                            angle: _transformAngle.value,
                            child: Icon(
                              Icons.flip_camera_ios,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                          onPressed: () async {
                            _isFrontCamera.value = !_isFrontCamera.value;
                            _transformAngle.value =
                                _transformAngle.value + 3.14;
                            _cameraController = CameraController(
                                _commonDetailsProvider.getCameraList[
                                    _isFrontCamera.value ? 1 : 0],
                                ResolutionPreset.high);
                            setState(() {});
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  Obx(
                    () => Text(
                      _currentStatus.value,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
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
