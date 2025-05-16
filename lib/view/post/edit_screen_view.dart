import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stacked/stacked.dart';
import 'package:test_assessment/view/post/post_viewmodel.dart';
import 'package:test_assessment/view/shared/snack_bar.dart';
import '../../model/article_model.dart';
import '../../utils/all_categories.dart';
import '../../utils/download_doc.dart';
import '../../utils/plain_text.dart';


class EditingPage extends StatelessWidget {
  const EditingPage({super.key, required this.articleModel});
  final ArticleModel articleModel;

  @override
  Widget build(BuildContext context) {

    final plainText = extractPlainText(articleModel.content);

    return ViewModelBuilder.reactive(
      viewModelBuilder: () => PostViewModel(plainText, articleModel.isPinned),
      builder: (context, viewModel, child) {
        return Scaffold(
          appBar: AppBar(
            title: Container(
              padding: EdgeInsets.symmetric(vertical: 10.h),
              child: TextField(
                decoration: InputDecoration(hintText: articleModel.title, border: InputBorder.none),
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            actions: [
              IconButton(
                onPressed: () async{
                  if(articleModel.tags == ''){
                    showModalBottomSheet(context: context, builder: (context) {

                      return Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 10.w,
                            vertical: 20.h
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(),
                                  Text('Categories', style: Theme.of(context).textTheme.titleMedium,),
                                  IconButton.filledTonal(onPressed: (){
                                    Navigator.pop(context);
                                  }, icon: Icon(Icons.close))
                                ]
                            ),

                            Container(
                                height: 200,
                                child: ListView.builder(
                                  itemCount: allCategories.length,
                                  itemBuilder: (context, index) {

                                    return ListTile(
                                      title: Text(allCategories[index], style: Theme.of(context).textTheme.bodyMedium,),
                                      onTap: () async{
                                        String result = await viewModel.updateArticle(articleId: articleModel.id, oldTitle: articleModel.title, oldCategory: allCategories[index]);
                                        if(result == 'success'){
                                          showSnackBar(context, 'saved');
                                          Navigator.popUntil(context, (route) => route.isFirst,);
                                        }
                                        else{
                                          showSnackBar(context, result);
                                        }

                                      },
                                    );
                                  },)
                            ),

                            Container(
                              margin: EdgeInsets.symmetric(vertical: 10.h),
                              width: double.infinity,
                              child: ElevatedButton(
                                child: Text("Save"),
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),

                                  foregroundColor: Colors.white,
                                  backgroundColor: Colors.brown,
                                  textStyle: const TextStyle(fontSize: 16),
                                ),
                                onPressed: () async {
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    },);
                  } else{
                    String result = await viewModel.updateArticle(articleId: articleModel.id, oldTitle: articleModel.title, oldCategory: articleModel.tags);
                    if(result == 'success'){
                      showSnackBar(context, 'Note Saved');
                      Navigator.of(context).pop();
                    }
                    else{
                      showSnackBar(context, result);
                    }
                  }

                },
                icon: Icon(Icons.drive_folder_upload_outlined),
              ),

              IconButton(onPressed: () {
                 viewModel.onPinning(articleModel.id);
              }, icon: Icon(viewModel.isPinned? Icons.push_pin: Icons.push_pin_outlined)),

              IconButton(onPressed: () {
                generateAndSharePdf(viewModel.controller, "my_note");
              }, icon: Icon(Icons.ios_share)),

              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert), // More options icon
                onSelected: (value) async {
                  switch (value) {
                    case 'Save':
                      String responds = await saveQuillContentAsPdf(viewModel.controller, "my_note");
                      showSnackBar(context, responds);
                      break;
                    case 'Details':
                     showModalBottomSheet(context: context, builder: (context) {
                       return Padding(
                         padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                         child: Column(
                           mainAxisSize: MainAxisSize.min,
                           children: [
                             Row(children: [
                               Text('Title: ', style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),),
                               Text(articleModel.title),
                             ],),

                             Row(children: [
                               Text('Category: ', style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),),
                               Text(articleModel.tags),
                             ],),

                             Row(children: [
                               Text('Created Date: ', style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),),
                               Text(articleModel.timeCreated.toDate().toString()),
                             ],),

                             Row(children: [
                             Text('Last Edited: ', style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),),
                       Text(articleModel.lastEdit.toDate().toString()),
                       ],),

                           ],
                         ),
                       );
                     },);

                      break;
                    case 'Delete':

                    String result = await viewModel.deleteArticle(articleId: articleModel.id);

                    if(result == 'success'){
                      showSnackBar(context, 'Note Deleted');
                      Navigator.pop(context);
                    } else{
                      showSnackBar(context, result);
                    }

                      break;
                  }
                },
                itemBuilder: (BuildContext context) => [
                  const PopupMenuItem(
                    value: 'Save',
                    child: Text('Save as pdf'),
                  ),
                  const PopupMenuItem(
                    value: 'Details',
                    child: Text('Details'),
                  ),
                  const PopupMenuItem(
                    value: 'Delete',
                    child: Text('Delete'),
                  ),
                ],
              ),



              // IconButton(onPressed: () async{
              //   if(articleModel.tags == ''){
              //     showModalBottomSheet(context: context, builder: (context) {
              //
              //       return Padding(
              //         padding: EdgeInsets.symmetric(
              //             horizontal: 10.w,
              //             vertical: 20.h
              //         ),
              //         child: Column(
              //           mainAxisSize: MainAxisSize.min,
              //           children: [
              //             Row(
              //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //                 children: [
              //                   SizedBox(),
              //                   Text('Categories', style: Theme.of(context).textTheme.titleMedium,),
              //                   IconButton.filledTonal(onPressed: (){
              //                     Navigator.pop(context);
              //                   }, icon: Icon(Icons.close))
              //                 ]
              //             ),
              //
              //             Container(
              //                 height: 200,
              //                 child: ListView.builder(
              //                   itemCount: allCategories.length,
              //                   itemBuilder: (context, index) {
              //
              //                     return ListTile(
              //                       title: Text(allCategories[index], style: Theme.of(context).textTheme.bodyMedium,),
              //                       onTap: () async{
              //                         String result = await viewModel.updateArticle(articleId: articleModel.id, oldTitle: articleModel.title, oldCategory: allCategories[index]);
              //                         if(result == 'success'){
              //                           showSnackBar(context, 'saved');
              //                           Navigator.popUntil(context, (route) => route.isFirst,);
              //                         }
              //                         else{
              //                           showSnackBar(context, result);
              //                         }
              //
              //                       },
              //                     );
              //                   },)
              //             ),
              //
              //             Container(
              //               margin: EdgeInsets.symmetric(vertical: 10.h),
              //               width: double.infinity,
              //               child: ElevatedButton(
              //                 child: Text("Save"),
              //                 style: ElevatedButton.styleFrom(
              //                   padding: const EdgeInsets.symmetric(vertical: 16),
              //                   shape: RoundedRectangleBorder(
              //                     borderRadius: BorderRadius.circular(12),
              //                   ),
              //
              //                   foregroundColor: Colors.white,
              //                   backgroundColor: Colors.brown,
              //                   textStyle: const TextStyle(fontSize: 16),
              //                 ),
              //                 onPressed: () async {
              //                 },
              //               ),
              //             ),
              //           ],
              //         ),
              //       );
              //     },);
              //   } else{
              //    String result = await viewModel.updateArticle(articleId: articleModel.id, oldTitle: articleModel.title, oldCategory: articleModel.tags);
              //    if(result == 'success'){
              //      showSnackBar(context, 'Note Saved');
              //      Navigator.of(context).pop();
              //    }
              //    else{
              //      showSnackBar(context, result);
              //    }
              //   }
              //
              // }, icon: Icon(Icons.cloud_upload_rounded)),
            ],
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 10.h),
            child: Stack(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 5.w),
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

                        IconButton(onPressed: () {
                          viewModel.onMoreEditingOptions();
                        }, icon: Icon(viewModel.moreEditingOptions? Icons.arrow_forward_ios :Icons.arrow_back_ios)),

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
        );
      },
    );
  }
}
