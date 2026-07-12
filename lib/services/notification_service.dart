import 'package:flutter/material.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final ValueNotifier<List<Map<String, dynamic>>> notificationsNotifier =
      ValueNotifier<List<Map<String, dynamic>>>([]);

  int get unreadCount => notificationsNotifier.value.where((n) => !(n['isRead'] as bool)).length;

  void addNotification({
    required String title,
    required String message,
    IconData icon = Icons.info_outline_rounded,
  }) {
    final newNotification = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'title': title,
      'message': message,
      'icon': icon,
      'timestamp': DateTime.now(),
      'isRead': false,
    };
    notificationsNotifier.value = [newNotification, ...notificationsNotifier.value];
  }

  void markAllAsRead() {
    final updated = notificationsNotifier.value.map((n) {
      return {...n, 'isRead': true};
    }).toList();
    notificationsNotifier.value = updated;
  }

  void clearAll() {
    notificationsNotifier.value = [];
  }
}
