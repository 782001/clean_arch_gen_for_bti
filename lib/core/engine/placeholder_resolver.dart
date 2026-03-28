import 'dart:io';
import '../../schema/feature_schema.dart';
import 'json_complex_parser.dart';

class PlaceholderResolver {
  String _pascal(String v) => v.split(RegExp(r'[_|\-| ]')).map((e) {
        if (e.isEmpty) return '';
        return e[0].toUpperCase() + e.substring(1);
      }).join();

  String _snake(String v) {
    return v
        .replaceAllMapped(
            RegExp(r'([a-z0-9])([A-Z])'), (Match m) => '${m[1]}_${m[2]}')
        .replaceAll(RegExp(r'\s+|-'), '_')
        .toLowerCase();
  }

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

  String buildDataBodyField(FeatureSchema s) {
    if (s.request.body.isEmpty) return '';
    return '      data: {\n        ${buildBodyMap(s)}\n      },';
  }

  String buildQueryParameters(FeatureSchema s) => s.request.query.entries
      .map((e) => "'${e.key}': parameters.${e.key}")
      .join(',\n        ');

  String buildQueryParametersField(FeatureSchema s) {
    if (s.request.query.isEmpty) return '';
    return '      queryParameters: {\n        ${buildQueryParameters(s)}\n      },';
  }

  String buildCubitParameters(FeatureSchema s) {
    if (_allParams(s).isEmpty) return '';
    return '{\n    ' +
        _allParams(s)
            .map((e) => 'required ${e.value} ${e.key},')
            .join('\n    ') +
        '\n  }';
  }

  String buildUsecaseParams(FeatureSchema s) =>
      _allParams(s).map((e) => '${e.key}: ${e.key},').join('\n        ');

  String resolve(String template, FeatureSchema s) {
    var t = File('lib/core/templates/$template').readAsStringSync();
    return resolveContent(t, s);
  }

  String resolveContent(String content, FeatureSchema s) {
    var t = content;
    t = t.replaceAll('{{Feature}}', _pascal(s.feature));
    t = t.replaceAll('{{feature}}', _snake(s.feature));
    t = t.replaceAll('{{entity}}', s.response.entity);
    t = t.replaceAll(
        '{{model}}', s.response.entity.replaceAll('Entity', '') + 'Model');
    t = t
        .replaceAll('{{cubitParameters}}', buildCubitParameters(s))
        .replaceAll('{{usecaseParams}}', buildUsecaseParams(s));
    final module = moduleNameFromPath(s.layerPath);
    final modulePascal = pascalFromPath(s.layerPath);

    t = t.replaceAll('{{Module}}', modulePascal);
    t = t.replaceAll('{{module}}', module);

    t = t
        .replaceAll('{{endpoint}}', s.endpoint.url)
        .replaceAll('{{dataBodyField}}', buildDataBodyField(s))
        .replaceAll('{{queryParametersField}}', buildQueryParametersField(s))
        .replaceAll('{{dataBodyMap}}', buildBodyMap(s))
        .replaceAll('{{queryParameters}}', buildQueryParameters(s));
    t = t.replaceAll('{{method}}', s.endpoint.method);
    t = t.replaceAll('{{featureCamel}}', _camel(s.feature));
    t = t.replaceAll('{{entityCamel}}', _camel(s.response.entity));

    t = t
        .replaceAll('{{parameters}}', buildParameters(s))
        .replaceAll('{{constructorDef}}', buildConstructorDef(s))
        .replaceAll('{{constructor}}', buildConstructor(s))
        .replaceAll('{{props}}', buildProps(s));

    // Dynamic Entity & Model Recursive Parser using JsonComplexParser
    final jsonParser = JsonComplexParser(s.response.entity, s.response.data);
    final entityClassesCode = jsonParser.generateEntities();
    final modelClassesCode = jsonParser.generateModels();

    t = t.replaceAll('{{entityClasses}}', entityClassesCode);
    t = t.replaceAll('{{modelClasses}}', modelClassesCode);

    return t;
  }

