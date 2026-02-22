import '../../schema/endpoint_schema.dart';
import '../naming/naming_helper.dart';

class BaseRepositoryGenerator {
  final EndpointSchema schema;
  final NamingHelper naming;

  BaseRepositoryGenerator(this.schema)
      : naming = NamingHelper(schema.name);

  Map<String, String> buildTemplateData() {
    return {
      'BaseRepositoryName': naming.baseRepository,
      'ResponseEntity': naming.responseEntity,
      'Parameters': naming.parameters,
      'methodName': naming.repositoryMethod,
    };
  }
}
