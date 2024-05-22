import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthSource {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<AuthResponse<UserCredential>> signIn(String email, String password) async {
    try {
      final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return AuthResponse.success(userCredential);
    } catch (e) {
      return AuthResponse.error(
        (e is FirebaseAuthException) ? e.message ?? e.toString() : 'Unknown error occurred',
      );
    }
  }

  Future<AuthResponse<UserCredential>> register(String email, String password) async {
    try {
      final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return AuthResponse.success(userCredential);
    } catch (e) {
      return AuthResponse.error(
        (e is FirebaseAuthException) ? e.message ?? e.toString() : 'Unknown error occurred',
      );
    }
  }
}

class AuthResponse<T> {
  AuthResponse._();

  factory AuthResponse.success(T data) = AuthSuccess<T>;

  factory AuthResponse.error(String message) = AuthError<T>;
}

class AuthSuccess<T> extends AuthResponse<T> {
  final T data;

  AuthSuccess(this.data) : super._();
}

class AuthError<T> extends AuthResponse<T> {
  final String message;

  AuthError(this.message) : super._();
}