  String fileName(String tpl, FeatureSchema s) {
    final module = moduleNameFromPath(s.layerPath);

    if (tpl == 'cubit.tpl' || tpl == 'states.tpl') {
      return '${_snake(module)}_${tpl.replaceAll('.tpl', '')}.dart';
    }
    if (tpl == 'injection_container.tpl') {
      return '${_snake(module)}_injection.dart';
    }

    return '${_snake(s.feature)}_${tpl.replaceAll('.tpl', '')}.dart';
  }

  String _camel(String v) {
    final p = _pascal(v);
    return p[0].toLowerCase() + p.substring(1);
  }

  String buildParameters(FeatureSchema s) =>
      _allParams(s).map((e) => 'final ${e.value} ${e.key};').join('\n  ');

  String buildConstructor(FeatureSchema s) =>
      _allParams(s).map((e) => 'required this.${e.key},').join('\n    ');

  String buildConstructorDef(FeatureSchema s) {
    if (_allParams(s).isEmpty) {
      return 'const ${_pascal(s.feature)}Parameters();';
    }
    return 'const ${_pascal(s.feature)}Parameters({\n    ${buildConstructor(s)}\n  });';
  }

  String buildProps(FeatureSchema s) =>
      _allParams(s).map((e) => e.key).join(', ');
  Iterable<MapEntry<String, String>> _allParams(FeatureSchema s) => [
        ...s.request.pathParams.entries,
        ...s.request.body.entries,
        ...s.request.query.entries,
      ];

  String resolveSnippet(String snippetName, FeatureSchema s) {
    final featurePascal = _pascal(s.feature);
    final featureSnake = _snake(s.feature);
    final featureCamel = _camel(s.feature);
    final modulePascal = pascalFromPath(s.layerPath);

    switch (snippetName) {
      case 'cubitField':
        return '  final ${featurePascal}UseCase k${featurePascal}UseCase;';
      case 'cubitConstructorParam':
        return '    required this.k${featurePascal}UseCase,';
      case 'cubitImports':
        return "import '../../../domain/entities/${featureSnake}_entity.dart';\nimport '../../../domain/usecases/${featureSnake}_usecase.dart';";
      case 'cubitMethod':
        final entity = s.response.entity;
        final entityCamel = _camel(entity);
        return '''
  $entity? $entityCamel;
  void ${featureCamel}Method(${buildCubitParameters(s)}) async {
    emit(${featurePascal}LoadingState());

    final response = await k${featurePascal}UseCase(
      ${featurePascal}Parameters(
        ${buildUsecaseParams(s)}
      ),
    );

    response.fold(
      (failure) {
        debugPrint('Failure: ${featurePascal}ErrorState');
        emit(${featurePascal}ErrorState());
      },
      (r) {
        $entityCamel = r;
        debugPrint('Success: \${r.message}');
        emit(${featurePascal}SucssesState(message: r.message ?? ''));
      },
    );
  }''';
      case 'diCubitParam':
        return '        k${featurePascal}UseCase: sl(),';
      case 'diUseCase':
        return '''    sl.registerLazySingleton<${featurePascal}UseCase>(
      () => ${featurePascal}UseCase(baseRepository: sl()),
    );''';
      case 'diRepo':
        return '''    sl.registerLazySingleton<${featurePascal}BaseRepository>(
      () => ${featurePascal}Repository(sl()),
    );''';
      case 'diDS':
        return '''    sl.registerLazySingleton<${featurePascal}BaseRemoteDataSource>(
      () => ${featurePascal}RemoteDataSource(sl<DioClient>()),
    );''';
      case 'cubitStates':
        return '''
class ${featurePascal}LoadingState extends ${modulePascal}State {}

class ${featurePascal}ErrorState extends ${modulePascal}State {
  ${featurePascal}ErrorState();
}

class ${featurePascal}SucssesState extends ${modulePascal}State {
  final String message;

  ${featurePascal}SucssesState({
    required this.message,
  });
}''';
      default:
        return '';
    }
  }
}
