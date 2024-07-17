import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:image_picker/image_picker.dart';
import 'package:impactify_app/models/activity.dart';
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
  bool? _isHistoryLoading;
  bool? _isLoading;
  String? _postCount;
  String? _likeCount;
  String? _participationCount;
  List<Activity>? _history = [];

  auth.User? get firebaseUser => _firebaseUser;
  User? get userData => _userData;
  bool? get isHistoryLoading => _isHistoryLoading;
  bool? get isLoading => _isLoading;
  String? get postCount => _postCount;
  String? get likeCount => _likeCount;
  String? get participationCount => _participationCount;
  List<Activity>? get history => _history;

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
    _isLoading = true;
    notifyListeners();

    await _fetchUserData(_authRepository.currentUser!.uid);
    await _fetchUserHistory();
    await _fetchUserStats();

    _isLoading = false;
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

  Future<void> _fetchUserHistory() async {
    

    try {
      _history  = await _userRepository.fetchUserHistory(_authRepository.currentUser!.uid);
      

    } catch (e) {
      _history = [];
      print('Error in EventProvider: $e');
    }

  }

  Future<void> _fetchUserStats() async {
     

    try {
      _postCount = await _userRepository.fetchPostCount(_authRepository.currentUser!.uid);
      _likeCount = await _userRepository.fetchLikeCount(_authRepository.currentUser!.uid);
      _participationCount = await _userRepository.fetchParticipationCount(_authRepository.currentUser!.uid);

    } catch (e) {
      _history = [];
      print('Error in EventProvider: $e');
    }

  }

  

  
}
