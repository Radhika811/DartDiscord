class Roles{
  int? mizunoto;
  int? kinoe;
  int? hashira;
  int? mizunotoServer;
  int? kinoeServer;
  int? hashiraServer;

  Roles(){
    mizunoto = 1;
    kinoe = 3;
    hashira = 7;
    mizunotoServer = 0;
    kinoeServer = (1<<2) - 1;
    hashiraServer = (1<<6) - 1;
  }
}

