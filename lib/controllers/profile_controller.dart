import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';

class ProfileController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();
  final FirestoreService _firestoreService = FirestoreService();
  final GetStorage _box = GetStorage();

  var user = Rx<UserModel?>(null);
  var isDarkMode = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadUserData();
    // Load the saved theme setting, default to false (light mode)
    isDarkMode.value = _box.read('isDarkMode') ?? false;
  }

  Future<void> _loadUserData() async {
    final firebaseUser = _authService.currentUser.value;
    if (firebaseUser != null) {
      user.value = await _firestoreService.getUser(firebaseUser.uid);
    }
  }

  void changeTheme(bool isDark) {
    Get.changeThemeMode(isDark ? ThemeMode.dark : ThemeMode.light);
    // Save the user's choice to storage
    _box.write('isDarkMode', isDark);
    isDarkMode.value = isDark;
  }

  void signOut() {
    _authService.signOut();
  }
}