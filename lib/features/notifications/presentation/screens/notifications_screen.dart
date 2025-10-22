import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  final List<Map<String, dynamic>> notifications = [
    {
      'title': '⏰ Task Reminder',
      'message': 'Don\'t forget: "Duha" is due in 2 hours!',
      'time': '5 min ago',
      'unread': true,
    },
    {
      'title': '🎉 Achievement Unlocked',
      'message': 'You earned the "Consistent" badge!',
      'time': '1 hour ago',
      'unread': true,
    },
    {
      'title': '✅ Task Completed',
      'message': 'Sarah completed "Review quarterly reports"',
      'time': '2 hours ago',
      'unread': false,
    },
    {
      'title': '🔥 Streak Alert',
      'message': 'Complete 1 task today to maintain your 7-day streak!',
      'time': '3 hours ago',
      'unread': false,
    },
  ];

  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text('Mark all read'),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notif = notifications[index];
          return Container(
            color: notif['unread'] ? Colors.purple[50] : null,
            child: ListTile(
              leading: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: notif['unread'] ? const Color(0xFF7C3AED) : Colors.transparent,
                  shape: BoxShape.circle,
                ),
              ),
              title: Text(
                notif['title'],
                style: TextStyle(
                  fontWeight: notif['unread'] ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(notif['message']),
                  const SizedBox(height: 4),
                  Text(
                    notif['time'],
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
              onTap: () {},
            ),
          );
        },
      ),
    );
  }
}
