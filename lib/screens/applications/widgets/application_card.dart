import 'package:applystack/screens/applications/application_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../models/application_model.dart';
import 'status_tag.dart';

class ApplicationCard extends StatelessWidget {
  final ApplicationModel application;
  const ApplicationCard({Key? key, required this.application}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: InkWell(
        onTap: () {
          // Navigate to the detail screen, passing the specific application object
          Get.to(() => ApplicationDetailScreen(application: application));
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      application.companyName,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1F2937)),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 16),
                  StatusTag(status: application.status),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                application.jobTitle,
                style: const TextStyle(fontSize: 15, color: Color(0xFF6B7280), fontWeight: FontWeight.w500),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Icon(Icons.calendar_today, size: 14, color: Color(0xFF9CA3AF)),
                  const SizedBox(width: 6),
                  Text(
                    'Applied on ${DateFormat.yMMMd().format(application.dateApplied)}',
                    style: const TextStyle(fontSize: 13, color: Color(0xFF9CA3AF)),
                  ),
                  const Spacer(),
                  const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Color(0xFF9CA3AF)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}