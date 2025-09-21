import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/application_model.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';

class AddApplicationController extends GetxController {
  final FirestoreService _firestoreService = FirestoreService();
  final AuthService _authService = Get.find<AuthService>();

  final formKey = GlobalKey<FormState>();
  final companyController = TextEditingController();
  final jobTitleController = TextEditingController();
  final urlController = TextEditingController();
  final notesController = TextEditingController();

  var status = 'applied'.obs;
  var selectedDate = DateTime.now().obs;
  var isLoading = false.obs;

  Future<void> saveApplication() async {
    if (formKey.currentState!.validate()) {
      try {
        isLoading.value = true;
        final userId = _authService.currentUser.value?.uid;
        if (userId == null) throw Exception("User not logged in");

        final newApplication = ApplicationModel(
          userId: userId,
          companyName: companyController.text,
          jobTitle: jobTitleController.text,
          jobUrl: urlController.text,
          dateApplied: selectedDate.value,
          status: status.value,
          notes: notesController.text,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        await _firestoreService.addApplication(newApplication);

        Get.back(); // Go back to the dashboard
        Get.snackbar(
            'Success!', 'Application for ${newApplication.companyName} saved.',
            backgroundColor: Colors.green, colorText: Colors.white
        );
      } catch (e) {
        Get.snackbar('Error', 'Could not save application.');
      } finally {
        isLoading.value = false;
      }
    }
  }

  void pickDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate.value,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) selectedDate.value = picked;
  }
}