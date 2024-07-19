import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:impactify_management/models/organizer.dart';
import 'package:impactify_management/repositories/user_repository.dart';

class UserProvider with ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final UserRepository _userRepository = UserRepository();

  Organizer? _user;
  bool _isLoading = false;

  Organizer? get user => _user;
  bool get isLoading => _isLoading;

  Future<void> fetchOrganizer() async {
  
    _user = await _userRepository.fetchOrganizer(_firebaseAuth.currentUser!.uid);

  }
}
