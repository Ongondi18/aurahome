import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';

class DevicesScreen extends StatelessWidget {
  static const routeName = '/devices';

  const DevicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Devices'),
      ),
      drawer: const AppDrawer(),
      body: const Center(
        child: Text('Devices Screen'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Add new device
        },
        child: const Icon(Icons.add),
      ),
    );
  }
} 