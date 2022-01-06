// To parse this JSON data, do
//
//     final chatRoomModel = chatRoomModelFromJson(jsonString);

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

ChatRoomModel chatRoomModelFromJson(String str) => ChatRoomModel.fromJson(json.decode(str));

String chatRoomModelToJson(ChatRoomModel data) => json.encode(data.toJson());

class ChatRoomModel {
  ChatRoomModel({
    this.chatRoom,
  });

  List<ChatRoom>? chatRoom;

  factory ChatRoomModel.fromJson(Map<String, dynamic> json) => ChatRoomModel(
    chatRoom: List<ChatRoom>.from(json["chatRoom"].map((x) => ChatRoom.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "chatRoom": List<dynamic>.from(chatRoom!.map((x) => x.toJson())),
  };
}

class ChatRoom {
  ChatRoom({
    this.isRead,
    this.messageId,
    this.receiver,
    this.sender,
    this.message,
    this.time,
  });

  bool? isRead;
  String? messageId;
  String? receiver;
  String? sender;
  String? message;
  Timestamp? time;

  factory ChatRoom.fromJson(Map<String, dynamic> json) => ChatRoom(
    messageId: json["messageId"],
    isRead: json["isRead"],
    receiver: json["penerima"],
    sender: json["pengirim"],
    message: json["pesan"],
    time: json["time"],
  );

  Map<String, dynamic> toJson() => {
    "isRead": isRead,
    "penerima": receiver,
    "pengirim": sender,
    "pesan": message,
    "time": time,
  };
}
