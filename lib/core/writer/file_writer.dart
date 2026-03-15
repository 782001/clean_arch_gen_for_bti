import 'dart:io';

class FileWriter {
  final String? basePath;

  FileWriter([this.basePath]);

  String getFinalPath(String path) {
    String finalPath = path;
    
    // First, trim any trailing slashes from basePath if present safely
    final safeBase = basePath?.replaceAll(RegExp(r'[\\\/]$'), '');

    if (safeBase != null && safeBase.isNotEmpty) {
      // User provided a path, we force prepend it directly
      finalPath = '$safeBase/$path';
    } else {
      // Default clean architecture flutter flow if no CLI path provided
      if (!path.startsWith('/') && !path.startsWith(RegExp(r'^[a-zA-Z]:\\'))) {
        if (!path.startsWith('lib/')) {
          finalPath = 'lib/$path';
        }
      }
    }
    return finalPath;
  }

  void write(String path, String content) {
    final file = File(getFinalPath(path));
    file.createSync(recursive: true);
    file.writeAsStringSync(content);
  }
}
