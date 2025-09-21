import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String userId;
  final String name;
  final String email;
  final int age;
  final String status;
  final DateTime createdAt;
  final bool profileCompleted;

  UserModel({
    required this.userId,
    required this.name,
    required this.email,
    required this.age,
    required this.status,
    required this.createdAt,
    required this.profileCompleted,
  });

  // Convert from Firestore document
  factory UserModel.fromFirestore(Map<String, dynamic> data, String id) {
    return UserModel(
      userId: id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      age: data['age'] ?? 0,
      status: data['status'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      profileCompleted: data['profileCompleted'] ?? false,
    );
  }

  // Convert to Firestore document
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'email': email,
      'age': age,
      'status': status,
      'createdAt': Timestamp.fromDate(createdAt),
      'profileCompleted': profileCompleted,
    };
  }
}
