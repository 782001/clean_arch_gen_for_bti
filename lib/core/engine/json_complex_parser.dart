import 'package:dart_style/dart_style.dart';

class JsonComplexParser {
  final Map<String, dynamic> _json;
  final String _rootEntityName;

  final Map<String, ClassInfo> _entityClasses = {};

  JsonComplexParser(this._rootEntityName, this._json) {
    _parse(_rootEntityName, _json);
  }

  void _parse(String entityName, Map<String, dynamic> json) {
    if (_entityClasses.containsKey(entityName)) return;

    final fields = <String, FieldInfo>{};

    for (final entry in json.entries) {
      final key = entry.key;
      final value = entry.value;

      final typeAndSubclass = _inferType(key, value, entityName);
      fields[key] = typeAndSubclass;
    }

    _entityClasses[entityName] = ClassInfo(entityName, fields);
  }

  FieldInfo _inferType(String key, dynamic value, String parentClassName) {
    if (value == null) {
      return FieldInfo(key, 'dynamic', false, true);
    }
    if (value is String) return FieldInfo(key, 'String', false, true);
    if (value is int) return FieldInfo(key, 'int', false, true);
    if (value is double) return FieldInfo(key, 'double', false, true);
    if (value is bool) return FieldInfo(key, 'bool', false, true);

    if (value is Map<String, dynamic>) {
      final baseName = _pascalCase(key);
      final entityName = '${baseName}Entity';
      _parse(entityName, value);
      return FieldInfo(key, entityName, false, false, baseName);
    }

    if (value is List) {
      if (value.isEmpty) {
        return FieldInfo(key, 'dynamic', true, true);
      }
      final first = value.first;
      if (first is Map<String, dynamic>) {
        final baseName = _pascalCase(key) + 'Item';
        final entityName = '${baseName}Entity';
        _parse(entityName, first);
        return FieldInfo(key, entityName, true, false, baseName);
      } else {
        final primitiveType = _inferType(key, first, parentClassName).type;
        return FieldInfo(key, primitiveType, true, true);
      }
    }
    return FieldInfo(key, 'dynamic', false, true);
  }

  String _pascalCase(String str) {
    if (str.isEmpty) return 'Obj';
    return str.split(RegExp(r'[_|\-| ]')).map((word) {
      if (word.isEmpty) return '';
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join('');
  }

  String generateEntities() {
    final buffer = StringBuffer();
    for (final cls in _entityClasses.values) {
      buffer.writeln('class ${cls.name} {');
      for (final f in cls.fields.values) {
        final typeStr = f.isList ? 'List<${f.type}>?' : '${f.type}?';
        buffer.writeln('  final $typeStr ${f.name};');
      }
      buffer.writeln('\n  ${cls.name}({');
      for (final f in cls.fields.values) {
        buffer.writeln('    this.${f.name},');
      }
      buffer.writeln('  });');
      buffer.writeln('}\n');
    }
    
    try {
      return DartFormatter(languageVersion: DartFormatter.latestLanguageVersion).format(buffer.toString());
    } catch(e) {
      return buffer.toString();
    }
  }

  String generateModels() {
    final buffer = StringBuffer();
    final allEntitiesCode = generateEntities();
    
    // In Dart, extending from an Entity requires the Entity class to be imported or present.
    // Assuming models import their corresponding entities.
    // We will generate the model classes matching the entities correctly.
    for (final cls in _entityClasses.values) {
      final modelName = cls.name.replaceAll('Entity', 'Model');
      buffer.writeln('class $modelName extends ${cls.name} {');

      buffer.writeln('  $modelName({');
      for (final f in cls.fields.values) {
        buffer.writeln('    super.${f.name},');
      }
      buffer.writeln('  });\n');

      buffer.writeln('  factory $modelName.fromJson(Map<String, dynamic> json) {');
      buffer.writeln('    return $modelName(');
      for (final f in cls.fields.values) {
        if (f.isList) {
          if (f.isPrimitive) {
            buffer.writeln(
                "      ${f.name}: (json['${f.name}'] as List<dynamic>?)?.map((e) => e as ${f.type}).toList(),");
          } else {
            final childModelName = f.baseName! + 'Model';
            buffer.writeln(
                "      ${f.name}: (json['${f.name}'] as List<dynamic>?)?.map((e) => $childModelName.fromJson(e as Map<String, dynamic>)).toList(),");
          }
        } else {
          if (f.isPrimitive) {
            if (f.type == 'double' || f.type == 'num') {
              buffer.writeln("      ${f.name}: (json['${f.name}'] as num?)?.toDouble(),");
            } else if (f.type != 'dynamic') {
              buffer.writeln("      ${f.name}: json['${f.name}'] as ${f.type}?,");
            } else {
              buffer.writeln("      ${f.name}: json['${f.name}'],");
            }
          } else {
            final childModelName = f.baseName! + 'Model';
            buffer.writeln(
                "      ${f.name}: json['${f.name}'] != null ? $childModelName.fromJson(json['${f.name}'] as Map<String, dynamic>) : null,");
          }
        }
      }
      buffer.writeln('    );');
      buffer.writeln('  }\n');

      buffer.writeln('  Map<String, dynamic> toJson() {');
      buffer.writeln('    return {');
      for (final f in cls.fields.values) {
        if (f.isList && !f.isPrimitive) {
          final paramMap = f.type != 'dynamic' ? '(e as ${f.baseName}Model).toJson()' : 'e';
          buffer.writeln(
              "      '${f.name}': ${f.name}?.map((e) => $paramMap).toList(),");
        } else if (!f.isPrimitive && !f.isList) {
          buffer.writeln(
              "      '${f.name}': (${f.name} as ${f.baseName}Model?)?.toJson(),");
        } else {
          buffer.writeln("      '${f.name}': ${f.name},");
        }
      }
      buffer.writeln('    };');
      buffer.writeln('  }');

      buffer.writeln('}\n');
    }
    
    try {
      return DartFormatter(languageVersion: DartFormatter.latestLanguageVersion).format(buffer.toString());
    } catch(e) {
      return buffer.toString();
    }
  }
}

class ClassInfo {
  final String name;
  final Map<String, FieldInfo> fields;
  ClassInfo(this.name, this.fields);
}

class FieldInfo {
  final String name;
  final String type;
  final bool isList;
  final bool isPrimitive;
  final String? baseName;

  FieldInfo(this.name, this.type, this.isList, this.isPrimitive,
      [this.baseName]);
}
