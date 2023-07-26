import 'dart:convert';
import 'dart:io';

import 'package:dartdiscord/constants/permission.dart';
import 'package:dartdiscord/database/database.dart';
import 'package:dartdiscord/models/category.dart';
import 'package:dartdiscord/models/Messages.dart';
import 'package:dartdiscord/models/server.dart';

class Channel{
  String? channelName;
  String? serverName;
  String? categoryName;
  int? type;
  List<String>? messages;

  Channel(this.channelName, this.categoryName, this.serverName, this.type, String? channelCreator){
    Message newMsg = Message(channelCreator, "I have created this channel");
    String jsonMsg = newMsg.msgToJson();
    messages = [jsonMsg];
  }

  Map<String, dynamic> toMap(){
    return{
      'channelName' : channelName,
      'serverName' : serverName,
      'categoryName' : categoryName,
      'type' : type,
      'messages' : jsonEncode(messages),
    };
  }

  static Future<void> createChannel(String categoryName, Server server, int type, String channelCreator) async {

    Permissions p = Permissions();
    if(server.users![channelCreator] & p.editChannel == 0){
      print("you do not have the right to add a channel, take help from a kinoe or hashira!!");
      return;
    }
    stdout.write("Please enter the name of the channel");
    String? channelName = stdin.readLineSync();

    Channel newChannel = Channel(channelName, categoryName, server.serverName, type, channelCreator);
    String serverName = server.serverName!;

    var path = 'lib/database/$serverName.db';
    databaseOp channelDb = databaseOp(path);

    String jsonKey = jsonEncode([categoryName, channelName]);

    await channelDb.openDb();
    List<dynamic>? records = await channelDb.storeDb(true);
    await channelDb.insertDb(jsonKey, jsonEncode(newChannel.toMap()));
    
  }

}