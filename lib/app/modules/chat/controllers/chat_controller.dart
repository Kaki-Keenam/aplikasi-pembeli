import 'package:get/get.dart';
import 'package:kakikeenam/app/data/models/chat_model.dart';
import 'package:kakikeenam/app/data/models/chat_room_model.dart';
import 'package:kakikeenam/app/data/models/vendor_model.dart';
import 'package:kakikeenam/app/data/repository/repository_remote.dart';

class ChatController extends GetxController {
  final RepositoryRemote _repositoryRemote = Get.find<RepositoryRemote>();

  @override
  void onInit() {

    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}


  Stream<ChatModel> getChats(){
    return _repositoryRemote.getChats().map((chat) {
      List<Chat> listData = List.empty(growable: true);
       chat.docs.forEach((element) {
          listData.add(Chat.fromJson(element.data() as Map<String, dynamic>));
      });
       return ChatModel(chats: listData);
    });
  }

  Stream<VendorModel> getVendorChat(String vendorId) {
    return _repositoryRemote.getVendorStream(vendorId).map((event) {
      return VendorModel.fromDocument(event);
    });
  }

  Stream<ChatRoomModel> getUnread(Chat chat){
    return _repositoryRemote.getChatRoomBySender(chat).map((unread) {
      List<ChatRoom> listData = List.empty(growable: true);
      unread.docs.forEach((element) {
        if(element.get("isRead") == false){
          listData.add(ChatRoom.fromJson(element.data() as Map<String, dynamic>));
        }
      });
      return ChatRoomModel(chatRoom: listData);
    });
  }

  Stream<ChatRoomModel> chatsRoom(String? chatId){
    return _repositoryRemote.getChatRoom(chatId!).map((room) {
      List<ChatRoom> listData = List.empty(growable: true);
      room.docs.forEach((element) {
        listData.add(ChatRoom.fromJson(element.data() as Map<String, dynamic>));
      });
      return ChatRoomModel(chatRoom: listData);
    });
  }
}
