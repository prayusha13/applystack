import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/application_controller.dart';
import 'widgets/application_card.dart';

class ApplicationsListScreen extends StatelessWidget {
  const ApplicationsListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ApplicationController controller = Get.put(ApplicationController());
    final List<String> filterOptions = ['All', 'Applied', 'Interview', 'Offer', 'Rejected'];

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(title: const Text('All Applications')),
      body: Column(
        children: [
          // Search and Filter Section
          Container(
            padding: const EdgeInsets.all(16.0),
            color: Colors.white,
            child: Column(
              children: [
                TextField(
                  controller: controller.searchController,
                  decoration: const InputDecoration(
                    hintText: 'Search by company or title...',
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 40,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: filterOptions.length,
                    separatorBuilder: (context, index) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final status = filterOptions[index];
                      return Obx(() {
                        final isSelected = controller.selectedStatus.value == status;
                        return ChoiceChip(
                          label: Text(status),
                          selected: isSelected,
                          onSelected: (_) => controller.changeStatusFilter(status),
                          backgroundColor: Colors.white,
                          selectedColor: const Color(0xFF2563EB).withOpacity(0.15),
                          labelStyle: TextStyle(
                            color: isSelected ? const Color(0xFF1E40AF) : const Color(0xFF374151),
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                          shape: const StadiumBorder(side: BorderSide(color: Color(0xFFD1D5DB))),
                        );
                      });
                    },
                  ),
                ),
              ],
            ),
          ),

          // The List of Applications
          Expanded(
            child: Obx(() {
              if (controller.filteredApplications.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.search_off_rounded, size: 64, color: Color(0xFF9CA3AF)),
                      const SizedBox(height: 16),
                      Text('No Applications Found', style: Theme.of(context).textTheme.headlineSmall),
                      const SizedBox(height: 8),
                      const Text('Try adjusting your filter or search query.', style: TextStyle(color: Color(0xFF6B7280))),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 16.0),
                itemCount: controller.filteredApplications.length,
                itemBuilder: (context, index) {
                  final application = controller.filteredApplications[index];
                  return ApplicationCard(application: application);
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}