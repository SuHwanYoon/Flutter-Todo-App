import 'package:flutter/material.dart';
import 'package:flutter_todo_app/utils/notification_helper.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          // Notification Settings Section
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Notifications',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.notifications_active, color: Colors.blue),
            title: const Text('Send Test Notification'),
            subtitle: const Text('Test local notification'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () async {
              await NotificationHelper.showNotification(
                id: 0,
                title: 'Test Notification',
                body: 'Local notification is working! 🎉',
              );
            },
          ),
          const Divider(),

          // More settings can be added here later
          // const Padding(
          //   padding: EdgeInsets.all(16.0),
          //   child: Text(
          //     'General',
          //     style: TextStyle(
          //       fontSize: 14,
          //       fontWeight: FontWeight.bold,
          //       color: Colors.grey,
          //     ),
          //   ),
          // ),
          // ListTile(
          //   leading: Icon(Icons.language),
          //   title: Text('Language'),
          //   trailing: Icon(Icons.chevron_right),
          //   onTap: () {},
          // ),
        ],
      ),
    );
  }
}
