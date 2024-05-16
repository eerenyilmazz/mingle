import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/user_model.dart' as CustomUser;

class UserService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<CustomUser.User?> signUp({
    required String fullName,
    required int age,
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? firebaseUser = userCredential.user;
      if (firebaseUser != null) {
        await _firestore.collection('users').doc(firebaseUser.uid).set({
          'fullName': fullName,
          'age': age,
          'email': email,
        });

        return CustomUser.User(
          uid: firebaseUser.uid,
          fullName: fullName,
          age: age,
          email: email,
        );
      }
    } catch (e) {
      if (kDebugMode) {
        if (kDebugMode) {
          if (kDebugMode) {
            if (kDebugMode) {
              print("Error signing up: $e");
            }
          }
        }
      }
    }
    return null;
  }

  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      if (kDebugMode) {
        print("Password reset email sent to $email");
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error sending password reset email: $e");
      }
    }
  }

  Future<CustomUser.User?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? firebaseUser = userCredential.user;
      if (firebaseUser != null) {
        DocumentSnapshot userSnapshot = await _firestore.collection('users').doc(firebaseUser.uid).get();
        if (userSnapshot.exists) {
          Map<String, dynamic> userData = userSnapshot.data() as Map<String, dynamic>;
          return CustomUser.User(
            uid: firebaseUser.uid,
            fullName: userData['fullName'],
            age: userData['age'],
            email: userData['email'],
          );
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error signing in: $e");
      }
    }
    return null;
  }

  Future<CustomUser.User?> getCurrentUser() async {
    try {
      User? firebaseUser = _auth.currentUser;
      if (firebaseUser != null) {
        DocumentSnapshot userSnapshot = await _firestore.collection('users').doc(firebaseUser.uid).get();
        if (userSnapshot.exists) {
          Map<String, dynamic> userData = userSnapshot.data() as Map<String, dynamic>;
          return CustomUser.User(
            uid: firebaseUser.uid,
            fullName: userData['fullName'],
            age: userData['age'],
            email: userData['email'],
          );
        }
      }
    } catch (e) {
      print("Error getting current user: $e");
    }
    return null;
  }
}
