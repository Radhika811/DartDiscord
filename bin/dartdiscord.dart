import 'dart:io';
import 'package:dartdiscord/models/user.dart';
import 'package:dartdiscord/models/check.dart';
import 'package:dartdiscord/models/server.dart';

void main(List<String> arguments) async{
  bool running = true;
  User currentUser = User('','');
  while(running){
    stdout.write(">> ");
    var arguments = stdin.readLineSync();
  
    if(arguments == 'register'){
      await User.registerUser();
    }

    else if(arguments == 'login'){
      bool check = checkValidity.checkLogin(currentUser);
      if(!check){
        stdout.write("Enter username : ");
        String? username = stdin.readLineSync();
        stdout.write("Enter password : ");
        String? password = stdin.readLineSync();
        currentUser = User(username, password!);
        bool correct = await currentUser.loginUser();
        if(!correct){
          currentUser = User('', '');
        }
      }
      else{
        print("User already logged in!!");
      }
    }

    else if(arguments == 'logout'){
      bool check = checkValidity.checkLogin(currentUser);
      if(!check){
        print("No user logged in!!");
      }
      else{
        currentUser = User('', '');
        print("logout successful");
        stdout.write("would you like to quit as well? [y/n] ");
        String? response = stdin.readLineSync();
        if(response == 'Y' || response == 'y'){
          running = false;
        }
      }
    }

    else if(arguments == 'user'){
      if(!checkValidity.checkLogin(currentUser)){
        print("No user logged in!!");
      }
      else {
        print(currentUser.username);
      }
    }

    else if(arguments == 'exit' || arguments == 'quit'){
      stdout.write("Are you sure you want to quit? [y/n] ");
      String? response = stdin.readLineSync();
      if(response == 'y' || response == 'Y'){
        running = false;
      }
    }

    else if(arguments == 'server'){
      bool runningServer = true;
      if(checkValidity.checkLogin(currentUser) == true){
        while(runningServer){
          stdout.write("server >> ");
          String? newargument = stdin.readLineSync();

          if(newargument == 'create'){
            await Server.createServer(currentUser);
          }

          else if(newargument == 'exit'){
            runningServer = false;
          }
        }
      }
      else{
        print("Please login to user Server functionality");
      }
    }
  }
}
