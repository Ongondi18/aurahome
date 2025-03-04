import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';

class HelpScreen extends StatelessWidget {
  static const routeName = '/help';

  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help & Support'),
      ),
      drawer: const AppDrawer(),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Quick Help Section
          const Text(
            'Quick Help',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildHelpCard(
            context,
            title: 'Getting Started',
            icon: Icons.play_circle_outline,
            onTap: () {
              // TODO: Show getting started guide
            },
          ),
          _buildHelpCard(
            context,
            title: 'FAQs',
            icon: Icons.question_answer_outlined,
            onTap: () {
              // TODO: Show FAQs
            },
          ),
          _buildHelpCard(
            context,
            title: 'Video Tutorials',
            icon: Icons.video_library_outlined,
            onTap: () {
              // TODO: Show video tutorials
            },
          ),

          const SizedBox(height: 32),

          // Contact Support Section
          const Text(
            'Contact Support',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildHelpCard(
            context,
            title: 'Chat with Support',
            icon: Icons.chat_outlined,
            onTap: () {
              // TODO: Open support chat
            },
          ),
          _buildHelpCard(
            context,
            title: 'Email Support',
            icon: Icons.email_outlined,
            onTap: () {
              // TODO: Open email support
            },
          ),
          _buildHelpCard(
            context,
            title: 'Call Support',
            icon: Icons.phone_outlined,
            onTap: () {
              // TODO: Show support phone number
            },
          ),

          const SizedBox(height: 32),

          // Troubleshooting Section
          const Text(
            'Troubleshooting',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildHelpCard(
            context,
            title: 'Device Issues',
            icon: Icons.build_outlined,
            onTap: () {
              // TODO: Show device troubleshooting
            },
          ),
          _buildHelpCard(
            context,
            title: 'Network Issues',
            icon: Icons.wifi_outlined,
            onTap: () {
              // TODO: Show network troubleshooting
            },
          ),
        ],
      ),
    );
  }

  Widget _buildHelpCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        leading: Icon(icon, size: 28),
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
} 