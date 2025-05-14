import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stacked/stacked.dart';
import 'package:test_assessment/view/post/post_viewmodel.dart';
import 'package:test_assessment/view/shared/snack_bar.dart';

import '../../utils/download_doc.dart';

class EditingPage extends StatelessWidget {
  const EditingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.reactive(
      viewModelBuilder: () => PostViewModel(),
      builder: (context, viewModel, child) {

        return Scaffold(
          appBar: AppBar(
            title: Container(
              padding: EdgeInsets.symmetric(vertical: 10.h),
              child: TextField(
                decoration: InputDecoration(hintText: 'Untitled', border: InputBorder.none),
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            actions: [
              IconButton(
                onPressed: () async{
                  String responds = await saveQuillContentAsPdf(viewModel.controller, "my_note");
                  showSnackBar(context, responds);
                },
                icon: Icon(Icons.drive_folder_upload_outlined),
              ),
              IconButton(onPressed: () {}, icon: Icon(Icons.push_pin)),
              IconButton(onPressed: () {
                generateAndSharePdf(viewModel.controller, "my_note");
              }, icon: Icon(Icons.ios_share)),
              IconButton(onPressed: () {
                viewModel.onMoreEditingOptions();
              }, icon: Icon(viewModel.moreEditingOptions? Icons.more_vert :Icons.more_horiz_outlined)),
            ],
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
            child: Stack(
              children: [
                Container(
                  height: double.maxFinite,
                  child: QuillEditor.basic(
                    controller: viewModel.controller,
                    config: const QuillEditorConfig(),
                    focusNode: FocusNode(),
                  ),
                ),

                Align(
                  alignment: const Alignment(0, .75),
                  child: viewModel.moreEditingOptions?
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.black87,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        viewModel.isBold?
                        IconButton.filledTonal(
                          onPressed: () {
                           viewModel.toggleAttribute(quill.Attribute.bold);
                          },
                          icon: const Icon(Icons.format_bold, color: Colors.white60),
                        ):
                        IconButton(
                          onPressed: () {
                           viewModel.toggleAttribute(quill.Attribute.bold);
                          },
                          icon: const Icon(Icons.format_bold, color: Colors.white60),
                        ),


                        viewModel.isItalic?
                        IconButton.filledTonal(
                          onPressed: () {
                            viewModel.toggleAttribute(quill.Attribute.italic);
                          },
                          icon: const Icon(Icons.format_italic, color: Colors.white60),
                        ):
                        IconButton(
                          onPressed: () {
                            viewModel.toggleAttribute(quill.Attribute.italic);
                          },
                          icon: const Icon(Icons.format_italic, color: Colors.white60),
                        ),


                        viewModel.isUnderLine?
                        IconButton.filledTonal(
                          onPressed: () {
                            viewModel.toggleAttribute(quill.Attribute.underline);
                          },
                          icon: const Icon(Icons.format_underline, color: Colors.white60),
                        ):
                        IconButton(
                          onPressed: () {
                            viewModel.toggleAttribute(quill.Attribute.underline);
                          },
                          icon: const Icon(Icons.format_underline, color: Colors.white60),
                        ),



                        IconButton(
                          onPressed: () {
                            viewModel.toggleAlignment(quill.Attribute.leftAlignment);
                          },
                          icon: const Icon(Icons.format_align_left, color: Colors.white60),
                        ),




                        IconButton(
                          onPressed: () {
                            viewModel.toggleAlignment(quill.Attribute.centerAlignment);
                          },
                          icon: const Icon(Icons.format_align_center, color: Colors.white60),
                        ),


                        IconButton(
                          onPressed: () {
                            viewModel.toggleAlignment(quill.Attribute.rightAlignment);
                          },
                          icon: const Icon(Icons.format_align_right, color: Colors.white60),
                        ),


                        IconButton(
                          onPressed: () {
                            viewModel.toggleAlignment(quill.Attribute.justifyAlignment);
                          },
                          icon: const Icon(Icons.format_align_justify, color: Colors.white60),
                        ),
                      ],
                    ),
                  ): Container(
                    decoration: BoxDecoration(
                      color: Colors.black45,
                      borderRadius: BorderRadius.circular(10.r)
                    ),
                    padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 5.w),
                    child: QuillSimpleToolbar(
                      controller: viewModel.controller,
                      config: const QuillSimpleToolbarConfig(),
                    ),
                  ),
                ),




              ],
            )
          ),
          floatingActionButton: FloatingActionButton(onPressed: (){}, child: Icon(Icons.cloud_upload_rounded),),
        );
      },
    );
  }
}
