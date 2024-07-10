// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:impactify_app/models/event.dart';
// import 'package:impactify_app/models/speech.dart';


// class SpeechRepository {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   Future<List<Speech>> getAllSpeeches() async {
//     try {
//       QuerySnapshot snapshot = await _firestore.collection('speeches').get();
//       List<Speech> speeches = snapshot.docs.map((doc) {
//         return Speech.fromFirestore(doc);
//       }).toList();
//       return speeches;
//     } catch (e) {
//       print('Error fetching events: $e');
//       throw e;
//     }

//   }
  
//   Future<Speech> getSpeechById(String speechID) async {
//     try {
//       DocumentSnapshot doc = await _firestore.collection('speeches').doc(speechID).get();
      
//       if (doc.exists) {
//         return Speech.fromFirestore(doc);
//       } else {
//         throw Exception('Speech not found');
//       }

//     } catch (e) {
//       print('Error fetching Speech: $e');
//       throw e;
//     }
//   }
// }