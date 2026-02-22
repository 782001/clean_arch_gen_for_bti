import '../../schema/endpoint_schema.dart';
import '../naming/naming_helper.dart';

class RepositoryImplGenerator {
  final EndpointSchema schema;
  final NamingHelper naming;

  RepositoryImplGenerator(this.schema)
      : naming = NamingHelper(schema.name);

  Map<String, String> buildTemplateData() {
    return {
      'RepositoryImpl': naming.repositoryImpl,
      'BaseRepository': naming.baseRepository,
      'RemoteDS': naming.remoteDataSource,
      'ResponseEntity': naming.responseEntity,
      'Parameters': naming.parameters,
      'methodName': naming.repositoryMethod,
    };
  }
}
