import 'package:dio/dio.dart';
import 'package:pharmacy/core/utils/app_strings.dart';
import 'package:flutter/foundation.dart';
import '../../../../../core/network/api_constance.dart';
import 'package:flutter/foundation.dart';
import 'package:pharmacy/config/services/injection_container.dart';

abstract class GoogleLoginBaseRemoteDataSource {
  Future<GoogleLoginResponseModel> GoogleLogin({
    required GoogleLoginParameters parameters,
  });
}


class GoogleLoginRemoteDataSource
    extends GoogleLoginBaseRemoteDataSource {

final dio = sl<Dio>();

  @override
  Future<GoogleLoginResponseModel> GoogleLogin({
    required GoogleLoginParameters parameters,
  }) async {
    try{
   
      debugPrint(
          'URL => ${dio.options.baseUrl + ApiConstance.googleLoginEndPoint}');
      debugPrint('Headers => ${dio.options.headers.toString()}');

       final response = await dio.post(
      ApiConstance.googleLoginEndPoint,
      //      "${ApiConstance.googleLoginEndPoint}/${parameters.productId}",

       queryParameters: {
       
        },
      data: {
        'idToken': parameters.idToken   
           },
    );
     return GoogleLoginResponseModel.fromJson(response.data);  }on DioError catch (error) {
      if (error.response != null) {
        // ShowToust(Text: error.response!.data["message"]);
        throw error.response!.data;
      } else {
        throw Exception("Network error occurred");
      }
    }
   

 
  }
}

