import 'package:clean_arch_gen/core/generators/parameters_generator.dart';

import '../schema/endpoint_schema.dart';
import 'generators/base_repository_generator.dart';
import 'generators/entity_generator.dart';
import 'generators/model_generator.dart';
import 'generators/remote_ds_generator.dart';
import 'generators/repository_generator.dart';
import 'generators/usecase_generator.dart';
import 'writer.dart';

Future<void> generateFeature(EndpointSchema schema) async {
  final entityGen = EntityGenerator(schema);
  final modelGen = ModelGenerator(schema);
  final remoteGen = RemoteDSGenerator(schema);
  final baseRepoGen = BaseRepositoryGenerator(schema);
  final repoImplGen = RepositoryImplGenerator(schema);
  final useCaseGen = UseCaseGenerator(schema);
  final paramsGen = ParametersGenerator(schema);

  FileWriter.write(
    path: 'lib/app_features/${schema.feature}/domain/entities',
    fileName: '${schema.name}_response_entity.dart',
    template: 'entity.tpl',
    data: entityGen.buildTemplateData(),
  );

  FileWriter.write(
    path: 'lib/app_features/${schema.feature}/data/models',
    fileName: '${schema.name}_response_model.dart',
    template: 'model.tpl',
    data: modelGen.buildTemplateData(),
  );

  FileWriter.write(
    path: 'lib/app_features/${schema.feature}/data/data_source',
    fileName: '${schema.name}_remote_data_source.dart',
    template: 'remote_ds.tpl',
    data: remoteGen.buildTemplateData(),
  );

  FileWriter.write(
    path: 'lib/app_features/${schema.feature}/domain/base_repository',
    fileName: '${schema.name}_base_repository.dart',
    template: 'base_repository.tpl',
    data: baseRepoGen.buildTemplateData(),
  );

  FileWriter.write(
    path: 'lib/app_features/${schema.feature}/data/repository',
    fileName: '${schema.name}_repository.dart',
    template: 'repository_impl.tpl',
    data: repoImplGen.buildTemplateData(),
  );

  FileWriter.write(
    path: 'lib/app_features/${schema.feature}/domain/usecases',
    fileName: '${schema.name}_usecase.dart',
    template: 'usecase.tpl',
    data: useCaseGen.buildTemplateData(),
  );

  FileWriter.write(
    path: 'lib/app_features/${schema.feature}/domain/usecases',
    fileName: '${schema.name}_parameters.dart',
    template: 'parameters.tpl',
    data: paramsGen.buildTemplateData(),
  );
}
