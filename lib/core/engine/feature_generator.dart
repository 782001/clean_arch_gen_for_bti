import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:dart_style/dart_style.dart';
import '../../schema/feature_schema.dart';
import '../writer/file_writer.dart';
import 'placeholder_resolver.dart';

class FeatureGenerator {
  final FeatureSchema schema;
  final FileWriter writer;
  final PlaceholderResolver resolver;

  FeatureGenerator(this.schema, this.writer, this.resolver);

  void generate() {
    final module = _moduleFromLayerPath(schema.layerPath);

    _gen('entity.tpl', 'domain/entities');
    _gen('model.tpl', 'data/models');
    _gen('remote_ds.tpl', 'data/data_sources');
    _gen('repo_base.tpl', 'domain/repositories');
    _gen('repo_impl.tpl', 'data/repositories');
    _gen('usecase.tpl', 'domain/usecases');

    if (schema.presentation.cubit) {
      final cubitPath = writer.getFinalPath(
        '${schema.layerPath}/presentation/controller/${module}_cubit/${resolver.fileName('cubit.tpl', schema)}',
      );
      final statesPath = writer.getFinalPath(
        '${schema.layerPath}/presentation/controller/${module}_cubit/${resolver.fileName('states.tpl', schema)}',
      );

      if (File(cubitPath).existsSync()) {
        _mergeIntoCubit(module, cubitPath);
      } else {
        _gen('cubit.tpl', 'presentation/controller/${module}_cubit');
      }

      if (File(statesPath).existsSync()) {
        _mergeIntoStates(statesPath);
      } else {
        _gen('states.tpl', 'presentation/controller/${module}_cubit');
      }
    }

    if (schema.presentation.injectionContainer) {
      _generateOrUpdateFeatureDi(module);
      if (schema.presentation.injectionContainerPath != null) {
        _updateMainInjectionContainer(module);
      }
    }
  }

  String _moduleFromLayerPath(String path) {
    return path.split('/').last;
  }

  void _gen(String tpl, String folder) {
    writer.write(
      '${schema.layerPath}/$folder/${resolver.fileName(tpl, schema)}',
      resolver.resolve(tpl, schema),
    );
  }

  void _generateOrUpdateFeatureDi(String module) {
    final diFileName = resolver.fileName('injection_container.tpl', schema);
    final diPath = writer.getFinalPath('${schema.layerPath}/service_injection/$diFileName');
    final file = File(diPath);

    if (!file.existsSync()) {
      File(diPath).parent.createSync(recursive: true);
      _gen('injection_container.tpl', 'service_injection');
    } else {
      _mergeIntoFeatureDi(file, module);
    }
  }

  void _mergeIntoFeatureDi(File file, String module) {
    var content = file.readAsStringSync();
    final fPascal = resolver.resolveContent('{{Feature}}', schema);
    final mPascal = resolver.pascalFromPath(schema.layerPath);

    print('🧬 Merging dependencies into existing ${mPascal}DI.');

    void injectUnderHeading(String heading, String snippetKey) {
      String searchKey = '';
      if (snippetKey == 'diUseCase') searchKey = '<${fPascal}UseCase>';
      if (snippetKey == 'diRepo') searchKey = '<${fPascal}BaseRepository>';
      if (snippetKey == 'diDS') {
        searchKey = '<${fPascal}BaseRemoteDataSource>';
      }

      if (content.contains(searchKey)) return;

      final headingRegex = RegExp(heading, caseSensitive: false);
      final headMatches = headingRegex.allMatches(content);

      if (headMatches.isNotEmpty) {
        final headingMatch = headMatches.first;
        final snippet = resolver.resolveSnippet(snippetKey, schema);
        content = content.replaceRange(
            headingMatch.end, headingMatch.end, '\n$snippet');
      }
    }

    injectUnderHeading(r'/// --------DataSource--------', 'diDS');
    injectUnderHeading(r'/// --------Repository--------', 'diRepo');
    injectUnderHeading(r'/// --------useCases----------', 'diUseCase');

    // Update Cubit Registration
    final cubitRegRegex = RegExp(
      'sl\\.registerFactory<${mPascal}Cubit>\\s*\\([\\s\\S]*?=>\\s*${mPascal}Cubit\\s*\\(',
      multiLine: true,
    );
    final cubitMatch = cubitRegRegex.firstMatch(content);
    if (cubitMatch != null && !content.contains('k${fPascal}UseCase: sl()')) {
      print('🔄 Inserting k${fPascal}UseCase into existing ${mPascal}Cubit DI.');
      content = content.replaceRange(
          cubitMatch.end, cubitMatch.end, '\n        k${fPascal}UseCase: sl(),');
    } else if (cubitMatch == null && !content.contains('<${mPascal}Cubit>')) {
      final headingRegex =
          RegExp('///\\s*-----${mPascal}Cubit------', caseSensitive: false);
      final headMatches = headingRegex.allMatches(content);
      if (headMatches.isNotEmpty) {
        final headingMatch = headMatches.first;
        final snippet = '''
    sl.registerFactory<${mPascal}Cubit>(
      () => ${mPascal}Cubit(
        k${fPascal}UseCase: sl(),
      ),
    );''';
        content = content.replaceRange(
            headingMatch.end, headingMatch.end, '\n$snippet');
      }
    }

    final cubitFile = resolver.fileName('cubit.tpl', schema);
    final newImports = [
      "import '../presentation/controller/${module}_cubit/$cubitFile';",
      "import '../domain/usecases/${resolver.fileName('usecase.tpl', schema)}';",
      "import '../domain/repositories/${resolver.fileName('repo_base.tpl', schema)}';",
      "import '../data/repositories/${resolver.fileName('repo_impl.tpl', schema)}';",
      "import '../data/data_sources/${resolver.fileName('remote_ds.tpl', schema)}';",
    ];

    for (var imp in newImports) {
      if (!content.contains(imp)) {
        final lastImport = RegExp(r'^import\s+.*$', multiLine: true)
            .allMatches(content)
            .lastOrNull;
        if (lastImport != null)
          content =
              content.replaceRange(lastImport.end, lastImport.end, '\n$imp');
        else
          content = '$imp\n$content';
      }
    }

    try {
      content =
          DartFormatter(languageVersion: DartFormatter.latestLanguageVersion)
              .format(content);
    } catch (e) {
      print('⚠️ Formatting DI failed: $e');
    }

    file.writeAsStringSync(content);
  }

