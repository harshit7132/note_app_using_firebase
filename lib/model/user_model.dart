class UserModel {
  String? id;
  String? name;
  String? email;
  String? password;
  String? mobNumber;
  String profilePic;

  UserModel(
      {this.id,
      this.name,
      this.email,
      this.mobNumber,
      this.profilePic = '',
      this.password});

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      mobNumber: map['mobNumber'],
      profilePic: map['profilePic'],
      password: map['password'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'mobNumber': mobNumber,
      'profilePic': profilePic,
      'password': password,
    };
  }
}
