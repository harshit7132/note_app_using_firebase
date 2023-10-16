class NoteModel {
  String? title;
  String? body;
  String? timer;

  NoteModel({this.title, this.body, this.timer});

  factory NoteModel.fromJson(Map<String, dynamic> json) {
    return NoteModel(
      title: json['title'],
      body: json['body'],
      timer: json[DateTime.now()],
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
