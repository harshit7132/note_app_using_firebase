import 'package:cloud_firestore/cloud_firestore.dart';

class NoteModel {
  String? title;
  String? body;
  Timestamp? timer;

  NoteModel({this.title, this.body, this.timer});

  factory NoteModel.fromJson(Map<String, dynamic> json) {
    return NoteModel(
      title: json['title'],
      body: json['body'],
      timer: json['timer'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'body': body,
      'timer': DateTime.now(),
    };
  }
}
