import 'package:dio/dio.dart';
import 'package:pharmacy/core/utils/app_strings.dart';
import 'package:flutter/foundation.dart';
import 'endpoints.dart';
import 'package:flutter/foundation.dart';
import 'package:pharmacy/config/services/injection_container.dart';

abstract class {{Feature}}BaseRemoteDataSource {
  Future<{{Feature}}ResponseModel> {{Feature}}({
    required {{Feature}}Parameters parameters,
  });
}


class {{Feature}}RemoteDataSource
    extends {{Feature}}BaseRemoteDataSource {

  final DioClient dio;
{{Feature}}RemoteDataSource(this.dio);
  @override
  Future<{{Feature}}ResponseModel> {{Feature}}({
    required {{Feature}}Parameters parameters,
  }) async {
  
       final response = await dio.{{method}}(
      Endpoint.{{endpoint}},
      //      "${Endpoint.{{endpoint}}}/${parameters.productId}",

       queryParameters: {
       {{queryParameters}}
        },
      data: {
        {{dataBodyMap}}   
           },
    );
     return {{Feature}}ResponseModel.fromJson(response.data);  
   

 
  }
}

