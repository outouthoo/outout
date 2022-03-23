// import 'dart:io';
// import 'package:dio/native_imp.dart';
// import 'package:out_out/utils/CustomHttpException.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:path/path.dart' as path;
//
// class DownloadPdfFromUrlUtils {
//   final String fileUrl;
//   String fileNameWithExtension;
//   String fileExtension;
//   final String menuNameToStoreFileInIt;
//   final DioForNative _dio = DioForNative();
//
//   DownloadPdfFromUrlUtils({
//     this.fileUrl,
//     this.menuNameToStoreFileInIt,
//   }) {
//     fileNameWithExtension = fileUrl.split('/').last;
//     fileExtension = fileUrl.substring(fileUrl.lastIndexOf("."));
//   }
//
//   Future<Directory> _getDownloadDirectory() async {
//     if (Platform.isAndroid) {
//       return await  getApplicationDocumentsDirectory();
//     }
//     return await getApplicationDocumentsDirectory();
//   }
//
//   Future<void> download() async {
//     try {
//       final dir = await _getDownloadDirectory();
//
//       final savePath = path.join(dir.path, fileNameWithExtension);
//       await _startDownload(fileUrl, savePath);
//     } catch (error) {
//       throw CustomHttpException(exceptionMsg: error.toString());
//     }
//   }
//
//   Future<void> _startDownload(String fileUrl, String savePath) async {
//     try {
//       final response = await _dio.download(fileUrl, savePath);
//       if (response.statusCode == 200) {
//         await openFilefromFilePath(savePath);
//       }
//     } catch (error) {
//       throw CustomHttpException(exceptionMsg: error.toString());
//     }
//   }
//
//   Future<void> openFilefromFilePath(String filePath) async {
//     try {
//       await WebSocket.open(filePath);
//     } catch (error) {
//       throw CustomHttpException(exceptionMsg: error.toString());
//     }
//   }
// }
