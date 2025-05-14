import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';
import '../../utils/all_categories.dart';
import '../shared/preview_cards.dart';
import 'home_viewmodel.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.reactive(
      viewModelBuilder: () => HomeViewModel(),
      builder: (context, viewModel, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text('${viewModel.today.year}, ${viewModel.today.month} '),
            actions: [
              IconButton(icon: Icon(Icons.more_vert), onPressed: () {}),
            ],
            bottom: PreferredSize(
              preferredSize: Size(double.maxFinite, 50),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: SearchBar(
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
                          color: isPicked ? Colors.black : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isPicked ? Colors.white : Colors.black,
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
                                color: isPicked ? Colors.white : Colors.black,
                              ),
                            ),

                            Text(
                              '$dayNumber',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: isPicked ? Colors.white : Colors.black,
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
                        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20.w),
                        margin: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: isPicked? Colors.black : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.black),
                        ),
                        child: Center(
                          child: Text(
                            category,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: isPicked? Colors.white: Colors.black),
                          ),
                        ),

                        ///
                      ),
                    );
                  },
                ),
              ),

              Expanded(
                child: Container(
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                    ),
                    itemBuilder: (context, index) {
                      return NotesContainer();
                    },
                  ),
                ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {},
            child: Icon(Icons.add),
          ),
        );
      },
    );
  }
}

