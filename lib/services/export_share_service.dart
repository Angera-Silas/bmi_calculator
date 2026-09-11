import 'dart:io';
import 'dart:typed_data';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

/// Platform sharing helper for health exports.
///
/// All methods are static and stateless. They accept the already-generated
/// payload, persist it to a temporary file, and delegate to the platform
/// share sheet via `share_plus` (v13 `SharePlus` API).
class ExportShareService {
  const ExportShareService._();

  /// Shares a text payload (e.g. CSV) via the platform share sheet.
  static Future<ShareResult> shareText({
    required String text,
    required String fileName,
    String subject = 'Health Report',
  }) async {
    final file = await _writeTempFile(fileName, text: text);
    return SharePlus.instance.share(
      ShareParams(files: [XFile(file.path, mimeType: _mimeType(fileName))], subject: subject),
    );
  }

  /// Shares a binary payload (e.g. PDF) via the platform share sheet.
  static Future<ShareResult> shareBytes({
    required Uint8List bytes,
    required String fileName,
    String subject = 'Health Report',
  }) async {
    final file = await _writeTempFile(fileName, bytes: bytes);
    return SharePlus.instance.share(
      ShareParams(files: [XFile(file.path, mimeType: _mimeType(fileName))], subject: subject),
    );
  }

  /// Writes the payload to a temp file in the app cache directory.
  /// The OS purges the cache directory automatically.
  static Future<File> _writeTempFile(
    String fileName, {
    String? text,
    Uint8List? bytes,
  }) async {
    final dir = await getTemporaryDirectory();
    final file = File(p.join(dir.path, fileName));
    if (text != null) {
      await file.writeAsString(text, flush: true);
    } else if (bytes != null) {
      await file.writeAsBytes(bytes, flush: true);
    } else {
      throw ArgumentError('Either text or bytes must be provided.');
    }
    return file;
  }

  static String _mimeType(String fileName) {
    final ext = p.extension(fileName).toLowerCase();
    return switch (ext) {
      '.csv' => 'text/csv',
      '.pdf' => 'application/pdf',
      _ => 'application/octet-stream',
    };
  }
}
