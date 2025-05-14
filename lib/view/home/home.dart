import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'home_viewmodel.dart';

class HomeScreen extends StatelessWidget {

  const HomeScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.reactive(viewModelBuilder: () => HomeViewModel(), builder: (context, viewModel, child) {
      return Scaffold(
        appBar: AppBar(
          title: Text('${viewModel.today.toDate().year}, ${viewModel.today.toDate().month} '),
          actions: [
            IconButton(
            icon: Icon(Icons.more_vert), onPressed: () {  },
            ),
          ],
          bottom: PreferredSize(preferredSize: Size(double.maxFinite, 50),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: SearchBar(
                  hintText: 'Search for notes',
                  leading: Icon(Icons.search),
                ),
              )),
        ),
        body: const Center(
          child: Text('Note list goes here'),
        ),
      );
    },);
  }
}
