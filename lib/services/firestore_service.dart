import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  static final FirestoreService _instance =
      FirestoreService._internal(); // Singleton instance

  factory FirestoreService() {
    // Factory constructor for access
    return _instance;
  }
  FirestoreService._internal();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Function to submit feedback to Firestore
  Future<void> submitFeedback(
      String feedbackType, String feedbackOption) async {
    await _firestore.collection('feedbackFromUser').add({
      'feedbackType': feedbackType, // "thumbs_up" or "thumbs_down"
      'feedbackOption': feedbackOption,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }
}
