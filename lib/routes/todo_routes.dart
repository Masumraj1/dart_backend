import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:uuid/uuid.dart';

import '../db/database_client.dart';

class TodoRoutes {
  final DatabaseClient db;

  TodoRoutes(this.db);

  Router get router {
    final router = Router();

    router.get('/', _healthCheck);
    router.get('/todos', _getAllTodos);
    router.post('/todos', _createTodo);
    router.put('/todos/<id>', _updateTodo);
    router.delete('/todos/<id>', _deleteTodo);

    return router;
  }

  Response _healthCheck(Request req) {
    return Response.ok(jsonEncode({'status': 'ok'}));
  }

  Future<Response> _getAllTodos(Request req) async {
    final todos = await db.getAllTodos();
    return Response.ok(jsonEncode(todos));
  }

  Future<Response> _createTodo(Request req) async {
    final data = jsonDecode(await req.readAsString());

    final todo = {
      'id': const Uuid().v4(),
      'title': data['title'] ?? 'No title',
      'completed': data['completed'] ?? false,
    };

    await db.createTodo(todo);
    return Response(201, body: jsonEncode(todo));
  }

  Future<Response> _updateTodo(Request req, String id) async {
    final data = jsonDecode(await req.readAsString());

    final updated = await db.updateTodo(
      id,
      data['title'],
      data['completed'],
    );

    if (!updated) {
      return Response.notFound(jsonEncode({'error': 'Todo not found'}));
    }

    return Response.ok(jsonEncode({'message': 'Updated'}));
  }

  Future<Response> _deleteTodo(Request req, String id) async {
    final deleted = await db.deleteTodo(id);

    if (!deleted) {
      return Response.notFound(jsonEncode({'error': 'Todo not found'}));
    }

    return Response.ok(jsonEncode({'message': 'Deleted'}));
  }
}
