import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:impactify_management/models/organizer.dart';

class UserRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  

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


}