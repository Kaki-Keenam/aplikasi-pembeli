import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kakikeenam/app/data/models/chat_model.dart';
import 'package:kakikeenam/app/data/models/chat_room_model.dart';
import 'package:kakikeenam/app/data/models/vendor_model.dart';
import 'package:kakikeenam/app/routes/app_pages.dart';

import '../controllers/chat_controller.dart';

class ChatView extends GetView<ChatController> {
  @override
  Widget build(BuildContext context) {
    print("hello");
    return Scaffold(
        appBar: AppBar(
          title: Text('Pesan'),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Expanded(
              child: StreamBuilder<ChatModel>(
                stream: controller.getChats(),
                  builder: (context, chat){
                if(chat.connectionState == ConnectionState.active && chat.hasData){
                  return ListView.builder(
                    physics: BouncingScrollPhysics(),
                    padding: EdgeInsets.zero,
                    itemCount: chat.data?.chats?.length,
                    itemBuilder: (context, index) {
                      return StreamBuilder<VendorModel>(
                          stream: controller.getVendorChat(
                              chat.data!.chats![index].connection![0]),
                          builder: (context, vendor) {
                            if (vendor.connectionState ==
                                ConnectionState.active && vendor.hasData) {
                              return ListTile(
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 5,
                                ),
                                onTap: () {
                                  Get.toNamed(Routes.CHAT_ROOM, arguments: [
                                    chat.data?.chats?[index],
                                    vendor.data
                                  ]);
                                },
                                leading: CircleAvatar(
                                  radius: 30,
                                  backgroundColor: Colors.black26,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: vendor.data?.storeImage != null
                                        ? Image.network(
                                      "${vendor.data?.storeImage}",
                                      fit: BoxFit.cover,
                                    )
                                        : Image.asset(
                                      "assets/images/person.png",
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                title: Text(
                                  "${vendor.data?.storeName}",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                trailing: StreamBuilder<ChatRoomModel>(
                                    stream: controller.getUnread(
                                        chat.data!.chats![index]),
                                    builder: (context, unread) {
                                      if (unread.connectionState ==
                                          ConnectionState.active && unread.data?.chatRoom?.length != 0) {
                                        return Chip(
                                          backgroundColor: Colors.amber[600],
                                          label: Text(
                                            "${unread.data?.chatRoom?.length}",
                                            style:
                                            TextStyle(color: Colors.white),
                                          ),
                                        );
                                      }
                                      return Text(
                                        "0",
                                        style: TextStyle(color: Colors.white),
                                      );
                                    },
                                ),
                              );
                            }
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          },
                      );
                    },
                  );
                }
                return Container();
              })

            ),
          ],
        ));
  }
}
