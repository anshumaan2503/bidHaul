enum NotificationType { company, transporter, admin }

class AppNotification {
  final int id;
  final String title;
  final String message;
  final String time;
  final bool isRead;
  final NotificationType type;

  const AppNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.time,
    required this.isRead,
    required this.type,
  });
}
