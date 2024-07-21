import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/foundation.dart';
import 'package:impactify_management/models/post.dart';
import 'package:impactify_management/repositories/post_repository.dart';

class PostProvider with ChangeNotifier {

  final PostRepository _postRepository = PostRepository();
  final auth.FirebaseAuth _firebaseAuth = auth.FirebaseAuth.instance;

  bool _isLoading = false;
  List<Post>? _posts;

  List<Post>? get posts => _posts;
  bool get isLoading => _isLoading;

  Future<void> fetchAllPostsByOrganizerID() async {
    _isLoading = true;
    notifyListeners();

    try {
      _posts = await _postRepository.fetchAllPostsByOrganizerID(_firebaseAuth.currentUser!.uid);
      _isLoading = false;
    notifyListeners();

    } catch (e) {
      _posts = [];
      _isLoading = false;
    notifyListeners();
      print('Error in PostProvider: $e');
    }
    
  }

  Future<void> fetchAllPostsByActivityID(String activityID) async {
    _isLoading = true;
    notifyListeners();

    try {

      _posts = await _postRepository.fetchAllPostsByActivityID(activityID);

    } catch (e) {
      _posts = [];
      print('Error in PostProvider: $e');
    }
    _isLoading = false;
    notifyListeners();
  }

}