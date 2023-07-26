import 'dart:convert';
import 'package:dartdiscord/database/database.dart';
import 'package:dartdiscord/models/server.dart';
import 'package:dartdiscord/models/user.dart';
import 'package:dartdiscord/constants/permission.dart';

class Category{
  String? categoryName;
  int? type;
  List<String>? channels;

  Category.creator(this.categoryName, this.type, String serverName);

  Category.fromDb(String serverName, this.categoryName);

  Future<Category> getCategoryObj(String categoryName, String serverName) async {
    var path = 'lib/database/categories';
    databaseOp categoryDb = databaseOp(path);
    await categoryDb.openDb();
    Category obj = Category.fromDb(categoryName, serverName);
    List<dynamic>? categoryRecords = await categoryDb.storeDb(true);
    String? categoryRec = await categoryDb.findDb(categoryName);
    await categoryDb.closeDb();

    String jsonChannels = jsonDecode(categoryRec!)["channels"];
    List<String>? channels = jsonDecode(jsonChannels);
    obj.channels = channels;
    return obj;
  }
}