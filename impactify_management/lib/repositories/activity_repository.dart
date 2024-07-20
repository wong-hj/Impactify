import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:impactify_management/models/project.dart';
import 'package:impactify_management/models/user.dart';

class ActivityRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  

  Future<List<Project>> fetchAllProjectsByOrganizer(String organizerID) async {
    List<Project> projects = [];
    try {
      QuerySnapshot projectSnapshot = await _firestore
          .collection('events')
          .where('organizerID', isEqualTo: organizerID)
          .get();
      projects =
          projectSnapshot.docs.map((doc) => Project.fromFirestore(doc)).toList();
      return projects;
    } catch (e) {
      print('Error fetching Projects: $e');
      throw e;
    }
  }

  Future<List<User>> fetchAttendeesByProjectID(String projectID) async {
  List<User> users = [];
  try {
    // Fetch participation documents where activityID equals projectID
    QuerySnapshot attendeesSnapshot = await _firestore
        .collection('participation')
        .where('activityID', isEqualTo: projectID)
        .get();

    // Extract userID from each document
    List<String> userIDs = attendeesSnapshot.docs
        .map((doc) => doc['userID'] as String)
        .toList();

    // Fetch user data for each userID
    for (String userID in userIDs) {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(userID).get();
      if (userDoc.exists) {
        users.add(User.fromFirestore(userDoc));
      }
    }

    return users;
  } catch (e) {
    print('Error fetching attendees: $e');
    throw e;
  }
}

  Future<Project> fetchProjectByID(String projectID) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('events').doc(projectID).get();

      if (doc.exists) {
        return Project.fromFirestore(doc);
      } else {
        throw Exception('Project not found');
      }
    } catch (e) {
      print('Error fetching Project: $e');
      throw e;
    }
  }

  
}