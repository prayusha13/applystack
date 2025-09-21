import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../screens/dashboard/dashboard_screen.dart';
import '../models/user_model.dart';
import 'firestore_service.dart';

class AuthService extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirestoreService _firestoreService = FirestoreService();

  final RxBool isLoading = false.obs;
  final RxBool hidePassword = true.obs;
  final RxString selectedStatus = 'Student'.obs;
  final Rx<User?> currentUser = Rx<User?>(null);

  @override
  void onReady() {
    super.onReady();
    currentUser.bindStream(_auth.authStateChanges());
    ever(currentUser, _setInitialScreen);
  }
  _setInitialScreen(User? user) {
    // A slight delay to allow the app to build the first frame.
    Future.delayed(Duration(seconds: 1), () {
      if (user == null) {
        Get.offAllNamed('/welcome'); // Or your login screen
      } else {
        Get.offAllNamed('/dashboard');
      }
    });
  }

  Future<void> signInWithEmail(String email, String password) async {
    try {
      isLoading.value = true;
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );



    } on FirebaseAuthException catch (e) {
      String message = 'Login failed';
      if (e.code == 'user-not-found') {
        message = 'No account found with this email';
      } else if (e.code == 'wrong-password') {
        message = 'Incorrect password';
      }

      Get.snackbar('Error', message,
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createAccount({
    required String name,
    required String email,
    required String password,
    required int age,
    required String status,
  }) async {
    try {
      isLoading.value = true;

      // Create Firebase user
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Create user document in Firestore
      final user = UserModel(
        userId: userCredential.user!.uid,
        name: name,
        email: email,
        age: age,
        status: status,
        createdAt: DateTime.now(),
        profileCompleted: true,
      );

      await _firestoreService.createUser(user);


    } on FirebaseAuthException catch (e) {
      String message = 'Registration failed';
      if (e.code == 'weak-password') {
        message = 'Password is too weak';
      } else if (e.code == 'email-already-in-use') {
        message = 'Email already registered';
      }

      Get.snackbar('Error', message,
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
