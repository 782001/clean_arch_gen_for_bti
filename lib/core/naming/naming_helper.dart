class NamingHelper {
  final String rawName; // increase_item_quantity

  NamingHelper(this.rawName);

  /// increase_item_quantity -> IncreaseItemQuantity
  String get pascalCase {
    return rawName
        .split('_')
        .map((e) => e[0].toUpperCase() + e.substring(1))
        .join();
  }

  /// increase_item_quantity -> increaseItemQuantity
  String get camelCase {
    final p = pascalCase;
    return p[0].toLowerCase() + p.substring(1);
  }

  /// ===== Domain =====
  String get responseEntity =>
      '${pascalCase}ResponseEntity';

  String get baseRepository =>
      '${pascalCase}BaseRepository';

  String get useCase =>
      '${pascalCase}UseCase';

  String get parameters =>
      '${pascalCase}Parameters';

  /// ===== Data =====
  String get responseModel =>
      '${pascalCase}ResponseModel';

  String get repositoryImpl =>
      '${pascalCase}Repository';

  String get remoteDataSource =>
      '${pascalCase}RemoteDataSource';

  /// ===== Methods =====
  String get repositoryMethod => camelCase;
}
