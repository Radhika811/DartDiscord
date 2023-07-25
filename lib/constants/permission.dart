class Permissions{
  int? addUser;
  int? createRole;
  int? removeUser;
  int? editChannel;
  int? editCategory;
  int? deleteServer;
  int? all;

  Permissions(){
    addUser = 1<<0;
    // print(addUser);
    removeUser = 1<<1;
    createRole = 1<<2;
    editChannel = 1<<3;
    editCategory = 1<<4;
    deleteServer = 1<<5;
    all = (1<<6) - 1;
  }
}


  