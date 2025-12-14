import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import 'controller/notification_controller.dart';

Router getRoutes() {
  final router = Router();

  router.post('/send-notification', (Request request) async {
    final data = jsonDecode(await request.readAsString());
    await NotificationController.sendNotification(data);
    return Response.ok(jsonEncode({'status': 'success'}), headers: {'Content-Type': 'application/json'});
  });

  router.get('/ping', (Request request) {
    return Response.ok(jsonEncode({'message': 'Server is running'}), headers: {'Content-Type': 'application/json'});
  });

  return router;
}
