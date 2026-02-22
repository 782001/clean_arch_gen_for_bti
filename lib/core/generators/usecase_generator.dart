import '../../schema/endpoint_schema.dart';
import '../naming/naming_helper.dart';

class UseCaseGenerator {
  final EndpointSchema schema;
  final NamingHelper naming;

  UseCaseGenerator(this.schema)
      : naming = NamingHelper(schema.name);

  Map<String, String> buildTemplateData() {
    return {
      'UseCaseName': naming.useCase,
      'ResponseEntity': naming.responseEntity,
      'Parameters': naming.parameters,
      'BaseRepository': naming.baseRepository,
      'methodName': naming.repositoryMethod,
    };
  }
}
