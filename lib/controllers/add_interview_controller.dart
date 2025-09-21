import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/interview_model.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';
import '../models/application_model.dart';

class AddInterviewController extends GetxController {
  final ApplicationModel application;
  AddInterviewController(this.application);


  final FirestoreService _firestoreService = FirestoreService();
  final AuthService _authService = Get.find<AuthService>();

  final formKey = GlobalKey<FormState>();
  final interviewerController = TextEditingController();
  final notesController = TextEditingController();

  var interviewType = 'technical'.obs;
  var selectedDate = DateTime.now().obs;
  var isLoading = false.obs;

  Future<void> saveInterview() async {
    if (formKey.currentState!.validate()) {
      try {
        isLoading.value = true;
        final userId = _authService.currentUser.value?.uid;
        if (userId == null) throw Exception("User not logged in");

        final newInterview = InterviewModel(
          applicationId: application.applicationId!,
          userId: userId,
          interviewDate: selectedDate.value,
          interviewType: interviewType.value,
          notes: notesController.text,
          interviewerName: interviewerController.text,
          companyName: application.companyName,
          jobTitle: application.jobTitle,
        );

        await _firestoreService.addInterview(newInterview);
        if (application.status != 'offer') {
          // Create a new instance with the updated status and timestamp
          final updatedApplication = application.copyWith(
            status: 'interview',
            updatedAt: DateTime.now(),
          );
          // Save the new, updated version to Firestore
          await _firestoreService.updateApplication(updatedApplication);
        }
        Get.back(); // Go back to the detail screen
        Get.snackbar(
            'Success!', 'Interview has been scheduled.',
            backgroundColor: Colors.green, colorText: Colors.white
        );
      } catch (e) {
        Get.snackbar('Error', 'Could not schedule interview.');
      } finally {
        isLoading.value = false;
      }
    }
  }

  // Function to pick both date and time
  Future<void> pickDateTime(BuildContext context) async {
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: selectedDate.value,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (date == null) return; // User cancelled date picker

    final TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(selectedDate.value),
    );

    if (time == null) return; // User cancelled time picker

    selectedDate.value = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );
  }
}