// Auth
  /// -----AuthCubit------
sl.registerFactory<AuthCubit>(() => AuthCubit(
  kGoogleLoginUseCase: sl(),
));
  /// --------useCases----------
sl.registerLazySingleton<GoogleLoginUseCase>(
  () => GoogleLoginUseCase(baseRepository: sl()),
);
  /// --------Repository--------
sl.registerLazySingleton<GoogleLoginBaseRepository>(
  () => GoogleLoginRepository(sl()),
);
  /// --------DataSource--------
sl.registerLazySingleton<GoogleLoginBaseRemoteDataSource>(
  () => GoogleLoginRemoteDataSource(),
);
