import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';
import '../models/device_model.dart';
import 'camera_feed_screen.dart';

class CamerasScreen extends StatelessWidget {
  static const routeName = '/cameras';

  const CamerasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Security Cameras'),
      ),
      drawer: const AppDrawer(),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3/2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemBuilder: (context, index) => _buildCameraCard(context),
        itemCount: 4, // Replace with actual camera count
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Add new camera
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildCameraCard(BuildContext context) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: () {
          // Navigate to camera feed
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CameraFeedScreen(
                camera: DeviceModel(
                  id: '1',
                  name: 'Front Door Camera',
                  type: DeviceType.camera,
                  status: DeviceStatus.active,
                  roomId: '1',
                  settings: {},
                  addedAt: DateTime.now(),
                  lastUpdated: DateTime.now(),
                ),
              ),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Center(
                  child: Icon(
                    Icons.videocam,
                    color: Colors.white54,
                    size: 32,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Front Door Camera',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Text(
                        'Online',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
} 