import '../../../../core/services/injection_container.dart';
import '../../../../core/dio_client/dio_client.dart';
import '../data/data_sources/{{feature}}_remote_ds.dart';
import '../data/repositories/{{feature}}_repo_impl.dart';
import '../domain/repositories/{{feature}}_repo_base.dart';
import '../domain/usecases/{{feature}}_usecase.dart';
import '../presentation/controller/{{module}}_cubit/{{module}}_cubit.dart';

class {{Module}}DI {
  static Future<void> init() async {
    // {{Module}}
    /// -----{{Module}}Cubit------
    sl.registerFactory<{{Module}}Cubit>(
      () => {{Module}}Cubit(
        k{{Feature}}UseCase: sl(),
      ),
    );

    /// --------useCases----------
    sl.registerLazySingleton<{{Feature}}UseCase>(
      () => {{Feature}}UseCase(baseRepository: sl()),
    );

    /// --------Repository--------
    sl.registerLazySingleton<{{Feature}}BaseRepository>(
      () => {{Feature}}Repository(sl()),
    );

    /// --------DataSource--------
    sl.registerLazySingleton<{{Feature}}BaseRemoteDataSource>(
      () => {{Feature}}RemoteDataSource(sl<DioClient>()),
    );
  }
}
