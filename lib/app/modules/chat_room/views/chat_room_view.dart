import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kakikeenam/app/data/models/chat_model.dart';
import 'package:kakikeenam/app/data/models/chat_room_model.dart';
import 'package:kakikeenam/app/data/models/vendor_model.dart';

import '../controllers/chat_room_controller.dart';

class ChatRoomView extends GetView<ChatRoomController> {
  final chatId = Get.arguments as String;

  @override
  Widget build(BuildContext context) {
    print('object $chatId');
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber[600],
        leadingWidth: 100,
        leading: InkWell(
          onTap: () => Get.back(),
          borderRadius: BorderRadius.circular(100),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(width: 5),
              Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              SizedBox(width: 5),
              CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.grey,
                  child: StreamBuilder<Chat>(
                    stream: controller.singleChat(chatId),
                    builder: (context, chat) {
                      if(chat.hasData){
                        return FutureBuilder<VendorModel>(
                            future: controller.vendor(chat.data!.connection![0]),
                            builder: (context, vendor) {
                              if(vendor.hasData){
                                return ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: vendor.data?.storeImage != null
                                      ? CachedNetworkImage(
                                    imageUrl: "${vendor.data?.storeImage}",
                                    fit: BoxFit.fill,
                                    placeholder: (context, url) => Transform.scale(
                                      scale: 0.5,
                                      child: CircularProgressIndicator(),
                                    ),
                                  )
                                      : Image.asset(
                                    "assets/images/person.png",
                                    fit: BoxFit.cover,
                                  ),
                                );
                              }
                              return Container();
                            }
                        );
                      }
                      return Container();
                    }
                  ),
              ),
            ],
          ),
        ),
        title: StreamBuilder<Chat>(
          stream: controller.singleChat(chatId),
          builder: (context, chat) {
            if(chat.hasData){
              return FutureBuilder<VendorModel>(
                future: controller.vendor(chat.data!.connection![0]),
                builder: (context, vendor) {
                  if(vendor.hasData){
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${vendor.data?.storeName}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '${vendor.data?.status}',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ],
                    );
                  }
                  return Container();
                }
              );
            }
            return Container();
          }
        ),
        centerTitle: false,
      ),
      body: WillPopScope(
        onWillPop: () {
          if (controller.isShowEmoji.isTrue) {
            controller.isShowEmoji.value = false;
          } else {
            Navigator.pop(context);
          }
          return Future.value(false);
        },
        child: Column(
          children: [
            Expanded(
              child: Container(
                child: StreamBuilder<Chat>(
                  stream: controller.singleChat(chatId),
                  builder: (context, chat) {
                    if(chat.hasData){
                      return StreamBuilder<ChatRoomModel>(
                        stream: controller.chatsRoom(chat.data!.chatId!),
                        builder: (context, room) {
                          if (room.connectionState == ConnectionState.active && room.hasData) {
                            Timer(
                              Duration.zero,
                                  () => controller.scrollC
                                  .jumpTo(controller.scrollC.position.maxScrollExtent),
                            );
                            return ListView.builder(
                              controller: controller.scrollC,
                              itemCount: room.data?.chatRoom?.length,
                              itemBuilder: (context, index) {
                                controller.updateUnread(
                                    room.data?.chatRoom?[index], chat.data!);
                                if (index == 0) {
                                  return Column(
                                    children: [
                                      SizedBox(height: 10),
                                      Text(
                                        "${DateFormat.yMMMMd('en_US').format(room.data!.chatRoom![index].time!.toDate())}",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      ItemChat(
                                        onDelete: (){
                                          if(room.data?.chatRoom?[index].pengirim ==
                                              chat.data?.connection?[1]){
                                            controller.deleteChat(room.data?.chatRoom?[index], chat.data!);
                                          }
                                        },
                                        msg: "${room.data?.chatRoom?[index].pesan}",
                                        isSender:
                                        room.data?.chatRoom?[index].pengirim ==
                                            chat.data?.connection?[1]
                                            ? true
                                            : false,
                                        time: DateFormat.jm('en_Us').format(
                                            room.data!.chatRoom![index].time!.toDate()),
                                      ),
                                    ],
                                  );
                                } else {
                                  if (DateFormat.yMMMMd('en_US').format(
                                      room.data!.chatRoom![index].time!.toDate()) ==
                                      DateFormat.yMMMMd('en_US').format(room
                                          .data!.chatRoom![index - 1].time!
                                          .toDate())) {
                                    return ItemChat(
                                      onDelete: (){
                                        if(room.data?.chatRoom?[index].pengirim ==
                                            chat.data?.connection?[1]){
                                          controller.deleteChat(room.data?.chatRoom?[index], chat.data!);
                                        }
                                      },
                                      msg: "${room.data?.chatRoom?[index].pesan}",
                                      isSender: room.data?.chatRoom?[index].pengirim ==
                                          chat.data?.connection?[1]
                                          ? true
                                          : false,
                                      time: DateFormat.jm('en_Us').format(
                                          room.data!.chatRoom![index].time!.toDate()),
                                    );
                                  } else {
                                    return Column(
                                      children: [
                                        Text(
                                          "${DateFormat.yMMMMd('en_US').format(room.data!.chatRoom![index].time!.toDate())}",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        ItemChat(
                                          onDelete: (){
                                            if(room.data?.chatRoom?[index].pengirim ==
                                                chat.data?.connection?[1]){
                                              controller.deleteChat(room.data?.chatRoom?[index], chat.data!);
                                            }

                                          },
                                          msg: "${room.data?.chatRoom?[index].pesan}",
                                          isSender:
                                          room.data?.chatRoom?[index].pengirim ==
                                              chat.data?.connection?[1]
                                              ? true
                                              : false,
                                          time: DateFormat.jm('en_Us').format(room
                                              .data!.chatRoom![index].time!
                                              .toDate()),
                                        ),
                                      ],
                                    );
                                  }
                                }
                              },
                            );
                          }
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        },
                      );
                    }
                    return Container();
                  }
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                bottom: controller.isShowEmoji.isTrue
                    ? 5
                    : context.mediaQueryPadding.bottom,
              ),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              width: Get.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Container(
                      child: TextField(
                        autocorrect: false,
                        controller: controller.chatC,
                        focusNode: controller.focusNode,
                        onEditingComplete: () {},
                        decoration: InputDecoration(
                          prefixIcon: IconButton(
                            onPressed: () {
                              controller.focusNode.unfocus();
                              controller.isShowEmoji.toggle();
                            },
                            icon: Icon(Icons.emoji_emotions_outlined),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Material(
                    borderRadius: BorderRadius.circular(100),
                    color: Colors.amber[600],
                    child: StreamBuilder<Chat>(
                      stream: controller.singleChat(chatId),
                      builder: (context, chat) {
                        if(chat.hasData){
                          return InkWell(
                            borderRadius: BorderRadius.circular(100),
                            onTap: () {
                              controller.sendChat(chat.data!);
                              controller.updateChat(chat.data!);
                              controller.chatC.clear();
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Icon(
                                Icons.send,
                                color: Colors.white,
                              ),
                            ),
                          );
                        }
                        return Container();
                      }
                    ),
                  ),
                ],
              ),
            ),
            Obx(() => (controller.isShowEmoji.isTrue)
                  ? Container(
                height: 325,
                child: EmojiPicker(
                  onEmojiSelected: (category, emoji) {
                    controller.addEmojiToChat(emoji);
                  },
                  onBackspacePressed: () {
                    controller.deleteEmoji();
                  },
                  config: Config(
                    backspaceColor: Color(0xFFB71C1C),
                    columns: 7,
                    emojiSizeMax: 32.0,
                    verticalSpacing: 0,
                    horizontalSpacing: 0,
                    initCategory: Category.RECENT,
                    bgColor: Color(0xFFF2F2F2),
                    indicatorColor: Color(0xFFB71C1C),
                    iconColor: Colors.grey,
                    iconColorSelected: Color(0xFFB71C1C),
                    progressIndicatorColor: Color(0xFFB71C1C),
                    showRecentsTab: true,
                    recentsLimit: 28,
                    noRecentsText: "No Recents",
                    noRecentsStyle: const TextStyle(
                        fontSize: 20, color: Colors.black26),
                    categoryIcons: const CategoryIcons(),
                    buttonMode: ButtonMode.MATERIAL,
                  ),
                ),
              )
                  : SizedBox(),
            ),
          ],
        ),
      ),

    );
  }
}

class ItemChat extends StatelessWidget {
  const ItemChat({
    Key? key,
    required this.isSender,
    required this.msg,
    required this.time,
    this.onDelete,

  }) : super(key: key);

  final bool isSender;
  final String msg;
  final String time;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onLongPress: onDelete,
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: 15,
          horizontal: 20,
        ),
        child: Column(
          crossAxisAlignment:
              isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Container(
              width: Get.width * 0.55,
              decoration: BoxDecoration(
                color: Colors.amber[600],
                borderRadius: isSender
                    ? BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                        bottomLeft: Radius.circular(15),
                      )
                    : BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                        bottomRight: Radius.circular(15),
                      ),
              ),
              padding: EdgeInsets.all(15),
              child: Text(
                "$msg",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 5),
            Text("${time}"),
          ],
        ),
        alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
      ),
    );
  }
}
