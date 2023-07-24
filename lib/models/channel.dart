import 'package:dartdiscord/database/database.dart';
import 'package:dartdiscord/models/category.dart';
import 'package:dartdiscord/models/Messages.dart';
import 'package:dartdiscord/models/server.dart';

class Channel{
  String? serverName;
  String? categoryName;
  int? permission;
  List<String>? messages;

  Channel(this.categoryName, this.serverName, this.permission, String serverCreator){
    Message newMsg = Message(serverCreator, "Auto generated message");
    String jsonMsg = newMsg.msgToJson();
    messages = [jsonMsg];
  }

  void createChannel(String categoryName, String serverName, int permission, String serverCreator, String channelCreator) async {

    var path = 'lib/database/server.db';
    databaseOp serverDb = databaseOp(path);
    await serverDb.openDb();
    List<dynamic>? records = await serverDb.storeDb(false);
    String? record = await serverDb.findDb(serverName);
    Map<String,dynamic> currServer = Server.fromJsonString(record!);
    List<dynamic> modUser = currServer['moduser'];
    bool access = false;

    for(String user in modUser){
      if(user == channelCreator){
        access = true;
      }
    }

    if(access == false){
      print("Sorry, you do not have the rights to create a channel in this server");
      return;
    }

    
  }

}