import '../../schema/endpoint_schema.dart';
import '../naming/naming_helper.dart';

class RemoteDSGenerator {
  final EndpointSchema schema;
  final NamingHelper naming;

  RemoteDSGenerator(this.schema)
      : naming = NamingHelper(schema.name);

  String httpMethod() => schema.method.toLowerCase();

  String endpoint() {
    if (!schema.hasIdInPath) {
      return "ApiConstance.${schema.name}EndPoint";
    }

    final idParam = schema.parameters
        .firstWhere((p) => p.location == 'path');

    return "ApiConstance.${schema.name}EndPoint"
        ".replaceFirst('{${idParam.name}}', parameters.${idParam.name}.toString())";
  }

  String body() {
    final bodyParams =
        schema.parameters.where((p) => p.location == 'body').toList();

    if (bodyParams.isEmpty || schema.method == 'GET') {
      return '';
    }

    final mapEntries = bodyParams
        .map((p) => "        '${p.name}': parameters.${p.name},")
        .join('\n');

    return '''
      data: {
$mapEntries
      },
''';
  }

  Map<String, String> buildTemplateData() {
    return {
      'RemoteDSName': naming.remoteDataSource,
      'ResponseModel': naming.responseModel,
      'Parameters': naming.parameters,
      'methodName': naming.repositoryMethod,
      'httpMethod': httpMethod(),
      'endpoint': endpoint(),
      'BODY': body(),
    };
  }
}
