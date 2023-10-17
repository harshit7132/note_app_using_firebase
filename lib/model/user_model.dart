class UserModel {
  String? id;
  String? name;
  String? email;
  String? mobNumber;
  String? profilePic;

  UserModel({this.id, this.name, this.email, this.mobNumber, this.profilePic});

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
        id: map['id'],
        name: map['name'],
        email: map['email'],
        mobNumber: map['mobNumber'],
        profilePic: map['profilePic']);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'mobNumber': mobNumber,
      'profilePic': profilePic,
    };
  }
}
