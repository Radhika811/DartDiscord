import 'dart:io';
import 'package:dartdiscord/models/category.dart';
import 'package:dartdiscord/models/channel.dart';
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
            await Server.createServer(currentUser.username!);
          }

          else if(newargument == 'exit'){
            runningServer = false;
          }

          else if(newargument == 'enter'){
            stdout.write("Print the server you want to enter : ");
            String? serverName = stdin.readLineSync();
            if(await checkValidity.checkServer(serverName!)){
            bool entry = await Server.enterServer(serverName!, currentUser);
            Server currServer = Server.fromDb(serverName);
            currServer = await currServer.getServerObj(serverName);
            int? currPerm = currServer.users![currentUser.username!];

            while(entry){
              stdout.write("$serverName >> ");
              String? command = stdin.readLineSync();

              //adding user to the server
              if(command == 'addUser'){
                // print(currPerm!);
                await Server.addUser(currentUser.username!, currServer.serverName!, currPerm!);
              }

              //print categories in a server with a delay of 2 sec
              else if(command == 'print categories'){
                await Server.printCategories(currentUser.username!, currServer, currPerm!);
              }

              //exit server
              else if(command == 'exit'){
                entry = false;
              }

              // else if(command == 'enter categoroy'){
              //   stdout.write("Please provide the name of the categoroy you want to enter");
              //   bool inCategory = true;
              //   String? categoryName = stdin.readLineSync();
              //   if(currServer.categories![categoryName] == null){
              //     inCategory = false;
              //   } 
              //   else{
              //     Category currCategory = Category(categoryName, currServer.categories![categoryName], serverName);
              //     while(inCategory){
              //       stdout.write('$serverName >> $categoryName >> ');
              //       String? command = stdin.readLineSync();
              //       if(command == 'create channel'){
              //         await Channel.createChannel(categoryName!, currServer, currCategory.type!, currentUser.username!);
              //       }
              //     }
              //   }  
              }
            }
            else{
              print("a server with server name $serverName does not exist");
            }
          }

          else{
            print("Please enter a valid command!!");
          }
        }
      }
      else{
        print("Please login to user Server functionality");
      }
    }

    else{
      print("Please enter a valid command!!");
    }
  }
}
