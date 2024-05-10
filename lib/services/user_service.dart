import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../models/user_model.dart';

class UserService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      print("Error signing in: $e");
      return null;
    }
  }

  Future<User?> registerWithEmailAndPassword(String email, String password, String fullName, File? profileImage) async {
    try {
      final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final User? user = userCredential.user;
      if (user != null) {
        String profileImageUrl = '';
        if (profileImage != null) {
          final Reference storageRef = _storage.ref().child('profile_images').child(user.uid);
          await storageRef.putFile(profileImage);
          profileImageUrl = await storageRef.getDownloadURL();
        }
        await _firestore.collection('users').doc(user.uid).set({
          'fullName': fullName,
          'email': email,
          'biography': '',
          'profileImageUrl': profileImageUrl,
        });
      }
      return user;
    } catch (e) {
      print("Error registering user: $e");
      return null;
    }
  }

  Future<void> updateUserProfile(String userId, String biography, File? newProfileImage) async {
    try {
      String newProfileImageUrl = '';
      if (newProfileImage != null) {
        final Reference storageRef = _storage.ref().child('profile_images').child(userId);
        await storageRef.putFile(newProfileImage);
        newProfileImageUrl = await storageRef.getDownloadURL();
      }

      await _firestore.collection('users').doc(userId).update({
        'biography': biography,
        'profileImageUrl': newProfileImageUrl,
      });
    } catch (e) {
      print("Error updating user profile: $e");
    }
  }

  Future<UserModel?> getUserById(String userId) async {
    try {
      final DocumentSnapshot userSnapshot = await _firestore.collection('users').doc(userId).get();
      if (userSnapshot.exists) {
        return UserModel.fromJson(userSnapshot.data() as Map<String, dynamic>);
      } else {
        return null;
      }
    } catch (e) {
      print("Error getting user: $e");
      return null;
    }
  }
}
