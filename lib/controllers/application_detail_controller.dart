import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/application_model.dart';
import '../services/firestore_service.dart';

class ApplicationDetailController extends GetxController {
  final FirestoreService _firestoreService = FirestoreService();
  final ApplicationModel application;

  // Constructor to receive the application we're viewing
  ApplicationDetailController(this.application);

  // Form state
  final formKey = GlobalKey<FormState>();
  late TextEditingController companyController;
  late TextEditingController jobTitleController;
  late TextEditingController notesController;

  var status = ''.obs;
  var isEditing = false.obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Initialize controllers with the application's data
    companyController = TextEditingController(text: application.companyName);
    jobTitleController = TextEditingController(text: application.jobTitle);
    notesController = TextEditingController(text: application.notes);
    status.value = application.status;
  }

  void toggleEditMode() {
    isEditing.toggle();
  }

  Future<void> saveChanges() async {
    if (formKey.currentState!.validate()) {
      try {
        isLoading.value = true;
        // Use the copyWith method from your model to create an updated version
        ApplicationModel updatedApplication = application.copyWith(
          companyName: companyController.text,
          jobTitle: jobTitleController.text,
          notes: notesController.text,
          status: status.value,
          updatedAt: DateTime.now(),
        );

        await _firestoreService.updateApplication(updatedApplication);
        isEditing.value = false; // Exit edit mode
        Get.snackbar('Success', 'Application updated.', backgroundColor: Colors.green, colorText: Colors.white);
      } catch (e) {
        Get.snackbar('Error', 'Failed to update application.');
      } finally {
        isLoading.value = false;
      }
    }
  }

  void confirmDelete() {
    Get.defaultDialog(
      title: "Delete Application",
      middleText: "Are you sure you want to delete this application? This action cannot be undone.",
      textConfirm: "Delete",
      textCancel: "Cancel",
      confirmTextColor: Colors.white,
      onConfirm: () async {
        try {
          // Close the dialog first
          Get.back();
          // Then navigate away from the detail screen as it's being deleted
          Get.back();
          await _firestoreService.deleteApplication(application.applicationId!);
          Get.snackbar('Deleted', 'The application has been removed.', backgroundColor: Colors.red, colorText: Colors.white);
        } catch (e) {
          Get.snackbar('Error', 'Failed to delete application.');
        }
      },
    );
  }
}