// import 'dart:io';
// import 'dart:convert';

// import '../lib/core/generate_feature.dart';
// import '../lib/schema/endpoint_schema.dart';


// void main(List<String> args) async {
//   if (args.isEmpty || args.first != 'generate') {
//     print('Usage: dart run clean_arch_gen generate <config.json>');
//     exit(1);
//   }

//   final configPath = args[1];
//   final configFile = File(configPath);

//   if (!configFile.existsSync()) {
//     print('Config file not found');
//     exit(1);
//   }

//   final jsonMap = jsonDecode(configFile.readAsStringSync());
//   final schema = EndpointSchema.fromJson(jsonMap);

//   await generateFeature(schema);

//   print('✅ Feature generated successfully');
// }
import 'dart:io';
import 'dart:convert';

import '../lib/schema/feature_schema.dart';
import '../lib/core/engine/feature_generator.dart';
import '../lib/core/engine/placeholder_resolver.dart';
import '../lib/core/writer/file_writer.dart';

void main(List<String> args) {
  if (args.length < 2) {
    print('Usage: dart run bin/clean_arch_gen.dart generate feature.json [optional/output/path]');
    exit(1);
  }

  // Assuming args[0] = 'generate', args[1] = 'feature.json', args[2] = 'optional/output/path'
  final file = File(args[1]);
  if (!file.existsSync()) {
    print('❌ Error: The file ${args[1]} does not exist.');
    exit(1);
  }

  final String? cliOutputPath = args.length > 2 ? args[2] : null;

  final jsonMap = jsonDecode(file.readAsStringSync());
  final schema = FeatureSchema.fromJson(jsonMap);

  final String? customOutputPath = cliOutputPath ?? schema.basePath;

  FeatureGenerator(
    schema,
    FileWriter(customOutputPath),
    PlaceholderResolver(),
  ).generate();

  print('✅ Feature generated successfully!');
}
