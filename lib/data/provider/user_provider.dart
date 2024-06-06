import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../utils/shared_preferences_utils.dart';
import '../../utils/utils.dart';
import '../db/entity/chat.dart';
import '../db/entity/match.dart';
import '../db/entity/app_user.dart';
import '../db/remote/firebase_auth_source.dart';
import '../db/remote/firebase_database_source.dart';
import '../db/remote/firebase_storage_source.dart';
import '../model/chat_with_user.dart';
import '../model/user_registration.dart';

class UserProvider extends ChangeNotifier {
  final FirebaseAuthSource _authSource = FirebaseAuthSource();
  final FirebaseStorageSource _storageSource = FirebaseStorageSource();
  final FirebaseDatabaseSource _databaseSource = FirebaseDatabaseSource();

  bool isLoading = false;
  AppUser? _user;

  Future<AppUser?> get user => _getUser();

  Future<AuthResponse> loginUser(String email, String password, GlobalKey<ScaffoldState> errorScaffoldKey) async {
    print('Kullanıcı giriş işlemi başlatılıyor...');
    AuthResponse<UserCredential> response = await _authSource.signIn(email, password);
    if (response is AuthSuccess<UserCredential>) {
      String id = response.data.user!.uid;
      print('Giriş başarılı, kullanıcı ID: $id');
      await SharedPreferencesUtil.setUserId(id);
      _user = await _getUser();
      notifyListeners();
    } else if (response is AuthError<UserCredential>) {
      print('Giriş başarısız: ${response.message}');
      showSnackBar(errorScaffoldKey.currentContext!, response.message);
    }
    return response;
  }

  Future<AuthResponse> registerUser(UserRegistration userRegistration, GlobalKey<ScaffoldState> errorScaffoldKey) async {
    print('Kullanıcı kayıt işlemi başlatılıyor...');
    AuthResponse<UserCredential> response = await _authSource.register(userRegistration.email, userRegistration.password);
    if (response is AuthSuccess<UserCredential>) {
      String id = response.data.user!.uid;
      print('Kayıt başarılı, kullanıcı ID: $id');
      CustomResponse<String> uploadResponse = await _storageSource.uploadUserProfilePhoto(userRegistration.localProfilePhotoPath, id);

      if (uploadResponse is Success<String>) {
        String profilePhotoUrl = uploadResponse.value;
        AppUser user = AppUser(
          id: id,
          name: userRegistration.name,
          age: userRegistration.age,
          profilePhotoPath: profilePhotoUrl,
        );
        _databaseSource.addUser(user);
        await SharedPreferencesUtil.setUserId(id);
        _user = user;
        notifyListeners();
        if (kDebugMode) {
          print('Kayıt ve profil fotoğrafı yükleme başarılı.');
        }
        return AuthResponse.success(user);
      } else if (uploadResponse is Error<String>) {
        print('Profil fotoğrafı yükleme başarısız: ${uploadResponse.message}');
        showSnackBar(errorScaffoldKey.currentContext!, uploadResponse.message);
        return AuthResponse.error(uploadResponse.message);
      }
    }
    if (response is AuthError<UserCredential>) {
      print('Kayıt başarısız: ${response.message}');
      showSnackBar(errorScaffoldKey.currentContext!, response.message);
    }
    return response;
  }

  Future<AppUser?> _getUser() async {
    if (_user != null) return _user;
    String? id = await SharedPreferencesUtil.getUserId();
    print('SharedPreferences\'den kullanıcı ID alındı: $id');
    if (id != null && id.isNotEmpty) {
      _user = AppUser.fromSnapshot(await _databaseSource.getUser(id));
    }
    return _user;
  }

  void updateUserProfilePhoto(String localFilePath, GlobalKey<ScaffoldState> errorScaffoldKey) async {
    if (_user == null) return;
    isLoading = true;
    notifyListeners();
    CustomResponse<String> response = await _storageSource.uploadUserProfilePhoto(localFilePath, _user!.id);
    isLoading = false;
    if (response is Success<String>) {
      _user!.profilePhotoPath = response.value;
      _databaseSource.updateUser(_user!);
    } else if (response is Error<String>) {
      showSnackBar(errorScaffoldKey.currentContext!, response.message);
    }
    notifyListeners();
  }

  void updateUserBio(String newBio) {
    if (_user == null) return;
    _user!.bio = newBio;
    _databaseSource.updateUser(_user!);
    notifyListeners();
  }

  Future<void> logoutUser() async {
    _user = null;
    await SharedPreferencesUtil.removeUserId();
    notifyListeners();
  }

  Future<List<ChatWithUser>> getChatsWithUser(String userId) async {
    print('Kullanıcı ID\'si ile sohbetler alınıyor: $userId');
    var matches = await _databaseSource.getMatches(userId);
    List<ChatWithUser> chatWithUserList = [];

    for (var matchDoc in matches.docs) {
      Match match = Match.fromSnapshot(matchDoc);
      AppUser matchedUser = AppUser.fromSnapshot(await _databaseSource.getUser(match.id));
      String chatId = compareAndCombineIds(match.id, userId);
      Chat chat = Chat.fromSnapshot(await _databaseSource.getChat(chatId));
      ChatWithUser chatWithUser = ChatWithUser(chat, matchedUser);
      chatWithUserList.add(chatWithUser);
    }
    print('Sohbetler başarıyla alındı.');
    return chatWithUserList;
  }
}
