import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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
    
    _isLoading = true;
    notifyListeners();

    _user = await _userRepository.fetchOrganizer(_firebaseAuth.currentUser!.uid);

    _isLoading = false;
    notifyListeners();

  }

  Future<void> updateUserData(Map<String, dynamic> data, XFile? imageFile, XFile? ssmPdfFile) async {
    
    
      await _userRepository.updateUserData(_firebaseAuth.currentUser!.uid, data, imageFile, ssmPdfFile);
      // Fetch the updated user data to reflect changes
      await fetchOrganizer();
    
  }

  
  
}
