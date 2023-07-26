class Roles{
  int? mizunoto;
  int? kinoe;
  int? hashira;
  int? mizunotoServer;
  int? kinoeServer;
  int? hashiraServer;
  int? kibutsuji;
  Map<String,int>? newRoles;

  Roles(){
    mizunoto = 1;
    kinoe = 2;
    hashira = 4;
    mizunotoServer = 1;
    kinoeServer = (1<<5) - 1 - (1<<2) + (1<<9);
    hashiraServer = (1<<11) - 1;
    kibutsuji = (1<<10);
  }
}

