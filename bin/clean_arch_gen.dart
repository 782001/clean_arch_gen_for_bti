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
  if (args.isEmpty) {
    print('Usage: dart run clean_arch_gen generate feature.json');
    exit(1);
  }

  final file = File(args.last);
  final jsonMap = jsonDecode(file.readAsStringSync());

  final schema = FeatureSchema.fromJson(jsonMap);

  FeatureGenerator(
    schema,
    FileWriter(),
    PlaceholderResolver(),
  ).generate();

  print('✅ Feature generated successfully');
}
