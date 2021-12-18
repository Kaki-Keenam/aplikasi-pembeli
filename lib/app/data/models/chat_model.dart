// To parse this JSON data, do
//
//     final chatModel = chatModelFromJson(jsonString);

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

ChatModel chatModelFromJson(String str) => ChatModel.fromJson(json.decode(str));

String chatModelToJson(ChatModel data) => json.encode(data.toJson());

class ChatModel {
  ChatModel({
    this.chats,
  });

  List<Chat>? chats;

  factory ChatModel.fromJson(Map<String, dynamic> json) => ChatModel(
    chats: List<Chat>.from(json["chats"].map((x) => Chat.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "chats": List<dynamic>.from(chats!.map((x) => x.toJson())),
  };
}

class Chat {
  Chat({
    this.connection,
    this.chatId,
    this.lastUpdate,
    this.totalUnread,
  });

  List<String>? connection;
  String? chatId;
  Timestamp? lastUpdate;
  int? totalUnread;

  factory Chat.fromJson(Map<String, dynamic> json) => Chat(
    connection: List<String>.from(json["connections"].map((x) => x)),
    chatId: json["chatId"],
    totalUnread: json["total_unread"],
  );

  Map<String, dynamic> toJson() => {
    "connections": List<dynamic>.from(connection!.map((x) => x)),
    "chat_id": chatId,
    "lastUpdate": lastUpdate,
    "total_unread": totalUnread,
  };
}