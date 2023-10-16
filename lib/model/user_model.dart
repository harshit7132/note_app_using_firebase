class UserModel {
  String? id;
  String? name;
  String? email;
  String? mobNumber;

  UserModel({this.id, this.name, this.email, this.mobNumber});

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
        id: map['id'],
        name: map['name'],
        email: map['email'],
        mobNumber: map['mobNumber']);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'mobNumber': mobNumber,
    };
  }
}
