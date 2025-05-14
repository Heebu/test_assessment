import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test_assessment/model/article_model.dart';
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
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => EditingPage(articleModel: articleModel,),));
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: getRandomCoolColor(),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  articleModel.title,
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                articleModel.isPinned?  IconButton(onPressed: () {}, icon: Icon( Icons.push_pin )): SizedBox.shrink(),
              ],
            ),
            Text(articleModel.content),
          ],
        ),
      ),
    );
  }
}
