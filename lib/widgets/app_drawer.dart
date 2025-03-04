import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/auth_service.dart';
import '../models/user_model.dart';

class AppDrawer extends ConsumerWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authService = AuthService();

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          FutureBuilder<UserModel?>(
            future: authService.getCurrentUserData(),
            builder: (context, snapshot) {
              return UserAccountsDrawerHeader(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Theme.of(context).primaryColor,
                      Theme.of(context).primaryColor.withOpacity(0.7),
                    ],
                  ),
                ),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: snapshot.data?.photoURL != null
                      ? ClipOval(
                          child: Image.network(
                            snapshot.data!.photoURL!,
                            fit: BoxFit.cover,
                            width: 90,
                            height: 90,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.person, size: 35),
                          ),
                        )
                      : const Icon(Icons.person, size: 35),
                ),
                accountName: Text(
                  snapshot.data?.displayName ?? 'Loading...',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                accountEmail: Text(
                  snapshot.data?.email ?? 'Loading...',
                  style: const TextStyle(fontSize: 14),
                ),
              );
            },
          ),
          // Main Features
          _buildDrawerItem(context, Icons.dashboard, 'Dashboard', '/'),
          _buildDrawerItem(context, Icons.room, 'Rooms', '/rooms'),
          _buildDrawerItem(context, Icons.devices, 'Devices', '/devices'),
          
          // Security Section
          const Divider(),
          const Padding(
            padding: EdgeInsets.only(left: 16, top: 8),
            child: Text('Security', style: TextStyle(color: Colors.grey)),
          ),
          _buildDrawerItem(context, Icons.security, 'Security System', '/security'),
          _buildDrawerItem(context, Icons.videocam, 'Cameras', '/cameras'),
          _buildDrawerItem(context, Icons.lock, 'Access Control', '/access'),

          // Entertainment Section
          const Divider(),
          const Padding(
            padding: EdgeInsets.only(left: 16, top: 8),
            child: Text('Entertainment', style: TextStyle(color: Colors.grey)),
          ),
          _buildDrawerItem(context, Icons.music_note, 'Music', '/music'),
          _buildDrawerItem(context, Icons.games, 'Gaming', '/gaming'),

          // Settings & Support
          const Divider(),
          const Padding(
            padding: EdgeInsets.only(left: 16, top: 8),
            child: Text('Settings & Support', style: TextStyle(color: Colors.grey)),
          ),
          _buildDrawerItem(context, Icons.settings, 'Settings', '/settings'),
          _buildDrawerItem(context, Icons.notifications, 'Notifications', '/notifications'),
          _buildDrawerItem(context, Icons.help, 'Help & Support', '/help'),
          _buildDrawerItem(context, Icons.person, 'Profile', '/profile'),
          _buildDrawerItem(context, Icons.report_problem, 'Report Issue', '/report'),

          // Logout
          const Divider(),
          _buildDrawerItem(
            context, 
            Icons.logout, 
            'Logout',
            '/auth',
            onTap: () async {
              final shouldLogout = await _showLogoutDialog(context);
              if (shouldLogout && context.mounted) {
                await authService.signOut();
                Navigator.of(context).pushReplacementNamed('/auth');
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context,
    IconData icon,
    String title,
    String routeName, {
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.white70),
      title: Text(
        title,
        style: const TextStyle(color: Colors.white),
      ),
      onTap: onTap ?? () => _navigateToScreen(context, routeName),
    );
  }

  void _navigateToScreen(BuildContext context, String routeName) {
    Navigator.of(context).pop(); // Close drawer
    if (ModalRoute.of(context)?.settings.name != routeName) {
      Navigator.of(context).pushReplacementNamed(routeName);
    }
  }

  Future<bool> _showLogoutDialog(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Logout'),
          ),
        ],
      ),
    ) ?? false;
  }
} 