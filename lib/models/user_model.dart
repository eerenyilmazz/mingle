class UserModel {
  final String id;
  final String fullName;
  final String email;
  final String biography;
  final String profileImageUrl;

  UserModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.biography,
    required this.profileImageUrl,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      fullName: json['fullName'],
      email: json['email'],
      biography: json['biography'],
      profileImageUrl: json['profileImageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'biography': biography,
      'profileImageUrl': profileImageUrl,
    };
  }
}
