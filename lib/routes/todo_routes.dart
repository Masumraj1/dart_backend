// import 'dart:convert';
// import 'package:shelf/shelf.dart';
// import 'package:shelf_router/shelf_router.dart';
// import 'package:uuid/uuid.dart';
//
// import '../db/database_client.dart';
//
// class TodoRoutes {
//   final DatabaseClient dbClient;
//
//   TodoRoutes(this.dbClient);
//
//   Router get router {
//     final router = Router();
//
//     // ✅ Root check
//     router.get('/', (Request req) {
//       return Response.ok(
//         '🚀 Todo Backend is running',
//         headers: {'Content-Type': 'text/plain'},
//       );
//     });
//
//     // 🔹 GET all todos
//     router.get('/todos', (Request req) async {
//       final todos = await dbClient.getAllTodos();
//       return Response.ok(
//         jsonEncode(todos),
//         headers: {'Content-Type': 'application/json'},
//       );
//     });
//
//     // 🔹 POST create todo
//     router.post('/todos', (Request req) async {
//       final body = await req.readAsString();
//       final data = jsonDecode(body);
//
//       final todo = {
//         'id': const Uuid().v4(),
//         'title': data['title'] ?? 'No Title',
//         'completed': data['completed'] ?? false,
//       };
//
//       await dbClient.createTodo(todo);
//
//       return Response.ok(
//         jsonEncode(todo),
//         headers: {'Content-Type': 'application/json'},
//       );
//     });
//
//     // 🔹 DELETE todo
//     router.delete('/todos/<id>', (Request req, String id) async {
//       final deleted = await dbClient.deleteTodo(id);
//
//       if (!deleted) {
//         return Response.notFound(
//           jsonEncode({'error': 'Todo not found'}),
//         );
//       }
//
//       return Response.ok(
//         jsonEncode({'message': 'Deleted successfully'}),
//       );
//     });
//
//     return router;
//   }
// }
