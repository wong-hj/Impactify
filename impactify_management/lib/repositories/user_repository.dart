import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:impactify_management/models/organizer.dart';

class UserRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  

  Future<Organizer?> fetchOrganizer(String organizerID) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('organizers').doc(organizerID).get();

      Organizer organizer = Organizer.fromFirestore(doc);

      return organizer;
    } catch (e) {
      print('Error fetching organizer: $e');
      throw e;
    }
  }

  // Fetch user data from Firestore
  Future<void> updateUserData(String uid, Map<String, dynamic> data, XFile? imageFile, XFile? ssmPdfFile) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
    
    if (user == null) {
      throw Exception('No user is currently signed in.');
    }

    // Check if email has changed
    if (data.containsKey('email') && data['email'] != user.email) {
      await user.verifyBeforeUpdateEmail(data['email']);
    }

    if (imageFile != null) {
      String fileName = 'organizers/$uid/profile_${DateTime.now().millisecondsSinceEpoch}.png';
      Reference storageRef = _storage.ref().child(fileName);
      UploadTask uploadTask = storageRef.putFile(File(imageFile.path));
      TaskSnapshot taskSnapshot = await uploadTask;

      // Get download URL
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();

      // Update the data map with the image URL
      data['profileImage'] = downloadUrl;
    }
    String? ssmUrl;
    if (ssmPdfFile != null) {
          try {
            String fileName =
                'ssm/${user.uid}_${DateTime.now().millisecondsSinceEpoch}.pdf';
            Reference storageRef =
                FirebaseStorage.instance.ref().child(fileName);
            UploadTask uploadTask = storageRef.putFile(File(ssmPdfFile.path));
            TaskSnapshot taskSnapshot = await uploadTask;
            ssmUrl = await taskSnapshot.ref.getDownloadURL();
            data['ssmURL'] = ssmUrl;
          } catch (e) {
            print('Error uploading SSM PDF: $e');
          }
        }
      await _firestore.collection('organizers').doc(uid).update(data);
    } catch (e) {
      print('Error updating user data: $e');
      throw e;
    }
  }
  


}