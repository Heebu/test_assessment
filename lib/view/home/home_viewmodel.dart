import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:stacked/stacked.dart';
import 'package:test_assessment/model/article_model.dart';
import 'package:test_assessment/view/auth/login.dart';
import 'package:test_assessment/view/shared/snack_bar.dart';
import '../../model/time_model.dart';
import '../../services/auth_service.dart';


class HomeViewModel extends BaseViewModel {
  bool isLoading = false;
  bool isCreating = false;
  User? currentUser;
  TimeModel today = TimeModel.fromDateTime(DateTime.now());
  TextEditingController searchController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  String search = '';
  DateTime now = DateTime.now();
  DateTime pickedDate = DateTime.now();
  String categoryPicked = 'All';
  List<ArticleModel> allArticles = <ArticleModel>[];
  List<ArticleModel> filterArticles = <ArticleModel>[];
  String userId = FirebaseAuth.instance.currentUser!.uid;
  final userPath = FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection('notes');

  void onSearch(value){
    search = value;
    notifyListeners();
  }

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
        .map((snapshot) {
      final articles = snapshot.docs
          .map((doc) {
            return ArticleModel.fromMap(doc.data());
          })
          .toList();



      // Sort with pinned ones first
      articles.sort((a, b) {
        if (a.isPinned && !b.isPinned) return -1;
        if (!a.isPinned && b.isPinned) return 1;
        // If both are pinned/unpinned, sort by lastEdit descending
        return b.lastEdit.compareTo(a.lastEdit);
      });

      return articles;
    });
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

  Future<String> createNote(String itemId) async{
    isCreating = true;
    notifyListeners();
    String responds = 'an error occurred';

    try{
      await userPath.doc(itemId).set({
        'id': itemId,
        'title': titleController.text,
        'content': quill.Document().toDelta().toJson(),
        'isPinned': false,
        'isDeleted': false,
        'userId': userId,
        'tags': '',
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

  Future<ArticleModel> fetchArticleById(String id) async {
    final doc = await FirebaseFirestore.instance.collection('articles').doc(id).get();
      return ArticleModel.fromMap(doc.data()!);

  }


  Future<void> signOut(context) async {
    await AuthService().signOut();
    currentUser = null;
    notifyListeners();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginView(),));
  }


}