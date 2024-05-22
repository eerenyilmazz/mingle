import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageSource {
  FirebaseStorage instance = FirebaseStorage.instance;

  Future<CustomResponse<String>> uploadUserProfilePhoto(
      String filePath, String userId) async {
    String userPhotoPath = "user_photos/$userId/profile_photo";

    try {
      await instance.ref(userPhotoPath).putFile(File(filePath));
      String downloadUrl = await instance.ref(userPhotoPath).getDownloadURL();
      return CustomResponse.success(downloadUrl);
    } catch (e) {
      return CustomResponse.error((e as FirebaseException).message ?? e.toString());
    }
  }
}

class CustomResponse<T> {
  CustomResponse._();

  factory CustomResponse.success(T data) = Success<T>;

  factory CustomResponse.error(String message) = Error<T>;
}

class Success<T> extends CustomResponse<T> {
  final T value;

  Success(this.value) : super._();
}

class Error<T> extends CustomResponse<T> {
  final String message;

  Error(this.message) : super._();
}
