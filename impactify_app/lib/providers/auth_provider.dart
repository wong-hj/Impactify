import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:impactify_app/repositories/auth_repository.dart';

class AuthProvider with ChangeNotifier {
  final AuthRepository _authRepository = AuthRepository();
  User? _user;
  bool _isLoading = false;

  User? get user => _user;
  bool get isLoading => _isLoading;

  // Sign in with email and password and notify listeners
  Future<void> signInWithEmail(String email, String password) async {
    _setLoadingState(true);
    _user = await _authRepository.signInWithEmail(email, password);
    _setLoadingState(false);
  }

  // Sign in with Google and notify listeners
  Future<void> signInWithGoogle() async {
    _setLoadingState(true);
    _user = await _authRepository.signInWithGoogle();
    _setLoadingState(false);
  }

  Future<void> signUpWithEmail(String email, String password, String fullname, String username) async {
    _setLoadingState(true);
    _user = await _authRepository.signUpWithEmail(email, password, fullname, username);
    _setLoadingState(false);
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

   void _setLoadingState(bool isLoading) {
    _isLoading = isLoading;
    print("Setting loading state to: $isLoading");
    notifyListeners();
  }
}
