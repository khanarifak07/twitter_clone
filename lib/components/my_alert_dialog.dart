import 'package:flutter/material.dart';
import 'package:twitter_clone/components/my_textfield.dart';
import 'package:twitter_clone/services/database/database_provider.dart';

class MyAlertDialog extends StatelessWidget {
  const MyAlertDialog({
    super.key,
    required this.databaseProvider,
    required this.colorScheme,
    this.isBio = false,
    this.isPost = false,
    this.onPressedText = 'Save',
  });

  final DatabaseProvider databaseProvider;
  final ColorScheme colorScheme;
  final bool isBio;
  final bool isPost;
  final String onPressedText;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      content: isBio
          ? MyTextField(
              colorScheme: Theme.of(context).colorScheme,
              controller: databaseProvider.bioCtrl,
              text: 'Bio',
              maxLength: 150,
              maxLines: 5,
            )
          : isPost
              ? MyTextField(
                  colorScheme: Theme.of(context).colorScheme,
                  controller: databaseProvider.postMessageCtrl,
                  text: 'Post message here...',
                  maxLength: 120,
                  maxLines: 5,
                )
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    MyTextField(
                      colorScheme: Theme.of(context).colorScheme,
                      controller: databaseProvider.emailCtrl,
                      text: 'Email',
                    ),
                    MyTextField(
                      colorScheme: colorScheme,
                      controller: databaseProvider.nameCtrl,
                      text: 'Name',
                    ),
                  ],
                ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            isBio
                ? databaseProvider.updateUserBio(
                    databaseProvider.bioCtrl.text,
                    context,
                  )
                : isPost
                    ? databaseProvider.addPost(
                        databaseProvider.postMessageCtrl.text,
                        context,
                      )
                    : databaseProvider.updateNameEmailAndUsername(context);
          },
          child: databaseProvider.isLoading
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ))
              : Text(onPressedText),
        )
      ],
    );
  }
}
