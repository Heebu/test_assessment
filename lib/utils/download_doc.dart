import 'dart:io';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';

Future<String> saveQuillContentAsPdf(quill.QuillController controller, String fileName) async {
 String responds = 'an unexpected error occurred';
  try {
    // Request storage permission
    final status = await Permission.storage.request();
    if (!status.isGranted) {
      responds = 'Storage permission denied';
      throw Exception("Storage permission denied");
    }

    // Get the text from the controller
    final plainText = controller.document.toPlainText();

    // Create a PDF document
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          return pw.Container(
            padding: const pw.EdgeInsets.all(24),
            child: pw.Text(
              plainText,
              style: pw.TextStyle(fontSize: 14),
            ),
          );
        },
      ),
    );

    // Save the file to the device
    final dir = await getExternalStorageDirectory(); // On Android: /storage/emulated/0/Android/data/<package>/files
    final path = '${dir!.path}/$fileName.pdf';
    final file = File(path);
    await file.writeAsBytes(await pdf.save());

    responds = 'PDF saved to: $path';
    print('PDF saved to: $path');
  } catch (e) {
    responds = 'Error saving PDF: $e';
    print('Error saving PDF: $e');
  }

  return responds;
}



Future<void> generateAndSharePdf(quill.QuillController controller, String fileName) async {
  try {
    // Request permission (Android)
    final status = await Permission.storage.request();
    if (!status.isGranted) throw Exception("Storage permission denied");

    // Create the PDF
    final pdf = pw.Document();
    final plainText = controller.document.toPlainText();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          return pw.Container(
            padding: const pw.EdgeInsets.all(24),
            child: pw.Text(
              plainText,
              style: pw.TextStyle(fontSize: 14),
            ),
          );
        },
      ),
    );

    // Save the file locally
    final dir = await getTemporaryDirectory(); // use temp directory for share
    final filePath = '${dir.path}/$fileName.pdf';
    final file = File(filePath);
    await file.writeAsBytes(await pdf.save());

    // Share the file
    await Share.shareXFiles([XFile(filePath)], text: fileName);

  } catch (e) {
    print('Error generating/sharing PDF: $e');
  }
}
