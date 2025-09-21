import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../controllers/add_interview_controller.dart';
import '../../models/application_model.dart';


class AddInterviewScreen extends StatelessWidget {
  final ApplicationModel application;
  const AddInterviewScreen({Key? key, required this.application}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final AddInterviewController controller = Get.put(AddInterviewController(application));

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Schedule New Interview'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: controller.interviewerController,
                decoration: const InputDecoration(
                  labelText: 'Interviewer Name(s)',
                  prefixIcon: Icon(Icons.person_outline),
                ),
                validator: (value) => value!.isEmpty ? 'Please enter a name' : null,
              ),
              const SizedBox(height: 20),

              Obx(() => DropdownButtonFormField<String>(
                value: controller.interviewType.value,
                decoration: const InputDecoration(
                  labelText: 'Interview Type',
                  prefixIcon: Icon(Icons.work_outline_rounded),
                ),
                items: ['technical', 'phone_screen', 'hr_round', 'final_round']
                    .map((type) => DropdownMenuItem(
                  value: type,
                  child: Text(type.replaceAll('_', ' ').capitalizeFirst!),
                ))
                    .toList(),
                onChanged: (value) {
                  if (value != null) controller.interviewType.value = value;
                },
              )),
              const SizedBox(height: 20),

              Obx(() => ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(color: Color(0xFFD1D5DB)),
                ),
                tileColor: const Color(0xFFF9FAFB),
                leading: const Icon(Icons.calendar_month_outlined, color: Color(0xFF6B7280)),
                title: const Text("Date & Time", style: TextStyle(color: Color(0xFF6B7280))),
                subtitle: Text(
                  DateFormat.yMMMd().add_jm().format(controller.selectedDate.value),
                  style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF1F2937)),
                ),
                onTap: () => controller.pickDateTime(context),
              )),
              const SizedBox(height: 20),

              TextFormField(
                controller: controller.notesController,
                decoration: const InputDecoration(
                  labelText: 'Notes (Optional)',
                  alignLabelWithHint: true,
                  prefixIcon: Icon(Icons.note_alt_outlined),
                ),
                maxLines: 4,
              ),
              const SizedBox(height: 40),

              Obx(() => SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: controller.isLoading.value ? null : controller.saveInterview,
                  icon: controller.isLoading.value
                      ? const SizedBox.shrink()
                      : const Icon(Icons.save_rounded, size: 20),
                  label: controller.isLoading.value
                      ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3))
                      : const Text('Save Interview'),
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }
}