import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../widgets/app_drawer.dart';
import '../services/auth_service.dart';
import '../models/user_model.dart';
import 'dart:io';

class ProfileScreen extends StatefulWidget {
  static const routeName = '/profile';

  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _authService = AuthService();
  bool _isEditing = false;
  String? _imageUrl;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final userData = await _authService.getCurrentUserData();
    if (userData != null) {
      _nameController.text = userData.displayName;
      _imageUrl = userData.photoURL;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.save : Icons.edit),
            onPressed: () {
              if (_isEditing) {
                // TODO: Save profile changes
              }
              setState(() {
                _isEditing = !_isEditing;
              });
            },
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: FutureBuilder<UserModel?>(
        future: _authService.getCurrentUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final user = snapshot.data;
          if (user == null) {
            return const Center(child: Text('No user data found'));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Profile Picture
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.grey[200],
                      backgroundImage: _imageUrl != null
                          ? NetworkImage(_imageUrl!)
                          : null,
                      child: _imageUrl == null
                          ? const Icon(Icons.person, size: 50)
                          : null,
                    ),
                    if (_isEditing)
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: CircleAvatar(
                          backgroundColor: Theme.of(context).primaryColor,
                          radius: 18,
                          child: IconButton(
                            icon: const Icon(Icons.camera_alt, size: 18),
                            color: Colors.white,
                            onPressed: () => _selectImage(),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 24),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Display Name',
                          border: OutlineInputBorder(),
                        ),
                        enabled: _isEditing,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        initialValue: user.email,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(),
                        ),
                        enabled: false,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                // Additional Options
                _buildOptionTile(
                  icon: Icons.lock_outline,
                  title: 'Change Password',
                  onTap: () {
                    // TODO: Implement password change
                  },
                ),
                _buildOptionTile(
                  icon: Icons.security,
                  title: 'Two-Factor Authentication',
                  onTap: () {
                    // TODO: Implement 2FA settings
                  },
                ),
                _buildOptionTile(
                  icon: Icons.delete_outline,
                  title: 'Delete Account',
                  color: Colors.red,
                  onTap: () {
                    // TODO: Implement account deletion
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _selectImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      await _uploadImage(image);
    }
  }

  Future<void> _uploadImage(XFile image) async {
    final userId = _authService.currentUser?.uid; // Use null-aware operator
    if (userId != null) {
        final storageRef = FirebaseStorage.instance.ref().child('profile_images/$userId.jpg');
        await storageRef.putFile(File(image.path));
        final downloadUrl = await storageRef.getDownloadURL();

        // Update the user's profile with the new image URL
        await _authService.updateUserProfileImage(downloadUrl);
        setState(() {
            _imageUrl = downloadUrl;
        });
    } else {
        // Handle the case where userId is null (e.g., show an error message)
        print("User is not logged in.");
    }
  }

  Widget _buildOptionTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? color,
  }) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(
        title,
        style: TextStyle(color: color),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }
} 