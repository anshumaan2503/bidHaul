import '../models/app_notification.dart';

final List<AppNotification> dummyNotifications = [
  const AppNotification(
    id: 1,
    title: "New Bid Received",
    message: "ABC Logistics submitted a bid.",
    time: "2 min ago",
    isRead: false,
    type: NotificationType.company,
  ),

  const AppNotification(
    id: 2,
    title: "Tender Available",
    message: "A new tender matches your fleet.",
    time: "12 min ago",
    isRead: false,
    type: NotificationType.transporter,
  ),

  const AppNotification(
    id: 3,
    title: "Company Verification",
    message: "XYZ Logistics is waiting for approval.",
    time: "25 min ago",
    isRead: true,
    type: NotificationType.admin,
  ),
];
