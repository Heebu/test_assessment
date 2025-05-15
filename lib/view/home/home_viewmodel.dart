import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:stacked/stacked.dart';
import 'package:test_assessment/model/article_model.dart';
import 'package:test_assessment/view/shared/snack_bar.dart';
import 'package:uuid/uuid.dart';
import '../../model/time_model.dart';


class HomeViewModel extends BaseViewModel {
  bool isLoading = false;
  bool isCreating = false;
  TimeModel today = TimeModel.fromDateTime(DateTime.now());
  DateTime now = DateTime.now();
  DateTime pickedDate = DateTime.now();
  String categoryPicked = 'All';
  List<ArticleModel> allArticles = <ArticleModel>[];
  List<ArticleModel> filterArticles = <ArticleModel>[];
  String userId = FirebaseAuth.instance.currentUser!.uid;
  final userPath = FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection('notes');

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


  Stream<List<ArticleModel>> get articlesStream {
    return userPath
        .orderBy('lastEdit', descending: true)
        .snapshots()
        .map((snapshot) =>
        snapshot.docs.map((doc) => ArticleModel.fromMap(doc.data())).toList());
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
       final incomingData = await userPath.get();
       allArticles = incomingData.docs.map((doc) => ArticleModel.fromMap(doc.data())).toList();

       filterByCat(categoryPicked);
       notifyListeners();

     } catch(e){
       showSnackBar(context, e.toString());
     }

    isLoading == false;
    notifyListeners();
  }

  Future<String> createNote(String title, String category) async{
    isCreating = true;
    notifyListeners();
    String responds = 'an error occurred';
    final uuid = Uuid();
    String itemId = uuid.v7();

    try{
      await userPath.doc(itemId).set({
        'id': itemId,
        'title': title,
        'content': '',
        'isPinned': false,
        'isDeleted': false,
        'userId': userId,
        'tags': category,
        'timeCreated': Timestamp.now(),
        'lastEdit': Timestamp.now(),
      });
      responds = 'success';
    }catch(e){
      responds = e.toString();
    }

    isCreating = false;
    notifyListeners();
    return responds;
  }


}