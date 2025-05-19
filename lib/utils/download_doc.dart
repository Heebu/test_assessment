import 'dart:io';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';

Future<bool> requestStoragePermission() async {
  if (!kIsWeb && Platform.isAndroid) {
    final androidInfo = await DeviceInfoPlugin().androidInfo;
    final sdkInt = androidInfo.version.sdkInt;

    if (sdkInt >= 30) {
      final status = await Permission.manageExternalStorage.request();
      return status.isGranted;
    } else {
      final status = await Permission.storage.request();
      return status.isGranted;
    }
  } else if (!kIsWeb && Platform.isIOS) {
    // iOS doesn't need manual permission for app's sandbox
    return true;
  }
  return false;
}

/// Save Quill content as PDF and return file path
Future<String> saveQuillContentAsPdf(
    quill.QuillController controller,
    String baseFileName,
    ) async {
  String response = 'An unexpected error occurred';
  try {
    final hasPermission = await requestStoragePermission();
    if (!hasPermission) throw Exception("Storage permission denied");

    final plainText = controller.document.toPlainText();

    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) => pw.Container(
          padding: const pw.EdgeInsets.all(24),
          child: pw.Text(plainText, style: pw.TextStyle(fontSize: 14)),
        ),
      ),
    );

    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final fileName = '$baseFileName-$timestamp.pdf';

    final dir = await getExternalStorageDirectory();
    final filePath = '${dir!.path}/$fileName';
    final file = File(filePath);
    await file.writeAsBytes(await pdf.save());

    debugPrint('PDF saved to: $filePath');
    return 'PDF saved to: $filePath';
  } catch (e) {
    debugPrint('Error saving PDF: $e');
    return 'Error saving PDF: $e';
  }
}

/// Generate and share the Quill content as a PDF
Future<void> generateAndSharePdf(
    quill.QuillController controller,
    String baseFileName,
    ) async {
  try {
    final hasPermission = await requestStoragePermission();
    if (!hasPermission) throw Exception("Storage permission denied");

    final plainText = controller.document.toPlainText();
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) => pw.Container(
          padding: const pw.EdgeInsets.all(24),
          child: pw.Text(plainText, style: pw.TextStyle(fontSize: 14)),
        ),
      ),
    );

    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final fileName = '$baseFileName-$timestamp.pdf';

    final tempDir = await getTemporaryDirectory();
    final filePath = '${tempDir.path}/$fileName';
    final file = File(filePath);
    await file.writeAsBytes(await pdf.save());

    await Share.shareXFiles([XFile(filePath)], text: 'Here is your note!');
  } catch (e) {
    debugPrint('Error generating/sharing PDF: $e');
  }
}
