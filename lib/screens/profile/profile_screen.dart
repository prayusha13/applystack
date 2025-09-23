import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/profile_controller.dart';
import '../statistics/statistics_screen.dart';
import '../more/faq_screen.dart';
import '../more/about_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ProfileController controller = Get.put(ProfileController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile & Settings'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Align titles to the left
          children: [
            Center( // Keep profile info centered
              child: Obx(() {
                if (controller.user.value == null) {
                  return const SizedBox(height: 150, child: Center(child: CircularProgressIndicator()));
                }
                return Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                      child: Text(
                        controller.user.value!.name.isNotEmpty ? controller.user.value!.name[0].toUpperCase() : 'U',
                        style: const TextStyle(fontSize: 40),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      controller.user.value!.name,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      controller.user.value!.email,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                );
              }),
            ),
            const Divider(height: 40),

            // --- SETTINGS SECTION ---
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                'Settings',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 10),
            Obx(() => ListTile(
              title: const Text('Dark Mode'),
              leading: const Icon(Icons.brightness_6_outlined),
              trailing: Switch(
                value: controller.isDarkMode.value,
                onChanged: (value) => controller.changeTheme(value),
              ),
            )),
            const Divider(),

            // --- MORE SECTION (NEW) ---
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
              child: Text(
                'More',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey),
              ),
            ),
            ListTile(
              title: const Text('Application Statistics'),
              leading: const Icon(Icons.pie_chart_outline_rounded),
              trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
              onTap: () => Get.to(() => const StatisticsScreen()),
            ),
            ListTile(
              title: const Text('Help & FAQ'),
              leading: const Icon(Icons.help_outline_rounded),
              trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
              onTap: () => Get.to(() => const FaqScreen()),
            ),
            ListTile(
              title: const Text('About'),
              leading: const Icon(Icons.info_outline_rounded),
              trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
              onTap: () => Get.to(() => const AboutScreen()),
            ),
            const Divider(),

            // --- SIGN OUT BUTTON ---
            ListTile(
              title: const Text('Sign Out', style: TextStyle(color: Colors.red)),
              leading: const Icon(Icons.logout, color: Colors.red),
              onTap: () => controller.signOut(),
            ),
          ],
        ),
      ),
    );
  }
}