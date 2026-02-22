import '../../schema/endpoint_schema.dart';
import '../naming/naming_helper.dart';

class ParametersGenerator {
  final EndpointSchema schema;
  final NamingHelper naming;

  ParametersGenerator(this.schema)
      : naming = NamingHelper(schema.name);

  String fields() {
    return schema.parameters
        .map((p) => '  final ${p.type} ${p.name};')
        .join('\n');
  }

  String constructor() {
    return schema.parameters
        .map((p) => '    required this.${p.name},')
        .join('\n');
  }

  String props() {
    return schema.parameters.map((p) => p.name).join(',');
  }

  Map<String, String> buildTemplateData() {
    return {
      'Parameters': naming.parameters,
      'FIELDS': fields(),
      'CONSTRUCTOR': constructor(),
      'PROPS': props(),
    };
  }
}
