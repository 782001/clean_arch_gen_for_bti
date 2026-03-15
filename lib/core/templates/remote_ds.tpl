import '../../../../core/dio_client/dio_client.dart';
import '../../../../core/dio_client/endpoints.dart';
import '../../domain/usecases/{{feature}}_usecase.dart';
import '../models/{{feature}}_model.dart';

abstract class {{Feature}}BaseRemoteDataSource {
  Future<{{model}}> {{Feature}}({
    required {{Feature}}Parameters parameters,
  });
}


class {{Feature}}RemoteDataSource
    extends {{Feature}}BaseRemoteDataSource {

  final DioClient dio;
{{Feature}}RemoteDataSource(this.dio);
  @override
  Future<{{model}}> {{Feature}}({
    required {{Feature}}Parameters parameters,
  }) async {
  
       final response = await dio.{{method}}(
      Endpoint.{{endpoint}},
      //      "${Endpoint.{{endpoint}}}/${parameters.productId}",

{{queryParametersField}}
{{dataBodyField}}
    );
     return {{model}}.fromJson(response.data);  
   

 
  }
}