  void _updateMainInjectionContainer(String module) {
    final mainDiPath = schema.presentation.injectionContainerPath!;
    final file = File(mainDiPath);
    if (!file.existsSync()) return;

    var content = file.readAsStringSync();
    final mPascal = resolver.pascalFromPath(schema.layerPath);
    
    // Ensure the method is Future<void> initDependencies() async
    if (content.contains('void initDependencies() {')) {
      content = content.replaceAll('void initDependencies() {', 'Future<void> initDependencies() async {');
    }

    final initCall = 'await ${mPascal}DI.init();';
    if (!content.contains(initCall)) {
      final featuresBlock = RegExp(r'//!\s*Features.*$', multiLine: true);
      final match = featuresBlock.firstMatch(content);
      if (match != null) {
        content = content.replaceRange(match.end, match.end, '\n  $initCall');
      } else {
        // Just append before the closing brace if '//! Features' is missing
        final lastBrace = content.lastIndexOf('}');
        if (lastBrace != -1) {
          content = content.replaceRange(lastBrace, lastBrace, '  $initCall\n');
        }
      }

      // Add appropriate import
      // Using relative path based on actual location. Assume it's located below the common lib dir
      final diDir = p.dirname(file.path);
      String rel(String t) =>
        p.relative(writer.getFinalPath(t), from: diDir).replaceAll('\\', '/');

      final targetDiFileName = resolver.fileName('injection_container.tpl', schema);
      final imp = "import '${rel('${schema.layerPath}/service_injection/$targetDiFileName')}';";

      if (!content.contains(imp)) {
        final lastImport = RegExp(r'^import\s+.*$', multiLine: true)
            .allMatches(content)
            .lastOrNull;
        if (lastImport != null) {
          content = content.replaceRange(lastImport.end, lastImport.end, '\n$imp');
        } else {
          content = '$imp\n$content';
        }
      }

      try {
        content = DartFormatter(languageVersion: DartFormatter.latestLanguageVersion).format(content);
      } catch (e) {}

      file.writeAsStringSync(content);
    }
  }

  void _mergeIntoStates(String statesPath) {
    final file = File(statesPath);
    var content = file.readAsStringSync();
    final fPascal = resolver.resolveContent('{{Feature}}', schema);

    if (content.contains('${fPascal}LoadingState')) return;

    print('🧬 Merging new states into: $statesPath');
    final newStates = resolver.resolveSnippet('cubitStates', schema);
    content = '$content\n$newStates';

    try {
      content =
          DartFormatter(languageVersion: DartFormatter.latestLanguageVersion)
              .format(content);
    } catch (e) {}
    file.writeAsStringSync(content);
  }

  void _mergeIntoCubit(String module, String cubitPath) {
    final file = File(cubitPath);
    var content = file.readAsStringSync();
    final fPascal = resolver.resolveContent('{{Feature}}', schema);

    if (content.contains('k${fPascal}UseCase')) {
      print(
          'ℹ️  Method for ${schema.feature} already exists in Cubit. Skipping merge.');
      return;
    }

    print('🧬 Merging new method into existing Cubit: $cubitPath');

    final imports = resolver.resolveSnippet('cubitImports', schema).split('\n');
    for (var imp in imports) {
      if (!content.contains(imp)) {
        final lastImport = RegExp(r'^import\s+.*$', multiLine: true)
            .allMatches(content)
            .lastOrNull;
        if (lastImport != null)
          content =
              content.replaceRange(lastImport.end, lastImport.end, '\n$imp');
        else
          content = '$imp\n$content';
      }
    }

    final field = resolver.resolveSnippet('cubitField', schema);
    final constructorRegex = RegExp(r'\w+Cubit\s*\({');
    final constructorMatch = constructorRegex.firstMatch(content);
    if (constructorMatch != null) {
      content = content.replaceRange(
          constructorMatch.start, constructorMatch.start, '$field\n\n');
    }

    final param = resolver.resolveSnippet('cubitConstructorParam', schema);
    final constructorBodyRegex = RegExp(r'required\s+this\.k\w+UseCase,?');
    final lastParamMatch = constructorBodyRegex.allMatches(content).lastOrNull;
    if (lastParamMatch != null) {
      final matchText = lastParamMatch.group(0)!;
      final suffix = matchText.endsWith(',') ? '' : ',';
      content = content.replaceRange(
          lastParamMatch.end, lastParamMatch.end, '$suffix\n$param');
    }

    final method = resolver.resolveSnippet('cubitMethod', schema);
    final lastBraceIndex = content.lastIndexOf('}');
    if (lastBraceIndex != -1) {
      content =
          content.replaceRange(lastBraceIndex, lastBraceIndex, '\n$method\n');
    }

    try {
      content =
          DartFormatter(languageVersion: DartFormatter.latestLanguageVersion)
              .format(content);
    } catch (e) {
      print('⚠️ Formatting Cubit failed: $e');
    }

    file.writeAsStringSync(content);
  }
}
