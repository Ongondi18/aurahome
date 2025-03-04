import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';

class GamingScreen extends StatelessWidget {
  static const routeName = '/gaming';

  const GamingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gaming'),
      ),
      drawer: const AppDrawer(),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: 4,
        itemBuilder: (context, index) => _buildGameConsoleCard(
          context,
          title: 'Gaming Console ${index + 1}',
          status: index % 2 == 0 ? 'Online' : 'Offline',
          icon: Icons.sports_esports,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Add new gaming device
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildGameConsoleCard(
    BuildContext context, {
    required String title,
    required String status,
    required IconData icon,
  }) {
    final isOnline = status == 'Online';

    return Card(
      child: InkWell(
        onTap: () {
          // TODO: Navigate to console control
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 48,
                color: isOnline ? Theme.of(context).primaryColor : Colors.grey,
              ),
              const SizedBox(height: 16),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: isOnline ? Colors.green : Colors.grey,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  status,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 