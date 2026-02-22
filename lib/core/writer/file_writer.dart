import 'dart:io';

class FileWriter {
  void write(String path, String content) {
    final file = File(path);
    file.createSync(recursive: true);
    file.writeAsStringSync(content);
  }
}
