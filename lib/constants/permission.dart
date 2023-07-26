class Permissions{
  int? mizunoto;
  int? kinoe;
  int? hashira;
  int? addUser;
  int? editpermission;
  int? removeUser;
  int? createRole;
  int? editChannel;
  int? editCategory;
  int? deleteServer;
  int? all;

  Permissions(){
    mizunoto = 1<<0;
    kinoe = 1<<1;
    hashira = 1<<2;

    addUser = 1<<3;
    editpermission = 1<<4;
    // print(addUser);
    removeUser = 1<<5;
    createRole = 1<<6;
    editChannel = 1<<7;
    editCategory = 1<<8;
    deleteServer = 1<<9;
    all = (1<<11) - 1;
  }
}


  