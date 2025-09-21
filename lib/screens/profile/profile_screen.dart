import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/profile_controller.dart';

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
          children: [
            Obx(() {
              if (controller.user.value == null) {
                return const Center(child: CircularProgressIndicator());
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
            const Divider(height: 40),
            const Text(
              'Settings',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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