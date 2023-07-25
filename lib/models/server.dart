import 'dart:convert';
import 'package:dartdiscord/models/user.dart';
import 'package:dartdiscord/database/database.dart';
import 'dart:io';
import 'package:dartdiscord/constants/permission.dart';
import 'package:dartdiscord/constants/roles.dart';
import 'package:dartdiscord/models/check.dart';

class Server{
  String? serverName;
  Map<String,dynamic>? users;
  Map<String,dynamic>? categories;
  
  Server(this.serverName, String creator){
    Permissions p = Permissions();
    Roles r = Roles();
    users = {
      creator : p.all!,
    };
    // print(p.all);
    categories = {
      'Admin' : r.mizunoto!,
      'People' : r.kinoe!,
      'Discuss' : r.hashira!,
    };
  }

  Server.fromDb(this.serverName);

  Future<Server> getServerObj(String serverName) async{
    var path = 'lib/database/server.db';
    databaseOp serverDb = databaseOp(path);
    await serverDb.openDb();
    List<dynamic>? serverRec = await serverDb.storeDb(true);
    String? record = await serverDb.findDb(serverName);
    await serverDb.closeDb();
    Server obj = Server.fromDb(serverName);
    print(jsonDecode(record!)['users']);
    String jsonUser = jsonDecode(record!)['users'];
    try{
      obj.users = jsonDecode(jsonUser);
    }
    catch(e){
      print(jsonDecode(jsonUser).runtimeType);
      print("Error : $e");
    }
    obj.categories = jsonDecode(jsonDecode(record)['categories']);
    return obj;
  }

  static Future<void> createServer(String creator) async{

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
    String serverJson = jsonEncode(newServer.toMap());
    await serverDb.insertDb(serverName, serverJson);
    print("Server created successfully!!");
  }

  Map<String,String> toMap(){
    return {
      'name': serverName!,
      'users' : jsonEncode(users),
      'categories' : jsonEncode(categories),
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

  // static Server fromMap(Map<String, dynamic> map) {
  //   return Server(
  //     map['name'] as String,
  //     map['users'] as String,
  //     map['categories'] as String,
  //   );
  // }

  static Future<void> addUser(String currentUser, String currentServer, int currPerm) async{
    Permissions p = Permissions();
    // print(p.addUser);
    if(currPerm & p.addUser! != p.addUser) {
      print("You do not have the rights to add user to the server!!");
      return;
    }
    stdout.write("Whom would you like to add?? : ");
    String? userName = stdin.readLineSync();
    // print("lets see how this goes :o");
    // print(checkValidity.checkRegistration(userName!));
    if(await checkValidity.checkRegistration(userName!) == false){
      print("such a user does not exist");
      return;
    }
    stdout.write("give permission manually or using roles? [M/R]");
    String? response = stdin.readLineSync();
    int? perm;
    String? role;
    if(response == 'M'){
      String? s = stdin.readLineSync();
      if (s != null){
        perm = int.parse(s);
      }
    }
    else if(response == 'R'){
      role = stdin.readLineSync();
    }
    else {
      print("please try again and provide a valid input!!");
      return;
    }

    var pathServ = 'lib/database/server.db';
    databaseOp serverDb = databaseOp(pathServ);
    await serverDb.openDb();
    List<dynamic>? records = await serverDb.storeDb(true);
    String? oldJson = await serverDb.findDb(currentServer);
      Map<String, dynamic> currServerDb = fromJsonString(oldJson!);
      // print(currServer);
      Map<String,dynamic> users = jsonDecode(currServerDb['users']!);
      if(users[userName] != null) {
        print("This user is already added to the server!!");
        return;
      }
      if(role == null){
        users[userName!] = perm!;
      }
      else{
        Roles r = Roles();
        switch(role){
          case 'hashira' : 
            users[userName!] = r.hashiraServer!;
            // print(r.hashiraServer);
            break;
          case 'kinoe' :
            users[userName!] = r.kinoeServer!;
            break;
          case 'minzunoto' : 
            users[userName!] = r.mizunotoServer!;
            break;
        } 
      }
      currServerDb['users'] = jsonEncode(users);
      String newJson = jsonEncode(currServerDb);
      await serverDb.deleteDb(currentServer);
      await serverDb.insertDb(currentServer, newJson);
      print("Congratulations!! You have successfully added user $userName to the current server");
  }

  static Future<bool> enterServer(String serverName, User userName) async{
    if(await checkValidity.checkServer(serverName)){
      if(checkValidity.checkLogin(userName)){
        if(await checkValidity.checkServerUser(userName.username!, serverName)){
          return true;
        }
      } 
    }
    return false;
  }
}
