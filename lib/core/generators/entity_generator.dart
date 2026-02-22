import '../../schema/endpoint_schema.dart';
import '../naming/naming_helper.dart';

class EntityGenerator {
  final EndpointSchema schema;
  final NamingHelper naming;

  EntityGenerator(this.schema)
      : naming = NamingHelper(schema.name);

  String generateFields() {
    return schema.response.fields.entries
        .map((e) => '  final ${e.value}? ${e.key};')
        .join('\n');
  }

  String generateConstructor() {
    return schema.response.fields.keys
        .map((e) => '    this.$e,')
        .join('\n');
  }

  Map<String, String> buildTemplateData() {
    return {
      'EntityName': naming.responseEntity,
      'FIELDS': generateFields(),
      'CONSTRUCTOR': generateConstructor(),
    };
  }
}
