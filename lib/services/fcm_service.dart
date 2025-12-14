import 'dart:convert';
import 'package:http/http.dart' as http;

class FCMService {
  static const String serverKey = 'YOUR_FIREBASE_SERVER_KEY';

  static Future<void> sendPushNotification(String token, String title, String body) async {
    final url = Uri.parse('https://fcm.googleapis.com/fcm/send');

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'key=$serverKey',
    };

    final payload = jsonEncode({
      "to": token,
      "notification": {
        "title": title,
        "body": body,
      },
      "data": {
        "click_action": "FLUTTER_NOTIFICATION_CLICK",
        "message": body,
      }
    });

    final response = await http.post(url, headers: headers, body: payload);
    print('FCM Response: ${response.statusCode} ${response.body}');
  }
}
