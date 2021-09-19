import 'package:cloud_firestore/cloud_firestore.dart';

class HomeData {
  List<NotesRowItem> listData = [];

  HomeData.fromSnapshots(List<QueryDocumentSnapshot> docs) {
    listData = docs.map((e) => NotesRowItem.fromJson(e.data())).toList();
  }
}

class NotesRowItem {
  String? title;
  String? content;
  String? createdAt;
  String? color;

  NotesRowItem.fromJson(Map<String, dynamic> data) {
    this.title = data['title'];
    this.content = data['description'];
    this.color = data['color'];
    this.createdAt = data['created_at'];
  }
}
