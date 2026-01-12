import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;

import '../db/database_client.dart';
import '../routes/todo_routes.dart';

Future<void> main() async {

  //============ ডাটাবেজের সাথে সংযোগ স্থাপন করা হচ্ছে==========
  final dbClient = await DatabaseClient.connect();

  //=========== ডাটাবেজ কানেকশনটি রাউট ক্লাসে পাঠানো হচ্ছে (Dependency Injection)===============
  final todoRoutes = TodoRoutes(dbClient);

  //=========রিকোয়েস্ট হ্যান্ডেল করার জন্য একটি পাইপলাইন তৈরি করা হচ্ছে===========
  final handler = Pipeline()
      .addMiddleware(logRequests()) // কনসোলে প্রতিটি রিকোয়েস্টের লগ দেখানোর জন্য
      .addMiddleware(_jsonHeaderMiddleware()) // সব রেসপন্স JSON হিসেবে পাঠানোর জন্য
      .addHandler(todoRoutes.router); // রিকোয়েস্টগুলো মেইন রাউটারে পাঠানোর জন্য

  // =========localhost-এর ৮০৯০ পোর্টে সার্ভারটি চালু করা হচ্ছে============
  final server = await io.serve(handler, '0.0.0.0', 8090);

  //=========== সার্ভার সফলভাবে চালু হলে কনসোলে মেসেজ প্রিন্ট করা হচ্ছে===============
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
