import 'package:flutter/material.dart';

class FaqScreen extends StatelessWidget {
  const FaqScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help & FAQ'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: const [
          ExpansionTile(
            title: Text("How do I update an application's status?"),
            children: [
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Text("Navigate to the 'All Applications' list, tap on the application you want to update, and on the detail screen, tap the 'Edit' button. You can then change the status and save your changes."),
              ),
            ],
          ),
          ExpansionTile(
            title: Text("Where can I see my scheduled interviews?"),
            children: [
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Text("Upcoming interviews are shown on your main Dashboard. You can see a complete list of all upcoming and past interviews on the 'All Interviews' screen."),
              ),
            ],
          ),
          ExpansionTile(
            title: Text("How do I change the theme?"),
            children: [
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Text("Go to your Profile screen by tapping the icon on the top right of the dashboard. You will find a 'Dark Mode' toggle switch under the settings section."),
              ),
            ],
          ),
        ],
      ),
    );
  }
}