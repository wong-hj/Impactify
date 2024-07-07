import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:impactify_app/repositories/auth_repository.dart';

class AuthProvider with ChangeNotifier {
  final AuthRepository _authRepository = AuthRepository();
  User? _user;

  User? get user => _user;

  // Sign in with email and password and notify listeners
  Future<void> signInWithEmail(String email, String password) async {
    _user = await _authRepository.signInWithEmail(email, password);
    notifyListeners();
  }

  // Sign in with Google and notify listeners
  Future<void> signInWithGoogle() async {
    _user = await _authRepository.signInWithGoogle();
    notifyListeners();
  }

  // Sign out and notify listeners
  Future<void> signOut() async {
    await _authRepository.logout();
    _user = null;
    notifyListeners();
  }

  // Check current user and notify listeners
  void checkCurrentUser() {
    _user = _authRepository.getCurrentUser();
    notifyListeners();
  }
}
