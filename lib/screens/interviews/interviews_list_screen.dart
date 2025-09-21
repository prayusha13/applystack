import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/interview_controller.dart';
import 'widgets/interview_card.dart';

class InterviewsListScreen extends StatelessWidget {
  const InterviewsListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final InterviewController controller = Get.put(InterviewController());

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('All Interviews'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Upcoming'),
              Tab(text: 'Past'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildInterviewList(controller.upcomingInterviews, "No upcoming interviews."),
            _buildInterviewList(controller.pastInterviews, "No past interviews found."),
          ],
        ),
      ),
    );
  }

  Widget _buildInterviewList(RxList<dynamic> interviews, String emptyMessage) {
    return Obx(() {
      if (interviews.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.event_busy, size: 64, color: Colors.grey),
              const SizedBox(height: 16),
              Text(emptyMessage, style: Get.textTheme.headlineSmall),
            ],
          ),
        );
      }
      return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: interviews.length,
        itemBuilder: (context, index) {
          return InterviewCard(interview: interviews[index]);
        },
      );
    });
  }
}