import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:impactify_management/repositories/auth_repository.dart';

class AuthProvider with ChangeNotifier {
  final AuthRepository _authRepository = AuthRepository();

  User? _firebaseUser;

  User? get firebaseUser => _firebaseUser;

  Future<void> signUpWithEmail(String email,
      String password,
      String fullName,
      String username,
      String organizationName,
      String? ssmNumber,
      XFile? ssmFile) async {
    
    _firebaseUser = await _authRepository.signUpWithEmail(email, password, fullName, username, organizationName, ssmNumber, ssmFile ?? null);
    // if (_firebaseUser != null) {
    //   await fetchUserData(_firebaseUser!.uid);
    // }
    
  }
  
}
