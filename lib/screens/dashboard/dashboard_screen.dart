import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../controllers/dashboard_controller.dart';
import '../../models/application_model.dart';
import '../../services/auth_service.dart';
import '../applications/add_application_screen.dart';
import '../applications/applications_list_screen.dart';
import '../profile/profile_screen.dart';
import 'package:applystack/screens/interviews/interviews_list_screen.dart';

class DashboardScreen extends StatelessWidget {

  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DashboardController controller = Get.put(DashboardController());
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('Dashboard', style: TextStyle(color: Color(0xFF1F2937), fontWeight: FontWeight.w600)),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'profile') {

                Get.to(() => const ProfileScreen());
              } else if (value == 'logout') {
                Get.find<AuthService>().signOut();
              }
            },
            icon: const Icon(Icons.person_outline, color: Color(0xFF6B7280)),
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(value: 'profile', child: Text('My Profile')),
              const PopupMenuItem<String>(value: 'logout', child: Text('Sign Out')),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(screenSize.width > 600 ? 32 : 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildWelcomeSection(context, controller),
              const SizedBox(height: 24),
              Obx(() {
                return _buildStatsSection(context, screenSize, controller.stats);
              }),
              const SizedBox(height: 32),
              _buildQuickActions(context, screenSize),
              const SizedBox(height: 32),
              _buildUpcomingInterviews(context, controller),
              const SizedBox(height: 32),
              _buildRecentActivity(context, controller),

            ],
          ),
        ),
      ),
    );
  }



  Widget _buildWelcomeSection(BuildContext context, DashboardController controller) {
    return Obx(() => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Welcome back, ${controller.userName.value}! 👋',
          style: Theme.of(context).textTheme.displayLarge!.copyWith(fontSize: 24, fontWeight: FontWeight.bold, color: const Color(0xFF1F2937)),
        ),
        const SizedBox(height: 4),
        const Text("Here's your job search progress", style: TextStyle(fontSize: 16, color: Color(0xFF6B7280))),
      ],
    ));
  }
  Widget _buildUpcomingInterviews(BuildContext context, DashboardController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // UPDATED: This is now a Row to include the "View All" button
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Upcoming Interviews', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xFF1F2937))),
            TextButton(
              onPressed: () => Get.to(() => const InterviewsListScreen()),
              child: const Text('View All'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Obx(() {
          if (controller.upcomingInterviews.isEmpty) {
            return const Card(
              child: Padding(
                padding: EdgeInsets.all(24.0),
                child: Center(child: Text("No upcoming interviews scheduled.")),
              ),
            );
          }
          return ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.upcomingInterviews.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final interview = controller.upcomingInterviews[index];
              return Card(
                child: ListTile(
                  leading: const Icon(Icons.event_available, color: Color(0xFF059669)),
                  title: Text(interview.companyName, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(interview.jobTitle),
                  trailing: Text(
                    DateFormat.yMMMd().add_jm().format(interview.interviewDate),
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ),
              );
            },
          );
        })
      ],
    );
  }

  Widget _buildQuickActions(BuildContext context, Size screenSize) {
    // This is the correct, consistent action for the "Schedule Interview" button.
    final VoidCallback scheduleInterviewAction = () {
      Get.to(() => const ApplicationsListScreen());
      Get.snackbar(
        "Select an Application",
        "Choose an application to schedule an interview for.",
      );
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Quick Actions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xFF1F2937))),
        const SizedBox(height: 16),
        screenSize.width > 600
            ? Row(children: [
          Expanded(child: _buildActionButton('Add New Application', Icons.add_circle_outline, const Color(0xFF2563EB), () => Get.to(() => AddApplicationScreen()))),
          const SizedBox(width: 16),
          // UPDATED: Now uses the consistent action
          Expanded(child: _buildActionButton('Schedule Interview', Icons.event_outlined, const Color(0xFF059669), scheduleInterviewAction)),
          const SizedBox(width: 16),
          Expanded(child: _buildActionButton('View All Applications', Icons.list_alt, const Color(0xFF7C3AED), () => Get.to(() => const ApplicationsListScreen()))),
        ])
            : Column(children: [
          _buildActionButton('Add New Application', Icons.add_circle_outline, const Color(0xFF2563EB), () => Get.to(() => AddApplicationScreen())),
          const SizedBox(height: 12),
          // This one was already correct
          _buildActionButton('Schedule Interview', Icons.event_outlined, const Color(0xFF059669), scheduleInterviewAction),
          const SizedBox(height: 12), // FIXED: Added missing space
          _buildActionButton('View All Applications', Icons.list_alt, const Color(0xFF7C3AED), () => Get.to(() => const ApplicationsListScreen())),
        ]),
      ],
    );
  }

  Widget _buildRecentActivity(BuildContext context, DashboardController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Recent Activity', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xFF1F2937))),
            TextButton(
              onPressed: () => Get.to(() => ApplicationsListScreen()),
              child: const Text('View All', style: TextStyle(color: Color(0xFF2563EB), fontWeight: FontWeight.w500)),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Obx(() {
          if (controller.recentApplications.isEmpty) {
            return _buildEmptyState();
          }
          final applications = controller.recentApplications.take(4).toList();
          return Container(
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFE5E7EB))),
            child: Column(
              children: applications.asMap().entries.map((entry) {
                final index = entry.key;
                final app = entry.value;
                return Column(children: [
                  _buildActivityItem(
                    'Applied to ${app.companyName}',
                    app.jobTitle,
                    _formatDate(app.dateApplied),
                    _getStatusIcon(app.status),
                    _getStatusColor(app.status),
                  ),
                  if (index < applications.length - 1) const Divider(height: 1, color: Color(0xFFE5E7EB)),
                ]);
              }).toList(),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildStatsSection(BuildContext context, Size screenSize, Map<String, int> stats) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Your Progress', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xFF1F2937))),
        const SizedBox(height: 16),
        screenSize.width > 600
            ? Row(children: [
          Expanded(child: _buildStatCard('Total Applications', '${stats['total'] ?? 0}', Icons.work_outline, const Color(0xFF2563EB))),
          const SizedBox(width: 16),
          Expanded(child: _buildStatCard('Interviews', '${stats['interview'] ?? 0}', Icons.calendar_today, const Color(0xFF059669))),
          const SizedBox(width: 16),
          Expanded(child: _buildStatCard('Offers', '${stats['offer'] ?? 0}', Icons.star_outline, const Color(0xFFD97706))),
          const SizedBox(width: 16),
          Expanded(child: _buildStatCard('Phone Screens', '${stats['phone_screen'] ?? 0}', Icons.phone, const Color(0xFF7C3AED))),
        ])
            : Column(children: [
          Row(children: [
            Expanded(child: _buildStatCard('Applications', '${stats['total'] ?? 0}', Icons.work_outline, const Color(0xFF2563EB))),
            const SizedBox(width: 12),
            Expanded(child: _buildStatCard('Interviews', '${stats['interview'] ?? 0}', Icons.calendar_today, const Color(0xFF059669))),
          ]),
          const SizedBox(height: 12),
          Row(children: [
            Expanded(child: _buildStatCard('Offers', '${stats['offer'] ?? 0}', Icons.star_outline, const Color(0xFFD97706))),
            const SizedBox(width: 12),
            Expanded(child: _buildStatCard('Phone Screens', '${stats['phone_screen'] ?? 0}', Icons.phone, const Color(0xFF7C3AED))),
          ]),
        ]),
      ],
    );
  }

  Widget _buildLoadingStats(Size screenSize) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Your Progress', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xFF1F2937))),
        const SizedBox(height: 16),
        Container(
          height: 100,
          child: const Center(child: CircularProgressIndicator(color: Color(0xFF2563EB))),
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(color: const Color(0xFF000000).withOpacity(0.02), offset: const Offset(0, 1), blurRadius: 3),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: color, size: 24),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
                child: Icon(Icons.arrow_upward, color: color, size: 12),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF1F2937))),
          const SizedBox(height: 4),
          Text(title, style: const TextStyle(fontSize: 14, color: Color(0xFF6B7280))),
        ],
      ),
    );
  }

  Widget _buildActionButton(String title, IconData icon, Color color, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        minimumSize: const Size(double.infinity, 60), // Ensures a consistent, large tap target
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 8),
          Text(title),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFE5E7EB))),
      child: Center(
        child: Column(
          children: [
            const Icon(Icons.work_outline, size: 48, color: Color(0xFF6B7280)),
            const SizedBox(height: 16),
            const Text('No applications yet', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xFF1F2937))),
            const SizedBox(height: 8),
            const Text('Start by adding your first job application!', style: TextStyle(fontSize: 14, color: Color(0xFF6B7280)), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityItem(String title, String subtitle, String time, IconData icon, Color iconColor) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: iconColor.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
            child: Icon(icon, color: iconColor, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF1F2937))),
                const SizedBox(height: 2),
                Text(subtitle, style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280))),
              ],
            ),
          ),
          Text(time, style: const TextStyle(fontSize: 12, color: Color(0xFF9CA3AF))),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date).inDays;

    if (difference == 0) return 'Today';
    if (difference == 1) return 'Yesterday';
    return '$difference days ago';
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'applied': return Icons.send_outlined;
      case 'phone_screen': return Icons.phone_outlined;
      case 'interview': return Icons.event_outlined;
      case 'offer': return Icons.star_outline;
      case 'rejected': return Icons.close_outlined;
      default: return Icons.work_outline;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'applied': return const Color(0xFF2563EB);
      case 'phone_screen': return const Color(0xFF7C3AED);
      case 'interview': return const Color(0xFF059669);
      case 'offer': return const Color(0xFFD97706);
      case 'rejected': return const Color(0xFFDC2626);
      default: return const Color(0xFF6B7280);
    }
  }
}