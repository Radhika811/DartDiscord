import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

class databaseOp{
  var path;
  Database? currDb;
  StoreRef<dynamic, dynamic>? store;
  List<dynamic>? records;

  databaseOp(this.path);

  Future<void> openDb() async{
    final DatabaseFactory dbFactory = databaseFactoryIo;
    currDb = await dbFactory.openDatabase(path);
    // print(path);
  }

  Future<List<dynamic>?> storeDb(bool insert) async{
    store = StoreRef<dynamic, dynamic>.main();
    // print(currDb);
    records = await store!.find(currDb!);
    if(!insert) currDb!.close();
    return records;
  }

  Future<void> insertDb(dynamic key, dynamic value) async {
    await store!.record(key).put(currDb!, value);
    await currDb!.close();
  }
}