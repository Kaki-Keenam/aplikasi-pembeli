import 'dart:async';

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:kakikeenam/app/data/models/chat_model.dart';
import 'package:kakikeenam/app/data/models/chat_room_model.dart';
import 'package:kakikeenam/app/data/repository/repository_remote.dart';

class ChatRoomController extends GetxController {
  final RepositoryRemote _repositoryRemote = Get.find<RepositoryRemote>();
  final TextEditingController chatC = TextEditingController();

  final ScrollController scrollC = ScrollController();

  var isShowEmoji = false.obs;
  late FocusNode focusNode;

  @override
  void onInit() {
    focusNode = FocusNode();
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        isShowEmoji.value = false;
      }
    });
    super.onInit();
  }

  @override
  void onReady() {

    super.onReady();
  }

  @override
  void onClose() {
    chatC.dispose();
    focusNode.dispose();
    scrollC.dispose();
  }

  void addEmojiToChat(Emoji emoji) {
    chatC.text = chatC.text + emoji.emoji;
  }

  void deleteEmoji() {
    chatC.text = chatC.text.substring(0, chatC.text.length - 2);
  }

  Stream<ChatRoomModel> chatsRoom(String chatId){
    return _repositoryRemote.getChatRoom(chatId).map((room) {
      List<ChatRoom> listData = List.empty(growable: true);
      room.docs.forEach((element) {
        listData.add(ChatRoom.fromJson(element.data() as Map<String, dynamic>, element.id));
      });
      return ChatRoomModel(chatRoom: listData);
    });
  }

  Future sendChat(Chat chat) async {
    await _repositoryRemote.sendChat(chat, chatC.text);
    Timer(
      Duration.zero,
          () => scrollC.jumpTo(
          scrollC.position.maxScrollExtent),
    );
  }

  Future updateChat(Chat chat) async{
    await _repositoryRemote.updateChat(chat);
  }

  Future updateUnread(ChatRoom? chatRoom, Chat chat) async {
    if(chatRoom?.pengirim == chat.connection?[0]){

      await _repositoryRemote.updateUnread(chatRoom, chat);
    }
  }

  Future deleteChat(String messageId, Chat chat) async {
    await _repositoryRemote.deleteChat(messageId, chat);
  }

}
