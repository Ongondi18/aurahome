import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';

class MusicScreen extends StatelessWidget {
  static const routeName = '/music';

  const MusicScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Music Control'),
      ),
      drawer: const AppDrawer(),
      body: Column(
        children: [
          // Now Playing Card
          Card(
            margin: const EdgeInsets.all(16),
            child: Column(
              children: [
                Container(
                  height: 200,
                  width: double.infinity,
                  color: Colors.grey[300],
                  child: const Icon(Icons.music_note, size: 64),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      const Text(
                        'Now Playing',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Artist Name',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.skip_previous),
                            onPressed: () {},
                            iconSize: 32,
                          ),
                          IconButton(
                            icon: const Icon(Icons.play_circle_filled),
                            onPressed: () {},
                            iconSize: 48,
                          ),
                          IconButton(
                            icon: const Icon(Icons.skip_next),
                            onPressed: () {},
                            iconSize: 32,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Room Selection
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                const Text('Playing in: '),
                DropdownButton<String>(
                  value: 'Living Room',
                  items: const [
                    DropdownMenuItem(
                      value: 'Living Room',
                      child: Text('Living Room'),
                    ),
                    DropdownMenuItem(
                      value: 'Kitchen',
                      child: Text('Kitchen'),
                    ),
                    DropdownMenuItem(
                      value: 'Bedroom',
                      child: Text('Bedroom'),
                    ),
                  ],
                  onChanged: (value) {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
} 