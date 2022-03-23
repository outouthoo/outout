import 'package:dio/dio.dart';
import 'package:out_out/api/api_url.dart';
import 'package:out_out/utils/commona_utils.dart';

class DioClient{
  static Dio dio;

  static Dio getInstance() {
    if (dio == null) {
      dio = Dio();
      dio.options.headers['Content-Type'] = 'application/x-www-form-urlencoded; charset=UTF-8';
      dio.options.baseUrl = ApiUrl.BASE_URL;
      dio.options.connectTimeout = CommonUtils.CONNECTION_TIME_OUT_IN_MILL_SEC;
      dio.options.receiveTimeout = CommonUtils.RECEIVE_TIME_OUT_IN_MILL_SEC;
    }
    return dio;
  }
}