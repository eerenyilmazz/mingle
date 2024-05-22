import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  String id;
  String name;
  int age;
  String profilePhotoPath;
  String bio;

  AppUser({
    required this.id,
    required this.name,
    required this.age,
    required this.profilePhotoPath,
    this.bio = "",
  });

  AppUser.fromSnapshot(DocumentSnapshot snapshot)
      : id = snapshot.get('id'),
        name = snapshot.get('name'),
        age = snapshot.get('age'),
        profilePhotoPath = snapshot.get('profile_photo_path'),
        bio = snapshot.get('bio') ?? '';

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'age': age,
      'profile_photo_path': profilePhotoPath,
      'bio': bio,
    };
  }
}
