import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_router/shelf_router.dart';
import 'package:uuid/uuid.dart';

import '../db/database_client.dart';

void main() async {
  final dbClient = await DatabaseClient.connect();
  final router = Router();

  // ✅ Root route
  router.get('/', (Request req) {
    return Response.ok(
      '🚀 Todo Backend is running',
      headers: {'Content-Type': 'text/plain'},
    );
  });

  // ✅ POST create todo
  router.post('/todos', (Request req) async {
    final body = await req.readAsString();
    final data = jsonDecode(body);

    final newTodo = {
      'id': const Uuid().v4(),
      'title': data['title'] ?? 'No Title',
      'completed': data['completed'] ?? false,
    };

    await dbClient.createTodo(newTodo);

    return Response.ok(
      jsonEncode(newTodo),
      headers: {'Content-Type': 'application/json'},
    );
  });

  // ✅ DELETE todo
  router.delete('/todos/<id>', (Request req, String id) async {
    final deleted = await dbClient.deleteTodo(id);

    if (!deleted) {
      return Response.notFound(
        jsonEncode({'error': 'Todo not found'}),
      );
    }

    return Response.ok(
      jsonEncode({'message': 'Deleted successfully'}),
    );
  });

  final handler = const Pipeline()
      .addMiddleware(logRequests())
      .addHandler(router);

  final server = await io.serve(handler, '0.0.0.0', 8090);
  print('🚀 Server running on http://localhost:${server.port}');
}
