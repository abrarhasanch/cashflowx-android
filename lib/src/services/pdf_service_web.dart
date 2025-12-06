// ignore_for_file: avoid_web_libraries_in_flutter, deprecated_member_use
import 'dart:html' as html;
import 'dart:typed_data';

/// Web implementation for saving and sharing PDFs
Future<void> saveAndSharePdf({
  required Uint8List bytes,
  required String fileName,
  required String subject,
  required String text,
}) async {
  // Create a blob from the PDF bytes
  final blob = html.Blob([bytes], 'application/pdf');
  
  // Create a download URL
  final url = html.Url.createObjectUrlFromBlob(blob);
  
  // Create an anchor element and trigger download
  final anchor = html.AnchorElement(href: url)
    ..target = 'blank'
    ..download = fileName;
  
  // Trigger the download
  html.document.body?.append(anchor);
  anchor.click();
  
  // Clean up
  anchor.remove();
  html.Url.revokeObjectUrl(url);
}
