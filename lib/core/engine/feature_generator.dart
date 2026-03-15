import 'dart:io';
import 'package:path/path.dart' as p;
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
      _gen('cubit.tpl', 'presentation/controller/${module}_cubit');
      _gen('states.tpl', 'presentation/controller/${module}_cubit');
    }

    if (schema.presentation.injectionContainer) {
      if (schema.presentation.injectionContainerPath != null) {
        _injectIntoExistingDi(module);
      } else {
        _gen(
          'injection_container.tpl',
          'presentation/controller/${module}_cubit',
        );
      }
    }
  }

  String _moduleFromLayerPath(String path) {
    // app_features/categories → categories
    return path.split('/').last;
  }

  void _gen(String tpl, String folder) {
    writer.write(
      '${schema.layerPath}/$folder/${resolver.fileName(tpl, schema)}',
      resolver.resolve(tpl, schema),
    );
  }

  void _injectIntoExistingDi(String module) {
    final diPath = schema.presentation.injectionContainerPath!;
    final file = File(diPath);

    if (!file.existsSync()) {
      print('❌ Error: Injection container file not found at $diPath');
      return;
    }

    print('Injecting into DI at: $diPath');
    var content = file.readAsStringSync();
    print('Original content length: ${content.length}');
    final generatedDiSnippet = resolver.resolve('injection_container.tpl', schema);

    // Build absolute paths to generate relative imports
    final cubitPath = writer.getFinalPath('${schema.layerPath}/presentation/controller/${module}_cubit/${resolver.fileName('cubit.tpl', schema)}');
    final usecasePath = writer.getFinalPath('${schema.layerPath}/domain/usecases/${resolver.fileName('usecase.tpl', schema)}');
    final repoBasePath = writer.getFinalPath('${schema.layerPath}/domain/repositories/${resolver.fileName('repo_base.tpl', schema)}');
    final repoImplPath = writer.getFinalPath('${schema.layerPath}/data/repositories/${resolver.fileName('repo_impl.tpl', schema)}');
    final remoteDsPath = writer.getFinalPath('${schema.layerPath}/data/data_sources/${resolver.fileName('remote_ds.tpl', schema)}');

    final diDir = p.dirname(diPath);
    
    String relativeFormat(String targetPath) {
      return p.relative(targetPath, from: diDir).replaceAll('\\', '/');
    }

    final imports = [
      "import '${relativeFormat(cubitPath)}';",
      "import '${relativeFormat(usecasePath)}';",
      "import '${relativeFormat(repoBasePath)}';",
      "import '${relativeFormat(repoImplPath)}';",
      "import '${relativeFormat(remoteDsPath)}';",
    ].join('\n');

    // Attempt to inject under imports. We find the last import statement or beginning of file if none.
    final importRegex = RegExp(r'^import\s+.*$', multiLine: true);
    final lastImportMatch = importRegex.allMatches(content).lastOrNull;

    if (lastImportMatch != null) {
      print('Found last import at position: ${lastImportMatch.end}');
      content = content.replaceRange(
        lastImportMatch.end,
        lastImportMatch.end,
        '\n$imports',
      );
    } else {
      print('No imports found');
      content = '$imports\n\n$content';
    }

    // Attempt to inject under //! Features (case insensitive, space tolerant)
    final featuresRegex = RegExp(r'//!\s*Features?', caseSensitive: false);
    final featuresMatch = featuresRegex.firstMatch(content);

    if (featuresMatch != null) {
      print('Found Features marker at: ${featuresMatch.end}');
      content = content.replaceRange(
        featuresMatch.end,
        featuresMatch.end,
        '\n\n$generatedDiSnippet',
      );
    } else {
      print('Features marker not found');
      // Fallback: just put it at the end of the initDependencies function or end of file
      content = '$content\n\n$generatedDiSnippet';
    }

    file.writeAsStringSync(content);
    print('Updated content length: ${content.length}');
  }
}
