import 'package:uuid/uuid.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'dart:io';
import 'package:dartdiscord/database/database.dart';

class User{
  String? username;
  String? passwordHash;
  String? uuId;

  User(this.username, String password){
    uuId = Uuid().v1();
    this.passwordHash = _hashPassword(password);
  }

  String toJson(){
    String jsonString = jsonEncode(toMap());
    return jsonString;
  }

  Map<String, String> toMap(){
    return {
      'username': username!,
      'passwordHash': passwordHash!,
    };
  }

  Map<String, String> fromJson(String? jsonString){
    Map<String, String> map = jsonDecode(jsonString!);
    return map;
  }

  //function for Register User
  static Future<void> registerUser() async{
    stdout.write("Please enter a username : ");
    String? username = stdin.readLineSync();
    var path = 'lib/database/users.db';
    databaseOp userDb = databaseOp(path);
    await userDb.openDb();
    List<dynamic>? records = await userDb.storeDb(true);
    for (var rec in records!) {
      if (rec.key == username) {
        print("Username already exists. Please choose a different username.");
        return;
      }
    }

    stdout.write("Password : ");
    String? password = stdin.readLineSync();
    stdout.write("Confirm Password : ");
    String? confirmPwd = stdin.readLineSync();

    if(confirmPwd != password){
      print("The passwords do not match.");
      return;
    }
    User newUser = User(username!, password!);
    await userDb.insertDb(newUser.username, newUser.passwordHash);
    print("User registered Successfully");
  }
    
  //function for login user
  Future<bool> loginUser() async {
      
    var path = 'lib/database/users.db';
    databaseOp userDb = databaseOp(path);

    await userDb.openDb();
      
    List<dynamic>? records = await userDb.storeDb(false);
    String? pwdHash;
    for (var rec in records!) {
      if (rec.key == username) {
        pwdHash = rec.value;
        break;
      }
    }

    if(pwdHash == ""){
      print("Username does not exit!!");
      return false;
    }

    String? newHash = passwordHash;
    if(newHash == pwdHash){
      User currentUser = User(username, newHash!);
      currentUser.passwordHash = passwordHash;
      print("login successful $username");
      return true;
    }
    print("Incorrect username or Password!!");
    return false;
  }

  String _hashPassword(String password) {
    var bytes = utf8.encode(password); 
    var digest = sha256.convert(bytes); 
    return digest.toString();
  }
}
