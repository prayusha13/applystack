import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/interview_model.dart';
import '../models/user_model.dart';
import '../models/application_model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? get currentUserId => _auth.currentUser?.uid;

  // User operations
  Future<void> createUser(UserModel user) async {
    try {
      await _firestore.collection('users').doc(user.userId).set(user.toFirestore());
      print('✅ User created: ${user.userId}');
    } catch (e) {
      print('❌ Error creating user: $e');
      rethrow;
    }
  }

  Future<UserModel?> getUser(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      if (doc.exists && doc.data() != null) {
        return UserModel.fromFirestore(doc.data()!, doc.id);
      }
      return null;
    } catch (e) {
      print('❌ Error getting user: $e');
      return null;
    }
  }

  // Application operations
  Future<String> addApplication(ApplicationModel application) async {
    try {
      final docRef = await _firestore.collection('applications').add(application.toFirestore());
      print('✅ Application added: ${docRef.id}');
      return docRef.id;
    } catch (e) {
      print('❌ Error adding application: $e');
      rethrow;
    }
  }

  Future<List<ApplicationModel>> getUserApplications() async {
    if (currentUserId == null) return [];

    try {
      final query = await _firestore
          .collection('applications')
          .where('userId', isEqualTo: currentUserId)
          .orderBy('dateApplied', descending: true)
          .get();

      return query.docs.map((doc) =>
          ApplicationModel.fromFirestore(doc.data(), doc.id)).toList();
    } catch (e) {
      print('❌ Error getting applications: $e');
      return [];
    }
  }
  // Update an existing application
  Future<void> updateApplication(ApplicationModel application) async {
    // We need the application's document ID to update it
    if (application.applicationId == null) return;
    try {
      await _firestore
          .collection('applications')
          .doc(application.applicationId)
          .update(application.toFirestore());
      print('✅ Application updated: ${application.applicationId}');
    } catch (e) {
      print('❌ Error updating application: $e');
      rethrow;
    }
  }
  // Delete an application
  Future<void> deleteApplication(String applicationId) async {
    try {
      await _firestore.collection('applications').doc(applicationId).delete();
      print('✅ Application deleted: $applicationId');
    } catch (e) {
      print('❌ Error deleting application: $e');
      rethrow;
    }
  }
  // Add a new interview
  Future<void> addInterview(InterviewModel interview) async {
    try {
      await _firestore.collection('interviews').add(interview.toFirestore());
      print('✅ Interview added');
    } catch (e) {
      print('❌ Error adding interview: $e');
      rethrow;
    }
  }
  // Get a stream of all interviews for a specific application
  Stream<List<InterviewModel>> getInterviewsForApplicationStream(String applicationId) {
    return _firestore
        .collection('interviews')
        .where('applicationId', isEqualTo: applicationId)
        .orderBy('interviewDate', descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => InterviewModel.fromFirestore(doc))
        .toList());
  }
  // Get a stream of upcoming interviews for the current user
  Stream<List<InterviewModel>> getUpcomingInterviewsStream() {
    if (currentUserId == null) return Stream.value([]);
    return _firestore
        .collection('interviews')
        .where('userId', isEqualTo: currentUserId)
        .where('interviewDate', isGreaterThanOrEqualTo: Timestamp.now())
        .orderBy('interviewDate', descending: false)
        .snapshots()
        .map((snapshot) =>
        snapshot.docs.map((doc) => InterviewModel.fromFirestore(doc)).toList());
  }
  Stream<List<InterviewModel>> getAllInterviewsStream() {
    if (currentUserId == null) return Stream.value([]);
    return _firestore
        .collection('interviews')
        .where('userId', isEqualTo: currentUserId)
        .orderBy('interviewDate', descending: true) // Show most recent first
        .snapshots()
        .map((snapshot) =>
        snapshot.docs.map((doc) => InterviewModel.fromFirestore(doc)).toList());
  }

  Stream<List<ApplicationModel>> getUserApplicationsStream() {
    if (currentUserId == null) return Stream.value([]);

    return _firestore
        .collection('applications')
        .where('userId', isEqualTo: currentUserId)
        .orderBy('dateApplied', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) =>
        ApplicationModel.fromFirestore(doc.data(), doc.id)).toList());
  }
  Stream<Map<String, int>> getApplicationStatsStream() {
    // We listen to the stream of applications that we already have
    return getUserApplicationsStream().map((applications) {
      // For each new list of applications, we re-calculate the totals
      Map<String, int> stats = {
        'total': applications.length,
        'applied': 0,
        'phone_screen': 0,
        'interview': 0,
        'offer': 0,
        'rejected': 0,
      };



      for (var app in applications) {
        // Increment the count for the status of each application
        stats[app.status] = (stats[app.status] ?? 0) + 1;
      }
      return stats;
    });
  }

  Future<Map<String, int>> getApplicationStats() async {
    if (currentUserId == null) return {};

    try {
      final query = await _firestore
          .collection('applications')
          .where('userId', isEqualTo: currentUserId)
          .get();

      Map<String, int> stats = {
        'total': query.docs.length,
        'applied': 0,
        'phone_screen': 0,
        'interview': 0,
        'offer': 0,
        'rejected': 0,
      };

      for (var doc in query.docs) {
        String status = doc.data()['status'] ?? 'applied';
        stats[status] = (stats[status] ?? 0) + 1;
      }

      return stats;
    } catch (e) {
      print('❌ Error getting stats: $e');
      return {};
    }
  }
}
