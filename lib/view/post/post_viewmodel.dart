import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;


class PostViewModel extends BaseViewModel{
  final notePath = FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection('notes');
  TextEditingController headerController = TextEditingController();
  String category = '';
  bool isPinned = false;
  bool moreEditingOptions = true;
  bool isBold = false;
  bool isItalic = false;
  bool isUnderLine = false;

  late final quill.QuillController controller;

  PostViewModel(String? initialContentJson, bool? isPin) {
    _initializeEditor(initialContentJson);
    isPinned = isPin!;
    notifyListeners();
  }

  void _initializeEditor(String? content) {

    try {
      final doc = quill.Document.fromJson(jsonDecode(content!));
      controller = quill.QuillController(
        document: doc,
        selection: const TextSelection.collapsed(offset: 0),
      );
    } catch (_) {

      final doc = quill.Document()..insert(0, content ?? '');
      controller = quill.QuillController(
        document: doc,
        selection: const TextSelection.collapsed(offset: 0),
      );
    }
  }


   void onPinning(articleId) async{
     isPinned = !isPinned;
     notifyListeners();

     await notePath
         .doc(articleId)
         .update({
       'isPinned': isPinned,
     });

   }


   onMoreEditingOptions(){
     moreEditingOptions = !moreEditingOptions;
     notifyListeners();
   }

   void onSelectCat(pickedCat) {
     category = pickedCat;
     notifyListeners();
   }

  void toggleAttribute(quill.Attribute attribute) {
    final currentAttr = controller
        .getSelectionStyle()
        .attributes[attribute.key];

    if (currentAttr == null) {
      controller.formatSelection(attribute);
    } else {
      controller.formatSelection(quill.Attribute.clone(attribute, null));
    }
    isBold = controller.getSelectionStyle().attributes.containsKey(quill.Attribute.bold.key);
    isItalic = controller.getSelectionStyle().attributes.containsKey(quill.Attribute.italic.key);
    isUnderLine = controller.getSelectionStyle().attributes.containsKey(quill.Attribute.underline.key);
    notifyListeners();
  }

  void toggleAlignment(quill.Attribute alignment) {
    controller.formatSelection(alignment);
    notifyListeners();
  }

  Future<String> updateArticle({
    required String articleId,
    required String oldTitle,
    required String oldCategory,
  })
  async {
     String result = 'an error occurred';

    try {
      final jsonContent = controller.document.toDelta().toJson();

      await notePath
          .doc(articleId)
          .update({
        'title': headerController.text.isNotEmpty? headerController.text: oldTitle,
        'tags': oldCategory != category? category: oldCategory,
        'content': jsonContent,
        'lastEdit': FieldValue.serverTimestamp(),
      });

      result = 'success';
    } catch (e) {
      result = 'Error updating article: $e';
      rethrow;
    }
    return result;
  }


  Future<String> deleteArticle({
    required String articleId,
  })
  async {
    String result = 'an error occurred';

    try {
      await notePath
          .doc(articleId)
          .delete();

      result = 'success';
    } catch (e) {
      result = 'Error deleting article: $e';
      rethrow;
    }
    return result;
  }


}