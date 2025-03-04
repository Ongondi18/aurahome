import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';

class RoomsScreen extends StatelessWidget {
  static const routeName = '/rooms';

  const RoomsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rooms'),
      ),
      drawer: const AppDrawer(),
      body: const Center(
        child: Text('Rooms Screen'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Add new room
        },
        child: const Icon(Icons.add),
      ),
    );
  }
} 