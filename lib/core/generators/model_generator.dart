import '../../schema/endpoint_schema.dart';
import '../naming/naming_helper.dart';

class ModelGenerator {
  final EndpointSchema schema;
  final NamingHelper naming;

  ModelGenerator(this.schema)
      : naming = NamingHelper(schema.name);

  String constructorParams() {
    return schema.response.fields.entries
        .map((e) => '    ${e.value}? ${e.key},')
        .join('\n');
  }

  String superConstructor() {
    return schema.response.fields.keys
        .map((e) => '          $e: $e,')
        .join('\n');
  }

  String fromJson() {
    return schema.response.fields.entries
        .map((e) => "      ${e.key}: json['${e.key}'],")
        .join('\n');
  }

  Map<String, String> buildTemplateData() {
    return {
      'ModelName': naming.responseModel,
      'EntityName': naming.responseEntity,
      'CONSTRUCTOR_PARAMS': constructorParams(),
      'SUPER_CONSTRUCTOR': superConstructor(),
      'FROM_JSON': fromJson(),
    };
  }
}
