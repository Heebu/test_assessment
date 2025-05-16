import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:test_assessment/model/article_model.dart';
import 'package:test_assessment/view/shared/snack_bar.dart';
import '../../utils/plain_text.dart';
import '../../utils/random_colors.dart';
import '../post/edit_screen_view.dart';

class NotesContainer extends StatelessWidget {
  NotesContainer({super.key, required this.articleModel});
  final ArticleModel articleModel;

  final Random random = Random();

  Color getRandomCoolColor() {
    return coolColors[random.nextInt(coolColors.length)];
  }

  @override
  Widget build(BuildContext context) {

    String headline = articleModel.title.length<10? articleModel.title: articleModel.title.replaceRange(9, articleModel.title.length, '..');

    final plainText = extractPlainText(articleModel.content);
    final contentPreview = plainText.length < 70
        ? plainText
        : plainText.replaceRange(69, plainText.length, '..');

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => EditingPage(articleModel: articleModel,),));
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: getRandomCoolColor().withOpacity(.9),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  headline,
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                articleModel.isPinned?  IconButton(onPressed: () {}, icon: Icon( Icons.push_pin )): SizedBox.shrink(),
              ],
            ),
            Expanded(
              child: Text(contentPreview, style: Theme.of(
                context,
              ).textTheme.bodyMedium,),
            ),
            Row(
              children: [
                Text(DateFormat('dd MMM yyyy').format(articleModel.lastEdit.toDate()),),
                Spacer(),
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert), // More options icon
                  onSelected: (value) async {
                    switch (value) {

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
                        try{
                          await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection('notes').doc(articleModel.id).delete();
                          showSnackBar(context, 'Note Deleted');
                        } catch(e){
                          showSnackBar(context, e.toString());
                        }

                        break;
                    }
                  },
                  itemBuilder: (BuildContext context) => [

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
              ],
            )
          ],
        ),
      ),
    );
  }
}
