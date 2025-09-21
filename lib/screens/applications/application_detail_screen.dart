import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../controllers/application_detail_controller.dart';
import '../../models/application_model.dart';
import '../interviews/add_interview_screen.dart';
import 'widgets/status_tag.dart';

class ApplicationDetailScreen extends StatelessWidget {
  final ApplicationModel application;
  const ApplicationDetailScreen({Key? key, required this.application}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Pass the application to the controller upon creation
    final ApplicationDetailController controller = Get.put(ApplicationDetailController(application));

    return Obx(() => Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(controller.isEditing.value ? 'Edit Application' : 'Application Details'),
        actions: [
          // Toggle between "Edit" and "Cancel" buttons
          TextButton(
            onPressed: controller.toggleEditMode,
            child: Text(controller.isEditing.value ? 'Cancel' : 'Edit'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoRow(
                label: 'Company',
                value: application.companyName,
                isEditing: controller.isEditing.value,
                controller: controller.companyController,
              ),
              _buildInfoRow(
                label: 'Job Title',
                value: application.jobTitle,
                isEditing: controller.isEditing.value,
                controller: controller.jobTitleController,
              ),
              _buildStatusRow(controller),
              _buildInfoRow(
                label: 'Date Applied',
                value: DateFormat.yMMMd().format(application.dateApplied),
              ),
              _buildInfoRow(
                label: 'Notes',
                value: application.notes,
                isEditing: controller.isEditing.value,
                controller: controller.notesController,
                maxLines: 4,
              ),
              const SizedBox(height: 32),
              // Conditionally show Save/Delete buttons

              if (controller.isEditing.value)
                _buildSaveChangesButton(controller)
              else
                Column(
                  children: [
                    _buildScheduleInterviewButton(context, application),
                    const SizedBox(height: 12),
                    _buildDeleteButton(controller),
                  ],
                ),
            ],
          ),
        ),
      ),
    ));
  }

  // Helper widget to display either Text or TextFormField
  Widget _buildInfoRow({
    required String label,
    required String value,
    bool isEditing = false,
    TextEditingController? controller,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 14)),
          const SizedBox(height: 8),
          if (isEditing && controller != null)
            TextFormField(
              controller: controller,
              maxLines: maxLines,
              decoration: const InputDecoration(border: OutlineInputBorder()),
              validator: (val) => val!.isEmpty ? 'This field cannot be empty' : null,
            )
          else
            Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildStatusRow(ApplicationDetailController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Status', style: TextStyle(color: Colors.grey, fontSize: 14)),
          const SizedBox(height: 8),
          if (controller.isEditing.value)
            DropdownButtonFormField<String>(
              value: controller.status.value,
              decoration: const InputDecoration(border: OutlineInputBorder()),
              items: ['applied', 'phone_screen', 'interview', 'offer', 'rejected']
                  .map((status) => DropdownMenuItem(
                value: status,
                child: Text(status.replaceAll('_', ' ').capitalize!),
              ))
                  .toList(),
              onChanged: (value) {
                if (value != null) controller.status.value = value;
              },
            )
          else
            Align(alignment: Alignment.centerLeft, child: StatusTag(status: controller.status.value)),
        ],
      ),
    );
  }

  Widget _buildSaveChangesButton(ApplicationDetailController controller) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton.icon(
        onPressed: controller.isLoading.value ? null : controller.saveChanges,
        icon: controller.isLoading.value
            ? const SizedBox.shrink()
            : const Icon(Icons.save_rounded, size: 20),
        label: controller.isLoading.value
            ? const CircularProgressIndicator(color: Colors.white)
            : const Text('Save Changes'),
      ),
    );
  }

  Widget _buildDeleteButton(ApplicationDetailController controller) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: OutlinedButton.icon(
        onPressed: controller.confirmDelete,
        style: OutlinedButton.styleFrom(foregroundColor: Colors.red, side: const BorderSide(color: Colors.red)),
        icon: const Icon(Icons.delete_outline_rounded),
        label: const Text('Delete Application'),
      ),
    );
  }
}
Widget _buildScheduleInterviewButton(BuildContext context, ApplicationModel application) {
  return SizedBox(
    width: double.infinity,
    height: 50,
    child: ElevatedButton.icon(
      onPressed: () {
        Get.to(() => AddInterviewScreen(application: application));
        },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF059669), // Green color for a positive action
        foregroundColor: Colors.white,
      ),
      icon: const Icon(Icons.calendar_month_outlined, size: 20),
      label: const Text('Schedule Interview'),
    ),
  );
}