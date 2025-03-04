import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Stream of authentication state changes
  Stream<bool> authStateChanges() {
    return _auth.authStateChanges().map((user) => user != null);
  }

  // Get user data from Firestore
  Future<UserModel?> getUserData(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        return UserModel.fromMap({...doc.data()!, 'uid': doc.id});
      }
      return null;
    } catch (e) {
      print('Error getting user data: $e');
      rethrow;
    }
  }

  // Update user data in Firestore
  Future<void> updateUserData(UserModel user) async {
    try {
      await _firestore.collection('users').doc(user.uid).update(user.toMap());
    } catch (e) {
      print('Error updating user data: $e');
      rethrow;
    }
  }

  // Sign in with email and password
  Future<UserModel> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      final user = userCredential.user;
      if (user == null) {
        throw Exception('No user found after login');
      }

      // Get or create user document in Firestore
      final userData = await getUserData(user.uid) ?? 
          UserModel(
            uid: user.uid,
            email: user.email ?? '',
            displayName: user.displayName ?? 'User',
            photoURL: user.photoURL,
            createdAt: DateTime.now(),
            lastLoginAt: DateTime.now(),
          );

      // Update last login time
      await updateUserData(userData.copyWith(lastLoginAt: DateTime.now()));
      
      return userData;
    } catch (e) {
      print('Sign in error: $e');
      rethrow;
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Reset password
  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email.trim());
  }

  // Sign up with email and password
  Future<UserModel> signUpWithEmailAndPassword(
    String email,
    String password,
    String displayName,
  ) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      final user = userCredential.user;
      if (user == null) {
        throw Exception('No user created');
      }

      // Update display name in Firebase Auth first
      await user.updateDisplayName(displayName);
      
      // Create user model
      final userModel = UserModel(
        uid: user.uid,
        email: email,
        displayName: displayName,
        photoURL: null,
        createdAt: DateTime.now(),
        lastLoginAt: DateTime.now(),
      );

      // Save user data to Firestore
      await _firestore
          .collection('users')
          .doc(user.uid)
          .set(userModel.toMap());

      return userModel;
    } catch (e) {
      print('Sign up error: $e');
      rethrow;
    }
  }

  // Register with email and password
  Future<UserModel> registerWithEmailAndPassword(
      String email, String password, String displayName) async {
    try {
      // Create user
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      if (credential.user == null) {
        throw Exception('Failed to create user');
      }

      // Update display name
      await credential.user!.updateDisplayName(displayName);

      // Create user document
      final userData = {
        'uid': credential.user!.uid,
        'email': email,
        'displayName': displayName,
        'photoURL': null,
        'createdAt': FieldValue.serverTimestamp(),
        'lastLoginAt': FieldValue.serverTimestamp(),
      };

      try {
        await _firestore.collection('users').doc(credential.user!.uid).set(userData);
      } catch (e) {
        print('Error creating Firestore document: $e');
        // Continue even if Firestore fails
      }

      return UserModel(
        uid: credential.user!.uid,
        email: email,
        displayName: displayName,
        photoURL: null,
        createdAt: DateTime.now(),
        lastLoginAt: DateTime.now(),
      );
    } on FirebaseAuthException catch (e) {
      print('Firebase Auth Error: ${e.code} - ${e.message}');
      rethrow;
    } catch (e) {
      print('Registration error: $e');
      if (e.toString().contains('PigeonUserDetails')) {
        final currentUser = _auth.currentUser;
        if (currentUser != null) {
          return UserModel(
            uid: currentUser.uid,
            email: currentUser.email ?? '',
            displayName: currentUser.displayName ?? displayName,
            photoURL: currentUser.photoURL,
            createdAt: DateTime.now(),
            lastLoginAt: DateTime.now(),
          );
        }
      }
      rethrow;
    }
  }

  // Get user profile
  Future<UserModel?> getUserProfile() async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) return null;

      final doc = await _firestore.collection('users').doc(currentUser.uid).get();
      
      if (!doc.exists) {
        // Create user document if it doesn't exist
        final userData = {
          'uid': currentUser.uid,
          'email': currentUser.email,
          'displayName': currentUser.displayName,
          'photoURL': currentUser.photoURL,
          'createdAt': FieldValue.serverTimestamp(),
          'lastLoginAt': FieldValue.serverTimestamp(),
        };

        await _firestore.collection('users').doc(currentUser.uid).set(userData);

        return UserModel(
          uid: currentUser.uid,
          email: currentUser.email ?? '',
          displayName: currentUser.displayName,
          photoURL: currentUser.photoURL,
          createdAt: DateTime.now(),
          lastLoginAt: DateTime.now(),
        );
      }

      final data = doc.data() ?? {};
      
      return UserModel(
        uid: currentUser.uid,
        email: currentUser.email ?? data['email'] ?? '',
        displayName: currentUser.displayName ?? data['displayName'],
        photoURL: currentUser.photoURL ?? data['photoURL'],
        createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
        lastLoginAt: (data['lastLoginAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      );
    } catch (e) {
      print('Get user profile error: $e');
      return null;
    }
  }

  // Update user profile
  Future<void> updateUserProfile({
    String? displayName,
    String? photoURL,
  }) async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) {
        throw Exception('No user logged in');
      }

      final updates = <String, dynamic>{
        'lastLoginAt': FieldValue.serverTimestamp(),
      };

      if (displayName != null) {
        await currentUser.updateDisplayName(displayName);
        updates['displayName'] = displayName;
      }

      if (photoURL != null) {
        await currentUser.updatePhotoURL(photoURL);
        updates['photoURL'] = photoURL;
      }

      await _firestore.collection('users').doc(currentUser.uid).update(updates);
    } catch (e) {
      print('Update profile error: $e');
      rethrow;
    }
  }

  // Sign in with biometric
  Future<UserModel?> signInWithBiometric(String email) async {
    try {
      // Get user document from Firestore
      final userDoc = await _firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .get();
      
      if (userDoc.docs.isEmpty) {
        throw Exception('No user found with this email');
      }

      // Get the user data
      final userData = userDoc.docs.first.data();
      
      // Update last login time
      await _firestore.collection('users').doc(userDoc.docs.first.id).update({
        'lastLoginAt': FieldValue.serverTimestamp(),
      });
      
      // Create and return UserModel
      return UserModel(
        uid: userDoc.docs.first.id,
        email: email,
        displayName: userData['displayName'],
        photoURL: userData['photoURL'],
        createdAt: (userData['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
        lastLoginAt: DateTime.now(),
      );
    } catch (e) {
      print('Biometric sign in error: $e');
      rethrow;
    }
  }

  // Get current user data
  Future<UserModel?> getCurrentUserData() async {
    final user = _auth.currentUser;
    if (user != null) {
      // Try to get existing user data from Firestore
      final userData = await getUserData(user.uid);
      if (userData != null) {
        return userData;
      }
      
      // Create new user data if none exists
      final newUserData = UserModel(
        uid: user.uid,
        email: user.email ?? '',
        displayName: _getDisplayName(user),  // Use helper method
        photoURL: user.photoURL,
        createdAt: DateTime.now(),
        lastLoginAt: DateTime.now(),
      );

      // Save the new user data to Firestore
      await _firestore
          .collection('users')
          .doc(user.uid)
          .set(newUserData.toMap());

      return newUserData;
    }
    return null;
  }

  // Helper method to handle nullable display name
  String _getDisplayName(User user) {
    final displayName = user.displayName;
    if (displayName == null || displayName.isEmpty) {
      return 'User';
    }
    return displayName;
  }
} 