import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../models/interview_model.dart';
import '../../applications/widgets/status_tag.dart'; // We can reuse this!

class InterviewCard extends StatelessWidget {
  final InterviewModel interview;
  const InterviewCard({Key? key, required this.interview}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    interview.companyName,
                    style: Theme.of(context).textTheme.titleLarge,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                StatusTag(status: interview.interviewType),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              interview.jobTitle,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.8),
              ),
            ),
            const Divider(height: 24),
            Row(
              children: [
                Icon(Icons.calendar_month_outlined, size: 16, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  DateFormat.yMMMd().add_jm().format(interview.interviewDate),
                  style: TextStyle(fontWeight: FontWeight.w500, color: Theme.of(context).colorScheme.primary),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}