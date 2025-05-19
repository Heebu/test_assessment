
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';
import 'package:uuid/uuid.dart';
import '../../main.dart';
import '../../model/article_model.dart';
import '../../utils/all_categories.dart';
import '../../utils/date_convert.dart';
import '../../utils/plain_text.dart';
import '../shared/preview_cards.dart';
import 'home_viewmodel.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.reactive(
       onDispose: (viewModel) => viewModel.allArticles,
      viewModelBuilder: () => HomeViewModel(),
      builder: (context, viewModel, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text('${viewModel.today.year}, ${viewModel.today.month} '),
            actions: [
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert), // More options icon
                onSelected: (value) async {
                  switch (value) {

                    case 'mode':
                      //
                      themeNotifier.value = themeNotifier.value == ThemeMode.dark
                          ? ThemeMode.light
                          : ThemeMode.dark;
                      break;
                    case 'logout':
                      viewModel.signOut(context);
                      break;
                  }
                },
                itemBuilder: (BuildContext context) => [

                   PopupMenuItem(
                    value: 'mode',
                    child:   themeNotifier.value == ThemeMode.dark? Text('Light Mode'):  Text('Dark Mode'),
                  ),
                  const PopupMenuItem(
                    value: 'logout',
                    child: Text('LogOut'),
                  ),
                ],
              ),
            ],
            bottom: PreferredSize(
              preferredSize: Size(double.maxFinite, 50),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: SearchBar(
                  controller: viewModel.searchController,
                  onChanged: (value) {
                    viewModel.onSearch(value);
                  },
                  hintText: 'Search for notes',
                  leading: Icon(Icons.search),
                ),
              ),
            ),
          ),

          body: Column(
            children: [
              SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: viewModel.daysInMonth.length,
                  itemBuilder: (context, index) {
                    final days = viewModel.daysInMonth;
                    final date = days[index];
                    final dayNumber = date.day;
                    final weekday = DateFormat('EEE').format(date);

                    bool isPicked = dayNumber == viewModel.pickedDate.day;

                    return GestureDetector(
                      onTap: () {
                        viewModel.onPickedDate(date);
                      },
                      child: Container(
                        width: 60,
                        padding: EdgeInsets.symmetric(vertical: 10),
                        margin: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: isPicked ? Colors.brown : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isPicked ? Colors.white : Colors.brown,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              weekday,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: isPicked ? Colors.white : Colors.brown,
                              ),
                            ),

                            Text(
                              '$dayNumber',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: isPicked ? Colors.white : Colors.brown,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              SizedBox(
                height: 70,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: allCategories.length,
                  itemBuilder: (context, index) {
                    String category = allCategories[index];
                    bool isPicked = viewModel.categoryPicked == category;

                    return GestureDetector(
                      onTap: () {
                        viewModel.onPickedCat(category);
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 5,
                          horizontal: 20.w,
                        ),
                        margin: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: isPicked ? Colors.brown : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.brown),
                        ),
                        child: Center(
                          child: Text(
                            category,
                            style: Theme.of(
                              context,
                            ).textTheme.bodySmall?.copyWith(
                              color: isPicked ? Colors.white : Colors.brown,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              Expanded(
                child: StreamBuilder<List<ArticleModel>>(
                  stream: viewModel.articlesStream,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }


                    final articles = snapshot.data ?? [];


                    final filteredArticles = articles.where((article) {
                      final title = article.title.toLowerCase();
                      final plainText = extractPlainText(article.content);
                      final content = plainText.toLowerCase();
                      final timing = article.timeCreated.toDate();
                      final categories = article.tags.toLowerCase();

                      final searchQuery = viewModel.search.toLowerCase();
                      final selectedCategory = viewModel.categoryPicked.toLowerCase();
                      final pickedDate = viewModel.pickedDate;

                      final matchesTitleOrContent = title.contains(searchQuery) || content.contains(searchQuery);

                      final matchesCategory = selectedCategory == 'all' || selectedCategory.isEmpty || categories.contains(selectedCategory);

                      final matchesDate = isSameDay(timing, pickedDate);

                      return matchesTitleOrContent && matchesCategory && matchesDate;
                    }).toList();



                    if (filteredArticles.isEmpty) {
                      return const Center(child: Text('No articles available'));
                    }

                    return GridView.builder(
                      gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                      ),
                      itemCount: filteredArticles.length,
                      itemBuilder: (context, index) {
                        return NotesContainer(
                          articleModel: filteredArticles[index],
                        );
                      },
                    );
                  },
                ),
              ),

            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              showAdaptiveDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('Add a new note'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          controller: viewModel.titleController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Title',
                          ),
                        ),
                      ],
                    ),
                    actions: [
                      ElevatedButton(onPressed: () async{
                        final uuid = Uuid();
                        String itemId = uuid.v7();
                        String result = await viewModel.createNote(itemId);
                        if(result == 'success') {
                         Navigator.pop(context);
                        };
                      }, child: viewModel.isCreating? CircularProgressIndicator() :Text('Create'))
                    ],
                  );
                },
              );
            },
            child: Icon(Icons.add),
          ),
        );
      },
    );
  }
}
