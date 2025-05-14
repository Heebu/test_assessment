import 'package:flutter/cupertino.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;


class PostViewModel extends BaseViewModel{
  final quill.QuillController controller = quill.QuillController.basic();
  TextEditingController headerController = TextEditingController();

  bool moreEditingOptions = true;

   bool isBold = false;
   bool isItalic = false;
   bool isUnderLine = false;

   onMoreEditingOptions(){
     moreEditingOptions = !moreEditingOptions;
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

initClass(title, content){
     headerController = 'jfj' as TextEditingController;
}

}