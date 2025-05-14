import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';

import '../../utils/random_colors.dart';
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
                height: 50,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: viewModel.daysInMonth.length,
                  itemBuilder: (context, index) {

                    return GestureDetector(
                      onTap: () {
                      },
                      child: Container(
                       
                        padding: EdgeInsets.symmetric(vertical: 10),
                        margin: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.brown,
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

class NotesContainer extends StatelessWidget {
   NotesContainer({
    super.key,
  });

  final Random random = Random();

  Color getRandomCoolColor() {
    return coolColors[random.nextInt(coolColors.length)];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: getRandomCoolColor(),
        borderRadius: BorderRadius.circular(10.r)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Hello World', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),),
              IconButton(onPressed: (){}, icon: Icon(Icons.favorite))
            ],
          ),
          Text('Hello World'),
        ],
      ),
    );
  }
}
