import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:image_picker/image_picker.dart';
import 'package:impactify_app/providers/auth_provider.dart';
import 'package:impactify_app/repositories/auth_repository.dart';
import '../repositories/user_repository.dart';
import '../models/user.dart';

class UserProvider with ChangeNotifier {
  final UserRepository _userRepository = UserRepository(); 
  final AuthRepository _authRepository = AuthRepository();
  //final AuthRepository _authRepository = AuthRepository();

  auth.User? _firebaseUser;
  User? _userData;

  auth.User? get firebaseUser => _firebaseUser;
   User? get userData => _userData;

  UserProvider(auth.User? firebaseUser) {
    _firebaseUser = firebaseUser;
    print("CURRENT: " + _firebaseUser.toString());
    if (_firebaseUser != null) {
      _fetchUserData(_firebaseUser!.uid);
    }
  }

  Future<void> initialize(auth.User? firebaseUser) async {
    _firebaseUser = firebaseUser;
    if (_firebaseUser != null) {
      await _fetchUserData(_firebaseUser!.uid);
    }
    notifyListeners();
  }

  Future<void> fetchUserData() async {
    
    await _fetchUserData(_authRepository.currentUser!.uid);
    
    notifyListeners();
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

  void clearUserData() {
    _userData = null;
    notifyListeners();
  }
}
