import '../services/fcm_service.dart';

class NotificationController {
  static Future<void> sendNotification(Map<String, dynamic> data) async {
    final token = data['token'] as String;
    final title = data['title'] as String;
    final body = data['body'] as String;

    await FCMService.sendPushNotification(token, title, body);
  }
}
