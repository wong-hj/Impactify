import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:impactify_app/models/user.dart';
import 'package:impactify_app/repositories/auth_repository.dart';
import 'package:impactify_app/repositories/user_repository.dart';

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {

  
  // auth.FirebaseAuth.instance.authStateChanges().listen((firebaseUser) {
  //   if (firebaseUser == null) {
  //     authNotifier.signOut();
  //   } else {
  //     authNotifier.checkCurrentUser();
  //   }
  // });

  return AuthNotifier();
});

// final authProvider = ChangeNotifierProvider<AuthProvider>((ref) {
//   return AuthProvider()..checkCurrentUser();
// });

class AuthState {
  final auth.User? firebaseUser;
  final bool isLoading;
  final User? userData;

  AuthState({
    this.firebaseUser,
    this.isLoading = false,
    this.userData,
  });

  AuthState copyWith({
    auth.User? firebaseUser,
    bool? isLoading,
    User? userData,
  }) {
    return AuthState(
      firebaseUser: firebaseUser ?? this.firebaseUser,
      isLoading: isLoading ?? this.isLoading,
      userData: userData ?? this.userData,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  //final AuthRepository _authRepository = AuthRepository();
  final AuthRepository _authRepository;
  final UserRepository _userRepository = UserRepository();

  AuthNotifier() : _authRepository = AuthRepository(), super(AuthState());

  //AuthNotifier() : super(AuthState());

  // auth.User? _firebaseUser;
  // bool _isLoading = false;
  // User? _userData;

  // auth.User? get user => _firebaseUser;
  // bool get isLoading => _isLoading;
  // User? get userData => _userData;

  // Sign in with email and password and notify state
  Future<void> signInWithEmail(String email, String password) async {
    _setLoadingState(true);
    final firebaseUser = await _authRepository.signInWithEmail(email, password);
    if (firebaseUser != null) {
      await fetchUserData(firebaseUser.uid);
    }
    // _setLoadingState(false);
    state = state.copyWith(firebaseUser: firebaseUser, isLoading: false);
  }

  // Sign in with Google and notify listeners
  Future<void> signInWithGoogle() async {
    _setLoadingState(true);
    final firebaseUser = await _authRepository.signInWithGoogle();
    if (firebaseUser != null) {
      await fetchUserData(firebaseUser.uid);
    }
    state = state.copyWith(firebaseUser: firebaseUser, isLoading: false);
  }

  Future<void> signUpWithEmail(String email, String password, String fullname, String username) async {
    _setLoadingState(true);
    final firebaseUser = await _authRepository.signUpWithEmail(email, password, fullname, username);
    if (firebaseUser != null) {
      await fetchUserData(firebaseUser.uid);
    }
    state = state.copyWith(firebaseUser: firebaseUser, isLoading: false);
  }

  // Sign out and notify listeners
  Future<void> signOut() async {
    await _authRepository.logout();
    print("Logged out from Firebase" + _authRepository.currentUser.toString());
    state = state.copyWith(firebaseUser: null, userData: null);
    print("STATE IS: " + state.firebaseUser.toString());
  }

  // Check current user and notify listeners
  Future<void> checkCurrentUser() async {
    final firebaseUser = _authRepository.currentUser;
    if (firebaseUser != null) {
      fetchUserData(firebaseUser.uid);
    }
    state = state.copyWith(firebaseUser: firebaseUser);
  }

  Future<void> fetchUserData(String uid) async {
    final userData = await _userRepository.getUserData(uid);
    state = state.copyWith(userData: userData);
  }

  void _setLoadingState(bool isLoading) {
    state = state.copyWith(isLoading: isLoading);
  }
}
