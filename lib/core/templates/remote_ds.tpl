import 'package:dio/dio.dart';
import 'package:pharmacy/core/utils/app_strings.dart';
import 'package:flutter/foundation.dart';
import '../../../../../core/network/api_constance.dart';
import 'package:flutter/foundation.dart';
import 'package:pharmacy/config/services/injection_container.dart';

abstract class {{Feature}}BaseRemoteDataSource {
  Future<{{Feature}}ResponseModel> {{Feature}}({
    required {{Feature}}Parameters parameters,
  });
}


class {{Feature}}RemoteDataSource
    extends {{Feature}}BaseRemoteDataSource {

final dio = sl<Dio>();

  @override
  Future<{{Feature}}ResponseModel> {{Feature}}({
    required {{Feature}}Parameters parameters,
  }) async {
    try{
   
      debugPrint(
          'URL => ${dio.options.baseUrl + ApiConstance.{{endpoint}}}');
      debugPrint('Headers => ${dio.options.headers.toString()}');

       final response = await dio.{{method}}(
      ApiConstance.{{endpoint}},
      //      "${ApiConstance.{{endpoint}}}/${parameters.productId}",

       queryParameters: {
       {{queryParameters}}
        },
      data: {
        {{dataBodyMap}}   
           },
    );
     return {{Feature}}ResponseModel.fromJson(response.data);  }on DioError catch (error) {
      if (error.response != null) {
        // ShowToust(Text: error.response!.data["message"]);
        throw error.response!.data;
      } else {
        throw Exception("Network error occurred");
      }
    }
   

 
  }
}

