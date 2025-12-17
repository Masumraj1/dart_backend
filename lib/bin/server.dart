import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;

import '../db/database_client.dart';
import '../routes/todo_routes.dart';

Future<void> main() async {
  final dbClient = await DatabaseClient.connect();
  final todoRoutes = TodoRoutes(dbClient);

  final handler = Pipeline()
      .addMiddleware(logRequests())
      .addMiddleware(_jsonHeaderMiddleware())
      .addHandler(todoRoutes.router);

  final server = await io.serve(handler, '0.0.0.0', 8090);
  print('🚀 Server running on http://localhost:${server.port}');
}

Middleware _jsonHeaderMiddleware() {
  return (handler) {
    return (request) async {
      final response = await handler(request);
      return response.change(
        headers: {'Content-Type': 'application/json'},
      );
    };
  };
}
