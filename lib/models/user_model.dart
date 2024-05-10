class User {
  final String uid;
  final String fullName;
  final int age;
  final String email;

  User({
    required this.uid,
    required this.fullName,
    required this.age,
    required this.email,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'fullName': fullName,
      'age': age,
      'email': email,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      uid: map['uid'],
      fullName: map['fullName'],
      age: map['age'],
      email: map['email'],
    );
  }
}
