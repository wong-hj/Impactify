import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:impactify_app/models/post.dart';
import 'package:impactify_app/repositories/auth_repository.dart';
import 'package:impactify_app/repositories/post_repository.dart';

class PostProvider with ChangeNotifier {
  final PostRepository _postRepository = PostRepository();
  final AuthRepository _authRepository = AuthRepository();

  bool _isLoading = false;
  List<Post>? _posts;

  List<Post>? get posts => _posts;
  bool get isLoading => _isLoading;

  Future<void> addPost(XFile? imageFile, String title, String description, String activityID) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _postRepository.addPost(_authRepository.currentUser!.uid, imageFile, title, description,
          activityID);
      //await fetchBookmarksAndProjects(); // Refresh the bookmarks list
      await fetchAllPosts();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      print('Error in PostProvider: $e');
      throw Exception('Error adding post');
    }
  }

  Future<void> fetchAllPosts() async {
    _isLoading = true;
    notifyListeners();

    try {
      _posts = await _postRepository.fetchAllPosts();
    } catch (e) {
      _posts = [];
      print('Error in PostProvider: $e');
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> likePost(String postID) async {

    await _postRepository.likePost(postID, _authRepository.currentUser!.uid);
    _updatePostLikes(postID, _authRepository.currentUser!.uid, true);
  }

  Future<void> unlikePost(String postID) async {
    await _postRepository.unlikePost(postID, _authRepository.currentUser!.uid);
    _updatePostLikes(postID, _authRepository.currentUser!.uid, false);
  }

  void _updatePostLikes(String postID, String userID, bool liked) {
    Post? post = _posts?.firstWhere((post) => post.postID == postID);
    if (post != null) {
      if (liked) {
        post.likes.add(userID);
      } else {
        post.likes.remove(userID);
      }
      notifyListeners();
    }
  }

  Future<void> fetchFilteredPosts(String filter, List<String> tagIDs, DateTime? startDate, DateTime? endDate) async {
    _isLoading = true;
    notifyListeners();

    try {
      _posts = await _postRepository.fetchFilteredPosts(filter, tagIDs, startDate, endDate);
    } catch (e) {
      _posts = [];
      print('Error in EventProvider: $e');
    }
    _isLoading = false;
    notifyListeners();
  }

}