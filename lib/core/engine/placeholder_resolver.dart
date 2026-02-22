import 'dart:io';
import '../../schema/feature_schema.dart';

class PlaceholderResolver {
  String _pascal(String v) =>
      v.split('_').map((e) => e[0].toUpperCase() + e.substring(1)).join();
  String moduleNameFromPath(String path) {
    // app_features/categories → categories
    return path.split('/').last;
  }

  String pascalFromPath(String path) {
    final name = moduleNameFromPath(path);
    return name[0].toUpperCase() + name.substring(1);
  }

  String buildBodyMap(FeatureSchema s) => s.request.body.entries
      .map((e) => "'${e.key}': parameters.${e.key}")
      .join(',\n        ');
  String buildQueryParameters(FeatureSchema s) => s.request.query.entries
      .map((e) => "'${e.key}': parameters.${e.key}")
      .join(',\n        ');
  String buildCubitParameters(FeatureSchema s) =>
      _allParams(s).map((e) => 'required ${e.value} ${e.key},').join('\n    ');

  String buildUsecaseParams(FeatureSchema s) =>
      _allParams(s).map((e) => '${e.key}: ${e.key},').join('\n        ');

  String resolve(String template, FeatureSchema s) {
    var t = File('lib/core/templates/$template').readAsStringSync();

    t = t.replaceAll('{{Feature}}', _pascal(s.feature));
    t = t.replaceAll('{{feature}}', s.feature);
    t = t.replaceAll('{{entity}}', s.response.entity);
    t = t
        .replaceAll('{{cubitParameters}}', buildCubitParameters(s))
        .replaceAll('{{usecaseParams}}', buildUsecaseParams(s));
    final module = moduleNameFromPath(s.layerPath);
    final modulePascal = pascalFromPath(s.layerPath);

    t = t.replaceAll('{{Module}}', modulePascal);
    t = t.replaceAll('{{module}}', module);

    t = t
        .replaceAll('{{endpoint}}', s.endpoint.url)
        .replaceAll('{{dataBodyMap}}', buildBodyMap(s))
        .replaceAll('{{queryParameters}}', buildQueryParameters(s));
    t = t.replaceAll('{{method}}', s.endpoint.method);
    t = t.replaceAll('{{featureCamel}}', _camel(s.feature));
    t = t.replaceAll('{{entityCamel}}', _camel(s.response.entity));

    t = t
        .replaceAll('{{parameters}}', buildParameters(s))
        .replaceAll('{{constructor}}', buildConstructor(s))
        .replaceAll('{{props}}', buildProps(s));
    final fields = s.response.fields.entries.map((e) {
      return 'final ${e.value}? ${e.key};';
    }).join('\n  ');

    return t.replaceAll('{{fields}}', fields);
  }

  String fileName(String tpl, FeatureSchema s) {
    final module = moduleNameFromPath(s.layerPath);

    if (tpl == 'cubit.tpl' ||
        tpl == 'states.tpl' ||
        tpl == 'injection_container.tpl') {
      return '${module}_${tpl.replaceAll('.tpl', '')}.dart';
    }

    return '${s.feature}_${tpl.replaceAll('.tpl', '')}.dart';
  }

  String _camel(String v) {
    final p =
        v.split('_').map((e) => e[0].toUpperCase() + e.substring(1)).join();
    return p[0].toLowerCase() + p.substring(1);
  }

  String buildParameters(FeatureSchema s) =>
      _allParams(s).map((e) => 'final ${e.value} ${e.key};').join('\n  ');

  String buildConstructor(FeatureSchema s) =>
      _allParams(s).map((e) => 'required this.${e.key},').join('\n    ');

  String buildProps(FeatureSchema s) =>
      _allParams(s).map((e) => e.key).join(', ');
  Iterable<MapEntry<String, String>> _allParams(FeatureSchema s) => [
        ...s.request.pathParams.entries,
        ...s.request.body.entries,
        ...s.request.query.entries,
      ];
}
