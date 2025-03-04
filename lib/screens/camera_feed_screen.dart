import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/device_model.dart';

class CameraFeedScreen extends StatelessWidget {
  final DeviceModel camera;

  const CameraFeedScreen({
    super.key,
    required this.camera,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          camera.name,
          style: GoogleFonts.poppins(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.fullscreen),
            onPressed: () {
              // TODO: Implement fullscreen mode
            },
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              // TODO: Show camera settings
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // Camera Feed (placeholder)
          Center(
            child: Container(
              color: Colors.black45,
              child: const Center(
                child: Icon(
                  Icons.videocam,
                  color: Colors.white54,
                  size: 64,
                ),
              ),
            ),
          ),
          // Camera Controls
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withOpacity(0.8),
                    Colors.transparent,
                  ],
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildCameraControl(Icons.screenshot, 'Screenshot'),
                  _buildCameraControl(Icons.fiber_manual_record, 'Record'),
                  _buildCameraControl(Icons.volume_up, 'Audio'),
                  _buildCameraControl(Icons.settings_outlined, 'Settings'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCameraControl(IconData icon, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(icon, color: Colors.white),
          onPressed: () {
            // TODO: Implement camera controls
          },
        ),
        Text(
          label,
          style: GoogleFonts.poppins(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
} 