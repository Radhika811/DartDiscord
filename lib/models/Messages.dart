import 'package:dartdiscord/models/user.dart';
import 'dart:convert';

class Message{
  String? sender;
  String? message;
  String? timeStamp;

  Message(this.sender, this.message){
    timeStamp = DateTime.now.toString();
  }

  String msgToJson(){
    String jsonString = jsonEncode(toMap());
    return jsonString;
  }

  Map<String,String> toMap(){
    return{
      'sender' : sender!,
      'message' : message!,
      'timeStamp' : timeStamp!,
    };
  }
}