import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twitter_clone/services/database/database_provider.dart';
import 'package:twitter_clone/components/my_textfield.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _UpdateEmailPageState();
}

class _UpdateEmailPageState extends State<ChangePasswordPage> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    late final databaseProiver = Provider.of<DatabaseProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('C H A N G E   P A S S W O R D'),
        centerTitle: true,
        foregroundColor: colorScheme.primary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MyTextField(
                colorScheme: colorScheme,
                text: 'Enter Current Password',
                controller: databaseProiver.passCtrl),
            MyTextField(
                colorScheme: colorScheme,
                text: 'Enter New Password',
                controller: databaseProiver.newPassCtrl),
            databaseProiver.isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: () {
                      databaseProiver.changeCurrentPassword(
                        context,
                        databaseProiver.passCtrl.text,
                        databaseProiver.newPassCtrl.text,
                      );
                    },
                    child: const Text("Update"),
                  )
          ],
        ),
      ),
    );
  }
}
