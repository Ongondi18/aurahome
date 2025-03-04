import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';

class AccessControlScreen extends StatelessWidget {
  static const routeName = '/access';

  const AccessControlScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Access Control'),
      ),
      drawer: const AppDrawer(),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildAccessCard(
            context,
            title: 'Front Door',
            subtitle: 'Locked',
            icon: Icons.lock,
            isLocked: true,
            onTap: () {
              // TODO: Implement door control
            },
          ),
          _buildAccessCard(
            context,
            title: 'Garage Door',
            subtitle: 'Closed',
            icon: Icons.garage,
            isLocked: true,
            onTap: () {
              // TODO: Implement garage control
            },
          ),
          _buildAccessCard(
            context,
            title: 'Back Door',
            subtitle: 'Locked',
            icon: Icons.door_back_door,
            isLocked: true,
            onTap: () {
              // TODO: Implement door control
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Add new access point
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildAccessCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isLocked,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        leading: Icon(
          icon,
          color: isLocked ? Colors.green : Colors.red,
          size: 32,
        ),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: Switch(
          value: isLocked,
          onChanged: (value) {
            // TODO: Implement lock/unlock
          },
        ),
        onTap: onTap,
      ),
    );
  }
} 