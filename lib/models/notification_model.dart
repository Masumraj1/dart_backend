class NotificationModel {
  final String token;
  final String title;
  final String body;

  NotificationModel({
    required this.token,
    required this.title,
    required this.body,
  });

  Map<String, dynamic> toJson() => {
    'token': token,
    'title': title,
    'body': body,
  };
}
