import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twitter_clone/services/database/database_provider.dart';
import 'package:twitter_clone/components/my_textfield.dart';

class UpdateEmailPage extends StatefulWidget {
  const UpdateEmailPage({super.key});

  @override
  State<UpdateEmailPage> createState() => _UpdateEmailPageState();
}

class _UpdateEmailPageState extends State<UpdateEmailPage> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final databaseProiver = Provider.of<DatabaseProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('U P D A T E  E M A I L'),
        centerTitle: true,
        foregroundColor: colorScheme.primary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MyTextField(
                colorScheme: colorScheme,
                text: 'Enter New Email',
                controller: databaseProiver.emailCtrl),
            MyTextField(
                colorScheme: colorScheme,
                text: 'Enter Current Password',
                controller: databaseProiver.passCtrl),
            databaseProiver.isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: () {
                      databaseProiver.verifyAndEmailUpdate(
                        context,
                        databaseProiver.emailCtrl.text,
                        databaseProiver.passCtrl.text,
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
