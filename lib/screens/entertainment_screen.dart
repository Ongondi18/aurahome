import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';

class EntertainmentScreen extends StatelessWidget {
  static const routeName = '/entertainment';
  
  const EntertainmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Entertainment'),
      ),
      drawer: const AppDrawer(),
      body: GridView.count(
        padding: const EdgeInsets.all(16),
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        children: [
          _buildEntertainmentCard(
            context,
            'Smart TV',
            Icons.tv,
            Colors.blue,
            () {
              // TODO: Implement TV controls
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('TV Controls Coming Soon')),
              );
            },
          ),
          _buildEntertainmentCard(
            context,
            'Music',
            Icons.music_note,
            Colors.purple,
            () {
              // TODO: Implement music controls
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Music Controls Coming Soon')),
              );
            },
          ),
          _buildEntertainmentCard(
            context,
            'Gaming',
            Icons.sports_esports,
            Colors.green,
            () {
              // TODO: Implement gaming controls
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Gaming Controls Coming Soon')),
              );
            },
          ),
          _buildEntertainmentCard(
            context,
            'Streaming',
            Icons.play_circle_filled,
            Colors.red,
            () {
              // TODO: Implement streaming controls
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Streaming Controls Coming Soon')),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildEntertainmentCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 48,
              color: color,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.black87,
                  ),
            ),
          ],
        ),
      ),
    );
  }
} 