import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:impactify_management/repositories/auth_repository.dart';

class AuthProvider with ChangeNotifier {
  final AuthRepository _authRepository = AuthRepository();

  User? _firebaseUser;
  bool _isLoading = false;

  User? get firebaseUser => _firebaseUser;
  bool get isLoading => _isLoading;

  // Sign in with email and password and notify listeners
  Future<void> signInWithEmail(String email, String password) async {

    _isLoading = true;
    notifyListeners();

    _firebaseUser = await _authRepository.signInWithEmail(email, password);

    _isLoading = false;
    notifyListeners();
    
  }

  Future<void> signUpWithEmail(String email,
      String password,
      String fullName,
      String username,
      String organizationName,
      String? ssmNumber,
      XFile? ssmFile) async {
    
    _isLoading = true;
    notifyListeners();


    _firebaseUser = await _authRepository.signUpWithEmail(email, password, fullName, username, organizationName, ssmNumber, ssmFile ?? null);

    _isLoading = false;
    notifyListeners();

    // if (_firebaseUser != null) {
    //   await fetchUserData(_firebaseUser!.uid);
    // }
    
  }

  // Sign out and notify listeners
  Future<void> signOut() async {
    await _authRepository.logout();
    _firebaseUser = null;
    
    notifyListeners();
  }
  
}
