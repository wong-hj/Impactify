// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart' as auth;
// import '../repositories/user_repository.dart';
// import '../models/user.dart';

// class UserProvider with ChangeNotifier {
//   final UserRepository _userRepository = UserRepository();
//   auth.User? _firebaseUser;
//   User? _userData;

//   User? get userData => _userData;

//   void checkCurrentUser() {
//     _firebaseUser = _userRepository.currentUser;
//     if (_firebaseUser != null) {
//       fetchUserData(_firebaseUser!.uid);
//     }
//     notifyListeners();
//   }

//   Future<void> fetchUserData(String uid) async {
//     _userData = await _userRepository.getUserData(uid);
//     notifyListeners();
//   }

//   void setFirebaseUser(auth.User? user) {
//     _firebaseUser = user;
//     notifyListeners();
//   }
// }
