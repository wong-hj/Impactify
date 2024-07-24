import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:impactify_management/models/activity.dart';
import 'package:impactify_management/models/project.dart';
import 'package:impactify_management/models/speech.dart';
import 'package:impactify_management/models/tag.dart';
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
          .where('status', isEqualTo: 'active')
          .get();
      projects = projectSnapshot.docs
          .map((doc) => Project.fromFirestore(doc))
          .toList();
      return projects;
    } catch (e) {
      print('Error fetching Projects: $e');
      throw e;
    }
  }

  Future<List<Speech>> fetchAllSpeechesByOrganizer(String organizerID) async {
    List<Speech> speeches = [];
    try {
      QuerySnapshot speechSnapshot = await _firestore
          .collection('speeches')
          .where('organizerID', isEqualTo: organizerID)
          .where('status', isEqualTo: 'active')
          .get();
      speeches =
          speechSnapshot.docs.map((doc) => Speech.fromFirestore(doc)).toList();
      return speeches;
    } catch (e) {
      print('Error fetching speeches: $e');
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
      List<String> userIDs =
          attendeesSnapshot.docs.map((doc) => doc['userID'] as String).toList();

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

  Future<Speech> fetchSpeechByID(String speechID) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('speeches').doc(speechID).get();

      if (doc.exists) {
        return Speech.fromFirestore(doc);
      } else {
        throw Exception('Speech not found');
      }
    } catch (e) {
      print('Error fetching Speech: $e');
      throw e;
    }
  }

  Future<void> uploadRecording(XFile? video, String speechID) async {
    try {
      if (video == null) {
        throw Exception('No video selected');
      }

      String fileName =
          'recordings/$speechID/${DateTime.now().millisecondsSinceEpoch}.mp4';
      Reference storageRef = FirebaseStorage.instance.ref().child(fileName);
      UploadTask uploadTask = storageRef.putFile(File(video.path));
      TaskSnapshot taskSnapshot = await uploadTask;

      String downloadUrl = await taskSnapshot.ref.getDownloadURL();

      await _firestore
          .collection('speeches')
          .doc(speechID)
          .update({'recording': downloadUrl});
    } catch (e) {
      throw Exception('Error uploading Recording: $e');
    }
  }

  Future<List<Activity>> fetchAllActivities(String organizerID) async {
    //await Future.delayed(Duration(seconds: 1));
    List<Activity> activities = [];
    try {
      QuerySnapshot projectSnapshot = await _firestore
          .collection('events')
          .where('organizerID', isEqualTo: organizerID)
          .where('status', isEqualTo: 'active')
          .get();

      activities.addAll(projectSnapshot.docs
          .map((doc) => Project.fromFirestore(doc))
          .toList());

      QuerySnapshot speechSnapshot = await _firestore
          .collection('speeches')
          .where('organizerID', isEqualTo: organizerID)
          .where('status', isEqualTo: 'active')
          .get();

      activities.addAll(
          speechSnapshot.docs.map((doc) => Speech.fromFirestore(doc)).toList());

      return activities;
    } catch (e) {
      print('Error fetching activities: $e');
      throw e;
    }
  }

  Future<List<Tag>> fetchAllTags() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('tags').get();

      return snapshot.docs.map((doc) => Tag.fromFirestore(doc)).toList();
    } catch (e) {
      print('Error fetching tags: $e');
      throw e;
    }
  }

  Future<void> addTag(String tagName) async {
    try {
      FirebaseFirestore _firestore = FirebaseFirestore.instance;

      DocumentReference docRef = _firestore.collection('tags').doc();

      // Create the tag data
      Map<String, dynamic> tagData = {
        'tagID': docRef.id,
        'name': tagName,
      };

      // Set the document with the tag data
      await docRef.set(tagData);

      print('Tag added successfully with ID: ${docRef.id}');
    } catch (e) {
      print('Error adding tag: $e');
      throw e;
    }
  }

  Future<void> addProject(String organizerID, String organizerName,
      Map<String, dynamic> data, XFile? imageFile) async {
    DocumentReference docRef;
    try {
      if (imageFile != null) {
        String fileName =
            'projects/$organizerID/project_${DateTime.now().millisecondsSinceEpoch}.png';
        Reference storageRef = _storage.ref().child(fileName);
        UploadTask uploadTask = storageRef.putFile(File(imageFile.path));
        TaskSnapshot taskSnapshot = await uploadTask;

        // Get download URL
        String downloadUrl = await taskSnapshot.ref.getDownloadURL();

        data['image'] = downloadUrl;
        data['organizerID'] = organizerID;
        data['organizer'] = organizerName;

        // Create a new document in the posts collection
        docRef = await _firestore.collection('events').add(data);

        // Update the document with the document ID as the bookmarkID
        await docRef.update({
          'eventID': docRef.id,
        });
      }
    } catch (e) {
      throw Exception('Error adding project: $e');
    }
  }

  Future<void> addSpeech(String organizerID, String organizerName,
      Map<String, dynamic> data, XFile? imageFile) async {
    DocumentReference docRef;
    try {
      if (imageFile != null) {
        String fileName =
            'speeches/$organizerID/speech_${DateTime.now().millisecondsSinceEpoch}.png';
        Reference storageRef = _storage.ref().child(fileName);
        UploadTask uploadTask = storageRef.putFile(File(imageFile.path));
        TaskSnapshot taskSnapshot = await uploadTask;

        // Get download URL
        String downloadUrl = await taskSnapshot.ref.getDownloadURL();

        data['image'] = downloadUrl;
        data['organizerID'] = organizerID;
        data['organizer'] = organizerName;

        // Create a new document in the posts collection
        docRef = await _firestore.collection('speeches').add(data);

        // Update the document with the document ID as the bookmarkID
        await docRef.update({
          'speechID': docRef.id,
        });
      }
    } catch (e) {
      throw Exception('Error adding speech: $e');
    }
  }

  Future<void> updateProject(
      Map<String, dynamic> data, XFile? imageFile) async {
    final projectID = data['projectID'];

    try {
      if (imageFile != null) {
        String fileName =
            'projects/$projectID/project_${DateTime.now().millisecondsSinceEpoch}.png';
        Reference storageRef = _storage.ref().child(fileName);
        UploadTask uploadTask = storageRef.putFile(File(imageFile.path));
        TaskSnapshot taskSnapshot = await uploadTask;

        // Get download URL
        String downloadUrl = await taskSnapshot.ref.getDownloadURL();

        data['image'] = downloadUrl;
      }

      // Create a new document in the posts collection
      await _firestore.collection('events').doc(projectID).update(data);
    } catch (e) {
      throw Exception('Error updating project: $e');
    }
  }

  Future<void> updateSpeech(Map<String, dynamic> data, XFile? imageFile) async {
    final speechID = data['speechID'];

    try {
      if (imageFile != null) {
        String fileName =
            'projects/$speechID/project_${DateTime.now().millisecondsSinceEpoch}.png';
        Reference storageRef = _storage.ref().child(fileName);
        UploadTask uploadTask = storageRef.putFile(File(imageFile.path));
        TaskSnapshot taskSnapshot = await uploadTask;

        // Get download URL
        String downloadUrl = await taskSnapshot.ref.getDownloadURL();

        data['image'] = downloadUrl;
      }

      // Create a new document in the posts collection
      await _firestore.collection('speeches').doc(speechID).update(data);
    } catch (e) {
      throw Exception('Error updating speech: $e');
    }
  }

  Future<void> deleteProject(String projectID) async {
    try {
      DocumentReference docRef =
          await _firestore.collection('events').doc(projectID);

      await docRef.update({'status': 'inactive'});
    } catch (e) {
      throw Exception('Error Deleting project: $e');
    }
  }

  Future<void> deleteSpeech(String speechID) async {
    try {
      DocumentReference docRef =
          await _firestore.collection('speeches').doc(speechID);

      await docRef.update({'status': 'inactive'});
    } catch (e) {
      throw Exception('Error Deleting Speech: $e');
    }
  }

  Future<Map<String, int>> fetchProjectsStats(String organizerID) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('events')
          .where('hostDate', isGreaterThan: Timestamp.now())
          .where('organizerID', isEqualTo: organizerID)
          .get();

      List<Project> ongoingProjects =
          snapshot.docs.map((doc) => Project.fromFirestore(doc)).toList();

      QuerySnapshot completedProjectSnapshot = await _firestore
          .collection('events')
          .where('hostDate', isLessThanOrEqualTo: Timestamp.now())
          .where('organizerID', isEqualTo: organizerID)
          .get();

      List<Project> completedProjects = completedProjectSnapshot.docs
          .map((doc) => Project.fromFirestore(doc))
          .toList();

      return {
        'ongoingProjects': ongoingProjects.length,
        'completedProjects': completedProjects.length,
      };
    } catch (e) {
      print('Error fetching ongoing projects: $e');
      throw e;
    }
  }

  Future<Map<String, int>> fetchSpeechesStats(String organizerID) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('speeches')
          .where('hostDate', isGreaterThan: Timestamp.now())
          .where('organizerID', isEqualTo: organizerID)
          .get();

      List<Project> ongoingSpeeches =
          snapshot.docs.map((doc) => Project.fromFirestore(doc)).toList();

      QuerySnapshot completedSpeechSnapshot = await _firestore
          .collection('speeches')
          .where('hostDate', isLessThanOrEqualTo: Timestamp.now())
          .where('organizerID', isEqualTo: organizerID)
          .get();

      List<Project> completedSpeeches = completedSpeechSnapshot.docs
          .map((doc) => Project.fromFirestore(doc))
          .toList();

      return {
        'ongoingSpeeches': ongoingSpeeches.length,
        'completedSpeeches': completedSpeeches.length,
      };
    } catch (e) {
      print('Error fetching Speeches Stats: $e');
      throw e;
    }
  }

  Future<int> fetchParticipationStats(String organizerID) async {
    FirebaseFirestore _firestore = FirebaseFirestore.instance;
    int participantCount = 0;

    try {
      // Step 1: Search for the given organizerID in events and speeches collections
      QuerySnapshot eventSnapshot = await _firestore
          .collection('events')
          .where('organizerID', isEqualTo: organizerID)
          .get();

      QuerySnapshot speechSnapshot = await _firestore
          .collection('speeches')
          .where('organizerID', isEqualTo: organizerID)
          .get();

      List<String> idsToCheck = [];

      if (eventSnapshot.docs.isNotEmpty) {
        idsToCheck.addAll(eventSnapshot.docs.map((doc) => doc.id).toList());
      }

      if (speechSnapshot.docs.isNotEmpty) {
        idsToCheck.addAll(speechSnapshot.docs.map((doc) => doc.id).toList());
      }

      // Step 2: Loop through the collected IDs and query the participation table
      for (String id in idsToCheck) {
        QuerySnapshot participationSnapshot = await _firestore
            .collection('participation')
            .where('activityID', isEqualTo: id)
            .get();

        participantCount += participationSnapshot.docs.length;
      }

      return participantCount;
    } catch (e) {
      print('Error finding participants: $e');
      return 0;
    }
  }
}
