// To parse this JSON data, do
//
//     final chatRoomModel = chatRoomModelFromJson(jsonString);

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

ChatRoomModel chatRoomModelFromJson(String str, String id) => ChatRoomModel.fromJson(json.decode(str), id);

String chatRoomModelToJson(ChatRoomModel data) => json.encode(data.toJson());

class ChatRoomModel {
  ChatRoomModel({
    this.chatRoom,
  });

  List<ChatRoom>? chatRoom;

  factory ChatRoomModel.fromJson(Map<String, dynamic> json, String id) => ChatRoomModel(
    chatRoom: List<ChatRoom>.from(json["chatRoom"].map((x) => ChatRoom.fromJson(x, id))),
  );

  Map<String, dynamic> toJson() => {
    "chatRoom": List<dynamic>.from(chatRoom!.map((x) => x.toJson())),
  };
}

class ChatRoom {
  ChatRoom({
    this.isRead,
    this.idMessage,
    this.penerima,
    this.pengirim,
    this.pesan,
    this.time,
  });

  bool? isRead;
  String? idMessage;
  String? penerima;
  String? pengirim;
  String? pesan;
  Timestamp? time;

  factory ChatRoom.fromJson(Map<String, dynamic> json, String id) => ChatRoom(
    idMessage: id,
    isRead: json["isRead"],
    penerima: json["penerima"],
    pengirim: json["pengirim"],
    pesan: json["pesan"],
    time: json["time"],
  );

  Map<String, dynamic> toJson() => {
    "isRead": isRead,
    "penerima": penerima,
    "pengirim": pengirim,
    "pesan": pesan,
    "time": time,
  };
}
