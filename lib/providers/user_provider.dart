import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

final userProvider = StateNotifierProvider<UserNotifier, UserModel?>((ref) {
  return UserNotifier(AuthService());
});

class UserNotifier extends StateNotifier<UserModel?> {
  final AuthService _authService;

  UserNotifier(this._authService) : super(null) {
    // Initialize by checking current user
    _init();
  }

  Future<void> _init() async {
    final user = _authService.currentUser;
    if (user != null) {
      // Get user data from Firestore
      // You'll need to implement this in AuthService
      final userData = await _authService.getUserData(user.uid);
      state = userData;
    }
  }

  Future<void> updateUser(UserModel updatedUser) async {
    // Update user data in Firestore
    await _authService.updateUserData(updatedUser);
    state = updatedUser;
  }

  void clearUser() {
    state = null;
  }
} 