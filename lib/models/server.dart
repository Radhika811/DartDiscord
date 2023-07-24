import 'dart:convert';
import 'package:dartdiscord/models/user.dart';
import 'package:dartdiscord/database/database.dart';
import 'dart:io';

class Server{
  String? serverName;
  String? creator;
  List<dynamic>? serverUsers;
  List<dynamic>? modUsers;
  
  Server(this.serverName, this.creator, this.serverUsers, this.modUsers);

  static Future<void> createServer(String? creator) async{

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
    List<dynamic>? currUser = [creator!];
    Server newServer = Server(serverName, creator, currUser, currUser);
    String serverJson = jsonEncode(newServer.toMap());
    await serverDb.insertDb(serverName, serverJson);
    print("Server created successfully!!");
  }

  Map<String,dynamic> toMap(){
    return {
      'name': serverName!,
      'creator': creator!,
      'users': serverUsers,
      'moduser' : modUsers,
    };
  }

  static String toJsonString(Server obj){
    String? JsonString = jsonEncode(obj.toMap());
    return JsonString;
  }

  static Map<String, dynamic> fromJsonString(String jsonString){
    Map<String, dynamic> map = jsonDecode(jsonString);
    // return Server.fromMap(map);
    return map;
  }

  static Server fromMap(Map<String, dynamic> map) {
    return Server(
      map['name'] as String,
      map['creator'] as String,
      map['users'] as List<dynamic>,
      map['moduser'] as List<dynamic>,
    );
  }

  static Future<void> joinServer(User currentUser) async{

    stdout.write("Enter the server name you want to join : ");
    String? serverName = stdin.readLineSync();
    var pathServ = 'lib/database/server.db';
    databaseOp serverDb = databaseOp(pathServ);
    await serverDb.openDb();
    List<dynamic>? records = await serverDb.storeDb(true);
    String? oldJson = await serverDb.findDb(serverName);
    if(oldJson == ''){
      print("OOPS!! A server with server name $serverName does not exist!!");
      return;
    }
    else{
      Map<String, dynamic> currServer = fromJsonString(oldJson!);
      // print(currServer);
      List<dynamic>? addingMod = currServer['users'];
      List<dynamic>? addingUser = currServer['moduser'];

      for(String user in addingUser!){
        if(user == currentUser.username){
          print("You are already present in the server!!");
          return;
        }
      }
      addingMod!.add(currentUser.username);
      addingUser.add(currentUser.username);
      currServer['users'] = addingMod;
      currServer['modusers'] = addingUser;

      String? newJson = jsonEncode(currServer);
      await serverDb.deleteDb(serverName);
      await serverDb.insertDb(serverName, newJson);
      print("Congratulations!! You are successfully added to server $serverName");
    }
  }
}
