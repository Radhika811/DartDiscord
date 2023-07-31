import 'dart:convert';
import 'package:dartdiscord/database/database.dart';
import 'package:dartdiscord/models/server.dart';
import 'package:dartdiscord/models/user.dart';
import 'package:dartdiscord/constants/permission.dart';

class Category{
  String? categoryName;
  int? type;
  List<dynamic>? channels;

  Category.creator(this.categoryName, this.type, String serverName);

  Category.fromDb(String serverName, this.categoryName);

  static Future<Category> getCategoryObj(String categoryName, String serverName) async {
    var path = 'lib/database/categories.db';
    databaseOp categoryDb = databaseOp(path);
    await categoryDb.openDb();
    // print(categoryDb.currDb);
    Category obj = Category.fromDb(serverName, categoryName);
    List<dynamic>? categoryRecords = await categoryDb.storeDb(true);
    // print(categoryRecords);
    String? categoryRec = await categoryDb.findDb(serverName);
    await categoryDb.closeDb();
    // print(categoryRec);
    List<dynamic>? jsonChannels = jsonDecode(categoryRec!)[categoryName];
    // print(jsonChannels);
    var pathServer = 'lib/database/server.db';
    databaseOp serverDb = databaseOp(pathServer);
    await serverDb.openDb();
    List<dynamic>? records = await serverDb.storeDb(true);
    String? record = await serverDb.findDb(serverName);
    String jsonString = jsonDecode(record!)["categories"];
    dynamic permission = jsonDecode(jsonString)[categoryName];
    obj.type = permission;
    obj.channels = jsonChannels;
    return obj;
  }

  static Future<Category> update(Category oldCategory, String serverName)async {
    Category category = await getCategoryObj(oldCategory.categoryName!, serverName);
    return category;
  }
}