import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:image_picker/image_picker.dart';
import 'package:impactify_app/providers/auth_provider.dart';
import 'package:impactify_app/repositories/auth_repository.dart';
import '../repositories/user_repository.dart';
import '../models/user.dart';

class UserProvider with ChangeNotifier {
  final UserRepository _userRepository = UserRepository(); 
  //final AuthProvider _authProvider = AuthProvider();
  //final AuthRepository _authRepository = AuthRepository();

  final auth.FirebaseAuth _firebaseAuth = auth.FirebaseAuth.instance;

  auth.User? _firebaseUser;
   User? _userData;

   User? get userData => _userData;

  UserProvider() {
    _firebaseUser = _firebaseAuth.currentUser;
    if (_firebaseUser != null) {
      _fetchUserData(_firebaseUser!.uid);
    }
  }

  Future<void> updateUserData(Map<String, dynamic> data, XFile? imageFile) async {
    
    if (_firebaseUser != null) {
      await _userRepository.updateUserData(_firebaseUser!.uid, data, imageFile);
      // Fetch the updated user data to reflect changes
      await _fetchUserData(_firebaseUser!.uid);
    } else {
      print('No user is signed in.');
    }
  }

  Future<void> _fetchUserData(String uid) async {
    _userData = await _userRepository.getUserData(uid);
    notifyListeners(); // Notify listeners after fetching user data
  }

  void checkCurrentUser() {
    _firebaseUser = _firebaseAuth.currentUser;
    if (_firebaseUser != null) {
      _fetchUserData(_firebaseUser!.uid);
    }
    notifyListeners();
  }
}
