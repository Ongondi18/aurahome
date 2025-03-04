import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';

class SecurityScreen extends StatelessWidget {
  static const routeName = '/security';

  const SecurityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Security'),
      ),
      drawer: const AppDrawer(),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: ListTile(
              leading: const Icon(Icons.video_camera_back),
              title: const Text('Cameras'),
              subtitle: const Text('View live camera feeds'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                // TODO: Implement camera view
              },
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.door_front_door),
              title: const Text('Door Locks'),
              subtitle: const Text('Manage smart locks'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                // TODO: Implement door locks management
              },
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.alarm),
              title: const Text('Alarm System'),
              subtitle: const Text('Configure alarm settings'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                // TODO: Implement alarm system settings
              },
            ),
          ),
        ],
      ),
    );
  }
} 