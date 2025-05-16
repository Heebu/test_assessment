import 'package:flutter_quill/flutter_quill.dart' hide Text;

String extractPlainText(List<dynamic> deltaJson) {
  final doc = Document.fromJson(deltaJson);
  return doc.toPlainText();
}
