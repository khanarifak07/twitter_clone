import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twitter_clone/components/my_alert_dialog.dart';
import 'package:twitter_clone/components/post_tile.dart';
import 'package:twitter_clone/components/profile_card.dart';
import 'package:twitter_clone/services/database/database_provider.dart';

class ProfilePage extends StatefulWidget {
  final String uid;
  const ProfilePage({super.key, required this.uid});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final DatabaseProvider databaseProvider =
        Provider.of<DatabaseProvider>(context);

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: const Text('P R O F I L E'),
        centerTitle: true,
        automaticallyImplyLeading: false,
        foregroundColor: colorScheme.primary,
      ),
      body: databaseProvider.user != null
          ? Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                // padding: const EdgeInsets.all(20),
                children: [
                  GestureDetector(
                    onTap: () async {
                      await databaseProvider.selectProfile();
                    },
                    child: CircleAvatar(
                      radius: 60,
                      backgroundColor: colorScheme.secondary,
                      backgroundImage: databaseProvider.user!.profile.isNotEmpty
                          ? NetworkImage(databaseProvider.user!.profile)
                          : (databaseProvider.profileImage != null
                              ? FileImage(
                                  File(
                                    databaseProvider.profileImage!.path,
                                  ),
                                )
                              : null),
                      child: databaseProvider.profileImage == null &&
                              (databaseProvider.user!.profile.isEmpty)
                          ? Icon(Icons.person,
                              size: 50, color: colorScheme.primary)
                          : null,
                    ),
                  ),

                  const SizedBox(height: 10),
                  Text(
                    textAlign: TextAlign.center,
                    databaseProvider.user!.name,
                    style: TextStyle(fontSize: 20, color: colorScheme.primary),
                  ),
                  const SizedBox(height: 10),
                  ProfileCard(
                    colorScheme: colorScheme,
                    databaseProvider: databaseProvider,
                    title: 'Personal Details',
                    isBio: false,
                    ontap: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return MyAlertDialog(
                              databaseProvider: databaseProvider,
                              colorScheme: colorScheme,
                              isBio: false,
                            );
                          });
                    },
                  ),
                  const SizedBox(height: 10),
                  ProfileCard(
                    colorScheme: colorScheme,
                    databaseProvider: databaseProvider,
                    title: 'Bio',
                    isBio: true,
                    ontap: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return MyAlertDialog(
                              databaseProvider: databaseProvider,
                              colorScheme: colorScheme,
                              isBio: true,
                            );
                          });
                    },
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Posts',
                    style: TextStyle(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: databaseProvider.posts!.length,
                      itemBuilder: (context, index) {
                        return PostTile(
                          colorScheme: colorScheme,
                          postData: databaseProvider.posts![index],
                          databaseProvider: databaseProvider,
                        );
                      },
                    ),
                  ),

                  // const Spacer(),
                  // ElevatedButton(
                  //   style: ElevatedButton.styleFrom(
                  //     backgroundColor: colorScheme.primary,
                  //     shape: RoundedRectangleBorder(
                  //       borderRadius: BorderRadius.circular(10),
                  //     ),
                  //     minimumSize: const Size.fromHeight(50),
                  //   ),
                  //   onPressed: () {

                  //   },
                  //   child: Text(
                  //     "Save",
                  //     style: TextStyle(color: colorScheme.secondary),
                  //   ),
                  // )
                ],
              ),
            )
          : const Center(
              child:
                  CircularProgressIndicator(), // Show loading indicator while data is being fetched
            ),
    );
  }
}
