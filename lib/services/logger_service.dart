import 'dart:io';
import 'package:path_provider/path_provider.dart';

class LoggerService {
  static Future<void> log(String message) async {
    final now = DateTime.now();
    final logMessage = '[${now.toIso8601String()}] $message\n';

    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/log.txt');

    await file.writeAsString(logMessage, mode: FileMode.append);
  }
}