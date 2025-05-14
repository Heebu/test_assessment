import 'package:cloud_firestore/cloud_firestore.dart';

class ArticleModel {
  final String id;
  final String title;
  final String content;
  final Timestamp timeCreated;
  final Timestamp lastEdit;
  final bool isPinned;
  final bool isDeleted;
  final String userId;
  final List<String> tags;


  ArticleModel({
    required this.id,
    required this.title,
    required this.content,
    required this.timeCreated,
    required this.lastEdit,
    required this.isPinned,
    required this.isDeleted,
    required this.userId,
    this.tags = const [],
  });

  factory ArticleModel.fromMap(Map<String, dynamic> data) {
    return ArticleModel(
      id: data['id'],
      title: data['title'],
      content: data['content'],
      timeCreated: data['timeCreated'],
      lastEdit: data['lastEdit'],
      isPinned: data['isPinned'],
      isDeleted: data['isDeleted'],
      userId: data['userId'],
      tags: List<String>.from(data['tags'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'content': content,
      'timeCreated': timeCreated,
      'lastEdit': lastEdit,
      'isPinned': isPinned,
      'isDeleted': isDeleted,
      'userId': userId,
      'tags': tags,
    };
  }


}
