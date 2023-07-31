class Permissions{
  int? mizunoto;
  int? kinoe;
  int? hashira;
  int? addUser;
  int? editpermission;
  int? removeUser;
  int? createRole;
  int? addChannel;
  int? addCategory;
  int? deleteServer;
  int? all;

  Permissions(){
    mizunoto = 1<<0;
    kinoe = 1<<1;
    hashira = 1<<2;
    addUser = 1<<3;
    editpermission = 1<<4;
    removeUser = 1<<5;
    createRole = 1<<6;
    addChannel = 1<<7;
    addCategory = 1<<8;
    deleteServer = 1<<9;
    all = (1<<11) - 1;
  }
}


  