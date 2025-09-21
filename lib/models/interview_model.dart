import 'package:cloud_firestore/cloud_firestore.dart';

class InterviewModel {
  final String? interviewId;
  final String applicationId; // Links back to the ApplicationModel
  final String userId;
  final DateTime interviewDate;
  final String interviewType; // e.g., "Phone Screen", "Technical", "HR"
  final String notes;
  final String interviewerName;// Name of the person interviewing
  final String companyName;
  final String jobTitle;

  InterviewModel({
    this.interviewId,
    required this.applicationId,
    required this.userId,
    required this.interviewDate,
    required this.interviewType,
    required this.notes,
    required this.interviewerName,
    required this.companyName,
    required this.jobTitle,
  });

  // From a Firestore document to our InterviewModel object
  factory InterviewModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return InterviewModel(
      interviewId: doc.id,
      applicationId: data['applicationId'] ?? '',
      userId: data['userId'] ?? '',
      interviewDate: (data['interviewDate'] as Timestamp).toDate(),
      interviewType: data['interviewType'] ?? '',
      notes: data['notes'] ?? '',
      interviewerName: data['interviewerName'] ?? '',
      companyName: data['companyName'] ?? '',
      jobTitle: data['jobTitle'] ?? '',
    );
  }

  // From our InterviewModel object to a Map for Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'applicationId': applicationId,
      'userId': userId,
      'interviewDate': Timestamp.fromDate(interviewDate),
      'interviewType': interviewType,
      'notes': notes,
      'interviewerName': interviewerName,
      'companyName': companyName,
      'jobTitle': jobTitle,
    };
  }
}