import 'package:flutter/material.dart';
import 'package:twitter_clone/UI/Settings/change_password.dart';
import 'package:twitter_clone/UI/Settings/update_email.dart';
import 'package:twitter_clone/Utilities/utilities.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('S E T T I N G S'),
        automaticallyImplyLeading: false,
        centerTitle: true,
        foregroundColor: colorScheme.primary,
        actions: const [],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Utilities.navigateScreen(context, const UpdateEmailPage());
              },
              child: const Text("Update Email"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Utilities.navigateScreen(context, const ChangePasswordPage());
              },
              child: const Text("Change Password"),
            )
          ],
        ),
      ),
    );
  }
}
