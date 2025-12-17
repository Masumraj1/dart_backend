import 'package:mongo_dart/mongo_dart.dart';

class DatabaseClient {
  final Db _db;
  final DbCollection _collection;

  DatabaseClient._(this._db, this._collection);

  static Future<DatabaseClient> connect() async {
    final db = await Db.create('mongodb://127.0.0.1:27017/todos_db');
    await db.open();

    final collection = db.collection('todos');
    print('✅ Connected to MongoDB');

    return DatabaseClient._(db, collection);
  }

  Future<void> createTodo(Map<String, dynamic> todo) async {
    await _collection.insertOne(todo);
  }

  Future<bool> deleteTodo(String id) async {
    final result = await _collection.deleteOne(where.eq('id', id));
    return result.isSuccess;
  }
}
