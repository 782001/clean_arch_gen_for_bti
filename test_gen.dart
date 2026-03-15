import 'dart:io';
import 'dart:convert';
import 'lib/schema/feature_schema.dart';
import 'lib/core/engine/placeholder_resolver.dart';

void main() {
  final file = File('feature.json');
  final jsonMap = jsonDecode(file.readAsStringSync());
  print('Raw Request: ${jsonMap['request']}');
  final schema = FeatureSchema.fromJson(jsonMap);
  print('Query: ${schema.request.query}');
  print('Params for queryParametersField: \n${PlaceholderResolver().buildQueryParametersField(schema)}');
}
