// import 'package:shelf/shelf_io.dart' as io;
// import 'package:shelf/shelf.dart';
// import '../lib/routes.dart';
//
// void main() async {
//   final handler = const Pipeline()
//       .addMiddleware(logRequests())
//       .addMiddleware(logRequests(logger: (msg, isError) {
//     print('[${isError ? "ERROR" : "INFO"}] $msg');
//   }))
//       .addHandler(getRoutes());
//
//   final server = await io.serve(handler, '0.0.0.0', 8080);
//   print('Server running on localhost:${server.port}');
// }
import 'dart:convert';
import 'dart:io';

import 'package:flutter_backend/services/todo_service.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_router/shelf_router.dart';


final todoService = TodoService();

void main() async {
  final router = Router();

  // GET all todos
  router.get('/todos', (Request request) {
    final todos = todoService.getAll().map((t) => t.toJson()).toList();
    return Response.ok(jsonEncode(todos),
        headers: {'Content-Type': 'application/json'});
  });

  // POST create todo
  router.post('/todos', (Request request) async {
    final payload = jsonDecode(await request.readAsString());
    final title = payload['title'] as String?;
    if (title == null || title.isEmpty) {
      return Response(400, body: 'Title is required');
    }

    final todo = todoService.create(title);
    return Response.ok(jsonEncode(todo.toJson()),
        headers: {'Content-Type': 'application/json'});
  });

  // PUT update todo
  router.put('/todos/<id>', (Request request, String id) async {
    final payload = jsonDecode(await request.readAsString());
    final title = payload['title'] as String? ?? '';
    final completed = payload['completed'] as bool? ?? false;

    final updated = todoService.update(id, title, completed);
    if (updated == null) return Response(404, body: 'Todo not found');

    return Response.ok(jsonEncode(updated.toJson()),
        headers: {'Content-Type': 'application/json'});
  });

  // DELETE todo
  // router.delete('/todos/<id>', (Request request, String id) {
  //   final deleted = todoService.delete(id);
  //   if (!deleted) return Response(404, body: 'Todo not found');
  //   return Response.ok(jsonEncode({'message': 'Deleted'}));
  // });

  final handler = Pipeline().addMiddleware(logRequests()).addHandler(router);

  final server = await io.serve(handler, 'localhost', 8080);
  print('Server running on localhost:${server.port}');
}
