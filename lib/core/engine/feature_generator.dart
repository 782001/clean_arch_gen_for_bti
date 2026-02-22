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
      _gen(
        'injection_container.tpl',
        'presentation/controller/${module}_cubit',
      );
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
}
