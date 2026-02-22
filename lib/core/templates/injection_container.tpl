// {{Module}}
  /// -----{{Module}}Cubit------
sl.registerFactory<{{Module}}Cubit>(() => {{Module}}Cubit(
  k{{Feature}}UseCase: sl(),
));
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
  () => {{Feature}}RemoteDataSource(),
);
