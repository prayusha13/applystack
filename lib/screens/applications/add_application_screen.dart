import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../controllers/add_application_controller.dart';

class AddApplicationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AddApplicationController controller = Get.put(AddApplicationController());

    return Scaffold(
      backgroundColor: Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text('Add New Application'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: controller.companyController,
                decoration: InputDecoration(labelText: 'Company Name'),
                validator: (value) => value!.isEmpty ? 'Please enter a company name' : null,
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: controller.jobTitleController,
                decoration: InputDecoration(labelText: 'Job Title'),
                validator: (value) => value!.isEmpty ? 'Please enter a job title' : null,
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: controller.urlController,
                decoration: InputDecoration(labelText: 'Job URL (Optional)'),
                keyboardType: TextInputType.url,
              ),
              SizedBox(height: 20),
              Obx(() => DropdownButtonFormField<String>(
                value: controller.status.value,
                decoration: InputDecoration(labelText: 'Status'),
                items: ['applied', 'phone_screen', 'interview', 'offer', 'rejected']
                    .map((status) => DropdownMenuItem(
                  value: status,
                  child: Text(status.replaceAll('_', ' ').capitalize!),
                ))
                    .toList(),
                onChanged: (value) {
                  if (value != null) controller.status.value = value;
                },
              )),
              SizedBox(height: 20),
              Obx(() => ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Color(0xFFD1D5DB)),
                ),
                tileColor: Color(0xFFF9FAFB),
                title: Text("Date Applied"),
                subtitle: Text(DateFormat.yMMMd().format(controller.selectedDate.value)),
                trailing: Icon(Icons.calendar_today),
                onTap: () => controller.pickDate(context),
              )),
              SizedBox(height: 20),
              TextFormField(
                controller: controller.notesController,
                decoration: InputDecoration(labelText: 'Notes (Optional)'),
                maxLines: 4,
              ),
              SizedBox(height: 40),
              Obx(() => SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: controller.isLoading.value ? null : controller.saveApplication,
                  icon: controller.isLoading.value
                      ? Container()
                      : Icon(Icons.save_rounded, size: 20),
                  label: controller.isLoading.value
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text('Save Application'),
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }
}