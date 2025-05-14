import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stacked/stacked.dart';
import 'package:test_assessment/model/article_model.dart';
import 'package:test_assessment/view/shared/snack_bar.dart';
import '../../model/time_model.dart';


class HomeViewModel extends BaseViewModel {
  bool isLoading = false;
  TimeModel today = TimeModel.fromDateTime(DateTime.now());
  DateTime now = DateTime.now();
  DateTime pickedDate = DateTime.now();
  String categoryPicked = 'All';
  List<ArticleModel> allArticles = <ArticleModel>[];
  List<ArticleModel> filterArticles = <ArticleModel>[];

  filterByCat(picked){
    isLoading == true;
    notifyListeners();

    List<ArticleModel> filter = <ArticleModel>[];

    if(picked == 'all'){
      for(int x = 0; x<allArticles.length; x++){
        allArticles[x].timeCreated.toDate() == pickedDate ? filter.add(allArticles[x]): null;
      }
      filterArticles = filter;
      notifyListeners();
    }
    else{
      for(int x = 0; x<allArticles.length; x++){
        allArticles[x].tags == categoryPicked && allArticles[x].timeCreated.toDate() == pickedDate ? filter.add(allArticles[x]): null;
      }
      filterArticles = filter;
      notifyListeners();
    }
    isLoading == false;
    notifyListeners();

  }


  List<DateTime> get daysInMonth {
    return List.generate(
      now.day, // only go up to today
          (index) => DateTime(now.year, now.month, now.day - index),
    );
  }


 void onPickedDate(DateTime picked){
    pickedDate = picked;
    notifyListeners();
  }

  void onPickedCat(String picked){
    categoryPicked = picked;
    filterByCat(picked);
    notifyListeners();

  }

  void getAllDoc(context) async{
    isLoading == true;
    notifyListeners();
     try {
       final incomingData = await FirebaseFirestore.instance.collection('user').doc('').collection('collectionPath').get();
       allArticles = incomingData.docs.map((doc) => ArticleModel.fromMap(doc.data())).toList();

       filterByCat(categoryPicked);
       notifyListeners();

     } catch(e){
       showSnackBar(context, e.toString());
     }

    isLoading == false;
    notifyListeners();

  }

  initFunc(){}
}