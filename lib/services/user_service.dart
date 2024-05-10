import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/user_model.dart' as customUser;

class UserService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<customUser.User?> signUp({
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

        return customUser.User(
          uid: firebaseUser.uid,
          fullName: fullName,
          age: age,
          email: email,
        );
      }
    } catch (e) {
      debugPrint("Error signing up: $e");
    }
    return null;
  }
}
