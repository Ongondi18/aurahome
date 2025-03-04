import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';

class NotificationsScreen extends StatelessWidget {
  static const routeName = '/notifications';

  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          IconButton(
            icon: const Icon(Icons.clear_all),
            onPressed: () {
              // TODO: Clear all notifications
            },
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) => _buildNotificationItem(
          context,
          title: 'Notification ${index + 1}',
          message: 'This is a sample notification message.',
          time: DateTime.now().subtract(Duration(minutes: index * 10)),
          icon: _getNotificationIcon(index),
        ),
      ),
    );
  }

  IconData _getNotificationIcon(int index) {
    switch (index % 4) {
      case 0:
        return Icons.security;
      case 1:
        return Icons.thermostat;
      case 2:
        return Icons.light;
      default:
        return Icons.notifications;
    }
  }

  Widget _buildNotificationItem(
    BuildContext context, {
    required String title,
    required String message,
    required DateTime time,
    required IconData icon,
  }) {
    return Dismissible(
      key: Key(title),
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        // TODO: Remove notification
      },
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
          child: Icon(icon, color: Theme.of(context).primaryColor),
        ),
        title: Text(title),
        subtitle: Text(message),
        trailing: Text(
          _formatTime(time),
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 12,
          ),
        ),
        onTap: () {
          // TODO: Handle notification tap
        },
      ),
    );
  }

  String _formatTime(DateTime time) {
    final difference = DateTime.now().difference(time);
    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }
} 