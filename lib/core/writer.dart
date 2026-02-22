import 'dart:io';

class FileWriter {
  static void write({
    required String path,
    required String fileName,
    required String template,
    required Map<String, String> data,
  }) {
    final dir = Directory(path);
    if (!dir.existsSync()) {
      dir.createSync(recursive: true);
    }

    final templateFile =
        File('lib/core/templates/$template').readAsStringSync();

    var content = templateFile;
    data.forEach((k, v) {
      content = content.replaceAll('{{${k}}}', v);
    });

    File('$path/$fileName').writeAsStringSync(content);
  }
}
