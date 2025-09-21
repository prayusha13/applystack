import 'package:cloud_firestore/cloud_firestore.dart';

class ApplicationModel {
  final String? applicationId;
  final String userId;
  final String companyName;
  final String jobTitle;
  final String? jobUrl;
  final DateTime dateApplied;
  final String status;
  final String notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  ApplicationModel({
    this.applicationId,
    required this.userId,
    required this.companyName,
    required this.jobTitle,
    this.jobUrl,
    required this.dateApplied,
    required this.status,
    required this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ApplicationModel.fromFirestore(Map<String, dynamic> data, String id) {
    return ApplicationModel(
      applicationId: id,
      userId: data['userId'] ?? '',
      companyName: data['companyName'] ?? '',
      jobTitle: data['jobTitle'] ?? '',
      jobUrl: data['jobUrl'],
      dateApplied: (data['dateApplied'] as Timestamp).toDate(),
      status: data['status'] ?? 'applied',
      notes: data['notes'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'companyName': companyName,
      'jobTitle': jobTitle,
      'jobUrl': jobUrl,
      'dateApplied': Timestamp.fromDate(dateApplied),
      'status': status,
      'notes': notes,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  // Copy with method for updates
  ApplicationModel copyWith({
    String? applicationId,
    String? userId,
    String? companyName,
    String? jobTitle,
    String? jobUrl,
    DateTime? dateApplied,
    String? status,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ApplicationModel(
      applicationId: applicationId ?? this.applicationId,
      userId: userId ?? this.userId,
      companyName: companyName ?? this.companyName,
      jobTitle: jobTitle ?? this.jobTitle,
      jobUrl: jobUrl ?? this.jobUrl,
      dateApplied: dateApplied ?? this.dateApplied,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
