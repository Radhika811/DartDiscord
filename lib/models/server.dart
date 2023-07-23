import 'dart:convert';
import 'package:dartdiscord/models/user.dart';
import 'package:dartdiscord/database/database.dart';
import 'dart:io';

class Server{
  String? serverName;
  User? creator;
  List<User>? serverUsers;
  
  Server(this.serverName, this.creator){
    serverUsers = [creator!];
  }

  static Future<void> createServer(User? creator) async{

    stdout.write("Enter Server Name : ");
    String? serverName = stdin.readLineSync();
    var pathServer = 'lib/database/server.db';
    databaseOp serverDb = databaseOp(pathServer);
    await serverDb.openDb();
    // print(serverDb.currDb);
    List<dynamic>? serverRec = await serverDb.storeDb(true);

    for(var rec in serverRec!){
      if(rec.key == serverName){
        print("A server with this name already exists!! Kindly choose a different name");
        return;
      }
    }

    // print("reached here");
    Server newServer = Server(serverName, creator);
    String serverJson = jsonEncode(newServer);
    await serverDb.insertDb(serverName, serverJson);
    print("Server created successfully!!");
  }

  Map<String,dynamic> toJson(){
    return {
      'name': serverName,
      'users': [creator!.username],
    };
  }
}