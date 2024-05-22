import '../db/entity/app_user.dart';
import '../db/entity/chat.dart';

class ChatWithUser {
  Chat chat;
  AppUser user;

  ChatWithUser(this.chat, this.user);
}
