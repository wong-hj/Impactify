import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:impactify_app/providers/auth_provider.dart';
import 'package:impactify_app/repositories/auth_repository.dart';
import '../repositories/user_repository.dart';
import '../models/user.dart';

final userProvider = StateNotifierProvider<UserNotifier, UserState>((ref) {
  final auth = ref.watch(authProvider);
  final userNotifier  = UserNotifier();
  print("initialize1" + auth.firebaseUser!.uid);
  userNotifier.initialize(auth.firebaseUser);
  print("initialize2" + auth.firebaseUser!.uid);
  return userNotifier;
});

class UserState {
  final auth.User? firebaseUser;
  final User? userData;

  UserState({
    this.firebaseUser,
    this.userData,
  });

  UserState copyWith({
    auth.User? firebaseUser,
    User? userData,
  }) {
    return UserState(
      firebaseUser: firebaseUser ?? this.firebaseUser,
      userData: userData ?? this.userData,
    );
  }
}

class UserNotifier extends StateNotifier<UserState> {
  final UserRepository _userRepository = UserRepository(); 

  // auth.User? _firebaseUser;
  //  User? _userData;

  //  User? get userData => _userData;

  UserNotifier() : super(UserState());

  // UserProvider(auth.User? firebaseUser) {
  //   _firebaseUser = firebaseUser;
  //   print("CURRENT: " + _firebaseUser.toString());
  //   if (_firebaseUser != null) {
  //     _fetchUserData(_firebaseUser!.uid);
  //   }
  // }

  Future<void> initialize(auth.User? firebaseUser) async {
    
    if (firebaseUser != null) {
      final userData = await _fetchUserData(firebaseUser.uid);
      state = state.copyWith(firebaseUser: firebaseUser, userData: userData);
    }
    else {
      state = UserState();
    }
  }

  Future<void> updateUserData(Map<String, dynamic> data, XFile? imageFile) async {
    
    if (state.firebaseUser != null) {
      await _userRepository.updateUserData(state.firebaseUser!.uid, data, imageFile);
      // Fetch the updated user data to reflect changes
      final updatedUserData = await _fetchUserData(state.firebaseUser!.uid);
      state = state.copyWith(userData: updatedUserData);

    } else {
      print('No user is signed in.');
    }
  }

  Future<User?> _fetchUserData(String uid) async {
    return await _userRepository.getUserData(uid);
     
  }

  void clearUserData() {
    state = UserState();
  }
}
