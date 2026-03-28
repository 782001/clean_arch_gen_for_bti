import 'dart:io';
import 'dart:convert';
import 'lib/schema/feature_schema.dart';
import 'lib/core/engine/placeholder_resolver.dart';
import 'lib/core/writer/file_writer.dart';
import 'lib/core/engine/feature_generator.dart';

void main() {
  final file = File('feature.json');
  final jsonMap = jsonDecode(file.readAsStringSync());
  final schema = FeatureSchema.fromJson(jsonMap);
  
  final resolver = PlaceholderResolver();
  final writer = FileWriter(schema.basePath);
  final generator = FeatureGenerator(schema, writer, resolver);
  
  generator.generate();
  print('Generation complete.');
}
