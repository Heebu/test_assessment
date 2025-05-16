import 'package:flutter_quill/flutter_quill.dart' hide Text;

String extractPlainText(List<dynamic> deltaJson) {
  final doc = Document.fromJson(deltaJson);
  return doc.toPlainText();
}

// import 'dart:convert';
//
// String extractPlainText(String deltaString) {
//   try {
//     final List<dynamic> deltaJson = jsonDecode(deltaString);
//     final doc = Document.fromJson(deltaJson);
//     return doc.toPlainText();
//   } catch (e) {
//     print('Error extracting plain text: $e');
//     return '';
//   }
// }

