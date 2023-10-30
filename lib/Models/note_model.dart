class NoteModel {
 String? name;
 String? position;
 String? dateTime;
 NoteModel(
     {required this.name,
      required this.position,
      required this.dateTime,
      });

 NoteModel.fromMap(Map<String, dynamic> map) {
  name = map["name"];
  position = map["position"];
  dateTime = map["dateTime"];
 }

 Map<String, dynamic> toMap() {
  return {
   "name": name,
   "position": position,
   "dateTime": dateTime,
  };
 }
}