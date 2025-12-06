import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

/// Mobile implementation for saving and sharing PDFs
Future<void> saveAndSharePdf({
  required Uint8List bytes,
  required String fileName,
  required String subject,
  required String text,
}) async {
  // Get temporary directory
  final tempDir = await getTemporaryDirectory();
  final file = File('${tempDir.path}/$fileName');
  
  // Write to file
  await file.writeAsBytes(bytes);
  
  // Share the file
  await Share.shareXFiles(
    [XFile(file.path)],
    subject: subject,
    text: text,
  );
}
