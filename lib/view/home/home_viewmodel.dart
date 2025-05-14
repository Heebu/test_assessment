import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stacked/stacked.dart';
import 'package:test_assessment/model/article_model.dart';
import 'package:test_assessment/view/shared/snack_bar.dart';
import '../../model/time_model.dart';


class HomeViewModel extends BaseViewModel {
  TimeModel today = TimeModel.fromDateTime(DateTime.now());
  DateTime now = DateTime.now();
  DateTime pickedDate = DateTime.now();
  String categoryPicked = 'All';
  List<ArticleModel> allArticles = <ArticleModel>[];


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
    notifyListeners();
  }

  void getAllDoc(context) async{
     try {
       final incomingData = await FirebaseFirestore.instance.collection('user').doc('').collection('collectionPath').get();
       allArticles = incomingData.docs.map((doc) => ArticleModel.fromMap(doc.data())).toList();
       notifyListeners();

     } catch(e){
       showSnackBar(context, e.toString());
     }


  }

  initFunc(){}
}